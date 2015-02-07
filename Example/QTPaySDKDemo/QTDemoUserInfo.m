//
//  QTPayUserInfo.m
//  QTPaySDK
//
//  Created by YoungShook on 15/2/6.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoUserInfo.h"

@implementation QTDemoUserInfo

+ (instancetype)sharedInstance{
    static dispatch_once_t pred = 0;
    static id _sharedInstance = nil;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc]init];
    });
    return _sharedInstance;
}

@end
