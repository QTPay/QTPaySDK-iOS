//
//  QTPaySDK.h
//  QTSDKDemo
//
//  Created by QTPay on 14/12/6.
//  Copyright (c) 2014年 QTPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTPayOrder.h"

typedef NS_ENUM (NSInteger, QTQueryDiscountType) {
    QTQueryDiscountTypeNone = 1 << 0,        /**默认全部*/
    QTQueryDiscountTypeBalance = 1 << 1,     /**余额*/
    QTQueryDiscountTypeCoupon = 1 << 2,      /**优惠券*/
    QTQueryDiscountTypePoint = 1 << 3,       /**积分*/
};


typedef NS_ENUM (NSInteger, QTSDKModelType) {
    QTSDKModelTypeSandBox,
    QTSDKModelTypeProduction,
    QTSDKModelTypeTest,
};

@interface QTPaySDK : NSObject

#pragma mark - API interface

/**
*	创建支付单例服务
*
*	@return 返回支付单例对象
*/
+ (instancetype)defaultService;

/**
 *	设置钱台SDK 环境（沙盒/正式）
 * 
 *  @model 设置环境
 *  默认：沙盒环境
 */
+ (void)setQTPayModel:(QTSDKModelType) model;

/**
 *	设置钱台SDK 签约商户的AppCode和访问Token(Token从钱台后台API获取,需在创建支付订单前传入此Token/AppCode/AppKey)
 *
 *	@param appCode 签约商户的AppCode
 *	@param appKey 签约商户的AppKey
 *	@param token 访问权限Token
 *	@param scheme App在info.plist中的scheme
 */
+ (void)setQTPayWithAppCode:(NSString *)appCode appKey:(NSString *)appKey accessToken:(NSString *)token appScheme:(NSString *)scheme;

/**
 *  获取收银台配置信息
 *
 *	@param order           订单信息
 *	@param completionBlock 配置结果回调Block
 */
+ (void)fetchCheckoutConfigWithOrder:(QTPayOrder *)order callBack:(CompletionBlock)completionBlock;

/**
 *	创建支付订单并发起支付
 *
 *	@param order           订单信息
 *	@param payCompletionBlock 支付结果回调Block
 */
- (void)paymentRequestWithOrder:(QTPayOrder *)order callBack:(PayCompletionBlock)payCompletionBlock;

/**
 *  获取服务器订单结果
 *
 *	@param completionBlock 配置结果回调Block
 */
- (void)fetchOrderResultCallBack:(CompletionBlock)completionBlock;

/**
 *	账户余额充值
 *
 *	@param order           订单信息
 *	@param payCompletionBlock 支付结果回调Block
 */
- (void)paymentRechargeRequestWithOrder:(QTPayOrder *)order callBack:(PayCompletionBlock)payCompletionBlock;

/**
 *  处理独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param resultUrl 支付结果url，传入后由SDK解析，统一在上面的pay方法的callback中回调
 *  @param payCompletionBlock 跳转App支付结果回调，保证跳转App支付过程中，即使调用方app被系统kill时，能通过这个回调取到支付结果。
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl standbyCallback:(PayCompletionBlock)payCompletionBlock;

/**
 *	获取订单的优惠券分享URL
 *
 *	@param completionBlock 优惠券分享URL回调Block
 */
- (void)fetchOrderShareURLCallBack:(CompletionBlock)completionBlock;

/**
 *	获取当前登录用户的优惠信息(余额，优惠券，积分)
 *
 *	@param queryType       查询类型
 *	@param amount          当前商品或服务消费金额(单位分，选填，若传amount则返回满足此金额可用的优惠券)
 *	@param completionBlock 用户优惠信息回调Block
 */
- (void)fetchUserDiscountInfoWithQueryType:(QTQueryDiscountType)type amount:(NSString *)amount callBack:(CompletionBlock)completionBlock;

/**
 *	获取当前账户余额充值金额对应的优惠信息,可用显示
 *
 *	@param recharge        充值金额(单位分)
 *	@param completionBlock 充值优惠信息回调Block
 */
- (void)fetchBalanceRechargeDiscountInfoWithAmount:(NSString *)recharge callBack:(CompletionBlock)completionBlock;

/**
 *	查询账户余额充值金额规则
 *
 *	@param completionBlock 余额充值规则回调Block
 */
- (void)queryBalanceRechargeDiscountRuleCallBack:(CompletionBlock)completionBlock;

#pragma mark - UI interface

/**
 *  调取钱台支付页面
 *
 *  @param payOrder        订单信息
 *  @param completionBlock 支付结果的回调Block
 */
- (void)presentPaymentViewWithOrder:(QTPayOrder *)payOrder withCompletion:(PayCompletionBlock)completionBlock;

@end
