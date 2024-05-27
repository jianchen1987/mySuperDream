//
//  PNFilterView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

/// 点击确定回调
typedef void (^ConfirmBlock)(NSString *startDate, NSString *endDate, PNWalletListFilterType transType, NSString *currency);


@interface PNWalletOrderFilterView : PNView

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, assign) PNWalletListFilterType transType;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic, copy) ConfirmBlock confirmBlock;

- (void)showInSuperView:(UIView *)superview;

@end

NS_ASSUME_NONNULL_END
