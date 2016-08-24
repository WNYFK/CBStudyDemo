//
//  main.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


int MaxSubString(int *A, int n) {
    int Start = A[n - 1];
    int All = A[n - 1];
    for (int i = n - 2; i >= 0; i--) {
        Start = fmax(A[i], A[i] + Start);
        All = fmax(Start, All);
    }
    return All;
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
