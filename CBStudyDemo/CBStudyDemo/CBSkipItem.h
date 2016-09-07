//
//  CBSkipItem.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CBNormalCallBack)();

@interface CBSkipItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) Class destinationClass;
@property (nonatomic, copy) CBNormalCallBack callBack;

- (instancetype)initWithTitle:(NSString *)title destinationClass:(Class)dClass;
- (instancetype)initWithTitle:(NSString *)title callBack:(CBNormalCallBack)callBack;

@end

@interface CBSectionItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readonly) NSMutableArray<CBSkipItem *> *cellItems;

- (instancetype)initWithTitle:(NSString *)title;

@end