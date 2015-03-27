//
//  QTDemoSettingListViewController.h
//  QTPaySDK
//
//  Created by wanglijiao on 15/3/17.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, QTDemoModelType) {
    QTDemoModelTypeProduction,
    QTDemoModelTypeSandBox,
    QTDemoModelTypeTest,
};

typedef void (^SelectedListBlock)(id object);

@interface QTDemoSettingListViewController : UITableViewController

@property (nonatomic,copy) NSIndexPath   *selectedIndexPath;
@property (nonatomic,copy) SelectedListBlock selectedListBlock;

@end
