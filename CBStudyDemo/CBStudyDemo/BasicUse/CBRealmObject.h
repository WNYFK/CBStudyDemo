//
//  CBRealmObject.h
//  CBStudyDemo
//
//  Created by ChenBin on 2017/4/25.
//  Copyright © 2017年 ChenBin. All rights reserved.
//


@interface CBRealmObject : RLMObject<MTLModel, MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;

@end
