//
//  TransListCell.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
#import "PNTransListModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNTransListCell : PNTableViewCell
@property (nonatomic, strong) PNTransListModel *model;
@property (nonatomic, copy) void (^collecBlock)(PNTransListModel *model);
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *accountLabel;
@property (nonatomic, strong) UIButton *collecButton;
@property (nonatomic, strong) UIView *lineView;
/// 是否最后一个
@property (nonatomic, assign) BOOL isLastCell;
@end

NS_ASSUME_NONNULL_END
