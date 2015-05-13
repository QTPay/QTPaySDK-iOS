//
//  NSString+QTPayHelper.h
//  QTPaySDK
//
//  Created by QTPay on 15/2/5.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QTPayHelper)

+ (NSString *)qt_MD5String:(NSString *)string;
+ (NSString *)generateTradeNO;
- (NSString *)convertToYuan;
- (NSString *)convertToFen;
- (BOOL)verfiyNumber;
- (BOOL)verfiyMoney;

@end
