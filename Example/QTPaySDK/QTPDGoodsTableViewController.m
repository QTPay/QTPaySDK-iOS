//
//  QTPDGoodsTableViewController.m
//  QTPosDemo
//
//  Created by YoungShook on 15/3/18.
//  Copyright (c) 2015年 QFPay. All rights reserved.
//

#import "QTPDGoodsTableViewController.h"

@interface QTPDGoodsTableViewController ()
@property(nonatomic, copy) NSArray *goodsArray;
@property(nonatomic, copy) NSArray *amountArray;
@end

@implementation QTPDGoodsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.goodsArray = @[@"08 年 奥迪A6", @"09 年 奔驰320", @"13 年 宝马X5"];
    self.amountArray = @[@"0.2", @"0.3", @"0.4"];
    self.tableView.rowHeight = 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    __weak QTPDGoodsTableViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:@"t" forHTTPHeaderField:@"X-QT-ROUTE"];
    [manager setRequestSerializer:serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    NSDictionary *requestDic = @{@"total_amt":[[self.amountArray objectAtIndex:indexPath.row] convertToFen],
                                 @"out_sn":[NSString generateTradeNO],
                                 @"goods_name":[self.goodsArray objectAtIndex:indexPath.row],
                                 @"token":self.userToken
                                 };
    [manager POST:[NSString stringWithFormat:@"%@/v1/order/simple_create", QTSDKDemoBaseAPI] parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (![responseObject[@"respcd"] isEqualToString:@"0000"]) {
            [UIAlertView showWithTitle:@"提示" message:responseObject[@"resperr"] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
            return ;
        }
        
        [self sendRequestQPOSPaymentWithOrder:responseObject];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        [UIAlertView showWithTitle:@"提示" message:error.localizedDescription cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    }];

}

- (void)sendRequestQPOSPaymentWithOrder:(NSDictionary *)orderInfo{
    NSString *scheme = @"POSDemo";
    NSString *orderID = orderInfo[@"data"][@"order_id"];
    NSString *orderCreate = orderInfo[@"data"][@"create_userid"];
    NSString *timestamp = [NSString stringWithFormat:@"%ld",time(NULL)];
    NSString *platform = @"2";
    NSString *mobile = @"14700000291";

    NSDictionary *orderDic;
    NSString *qf_token = orderInfo[@"data"][@"qf_token"];
    if (qf_token) {
        orderDic = @{@"pay_order_id":orderID,@"pay_order_create":orderCreate, @"platform":platform, @"scheme":scheme,@"qf_token":qf_token,@"timestamp":timestamp,@"mobile":mobile};
    }else{
        orderDic = @{@"pay_order_id":orderID,@"pay_order_create":orderCreate, @"platform":platform, @"scheme":scheme,@"timestamp":timestamp,@"mobile":mobile};
    }
    
    NSString *requestURLString = [NSString stringWithFormat:@"qpos://%@",[self __packageGetURLParameters:orderDic]];
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:requestURL]) {
        [[UIApplication sharedApplication] openURL:requestURL];
    }else{
        [UIAlertView showWithTitle:@"提示" message:@"未找到「钱方商户」App,支付前请到AppStore中安装." cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    }
}

// create URL with sign
// 参数添加sign签名（可选）
- (NSString *)__packageGetURLParameters:(NSDictionary *)dic {
    NSMutableString *parametersString = [NSMutableString new];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [[[dic allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [parametersString appendString:[NSString stringWithFormat:@"%@=%@&", obj, dic[obj]]];
    }];
    NSString *subParametersString = [parametersString substringToIndex:[parametersString length] - 1];
    
    NSString *signMD5 = [NSString qt_MD5String:[subParametersString stringByAppendingString:@"qpos"]];
    
    return [NSString stringWithFormat:@"?%@&sign=%@", subParametersString, signMD5];
}

@end
