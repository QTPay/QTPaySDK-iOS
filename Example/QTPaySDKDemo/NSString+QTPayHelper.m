//
//  NSString+QTPayHelper.m
//  QTPaySDK
//
//  Created by QTPay on 15/2/5.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "NSString+QTPayHelper.h"

@implementation NSString (QTPayHelper)

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
