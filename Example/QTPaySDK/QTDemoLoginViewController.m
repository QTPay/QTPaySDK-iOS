//
//  QTDemoLoginViewController.m
//  QTSDKDemo
//
//  Created by QTPay on 14/12/6.
//  Copyright (c) 2014年 QTPay. All rights reserved.
//

#import "QTDemoLoginViewController.h"
#import "QTDemoGoodsListViewController.h"
#import "QTDemoSettingListViewController.h"
#import "QTPayFunctionExperienceViewController.h"
#import "AppDelegate.h"

@interface QTDemoLoginViewController ()
@property (nonatomic,weak) IBOutlet UIButton *loginButton;
@property (nonatomic,weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,copy) NSIndexPath *selectedIndexPath;
@end

@implementation QTDemoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户登录";
    self.activityIndicatorView = [UIActivityIndicatorView new];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicatorView];
    
    self.loginButton.layer.borderColor = [UIColor colorWithRed:0 green:187./255. blue:0 alpha:1.f].CGColor;
    self.loginButton.layer.cornerRadius = 5.f;
    self.loginButton.layer.borderWidth = 1.f;
    [self.usernameTextField becomeFirstResponder];
    [self __handleTwoFingerSwipeAction];
}

- (IBAction)onLogin:(id)sender{

    NSString *errorTip = nil;
    QTLog(@"%@--%@--%@", QTSDKAppCode, QTSDKAppKey, QTSDKDemoOutMerchant);
    if(![self.usernameTextField.text length]){
        errorTip = @"手机号不能为空";
    }else if([self.usernameTextField.text length] != 11 || ![self.usernameTextField.text hasPrefix:@"1"] || ![self.usernameTextField.text verfiyNumber]) {
        errorTip = @"请输入正确的手机号";
    }
    
    if(errorTip) {
        [UIAlertView showWithTitle:@"提示" message:errorTip cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    
    [self.usernameTextField resignFirstResponder];
    __weak QTDemoLoginViewController *weakSelf = self;
    [self.activityIndicatorView startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:[NSString stringWithFormat:@"%@/createtoken?mobile=%@&app_code=%@&out_mchnt=%@", QTSDKDemoBaseAPI, self.usernameTextField.text, QTSDKAppCode, QTSDKDemoOutMerchant] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [weakSelf.activityIndicatorView stopAnimating];
        QTLog(@"!!!%@", [NSString stringWithFormat:@"%@/createtoken?mobile=%@&app_code=%@&out_mchnt=%@", QTSDKDemoBaseAPI, self.usernameTextField.text, QTSDKAppCode, QTSDKDemoOutMerchant]);
        QTPayFunctionExperienceViewController *functionExperienceVc = [self.storyboard instantiateViewControllerWithIdentifier:@"QTPayFunctionExperienceViewController"];
        [QTDemoUserInfo sharedInstance].mobile = weakSelf.usernameTextField.text;
        [QTDemoUserInfo sharedInstance].token = responseObject[@"token"];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).userToken = responseObject[@"token"];
        [weakSelf.navigationController pushViewController:functionExperienceVc animated:YES];
        QTLog(@"responseObject=%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.activityIndicatorView stopAnimating];
        [UIAlertView showWithTitle:@"提示" message:error.localizedDescription cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    }];
}

// 双指右划手势
- (void)__handleTwoFingerSwipeAction{
    
    UISwipeGestureRecognizer *actionGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [actionGestureRecognizer setNumberOfTouchesRequired:2];
    [actionGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:actionGestureRecognizer];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapGesture:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    QTDemoSettingListViewController *settingListViewController = [QTDemoSettingListViewController new];
    UINavigationController *settingNavigationController = [[UINavigationController alloc] initWithRootViewController:settingListViewController];
    settingListViewController.selectedIndexPath = self.selectedIndexPath;
    settingListViewController.selectedListBlock = ^(id object) {
        QTDemoSettingListViewController *settingListViewController = (QTDemoSettingListViewController *)object;
        self.selectedIndexPath = settingListViewController.selectedIndexPath;
    };
    [self.navigationController presentViewController:settingNavigationController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
