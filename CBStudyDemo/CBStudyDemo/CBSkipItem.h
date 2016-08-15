//
//  CBSkipItem.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBSkipItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) Class destinationClass;

- (instancetype)initWithTitle:(NSString *)title destinationClass:(Class)dClass;

@end

@interface CBSectionItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readonly) NSMutableArray<CBSkipItem *> *cellItems;

- (instancetype)initWithTitle:(NSString *)title;

@end