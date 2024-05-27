//
//  DepositCell.h
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNDepositModel.h"
#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNDepositCell : PNTableViewCell
@property (nonatomic, strong) PNDepositModel *model;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) SALabel *detailLB;
@property (nonatomic, strong) HDUIButton *button;
@property (nonatomic, copy) void (^collecBlock)(PNDepositModel *model);

@end

NS_ASSUME_NONNULL_END
