//
//  TNOrderSubmitGoodsTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "SATableViewCell.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderSubmitGoodsTableViewCellModel : TNModel
/// 商品ID
@property (nonatomic, copy) NSString *productId;
/// logo
@property (nonatomic, copy) NSString *logoUrl;
/// itemname
@property (nonatomic, copy) NSString *goodsName;
/// skuName
@property (nonatomic, copy) NSString *skuName;
/// propertity
@property (nonatomic, strong) NSString *property ;
/// 数量
@property (nonatomic, strong) NSNumber *quantify;
/// 单价
@property (nonatomic, strong) SAMoneyModel *price;
/// line
@property (nonatomic, assign) CGFloat lineHeight;
/// 是否包邮
@property (nonatomic, assign) BOOL isFreeShipping;
/// 重量  返回的是 克  需转换成千克
@property (strong, nonatomic) NSNumber *weight;
/// 重量
@property (nonatomic, copy) NSString *showWight;
/// 供销码
@property (nonatomic, copy) NSString *sp;

///下面三个 订单详情使用
///活动订单所属的任务id
@property (nonatomic, strong) NSString *taskId;
///活动订单所属的活动id
@property (nonatomic, strong) NSString *activityId;
///订单类型
@property (nonatomic, strong) NSString *type;

/// 失效文案  如果商品失效或者下架 显示
@property (nonatomic, copy) NSString *invalidTips;
@end


@interface TNOrderSubmitGoodsTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNOrderSubmitGoodsTableViewCellModel *model;
/// 退款状态文案
@property (nonatomic, copy) NSString *refundStatusDes;
@end

NS_ASSUME_NONNULL_END
