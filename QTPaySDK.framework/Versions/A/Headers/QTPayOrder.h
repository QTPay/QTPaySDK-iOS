//
//  QTPayOrder.h
//  QTSDKDemo
//
//  Created by YoungShook on 14/12/11.
//  Copyright (c) 2014年 QFPay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, QTPayType) {
	QTPayTypeNone = 0, /**使用余额或优惠券抵扣支付金额*/
	QTPayTypeAliPay, /**使用支付宝支付*/
	QTPayTypeWeChat, /**使用微信支付*/
};

typedef NS_ENUM (NSInteger, QTActionType) {
	QTActionTypeGoods = 0, /**进行普通商品或服务的支付行为*/
	QTActionTypeRecharge, /**对用户账户充值的支付行为*/
};

typedef NS_ENUM (NSInteger, QTRespCode) {
	QTSuccess           = 0,    /**交易成功    */
	QTErrCodeCommon     = -1,   /**普通错误类型    */
	QTErrCodeUserCancel = -2,   /**用户点击取消并返回    */
	QTErrCodeSentFail   = -3,   /**发送交易失败    */
	QTErrConnection     = -4,   /**网络连接失败*/
	QTErrInvalidParameters  = -5,   /**无效的请求参数*/
};

/**
 *	服务完成回调Block
 *
 *	@param resultDic 结果
 */
typedef void (^CompletionBlock)(NSDictionary *resultDic);

/**
 *	支付完成回调Block
 *
 *	@param success   支付结果成功或失败
 *	@param PayType   支付类型
 *	@param resultDic 支付结果详情
 */
typedef void (^PayCompletionBlock)(QTRespCode resultCode, QTPayType PayType, NSDictionary *resultDic);


@interface QTPayOrder : NSObject

/** 必填
 *	支付类型
 */
@property (nonatomic, assign) QTPayType payType;

/** 必填
 *  动作类型
 */
@property (nonatomic, assign) QTActionType actionType;

/** 必填
 *	外部订单号
 */
@property (nonatomic, copy) NSString *out_sn;

/** 必填
 *	商品服务的名称
 */
@property (nonatomic, copy) NSString *goods_name;

/** 选填
 *	商品或服务的描述
 */
@property (nonatomic, copy) NSString *goods_info;

/** 必填
 *	商品或服务的总金额(优惠前) 单位分
 */
@property (nonatomic, copy) NSString *total_amt;

/** 必填
 *	用户实际需要支付的金额(优惠后) 单位分
 */
@property (nonatomic, copy) NSString *pay_amt;

/** 必填
 *	消费者的手机号
 */
@property (nonatomic, copy) NSString *mobile;

/** 必填
 *	预下单orderToken
 */
@property (nonatomic, copy) NSString *order_token;

/** 选填
 *	使用优惠券的Code
 */
@property (nonatomic, copy) NSString *coupon_code;

/** 选填
 *	使用的余额金额 单位分
 */
@property (nonatomic, copy) NSString *balance_amt;

/** 选填
 *	使用积分兑换的金额 单位分
 */
@property (nonatomic, copy) NSString *point_amt;

/** 选填
 *	使用积分的点数
 */
@property (nonatomic, copy) NSString *point_num;

/** 选填
 *	商户名称
 */
@property (nonatomic, copy) NSString *mchnt_name;

/**
 *	获取订单List
 *
 *	@return 订单List
 */
- (NSDictionary *)orderInfo;

@end
