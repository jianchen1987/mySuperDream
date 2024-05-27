//
//  WMShoppingAddressTableViewCell.h
//  SuperApp
//
//  Created by Chaos on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingAddressTableViewCell : SATableViewCell
/// 是否需要校验地址是否完善
@property (nonatomic, assign) BOOL isNeedCompleteAddress;
/// 模型
@property (nonatomic, strong) SAShoppingAddressModel *model;
/// 线条
@property (nonatomic, strong, readonly) UIView *bottomLine;

@end

NS_ASSUME_NONNULL_END
