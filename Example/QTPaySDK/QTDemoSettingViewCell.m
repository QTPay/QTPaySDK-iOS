//
//  QTDemoSettingViewCell.m
//  QTPaySDK
//
//  Created by wanglijiao on 15/3/19.
//  Copyright (c) 2015年 QTPay. All rights reserved.
//

#import "QTDemoSettingViewCell.h"

@implementation QTDemoSettingViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
