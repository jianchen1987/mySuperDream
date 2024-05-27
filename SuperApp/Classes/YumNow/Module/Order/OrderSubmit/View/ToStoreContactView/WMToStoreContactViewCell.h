//
//  WMToStoreContactViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/8/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SAShoppingAddressModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMToStoreContactViewCell : SATableViewCell

@property (nonatomic, strong) SAShoppingAddressModel *model;

@property (nonatomic, strong) UIButton *btn;

@end

NS_ASSUME_NONNULL_END
