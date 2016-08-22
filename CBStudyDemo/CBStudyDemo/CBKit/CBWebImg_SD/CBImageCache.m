//
//  CBImageCache.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/18.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "CBWebImageCompat.h"


static const NSInteger KDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7;

static unsigned char kPNGSignatureBytes[8] = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};
static NSData *kPNGSignatureData = nil;

BOOL ImageDataHasPNGPreffix(NSData *data);

BOOL ImageDataHasPNGPreffix(NSData *data) {
    NSUInteger pngSignatureLength = [kPNGSignatureData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:kPNGSignatureData]) {
            return YES;
        }
    }
    
    return NO;
}

@interface CBImageCache ()

@property (nonatomic, strong) NSCache *memChache;
@property (nonatomic, strong) NSString *diskCachePath;
@property (nonatomic, strong) NSMutableArray *customPaths;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

FOUNDATION_STATIC_INLINE NSUInteger CBCacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}

@implementation CBImageCache {
    NSFileManager *_fileManager;
}

+ (CBImageCache *)sharedImageCache {
    static dispatch_once_t once;
    static CBImageCache *imageCache;
    dispatch_once(&once, ^{
        imageCache = [[CBImageCache alloc] init];
    });
    return imageCache;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    return [self initWithNamespace:@"default"];
}

- (instancetype)initWithNamespace:(NSString *)ns {
    NSString *path = [self makeDiskCachePath:ns];
    return [self initWithNamespace:ns diskCacheDirectory:path];
}

- (instancetype)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory {
    if (self = [super init]) {
        NSString *fullNamespace = [@"com.chenbin.CBWebImageCache." stringByAppendingString:ns];
        
        self.ioQueue = dispatch_queue_create("com.chenbin.CBWebImageCahce", DISPATCH_QUEUE_CONCURRENT);
        self.maxCacheAge = KDefaultCacheMaxCacheAge;
        self.memChache = [[NSCache alloc] init];
        self.memChache.name = fullNamespace;
        
        if (directory != nil) {
            self.diskCachePath = [directory stringByAppendingPathComponent:fullNamespace];
        } else {
            NSString *path = [self makeDiskCachePath:ns];
            self.diskCachePath = path;
        }
        self.shouldDecompressImages = YES;
        self.shouldCacheImagesInMemory = YES;
        self.shouldDisableiCloud = YES;
        dispatch_sync(self.ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanDisk) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundCleanDisk) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
    }
    return self;
}

- (NSString *)makeDiskCachePath:(NSString *)fullNamespace {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *fileName = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:fileName];
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

#pragma mark SDImageCache (private)

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}

#pragma mark ImageCache

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(CBWebImageQueryCompletedBlock)doneBlock {
    if (!doneBlock) return nil;
    if (!key) {
        doneBlock(nil, CBImageCacheTypeNone);
        return nil;
    }
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        doneBlock(image, CBImageCacheTypeMemory);
        return nil;
    }
    NSOperation *operation = [NSOperation new];
    dispatch_async(self.ioQueue, ^{
        if (operation.isCancelled) { return; }
        @autoreleasepool {
            UIImage *diskImg = [self diskImageForKey:key];
            if (diskImg && self.shouldCacheImagesInMemory) {
                NSUInteger cost = CBCacheCostForImage(diskImg);
                [self.memChache setObject:image forKey:key cost:cost];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                doneBlock(diskImg, CBImageCacheTypeDisk);
            });
        }
    });
    return operation;
}

- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk {
    if (!image || !key) { return; }
    if (self.shouldCacheImagesInMemory) {
        NSUInteger cost = CBCacheCostForImage(image);
        [self.memChache setObject:image forKey:key cost:cost];
    }
    if (!toDisk) { return; }
    dispatch_async(self.ioQueue, ^{
        NSData *data = imageData;
        if (image && (recalculate || !data)) {
            int alphaInfo = CGImageGetAlphaInfo(image.CGImage);
            BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                              alphaInfo == kCGImageAlphaNoneSkipFirst ||
                              alphaInfo == kCGImageAlphaNoneSkipLast);
            BOOL imageIsPng = hasAlpha;
            if (imageData.length >= kPNGSignatureData.length) {
                imageIsPng = ImageDataHasPNGPreffix(imageData);
            }
            if (imageIsPng) {
                data = UIImagePNGRepresentation(image);
            } else {
                data = UIImageJPEGRepresentation(image, 1.0);
            }
        }
        [self storeImageDataToDisk:data forKey:key];
    });
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    [self storeImage:image recalculateFromImage:YES imageData:nil forKey:key toDisk:YES];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk {
    [self storeImage:image recalculateFromImage:YES imageData:nil forKey:key toDisk:toDisk];
}

- (void)storeImageDataToDisk:(NSData *)imageData forKey:(NSString *)key {
    if (!imageData) return;
    if (![_fileManager fileExistsAtPath:self.diskCachePath]) {
        [_fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *cachePathForKey = [self defaultCachePathForKey:key];
    NSURL *fileURL = [NSURL fileURLWithPath:cachePathForKey];
    [_fileManager createFileAtPath:cachePathForKey contents:imageData attributes:nil];
    
    if (self.shouldDisableiCloud) {
        [fileURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}

- (BOOL)diskImageExistsWithKey:(NSString *)key {
    BOOL exists = NO;
    exists = [[NSFileManager defaultManager] fileExistsAtPath:[self defaultCachePathForKey:key]];
    if (!exists) {
        exists = [[NSFileManager defaultManager] fileExistsAtPath:[[self defaultCachePathForKey:key] stringByDeletingPathExtension]];
    }
    return exists;
}

- (void)diskImageExistsWithKey:(NSString *)key completion:(CBWebImageCheckCacheCompletionBlock)completionBlock {
    dispatch_async(self.ioQueue, ^{
        if (completionBlock) {
            BOOL exists = [self diskImageExistsWithKey:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(exists);
            });
        }
    });
}

- (NSData *)diskImageDataBySearchAllPathForKey:(NSString *)key {
    NSString *defaultPath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) return data;
    NSArray *customPaths = [self.customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self cachePathForKey:key inPath:path];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        if (imageData) return imageData;
        imageData = [NSData dataWithContentsOfFile:[filePath stringByDeletingPathExtension]];
        if (imageData) return imageData;
    }
    return nil;
}

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [self.memChache objectForKey:key];
}

- (UIImage *)diskImageForKey:(NSString *)key {
    NSData *data = [self diskImageDataBySearchAllPathForKey:key];
    if (data) {
        return [UIImage imageWithData:data];
    }
    return nil;
}

- (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) return image;
    UIImage *diskImage = [self diskImageForKey:key];
    if (diskImage && self.shouldCacheImagesInMemory) {
        NSUInteger cost = CBCacheCostForImage(diskImage);
        [self.memChache setObject:diskImage forKey:key cost:cost];
    }
    return diskImage;
}

- (void)removeImageForKey:(NSString *)key {
    [self removeImageForKey:key withCompletion:nil];
}

- (void)removeImageForKey:(NSString *)key withCompletion:(CBWebImageNoParamsBlock)completion {
    [self removeImageForKey:key fromDisk:YES withCompletion:completion];
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk {
    [self removeImageForKey:key fromDisk:fromDisk withCompletion:nil];
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(CBWebImageNoParamsBlock)completion {
    if (key == nil) return;
    if (self.shouldCacheImagesInMemory) {
        [self.memChache removeObjectForKey:key];
    }
    if (fromDisk) {
        dispatch_async(self.ioQueue, ^{
            [_fileManager removeItemAtPath:[self defaultCachePathForKey:key] error:nil];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        });
    } else if (completion) {
        completion();
    }
}

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    self.memChache.totalCostLimit = maxMemoryCost;
}

- (NSUInteger)maxMemoryCost {
    return self.memChache.totalCostLimit;
}

- (NSUInteger)maxMemoryCountLimit {
    return self.memChache.countLimit;
}

- (void)setMaxMemoryCountLimit:(NSUInteger)maxMemoryCountLimit {
    self.memChache.countLimit = maxMemoryCountLimit;
}

- (void)clearMemory {
    [self.memChache removeAllObjects];
}

- (void)cleanDisk {
    [self clearDiskOnCompletion:nil];
}

- (void)backgroundCleanDisk {
    
}

- (void)clearDiskOnCompletion:(CBWebImageNoParamsBlock)completion {
    dispatch_async(self.ioQueue, ^{
        [_fileManager removeItemAtPath:self.diskCachePath error:nil];
        [_fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}
@end
