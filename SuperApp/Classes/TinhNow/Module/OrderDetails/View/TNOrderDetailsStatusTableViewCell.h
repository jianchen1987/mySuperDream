//
//  TNOrderDetailsStatusTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"
#import "TNOrderDetailExpressOrderModel.h"
#import "TNOrderDetailsPaymentInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsStatusTableViewCellModel : TNModel
/// 订单状态
@property (nonatomic, copy) NSString *orderState;
///// 状态标题
@property (nonatomic, copy) NSString *statusTitle;
/// 超时时间
@property (nonatomic, assign) NSTimeInterval expireTime;
///// 状态描述
@property (nonatomic, copy) NSString *statusDes;
///
@property (nonatomic, strong) TNOrderDetailsPaymentInfoModel *paymentInfo;
/// 配送时间
@property (nonatomic, copy) NSString *deliverTime;
@end


@interface TNOrderDetailsStatusTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNOrderDetailsStatusTableViewCellModel *model;
/// 刷新回调
@property (nonatomic, copy) void (^needReflushBlock)(void);
@end

NS_ASSUME_NONNULL_END
