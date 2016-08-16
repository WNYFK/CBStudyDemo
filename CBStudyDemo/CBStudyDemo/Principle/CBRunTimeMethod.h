//
//  CBRunTimeMethod.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/16.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#ifndef CBRunTimeMethod_h
#define CBRunTimeMethod_h

#import <objc/runtime.h>

static NSArray *ClassMethodNames(Class c)
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++)
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    free(methodList);
    
    return array;
}

static void PrintDescription(NSString *name, id obj) {
    
    NSString *str = [NSString stringWithFormat:@"%@: %@ \n\tNSObject class %s\n\t libobjc class %@\n\t implements methods <%@>", name,
                     obj,
                     class_getName([obj class]),
                     object_getClass(obj),
                     [ClassMethodNames([obj class]) componentsJoinedByString:@", "]
                     ];
    
    printf("%s\n", [str UTF8String]);
}

#endif /* CBRunTimeMethod_h */
