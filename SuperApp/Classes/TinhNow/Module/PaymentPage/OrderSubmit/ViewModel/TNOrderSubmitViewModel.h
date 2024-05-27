//
//  TNOrderSubmitViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNShoppingCarStoreModel;
@class SAMoneyModel;
@class SAShoppingAddressModel;
@class TNCalcTotalPayFeeTrialRspModel;
@class TNPaymentMethodModel;
@class TNShippingMethodModel;
@class WMOrderSubmitRspModel;
@class TNPromoCodeRspModel;
@class SACouponTicketModel;
@class TNCouponParamsModel;
@class TNSubmitOrderNoticeModel;
@class TNCheckRegionModel;
@class TNOrderSubmitGoodsTableViewCell;
@class TNCheckSumitOrderModel;
@class TNDeliveryComponyModel;

@interface TNOrderSubmitViewModel : TNViewModel
/// 购物车商品数
@property (nonatomic, assign) NSUInteger totalCount;
/// 地址模型
@property (nonatomic, strong, readonly) SAShoppingAddressModel *addressModel;
/// 配送方式
@property (nonatomic, strong) TNShippingMethodModel *shippiingMethodModel;
/// 支付方式
@property (nonatomic, strong) TNPaymentMethodModel *__nullable paymentMethodModel;
/// 试算结果
@property (nonatomic, strong) TNCalcTotalPayFeeTrialRspModel *calcResult;
/// 当前门店购物车Model
@property (nonatomic, strong) TNShoppingCarStoreModel *storeModel;
/// 数据
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 当前可用的支付方式
@property (nonatomic, strong) NSArray<TNPaymentMethodModel *> *avaliablePaymentMethods;
/// 备注
@property (nonatomic, copy) NSString *memo;
/// 优惠券列表
@property (strong, nonatomic) NSArray<HDTableViewSectionModel *> *coupons;
/// 当前的优惠券列表请求参数
@property (strong, nonatomic) TNCouponParamsModel *paramsModel;
/// 公告相关数据
@property (strong, nonatomic) TNSubmitOrderNoticeModel *noticeModel;
/// 是否有同意条款
@property (nonatomic, assign) BOOL hasAgreeTerms;
/// 是否含有海外购商品
@property (nonatomic, assign) BOOL hasOverseasGood;
/// 漏斗埋点用
@property (nonatomic, copy) NSString *funnel;
///< 来源
@property (nonatomic, copy) NSString *source;
///< 关联ID
@property (nonatomic, copy) NSString *associatedId;
/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;
/// 商品模型数组
@property (strong, nonatomic) NSMutableArray *goodCellModelArr;
///< 商户号
@property (nonatomic, copy, nullable) NSString *merchantNo;
/// 可选的配送时间
@property (nonatomic, copy, readonly) NSString *deliveryTime;
/// 支付优惠金额 有的要需要处理
@property (strong, nonatomic, readonly) SAMoneyModel *paydiscountAmount;

/// 是否可以下单  默认是可以下单的  如果商品全部下架 就不能下单
@property (nonatomic, assign) BOOL canSubmitOrder;

/// 选中的物流公司数据
@property (strong, nonatomic, readonly) TNDeliveryComponyModel *selectedDeliveryComponyModel;
/// 选中的物流公司数据
@property (strong, nonatomic, readonly) NSArray *deliveryComponylist;


/// 网络加载失败
@property (nonatomic, copy) void (^networkFailBlock)(void);

/// 试算失败回调
@property (nonatomic, copy) void (^calcPayFeeFailBlock)(SARspModel *rspModel);
/// 是否需要弹窗提示输入优惠码
@property (nonatomic, assign) BOOL needToastEnterPromotionCode;
/// 是否需要弹窗提示选择优惠券
@property (nonatomic, assign) BOOL needToastSelectedCoupon;
/// 获取提交订单所需要的数据
- (void)querySubmitOrderDependData;
/// 获取公告数据
- (void)queryNoticeInfo;
/// 商品试算
- (void)calcTotalPayFee;
/// 预约时间弹窗
- (void)showSelectDeliveryTimeAlertViewWithTitle:(NSString *)title;
/// 更新支付优惠
- (void)updatePayDiscountAmount:(SAMoneyModel *_Nullable)payDiscountAmount;
/// 更新地址
- (void)updateAddressModel:(SAShoppingAddressModel *)addressModel;
/// 提交订单
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)submitOrderSuccess:(void (^_Nullable)(WMOrderSubmitRspModel *rspModel, TNPaymentMethodModel *paymentType))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 校验配送地址是否在配送范围内
- (void)checkRegion:(void (^)(TNCheckRegionModel *checkModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 下单前校验 1.校验配送地址是否在配送范围内  2.是否有重复下单
- (void)checkBeforeSubmitOrder:(void (^)(TNCheckSumitOrderModel *checkModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 通过随机串获取订单号
- (void)getUnifiedOrderNoByRandomStrComplete:(void (^)(NSString *orderNo))complete;
/// 立即送达不可用处理
- (void)processImmediateDeliveryNotAvailable;
/// 设置选中的物流公司
- (void)setSelectedDeliveryCompany:(TNDeliveryComponyModel *)model;

/// 重新加载
- (void)refreshLoad;
@end

NS_ASSUME_NONNULL_END
