//
//  QTDemoSettingListViewController.m
//  QTPaySDK
//
//  Created by wanglijiao on 15/3/17.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoSettingListViewController.h"
#import "QTDemoSettingViewCell.h"
#import <QTPaySDK/QTPaySDK.h>

@interface QTDemoSettingListViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSArray *demoModelList;
@property (nonatomic,copy)  NSString *appCode;
@property (nonatomic,copy)  NSString *appKey;
@property (nonatomic,copy)  NSString *mchntId;
@end

@implementation QTDemoSettingListViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"API环境";
    
    UIBarButtonItem *completeButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete:)];
    self.navigationItem.rightBarButtonItem = completeButton;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 44.0f;
    
    self.demoModelList = @[@"正式: qtdemo.qfpay.com",
                           @"沙盒: qtdemosandbox.qfpay.com",
                           @"Test: 172.100.101.178:8080",
                           @"DEV: 172.100.101.151:8080",
                           @"AppCode:",
                           @"AppKey:",
                           @"MchntId:"];
}

- (void)complete:(id)sender {
    
    [self.view endEditing:YES];
    if ([self.appCode length]) {
        QTSDKAppCode = self.appCode;
    }
    if ([self.appKey length]) {
        QTSDKAppKey = self.appKey;
    }
    if ([self.mchntId length]) {
        QTSDKDemoOutMerchant = self.mchntId;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (4 == textField.tag ) {
        self.appCode = textField.text;
    }else if (5 == textField.tag ){
        self.appKey = textField.text;
    }else if (6 == textField.tag ){
        self.mchntId = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.demoModelList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *modelCellID = @"modelCell";
    static NSString *parameterCellID = @"parameterCell";
    if (indexPath.row < 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:modelCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:modelCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.demoModelList[indexPath.row];
        [self __switchCellState:cell selected:[self.selectedIndexPath isEqual:indexPath]];
        if ([self.selectedIndexPath isEqual:indexPath]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        return cell;

    }else {
        QTDemoSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:parameterCellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"QTDemoSettingViewCell" owner:self options:nil][0];
        }
        cell.titleLabel.text = self.demoModelList[indexPath.row];
        cell.detailTextField.tag = indexPath.row;
        cell.detailTextField.delegate = self;
        return cell;
    }
 }

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > 3) {
        return nil;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self __switchCellState:cell selected:YES];
    self.selectedIndexPath = indexPath;
    return indexPath;
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self __switchCellState:cell selected:NO];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    self.selectedListBlock(self);
    
    if (0 == indexPath.row) {
        QTSDKDemoBaseAPI = @"https://qtdemo.qfpay.com";        // online
        QTSDKAppCode = @"45B78C3515583788E07C7D1C4F89B49A";
        QTSDKAppKey = @"0C3C2ECC4F192A166D6629F8B92663BB";
        QTSDKDemoOutMerchant = @"";
        [QTPaySDK setQTPayModel:QTSDKModelTypeProduction];
        
    }else if (1 == indexPath.row){
        QTSDKDemoBaseAPI = @"https://qtdemosandbox.qfpay.com"; // sandbox
        QTSDKAppCode = @"33856FB5471AB823119F2810C0CC2D7B";
        QTSDKAppKey = @"0C3C2ECC4F192A166D6629F8B92663BB";
        QTSDKDemoOutMerchant = @"";
        [QTPaySDK setQTPayModel:QTSDKModelTypeSandBox];
        
    }else if (2 == indexPath.row){
        QTSDKDemoBaseAPI = @"http://172.100.101.178:8080";     // Test
        QTSDKAppCode = @"8916DF0315571DE0F7BD60308BBA874C";
        QTSDKAppKey = @"api_key_test";
        QTSDKDemoOutMerchant = @"";
        [QTPaySDK setQTPayModel:QTSDKModelTypeTest];
    }else if (3 == indexPath.row){
        QTSDKDemoBaseAPI = @"http://172.100.101.151:8080";     // DEV
        QTSDKAppCode = @"10005";
        QTSDKAppKey = @"10005";
        QTSDKDemoOutMerchant = @"";
        [QTPaySDK setQTPayModel:QTSDKModelTypeDev];
    }

}

- (void)__switchCellState:(UITableViewCell *)cell selected:(BOOL)selected{
    
    if (selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

@end
