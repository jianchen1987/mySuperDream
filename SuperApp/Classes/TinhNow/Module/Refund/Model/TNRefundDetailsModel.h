//
//  TNRefundDetailsModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundDetailsItemsModel : TNModel
/// 标题文案
@property (nonatomic, strong) NSString *title;
/// 内容文案
@property (nonatomic, strong) NSString *content;
/// 操作时间
@property (nonatomic, strong) NSString *date;


/// details
///
@property (nonatomic, strong) NSString *_id;
///
@property (nonatomic, strong) NSString *orderNo;
///
@property (nonatomic, strong) NSString *productId;
/// 申请类型
@property (nonatomic, strong) NSString *applyType;
/// 退款状态 0待审核 1待退款 2退款完成 3退款关闭
@property (nonatomic, strong) NSString *refundStatus;
/// 退款类型
@property (nonatomic, strong) NSString *refundType;
/// 退款金额
@property (nonatomic, strong) NSString *refundAmount;
/// 退款金额（money对象）
@property (nonatomic, strong) SAMoneyModel *refundAmountMoney;
/// 退款类型
@property (nonatomic, strong) NSString *type;
/// 申请原因
@property (nonatomic, strong) NSString *refundReason;
/// 补充说明
@property (nonatomic, strong) NSString *remarks;
/// 联系电话
@property (nonatomic, strong) NSString *phone;
/// 图片
@property (nonatomic, strong) NSArray *images;
/// 申请退款日期
@property (nonatomic, strong) NSString *createdDate;

/// icom
///
@property (nonatomic, strong) NSString *iconStr;

@end


@interface TNRefundDetailsModel : TNModel

/// 订单退款流程
@property (nonatomic, strong) TNRefundDetailsItemsModel *orderRefundFlow;
/// 用户退款流程
@property (nonatomic, strong) TNRefundDetailsItemsModel *userRefundFlow;
/// 申请退款
@property (nonatomic, strong) TNRefundDetailsItemsModel *orderRefundDTO;
@end

NS_ASSUME_NONNULL_END
