//
//  QTDemoGoodsDetailViewController.h
//  QTSDKDemo
//
//  Created by QTPay on 15/1/16.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QTPayOrder;

@interface QTDemoGoodsDetailViewController : UIViewController
@property (nonatomic,strong) QTPayOrder *order;
@end
