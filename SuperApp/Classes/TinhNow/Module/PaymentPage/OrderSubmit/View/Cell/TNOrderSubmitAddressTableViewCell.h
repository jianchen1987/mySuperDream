//
//  TNOrderSubmitAddressTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"

typedef void (^EditClickHanderBlock)(void);

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderSubmitAddressTableViewCellModel : TNModel
/// 联系人
@property (nonatomic, copy) NSString *name;
/// 地址
@property (nonatomic, copy) NSString *address;
/// gender
@property (nonatomic, copy) NSString *gender;
/// 电话
@property (nonatomic, copy) NSString *phone;
/// default
@property (nonatomic, assign) BOOL isDefault;
/// 是否显示箭头
@property (nonatomic, assign) BOOL hideRightArrow;
/// 订单状态
@property (nonatomic, copy) TNOrderState status;
/// 是否显示修改按钮 (订单详情里面 有三种状态需要显示)
@property (nonatomic, assign) BOOL isShowEdit;

@end


@interface TNOrderSubmitAddressTableViewCell : SATableViewCell

/// model
@property (nonatomic, strong) TNOrderSubmitAddressTableViewCellModel *model;

/// 修改按钮点击回调
@property (nonatomic, copy) EditClickHanderBlock editClickHanderBlock;
@end

NS_ASSUME_NONNULL_END
