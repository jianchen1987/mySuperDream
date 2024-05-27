//
//  PayHDInfoCell.h
//  ViPay
//
//  Created by Quin on 2021/9/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "HDDealCommonInfoRowViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PayHDInfoCell : UITableViewCell
@property (nonatomic, strong) HDDealCommonInfoRowViewModel *model;
@property (nonatomic, strong) UILabel *titleLabel; ///< 标题
@property (nonatomic, strong) UILabel *detailLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
