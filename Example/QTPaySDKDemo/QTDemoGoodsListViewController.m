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

@interface QTDemoGoodsListViewController ()
@property(nonatomic, copy) NSArray *goodsArray;
@property(nonatomic, copy) NSArray *amountArray;
@end

@implementation QTDemoGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.goodsArray = @[@"大象 干柴烈火十八禁  × 1", @"大象 干柴烈火十八禁  × 2", @"大象 干柴烈火十八禁  × 3"];
    self.amountArray = @[@"0.01", @"0.02", @"0.03"];
    self.tableView.rowHeight = 44.0f;
    
    [QTPaySDK setQTPayWithAppID:@"AA2AB0B813856DB9A82E18C06525E6FE" accessToken:[QTDemoUserInfo sharedInstance].token appScheme:@"QTDemoDemo" callBack:^(NSDictionary *resultDic) {
    }];
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
        QTDemoGoodsDetailViewController *goodsDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTDemoGoodsDetailViewController"];
        goodsDetailViewController.goodsName = [self.goodsArray objectAtIndex:indexPath.row];
        goodsDetailViewController.payAmount = [self.amountArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:goodsDetailViewController animated:YES];
    }
    
}

@end
