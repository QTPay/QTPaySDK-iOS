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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"POSDemo"]) {
        //QFSH CallBack
        NSDictionary *callBackPayDic = [self queryDictionary:url];
        
        // 对返回值的签名校验（可选）
        if ([self __verifyRequestSignValidity:callBackPayDic]) {
            [self fetchPayResultInfo:callBackPayDic];
        }else{
            [UIAlertView showWithTitle:@"提示" message:@"支付返回签名错误，请检查." cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
    }else if([[url scheme] isEqualToString:@"QTDemo"] || [[url scheme] hasPrefix:@"wx"]){
        //WX or Alipay CallBack
        [[QTPaySDK  defaultService] processOrderWithPaymentResult:url standbyCallback:^(QTRespCode respCode, QTPayType PayType, NSDictionary *resultDic) {
            QTLog(@"SUCCESS:%@ PayType:%@ Result:%@",@(respCode),@(PayType),resultDic);
        }];
    }else{
        //None
    }
    return YES;
}

- (void)fetchPayResultInfo:(NSDictionary *)callBackPayDic{
    
    __weak  AppDelegate *weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:@"t" forHTTPHeaderField:@"X-QT-ROUTE"];
    [manager setRequestSerializer:serializer];
    [manager GET:[NSString stringWithFormat:@"%@/v1/order/query?token=%@&order_id=%@",QTSDKDemoBaseAPI,self.userToken,callBackPayDic[@"pay_order_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.window animated:NO];
        QTLog(@"%@", responseObject);
        if ([responseObject[@"respcd"] isEqualToString:@"0000"]) {
            NSNumber *resultStatus = [responseObject[@"data"][@"order_info"]firstObject][@"status"];
            NSString *resultString = nil;
            if ([resultStatus isEqualToNumber:@1]) {
                resultString = @"支付未完成,订单未支付！";
            }else if ([resultStatus isEqualToNumber:@2]){
                resultString = @"支付已完成,订单支付成功！";
            }else if ([resultStatus isEqualToNumber:@3]){
                resultString = @"支付未完成,订单已关闭,请重新支付";
            }else{
                resultString = @"支付未完成,订单不存在！";
            }
            [UIAlertView showWithTitle:@"提示" message:resultString cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }else{
            if ([callBackPayDic[@"status_code"] isEqualToString:@"0000"]) {
                [UIAlertView showWithTitle:@"提示" message:@"支付已完成,订单支付成功！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
            }else{
                [UIAlertView showWithTitle:@"提示" message:@"支付未完成,订单未支付！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.window animated:NO];
        QTLog(@"fetch pay result %@",error);
        if ([callBackPayDic[@"status_code"] isEqualToString:@"0000"]) {
            [UIAlertView showWithTitle:@"提示" message:@"支付已完成,订单支付成功！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }else{
            [UIAlertView showWithTitle:@"提示" message:@"支付未完成,订单未支付！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
    }];
}

// VerifySign
- (BOOL)__verifyRequestSignValidity:(NSDictionary *)dic{
    NSString *signString = dic[@"sign"];
    NSMutableString *parametersString = [NSMutableString new];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [[[dic allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isEqualToString:@"sign"]) {
            [parametersString appendString:[NSString stringWithFormat:@"%@=%@&", obj, dic[obj]]];
        }
    }];
    
    NSString *subParametersString = [parametersString substringToIndex:[parametersString length] - 1];
    NSString *signValidityMD5 = [NSString qt_MD5String:[subParametersString stringByAppendingString:@"qpos"]];
    return [signString isEqualToString:signValidityMD5];
}

- (NSDictionary *)queryDictionary:(NSURL *)url {
    NSString *queryString = [url query];
    if (!queryString) return nil;
    
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionary];
    
    NSCharacterSet *charSetAmpersand = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSCharacterSet *charSetEqualsSign = [NSCharacterSet characterSetWithCharactersInString:@"="];
    for (NSString *fieldValuePair in[queryString componentsSeparatedByCharactersInSet:charSetAmpersand]) {
        NSArray *fieldValueArray = [fieldValuePair componentsSeparatedByCharactersInSet:charSetEqualsSign];
        if (fieldValueArray.count == 2) {
            NSString *filed = [fieldValueArray objectAtIndex:0];
            NSString *value = [fieldValueArray objectAtIndex:1];
            [queryDictionary setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:filed];
        }
    }
    return queryDictionary;
}


@end
