//
//  QTDemoGoodsDetailViewController.m
//  QTSDKDemo
//
//  Created by QTPay on 15/1/16.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoGoodsDetailViewController.h"
#import "MBProgressHUD.h"
#import <BlocksKit+UIKit.h>
#import "QTPayOrder.h"
#import "QTPaySDK.h"
#import "WXApi.h"

@interface QTDemoGoodsDetailViewController ()

@property (nonatomic,strong) QTPayOrder *order;
@property (nonatomic,weak) IBOutlet UIButton *topPayButton;
@end

@implementation QTDemoGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单详情";
    
    self.order = [QTPayOrder new];
    self.order.out_sn     = [NSString generateTradeNO];
    self.order.pay_amt    = [self.payAmount convertToFen];
    self.order.total_amt  = [self.payAmount convertToFen];
    self.order.goods_info = self.goodsName;
    self.order.goods_name = @"大象套装";
    self.order.mobile     = [QTDemoUserInfo sharedInstance].mobile;
    self.order.mchnt_name = @"媚娘的店";
    
    self.topPayButton.layer.borderColor = [UIColor colorWithRed:0 green:187./255. blue:0 alpha:1.f].CGColor;
    self.topPayButton.layer.cornerRadius = 5.f;
    self.topPayButton.layer.borderWidth = 1.f;
}

- (IBAction)onPayment:(id)sender{
    
    __weak QTDemoGoodsDetailViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    [manager GET:[NSString stringWithFormat:@"%@/ordertoken?total_amt=%@&app_code=%@",QTSDKDemoBaseAPI,self.order.total_amt,QTSDKAppCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        weakSelf.order.order_token = responseObject[@"token"];
        weakSelf.order.actionType = QTActionTypeGoods;
        
        [[QTPaySDK defaultService] presentPaymentViewWithOrder:weakSelf.order withCompletion:^(QTRespCode respCode, QTPayType PayType, NSDictionary *resultDic) {
            
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
            
            if(respCode == QTSuccess) {
                
                [resultAlert bk_addButtonWithTitle:@"分享红包" handler:^{
                    
                    [[QTPaySDK defaultService]fetchOrderShareURLCallBack:^(NSDictionary *resultDic) {
                        if ([resultDic[@"respcd"] isEqualToString:@"0000"]) {
                            [weakSelf shareOrderURL:resultDic];
                        }
                    }];
                }];
                
            }
            [resultAlert show];
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:error.localizedDescription cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil] show];
    }];
}

- (void)shareOrderURL:(NSDictionary *)dic{
    
    __weak QTDemoGoodsDetailViewController *weakSelf = self;
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"微信分享红包"];
    [actionSheet bk_addButtonWithTitle:@"分享给好友" handler:^{
        [weakSelf shareWechat:dic shareScene:0];
    }];
    [actionSheet bk_addButtonWithTitle:@"分享到朋友圈" handler:^{
        [weakSelf shareWechat:dic shareScene:1];
    }];
    [actionSheet bk_addButtonWithTitle:@"取消" handler:^{
    }];
    [actionSheet showInView:self.view];
}

- (void)shareWechat:(NSDictionary *)shareDic shareScene:(NSInteger)sceneNumber{
    
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"您设备没有安装微信"];
        [alert show];
        return;
    }
    
    NSString *titleString = shareDic[@"data"][@"title"];
    NSString *shareString = shareDic[@"data"][@"content"];
    
    NSString *urlString = shareDic[@"data"][@"share_url"];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleString;
    message.description = shareString;
    [message setThumbImage:[UIImage imageNamed:@"coupon_logo"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = sceneNumber == 0 ? WXSceneSession : WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
