//
//  AppDelegate.m
//  QTSDKDemo
//
//  Created by QTPay on 14/12/6.
//  Copyright (c) 2014年 QTPay. All rights reserved.
//

#import "AppDelegate.h"
#import "QTPaySDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    [[QTPaySDK  defaultService] processOrderWithPaymentResult:url standbyCallback:^(QTRespCode respCode, QTPayType PayType, NSDictionary *resultDic) {
        NSLog(@"SUCCESS:%@ PayType:%@ Result:%@",@(respCode),@(PayType),resultDic);
    }];

    return YES;
}

@end
