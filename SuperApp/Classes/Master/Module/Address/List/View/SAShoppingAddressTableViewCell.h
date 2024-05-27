//
//  SAShoppingAddressTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAShoppingAddressTableViewCell : SATableViewCell
/// 是否检验地址是否完善
@property (nonatomic, assign) BOOL isNeedCompleteAddress;
/// 模型
@property (nonatomic, strong) SAShoppingAddressModel *model;
/// 线条
@property (nonatomic, strong, readonly) UIView *bottomLine;
/// 隐藏编辑按钮
@property (nonatomic, assign) BOOL showEditButton;
/// 标题
@property (nonatomic, strong) SALabel *titleLabel;
/// 描述
@property (nonatomic, strong) SALabel *detailTitleLabel;
/// 图标
@property (nonatomic, strong) UIImageView *iconView;
/// 编辑图片
@property (nonatomic, strong) UIImageView *typeIV;
/// 标签
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
@end

NS_ASSUME_NONNULL_END
