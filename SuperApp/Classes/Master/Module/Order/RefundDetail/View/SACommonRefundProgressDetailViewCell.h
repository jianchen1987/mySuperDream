//
//  SARefundProgressDetailViewCell.h
//  SuperApp
//
//  Created by Tia on 2022/5/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

@class SACommonRefundInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface SACommonRefundProgressDetailViewCell : SATableViewCell

@property (nonatomic, strong) SACommonRefundInfoModel *model;

@property (nonatomic, copy) NSString *orderNum;

@end

NS_ASSUME_NONNULL_END
