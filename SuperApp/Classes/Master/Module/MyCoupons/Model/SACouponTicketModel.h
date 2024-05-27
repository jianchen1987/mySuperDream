//
//  SACouponTicketModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMerchantInfoModel.h"
#import "SAMoneyModel.h"
#import "WMModel.h"
#import "WMOrderSubmitCouponModel.h"

typedef NS_ENUM(NSUInteger, SACouponTicketCellType) {
    SACouponTicketCellTypeNormal = 0, ///< 普通
    SACouponTicketCellTypeSelect      ///< 选择
};

NS_ASSUME_NONNULL_BEGIN


@interface SACouponTicketModel : WMModel
/// 消费门槛
@property (nonatomic, strong) SAMoneyModel *thresholdAmount;
/// 优惠券分类ID
@property (nonatomic, copy) NSString *couponNo;
/// 优惠券商户信息-商户券专用
@property (nonatomic, strong) SAMerchantInfoModel *merchantInfo;
/// 优惠券状态
@property (nonatomic, copy) SACouponTicketState couponState;
/// 折扣券专用 折扣比例
@property (nonatomic, assign) double couponDiscount;
/// 满减券/现金券专用 优惠金额
@property (nonatomic, strong) SAMoneyModel *couponAmount;
/// 优惠券使用说明(支付取这个字段，外卖不用)
@property (nonatomic, copy) NSString *couponUsageDescribe;
/// 优惠券归属类型 10-平台券 11-商户券 12-平台+商户券
@property (nonatomic, copy) WMCouponTicketSceneType sceneType;
/// 优惠券类型 13-折扣券 14-满减券 15-代金券 34-运费券
@property (nonatomic, assign) SACouponTicketType couponType;
/// 生效日期
@property (nonatomic, copy) NSString *effectiveDate;
/// 失效日期
@property (nonatomic, copy) NSString *expireDate;
/// 优惠券标题(支付取这个字段，外卖不用)
@property (nonatomic, copy) NSString *couponTitle;
/// 优惠券唯一编号
@property (nonatomic, copy) NSString *couponCode;
///< 支持的业务线
@property (nonatomic, strong) NSArray<NSNumber *> *businessTypeList;
/// 路由跳转地址
@property (nonatomic, copy) NSString *useLink;
///< 图标地址
@property (nonatomic, copy) NSString *iconUrl;
/// 10-正常 11-新到 12-快过期
@property (nonatomic, assign) NSInteger couponTimeStatus;
/// 使用日期
@property (nonatomic, assign) NSInteger useTime;
/// 消费上限 usd
@property (nonatomic, strong) SAMoneyModel *preferLimitUsd;
/// 优惠方式 10-固定金额 11-折扣比例
@property (nonatomic, assign) SACouponTicketDiscountType discountType;
/// 门店名字
@property (nonatomic, copy) NSString *storeName;
/// 折扣比例
@property (nonatomic, copy) NSString *preferRatio;
/// 展示折扣比例用这个
@property (nonatomic, copy) NSString *strPreferRatio;
/// 优惠券过期时间 yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString *couponExpireDate;
/// 优惠券过期时间 dd/MM/yyyy HH:mm:ss
@property (nonatomic, copy) NSString *formatCouponExpireDate;
/// 展示用优惠券有效结束时间 dd/MM/yyyy HH:mm
@property (nonatomic, copy) NSString *showCouponEffectiveDate;
/// 展示用优惠券有效开始时间 dd/MM/yyyy HH:mm
@property (nonatomic, copy) NSString *showCouponExpireDate;


#pragma mark - 绑定属性
/// 风格
@property (nonatomic, assign) SACouponTicketCellType cellType;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 是否展开
@property (nonatomic, assign) BOOL isExpanded;
/// 是否第一项
@property (nonatomic, assign) BOOL isFirstCell;
/// 是否最后一项
@property (nonatomic, assign) BOOL isLastCell;

/// 关联的下单页优惠券模型
@property (nonatomic, strong) WMOrderSubmitCouponModel *orderSubmitCouponModel;

+ (instancetype)modelWithOrderSubmitCouponModel:(WMOrderSubmitCouponModel *)model businessLine:(SAMarketingBusinessType)businessLine;
@end

NS_ASSUME_NONNULL_END
