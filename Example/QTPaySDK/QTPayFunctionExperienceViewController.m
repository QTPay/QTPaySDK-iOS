//
//  QTPayFunctionExperienceViewController.m
//  QTPaySDK
//
//  Created by Zr on 15/4/14.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTPayFunctionExperienceViewController.h"
#import "QTDemoGoodsListViewController.h"
#import "QTPDGoodsTableViewController.h"

@interface QTPayFunctionExperienceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *onlinePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *offlinePayBtn;

@end

@implementation QTPayFunctionExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"返回";
    self.navigationItem.backBarButtonItem = backbutton;
}

- (IBAction)onlinePayBtnClick:(UIButton *)sender {
    QTDemoGoodsListViewController *goodsListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTDemoGoodsListViewController"];
    [self.navigationController pushViewController:goodsListViewController animated:YES];
}

- (IBAction)offlinePayBtnClick:(UIButton *)sender {
    
    QTPDGoodsTableViewController *goodsListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTPDGoodsTableViewController"];
    goodsListViewController.userToken = [[QTDemoUserInfo sharedInstance] token];
    [self.navigationController pushViewController:goodsListViewController animated:YES];
    
}

@end
