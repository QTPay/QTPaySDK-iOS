//
//  QTDemoAccountViewController.m
//  QTPaySDK
//
//  Created by YoungShook on 15/2/6.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoAccountViewController.h"
#import "QTDemoCouponListViewController.h"
#import "QTDemoRechargeViewController.h"
#import "QTPayOrder.h"
#import "QTPaySDK.h"


@interface QTDemoAccountViewController ()
@property (nonatomic,weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic,strong) NSArray *couponList;
@end

@implementation QTDemoAccountViewController

- (void)viewDidAppear:(BOOL)animated{
    [self fetchUserDiscountInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 44.0f;
}

- (void)fetchUserDiscountInfo{
    
    [[QTPaySDK defaultService] fetchUserDiscountInfoWithQueryType:QTQueryDiscountTypeNone amount:nil callBack:^(NSDictionary *resultDic) {
        if ([resultDic[@"respcd"] isEqualToString:@"0000"]) {
            self.balanceLabel.text = [[[resultDic[@"data"][@"balance"] stringValue] convertToYuan] stringByAppendingString:@" 元"];
            self.couponList = resultDic[@"data"][@"coupons"];
        }else{
            [UIAlertView showWithTitle:@"提示" message:resultDic[@"respmsg"] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
    }];
    
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0) {
        QTDemoCouponListViewController *couponListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTDemoCouponListViewController"];
        couponListViewController.couponList = self.couponList;
        [self.navigationController pushViewController:couponListViewController animated:YES];
    }else if(indexPath.row == 1){
        QTDemoRechargeViewController *rechargeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTDemoRechargeViewController"];
        [self.navigationController pushViewController:rechargeViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
