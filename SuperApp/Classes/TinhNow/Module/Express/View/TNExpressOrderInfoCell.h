//
//  TNExpressInfoCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  运单信息

#import "SATableViewCell.h"
@class TNExpressDetailsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressOrderInfoCell : SATableViewCell
///
@property (nonatomic, strong) TNExpressDetailsModel *model;
@end

NS_ASSUME_NONNULL_END
