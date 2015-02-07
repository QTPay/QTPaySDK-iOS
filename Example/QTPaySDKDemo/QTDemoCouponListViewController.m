//
//  QTPayCouponListViewController.m
//  QTPaySDK
//
//  Created by YoungShook on 15/2/6.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoCouponListViewController.h"

@interface QTDemoCouponListViewController ()

@end

@implementation QTDemoCouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的优惠券";
    self.tableView.rowHeight = 44.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.couponList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[[self.couponList[indexPath.row][@"amt"] stringValue] convertToYuan] stringByAppendingString:@"元"];
    cell.detailTextLabel.text = self.couponList[indexPath.row][@"title"];
    return cell;
}


@end
