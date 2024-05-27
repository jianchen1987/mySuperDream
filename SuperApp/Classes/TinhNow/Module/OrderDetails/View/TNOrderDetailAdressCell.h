//
//  TNOrderDetailAdressCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailAdressCellModel : TNModel
/// 联系人
@property (nonatomic, copy) NSString *name;
/// 地址
@property (nonatomic, copy) NSString *address;
/// gender
@property (nonatomic, copy) NSString *gender;
/// 电话
@property (nonatomic, copy) NSString *phone;
/// 是否显示修改按钮 (订单详情里面 有三种状态需要显示)
@property (nonatomic, assign) BOOL isShowEdit;
/// 订单状态
@property (nonatomic, copy) TNOrderState status;
@end


@interface TNOrderDetailAdressCell : SATableViewCell
///
@property (strong, nonatomic) TNOrderDetailAdressCellModel *model;
/// 修改按钮点击回调
@property (nonatomic, copy) void (^editClickHanderBlock)(void);
@end

NS_ASSUME_NONNULL_END
