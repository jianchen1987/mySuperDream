//
//  bankListCell.h
//  ViPay
//
//  Created by Quin on 2021/8/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
#import "PNBankListModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBankListCell : PNTableViewCell
@property (nonatomic, strong) PNBankListModel *model;
@property (nonatomic, strong) UIView *lineview;
@property (nonatomic, strong) UIImageView *iconImageView; ///< 图标
@property (nonatomic, strong) UILabel *titleLabel;        ///< 标题
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
