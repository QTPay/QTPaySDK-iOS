//
//  QTDemoLoginViewController.m
//  QTSDKDemo
//
//  Created by QTPay on 14/12/6.
//  Copyright (c) 2014年 QTPay. All rights reserved.
//

#import "QTDemoLoginViewController.h"
#import "QTDemoGoodsListViewController.h"

@interface QTDemoLoginViewController ()
@property (nonatomic,weak) IBOutlet UIButton *loginButton;
@property (nonatomic,weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
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
    // Do any additional setup after loading the view.
}

- (IBAction)onLogin:(id)sender{

    NSString *errorTip = nil;
    if(![self.usernameTextField.text length]){
        errorTip = @"手机号不能为空";
    }else if([self.usernameTextField.text length] != 11 || ![self.usernameTextField.text hasPrefix:@"1"] || ![self.usernameTextField.text verfiyNumber]) {
        errorTip = @"请输入正确的手机号";
    }
    
    if(errorTip) {
        [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:errorTip cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil] show];
        return;
    }
    
    [self.usernameTextField resignFirstResponder];
    __weak QTDemoLoginViewController *weakSelf = self;
    [self.activityIndicatorView startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    [manager GET:[NSString stringWithFormat:@"%@/createtoken?mobile=%@",QTSDKDemoBaseAPI,self.usernameTextField.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf.activityIndicatorView stopAnimating];
        QTDemoGoodsListViewController *goodsListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QTDemoGoodsListViewController"];
        [QTDemoUserInfo sharedInstance].mobile = weakSelf.usernameTextField.text;
        [QTDemoUserInfo sharedInstance].token = responseObject[@"token"];
        [weakSelf.navigationController pushViewController:goodsListViewController animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.activityIndicatorView stopAnimating];
        [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:error.localizedDescription cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil]show];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
