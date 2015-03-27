//
//  QTDemoGoodsListViewController.m
//  QTSDKDemo
//
//  Created by QTPay on 15/1/4.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoGoodsListViewController.h"
#import "QTDemoGoodsDetailViewController.h"
#import "QTDemoAccountViewController.h"
#import "QTPayOrder.h"
#import "QTPaySDK.h"
#import "MBProgressHUD.h"

@interface QTDemoGoodsListViewController ()
@property(nonatomic, copy) NSArray *goodsArray;
@property(nonatomic, copy) NSArray *amountArray;
@property (nonatomic,strong) QTPayOrder *order;
@end

@implementation QTDemoGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.goodsArray = @[@"大象 干柴烈火十八禁  × 1", @"大象 干柴烈火十八禁  × 2", @"大象 干柴烈火十八禁  × 3"];
    self.amountArray = @[@"0.01", @"0.02", @"0.03"];
    self.tableView.rowHeight = 44.0f;
    
    [QTPaySDK setQTPayWithAppCode:QTSDKAppCode appKey:QTSDKAppKey accessToken:[QTDemoUserInfo sharedInstance].token appScheme:@"QTSDKDemo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >= 3) {
        QTDemoAccountViewController *accountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTDemoAccountViewController"];
        [self.navigationController pushViewController:accountViewController animated:YES];
    }else {
        self.order = [QTPayOrder new];
        self.order.out_sn     = [NSString generateTradeNO];
        self.order.pay_amt    = [[self.amountArray objectAtIndex:indexPath.row] convertToFen];
        self.order.total_amt  = [[self.amountArray objectAtIndex:indexPath.row] convertToFen];
        self.order.goods_info = [self.goodsArray objectAtIndex:indexPath.row];
        self.order.goods_name = @"大象套装";
        self.order.mobile     = [QTDemoUserInfo sharedInstance].mobile;
        self.order.mchnt_name = @"媚娘的店";
        
        __weak QTDemoGoodsListViewController *weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        [manager GET:[NSString stringWithFormat:@"%@/ordertoken?total_amt=%@&app_code=%@&out_mchnt=%@",QTSDKDemoBaseAPI,self.order.total_amt,QTSDKAppCode,QTSDKDemoOutMerchant] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
            weakSelf.order.order_token = responseObject[@"token"];
            weakSelf.order.actionType = QTActionTypeGoods;
            
            QTDemoGoodsDetailViewController *goodsDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTDemoGoodsDetailViewController"];
            goodsDetailViewController.order = weakSelf.order;
            [weakSelf.navigationController pushViewController:goodsDetailViewController animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIAlertView showWithTitle:@"提示" message:error.localizedDescription cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }];
    }
    
}

@end
