//
//  WMOrderFeedBackDetailModel.h
//  SuperApp
//
//  Created by wmz on 2022/11/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMOrderDetailProductModel.h"
#import "WMRspModel.h"
#import "WMShoppingCartStoreProduct.h"

NS_ASSUME_NONNULL_BEGIN

@class WMOrderFeedBackDetailTraclModel;


@interface WMOrderFeedBackDetailModel : WMRspModel
///售后反馈ID
@property (nonatomic, assign) NSInteger id;
///订单号
@property (nonatomic, copy) NSString *orderNo;
///反馈编号
@property (nonatomic, copy) NSString *postSaleNo;
///期望处理方式
@property (nonatomic, strong) WMOrderFeedBackPostShowType postSaleType;
///期望处理方式 文字
@property (nonatomic, strong) NSString *postSaleTypeStr;
///售后原因
@property (nonatomic, copy) NSString *reason;
///详细说明
@property (nonatomic, copy) NSString *remark;
///反馈图片
@property (nonatomic, copy) NSArray<NSString *> *imagePaths;
///实退金额
@property (nonatomic, strong) SAMoneyModel *actualRefund;
///退款金额
@property (nonatomic, strong) SAMoneyModel *refund;
///商品总金额
@property (nonatomic, strong) SAMoneyModel *commodityAmount;
///配送费金额
@property (nonatomic, strong) SAMoneyModel *deliveryFee;
///税费
@property (nonatomic, strong) SAMoneyModel *vat;
///打包费
@property (nonatomic, strong) SAMoneyModel *packageFee;
///处理状态
@property (nonatomic, strong) WMOrderFeedBackHandleStatus handleStatus;
///处理状态 文字
@property (nonatomic, strong) NSString *handleStatusStr;
///商品信息
@property (nonatomic, strong) NSArray<WMOrderDetailProductModel *> *commodityInfo;
///商品信息
@property (nonatomic, strong) NSArray<WMShoppingCartStoreProduct *> *showCommodityInfo;
///处理意见
@property (nonatomic, copy) NSString *handleOpinion;
///驳回原因
@property (nonatomic, copy) NSString *refuseReason;
///反馈时间
@property (nonatomic, copy) NSString *handleTime;
///反馈时间
@property (nonatomic, copy) NSString *createTime;
///售后反馈处理轨迹
@property (nonatomic, strong) NSArray<WMOrderFeedBackDetailTraclModel *> *postSaleTracks;

@end


@interface WMOrderFeedBackDetailTraclModel : WMRspModel
///处理类型 PSL001: 提交反馈 RECEIVE :PSL002: 接取 HANDLE :PSL003: 处理 REJECT :PSL004: 已驳回 DONE :PSL005: 处理完成 FINISH :PSL006: 处理完成-已解决
@property (nonatomic, copy) NSString *logType;
///处理类型str
@property (nonatomic, copy) NSString *logTypeStr;
///创建时间
@property (nonatomic, copy) NSString *createTime;

@end
NS_ASSUME_NONNULL_END
