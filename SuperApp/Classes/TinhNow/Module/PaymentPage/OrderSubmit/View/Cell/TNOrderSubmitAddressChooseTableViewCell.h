//
//  TNOrderSubmitAddressChooseTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SAShoppingAddressModel;


@interface TNOrderSubmitAddressChooseTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) SAShoppingAddressModel *model;
/// 点击回调
@property (nonatomic, copy) void (^clickOnCellView)(SAShoppingAddressModel *model);

@end

NS_ASSUME_NONNULL_END
