//
//  QTDemoRechargeViewController.m
//  QTSDKDemo
//
//  Created by QTPay on 15/1/4.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoRechargeViewController.h"
#import "QTPaySDK.h"

@interface QTDemoRechargeViewController ()
@property(nonatomic, weak) IBOutlet UITextField *inputTextField;
@end

@implementation QTDemoRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户余额充值";
    [self.inputTextField becomeFirstResponder];
}

- (IBAction)onRecharge:(id)sender {
    
    if(![self.inputTextField.text verfiyMoney]) {
        [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请输入正确的金额" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil]show];
        return;
    }
    
    __block QTPayOrder *order = [QTPayOrder new];
    order.out_sn = [NSString generateTradeNO];
    order.pay_amt = [self.inputTextField.text convertToFen];
    order.total_amt = [self.inputTextField.text convertToFen];
    order.goods_info = @"余额充值";
    order.goods_name = @"余额充值";
    order.mobile = [QTDemoUserInfo sharedInstance].mobile;
    order.mchnt_name = @"余额充值";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    [manager GET:[NSString stringWithFormat:@"%@/ordertoken?total_amt=%@",QTSDKDemoBaseAPI,order.total_amt] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        order.order_token = responseObject[@"token"];
        order.actionType = QTActionTypeRecharge;
        
        [[QTPaySDK defaultService] presentPaymentViewWithOrder:order withCompletion:^(QTRespCode respCode, QTPayType PayType, NSDictionary *resultDic) {
            
            NSString *resultString = nil;
            if (respCode == QTSuccess) {
                resultString = @"支付成功";
            }else if(respCode == QTErrCodeCommon){
                resultString = @"支付失败";
            }else if(respCode == QTErrCodeUserCancel){
                resultString = @"支付取消,可重新发起支付";
            }else if (respCode == QTErrCodeSentFail){
                resultString = @"订单创建失败";
            }else if (respCode == QTErrConnection){
                resultString = @"网络连接失败";
            }else if (respCode == QTErrInvalidParameters){
                resultString = @"无效的请求参数";
            }
            
            UIAlertView *resultAlert = [UIAlertView bk_alertViewWithTitle:resultString message:resultDic[@"respmsg"]];
            [resultAlert bk_addButtonWithTitle:@"确定" handler:^{
                
            }];
            [resultAlert show];
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:error.localizedDescription cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil] show];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
