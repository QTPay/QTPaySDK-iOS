//
//  QTDemoGoodsDetailViewController.m
//  QTSDKDemo
//
//  Created by QTPay on 15/1/16.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoGoodsDetailViewController.h"
#import "MBProgressHUD.h"
#import <QTPaySDK/QTPayOrder.h>
#import <QTPaySDK/QTPaySDK.h>
#import "WXApi.h"

@interface QTDemoGoodsDetailViewController ()<UIActionSheetDelegate>

@property (nonatomic,weak) IBOutlet UIButton *topPayButton;
@property (nonatomic,strong) NSDictionary *shareInfoDic;
@end

@implementation QTDemoGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单详情";
    
    self.topPayButton.layer.borderColor = [UIColor colorWithRed:0 green:187./255. blue:0 alpha:1.f].CGColor;
    self.topPayButton.layer.cornerRadius = 5.f;
    self.topPayButton.layer.borderWidth = 1.f;
}

- (IBAction)onPayment:(id)sender{
    
    __weak QTDemoGoodsDetailViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    QTLog(@"%@", weakSelf.order.order_token);
    [QTPaySDK fetchCheckoutConfigWithOrder:weakSelf.order callBack:^(NSDictionary *resultDic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([resultDic[@"result"]isEqualToString:@"success"]) {
            
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
                }else if (respCode == QTSuccessOffline){
                    resultString = @"下单成功，等待线下支付";
                }
                
                if(respCode == QTSuccess) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [UIAlertView showWithTitle:resultString message:resultDic[@"respmsg"] cancelButtonTitle:@"返回" otherButtonTitles:@[@"分享红包"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [[QTPaySDK defaultService] fetchOrderShareURLCallBack:^(NSDictionary *resultDic) {
                            if ([resultDic[@"respcd"] isEqualToString:@"0000"]) {
                                [weakSelf shareOrderURL:resultDic];
                            }
                        }];
                    }];
                }else{
                    [UIAlertView showWithTitle:resultString message:resultDic[@"respmsg"] cancelButtonTitle:@"返回" otherButtonTitles:nil tapBlock:nil];
                }
            }];
        }else {
            [UIAlertView showWithTitle:@"提示" message:[NSString stringWithFormat:@"配置信息有误，（%@）",resultDic[@"error"]] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
    }];
    
}

- (void)shareOrderURL:(NSDictionary *)dic{
    self.shareInfoDic = dic;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"微信分享红包" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友",@"分享到朋友圈", nil];
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex < 2) {
        [self shareWechat:self.shareInfoDic shareScene:buttonIndex];
    }
}

- (void)shareWechat:(NSDictionary *)shareDic shareScene:(NSInteger)sceneNumber{
    
    if (![WXApi isWXAppInstalled]) {
        [UIAlertView showWithTitle:@"提示" message:@"您设备没有安装微信" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
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
    
    if ([urlString length]) {
         [WXApi sendReq:req];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
