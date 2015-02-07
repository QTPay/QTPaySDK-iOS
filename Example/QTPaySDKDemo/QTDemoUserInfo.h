//
//  QTPayUserInfo.h
//  QTPaySDK
//
//  Created by YoungShook on 15/2/6.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTDemoUserInfo : NSObject
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *token;

+ (instancetype)sharedInstance;

@end
