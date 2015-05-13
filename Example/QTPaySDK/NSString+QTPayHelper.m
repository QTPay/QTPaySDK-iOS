//
//  NSString+QTPayHelper.m
//  QTPaySDK
//
//  Created by QTPay on 15/2/5.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "NSString+QTPayHelper.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (QTPayHelper)

+ (NSString *)qt_MD5String:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

+ (NSString *)generateTradeNO{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
        {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
        }
    return resultStr;
}

- (NSString *)convertToYuan{
    return [NSString stringWithFormat:@"%.2lf",[self doubleValue]/100.0];
}

- (NSString *)convertToFen{
    return  [[NSNumber numberWithInteger:[self doubleValue] * 100] stringValue];
}

- (BOOL)verfiyMoney {
    if (self.length >= 1 && ![self isEqualToString:@"0"]) {
        
        NSString *channelString = @"^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$";
        NSPredicate *channel = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",channelString];
        return [channel evaluateWithObject:self];
    }
    return NO;
    
}

- (BOOL)verfiyNumber {
    
    //只能输入数字
    if (self.length >= 1) {
        
        NSString *channelString = @"^[0-9]+$";
        NSPredicate *channel = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",channelString];
        return [channel evaluateWithObject:self];
    }
    return NO;
}


@end
