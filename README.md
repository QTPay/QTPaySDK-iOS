# 钱台线上收银台_iOS接入文档
标签： 钱台交易云-线上收银台

##1. 如何集成

### 1.1 使用CocoaPods集成

``` ruby
    pod 'QTPaySDK_UI_All'
```

注：默认会自动安装支付宝和微信 SDK，若项目中已集成过装支付宝或微信 SDK，为避免重复引入，请手动集成。

### 1.2 手动下载SDK集成

- 下载地址：

``` bash
    https://github.com/QTPay/QTPaySDK-iOS/archive/ui_checkout_all.zip
```
- 添加步骤：

    1. 把QTPaySDK.framework 拖入到您App工程下对应Targets的Frameworks文件夹中.
    2. 在工程中选择「 Build Phases 」/ 「Copy Bundle Resources」/选项点击加号,选择 Add Other… ,然后找到工程文件下QTPaySDK.framework中的QTPaySDKResource.bundle,添加进来.
    3.手动添加微信和支付宝SDK到工程中,同时加入微信和支付宝依赖的Framework.(微信的1.5 版本SDK 需要另再加入libc++.dylib)


- 必要依赖 Frameworks:

 * CFNetwork.framework
 * SystemConfiguration.framework
 * Security.framework


- 导入支付宝和微信SDK（若工程集成过或使用CocoaPods集成则无需导入）：

 * __AlipaySDK:__
     * AlipaySDK.bundle
     * AlipaySDK.framework
     * libssl.a
     * libcrypto.a

 * __WeChatSDK:__
     * libWeChatSDK.a

### 1.3 引入相关头文件

```objectivec
#import <QTPaySDK/QTPaySDK.h>
#import <QTPaySDK/QTPayOrder.h>
```

## 2. 如何使用

- 支付过程参与对象：

 * `Client`：集成方的终端（iOS/Android/Web）
 * `Server`：集成方的后台
 * `QTCloud`: 钱台支付服务方的云平台

### 2.1 支付流程

 1. 用户在登录`Client`后，`Client`请求`Server`获取`UserToken`（同时`Server`与`QTCloud`同步`UserToken`）
 2. `Client`初始化`QTPaySDK`相关参数

```objectivec
    [QTPaySDK setQTPayWithAppCode:@"123456"
	      appKey:@"123456"
	      accessToken:self.userToken
	      appScheme:@"QTPaySDKDemo"];
```

* 创建预订单（`Clinet`请求`Server`获取`OrderToken`）

```objectivec
    // 生成订单对象
    QTPayOrder *prePayOrder = [QTPayOrder new];
    prePayOrder.order_token = @"A764593SADD66523HSGA67575G";
    prePayOrder.out_sn     = @"JK2364563SA978638ADASD76523748";
    prePayOrder.pay_amt    = @"1000";
    prePayOrder.total_amt  = @"1000";
    prePayOrder.goods_info = @"包含基础护手,卸甲油胶,不含卸光疗延长甲.";
    prePayOrder.goods_name = @"武媚娘美甲基础套餐";
    prePayOrder.goods_num = @"3";
    prePayOrder.mobile     = @"18888888888";
    prePayOrder.mchnt_name = @"武媚娘";
    prePayOrder.actionType = QTActionTypeGoods;
    prePayOrder.goods_memo = @"媚娘的店，有你好看，年终大促，买3赠1.";
```

* 获取用户账户信息（优惠券、余额、积分）

```objectivec
    [[QTPaySDK defaultService] fetchUserDiscountInfoWithQueryType:(QTQueryDiscountType)type 								amount:(NSString *)amount
							callBack:^(NSDictionary *resultDic) {
		// 处理回调返回的用户账户信息，用于展示和选择
    }];
```

* 发起支付

```objectivec
    [[QTPaySDK defaultService] paymentRequestWithOrder:self.order
			       callBack:^(QTRespCode respCode,
					  QTPayType PayType,
					  NSDictionary *resultDic) {
		// 处理回调返回的支付结果
    }];
```
* 账户余额充值

```objectivec
    [[QTPaySDK defaultService] paymentRechargeRequestWithOrder:self.order
			       callBack:^(QTRespCode respCode,
					  QTPayType PayType,
					  NSDictionary *resultDic) {
		// 处理回调返回的余额支付结果
    }];
```

* 接收回调

在App中下面Delegate系统回调方法中调用 QTPaySDK 提供的API接口。

 App系统回调方法：
```objectivec
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
```

调用 QTPaySDK 提供的接收方法：

```objectivec
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl standbyCallback:(PayCompletionBlock)payCompletionBlock;
```

### 2.2 查询

* 查询当前账户余额充值金额对应的优惠信息

```objectivec
    [[QTPaySDK defaultService] fetchBalanceRechargeDiscountInfoWithAmount
			       callBack:^(NSDictionary *resultDic) {
	      //处理回调返回的账户余额充值金额对应的优惠信息
    }];
```

* 查询账户余额充值金额规则

```objectivec
    [[QTPaySDK defaultService] queryBalanceRechargeDiscountRuleCallBack:^(NSDictionary *resultDic) {
	      //处理回调返回的账户余额充值金额规则
    }];
```

* 获取服务器订单结果（用于确认服务器端得到的支付结果）

```objectivec
    [[QTPaySDK defaultService] fetchOrderResultCallBack:^(NSDictionary *resultDic) {
	      //处理回调返回的服务器订单结果
    }];
```

### 2.3 分享红包

* 根据订单号请求SDK取红包URL

```objectivec
    [[QTPaySDK defaultService] fetchOrderShareURLCallBack:^(NSDictionary *resultDic) {
		//处理回调返回的红包URL
    }];
```

### 2.4 SDK动态环境配置

* 设置钱台SDK 环境（沙盒/正式/测试）

```objectivec
    //QTSDKModelType:
    //QTSDKModelTypeSandBox 沙盒环境（用于前期接入）
    //QTSDKModelTypeProduction 正式环境（用于产品上线）
    //QTSDKModelTypeTest 测试调试（用于Debug）
    [QTPaySDK setQTPayModel:(QTSDKModelType) model]
```

* 获取收银台显示内容动态配置信息

```objectivec
    [QTPaySDK fetchCheckoutConfigWithOrder:self.order                                        callBack:^(NSDictionary *resultDic) {
	      //处理回调返回的收银台动态配置信息,用于配置收银台UI内容.
    }];
```

## 3. 使用钱台提供的收银台UI接口

* 发起支付

```objectivec
    [[QTPaySDK defaultService] presentPaymentViewWithOrder:self.order
			       withCompletion:^(QTRespCode respCode,
						QTPayType PayType,
						NSDictionary *resultDic) {
		// 处理回调返回的收银台支付结果
    }];
```
## 4. API 释义 ##

![](http://i.imgur.com/YH4JK6I.png)

注：详细的接口说明请见QTPaySDK.h文件。


===
===
===
===

钱台线下收款SDK for iOS App端接入文档
=========

标签： 钱台交易云-线下收款

1.接入调试前需获取或需要设置的信息
---------
    * `Scheme`  （设置iOS App的Scheme）
    * `TransferKey`（对称加密的Key，值写死为"qpos"）
    * 安装`钱方商户` iOS App
    
2.唤起`钱方商户`App 并支付
---------

### 请求参数 ###

|字段名          | 字段类型       | 字段含义|
|-------------|-------------|-----------|
|pay_order_create|string|支付订单创建者id，对应下单接口返回的create_userid字段|
|pay_order_id|string|支付订单id，对应下单接口返回的order_id字段|
|platform|string|网页端调用时填“1”，App调用时填"2"|
|qf_token|string|用户token，对应下单接口返回的qf_token字段|
|scheme|string|iOS App的Scheme|
|timestamp|string|发起请求的Unix时间戳|


`url`：
```objectivec
qpos://?pay_order_create=HHIKO121233S&pay_order_id=MX5FG2129HFD&platform=2&qf_token=be7018a1f5c24c7281bcc317dc5543ed&scheme=appdemo&timestamp=1426497589
```

### 调用方式 ###

```objectivec
NSURL *url = [NSURL URLWithString:@"url"];
[[UIApplication sharedApplication] openURL:url];
```

3.接收`钱方商户`App 的支付结果
---------

### 支付结果返回的参数 ###

|字段名          | 字段类型       | 字段含义|
|-------------|-------------|-----------|
|pay_order_id|string|支付订单id|
|status_code|string|交易状态码，0000表示成功，1111表示失败|
|timestamp|string|返回结果的Unix时间戳|
|sign|string|以上字段升序排列后加上`TransferKey`后算出的MD5值(32位大写)|

### 接收结果方式 ###

在App中下面Delegate系统回调方法中接收`钱方商户`App返回的支付结果。

 App系统回调方法：
```objectivec
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
```