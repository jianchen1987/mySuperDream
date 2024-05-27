//
//  TNOrderDetailsBizPartModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAMoneyModel.h"
#import "TNCodingModel.h"
#import "TNEnum.h"
#import "TNModel.h"
#import "TNOrderDetailExpressOrderModel.h"
#import "TNOrderDetailsCouponModel.h"
#import "TNOrderDetailsGoodsInfoModel.h"
#import "TNOrderDetailsPaymentInfoModel.h"
#import "TNOrderDetailsShippingInfoModel.h"
#import "TNOrderDetailsStoreInfoModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsBizPartModel : TNModel
/// 业务 detail id
@property (nonatomic, strong) NSString *_id;
/// 优惠折扣
@property (nonatomic, strong) SAMoneyModel *promotionDiscount;
/// 状态标题
@property (nonatomic, copy) NSString *statusTitle;
/// 状态说明文案
@property (nonatomic, copy) NSString *statusDes;
/// 运费
@property (nonatomic, strong) SAMoneyModel *freight;
/// 运费优惠
@property (nonatomic, strong) SAMoneyModel *freightDiscount;
/// 已退货数量
@property (nonatomic, strong) NSNumber *returnedQuantity;
/// 备注
@property (nonatomic, copy) NSString *remark;
/// 过期时间
@property (nonatomic, assign) NSTimeInterval expire;
/// 类型显示标题
@property (nonatomic, copy) NSString *typeTitle;
/// 应付金额
@property (nonatomic, strong) SAMoneyModel *amountPayable;
/// 订单类型
@property (nonatomic, copy) TNOrderType type;
/// 兑换积分
@property (nonatomic, strong) NSNumber *exchangePoint;
/// 可退金额
@property (nonatomic, strong) SAMoneyModel *refundableAmount;
/// 买家备注
@property (nonatomic, copy) NSString *userBuyRemark;
/// 订单来源
@property (nonatomic, copy) NSString *orderSource;
/// 优惠券折扣
@property (nonatomic, strong) SAMoneyModel *couponDiscount;
/// 退款金额
@property (nonatomic, strong) SAMoneyModel *refundAmount;
/// 税费
@property (nonatomic, strong) SAMoneyModel *tax;
/// 是否使用优惠券
@property (nonatomic, assign) BOOL isUseCouponCode;
/// 已付金额
@property (nonatomic, strong) SAMoneyModel *amountPaid;
/// 是否已兑换积分
@property (nonatomic, assign) BOOL isExchangePoint;
/// 数量
@property (nonatomic, strong) NSNumber *quantity;
/// 订单状态
@property (nonatomic, copy) TNOrderState status;
/// 商品价格
@property (nonatomic, strong) SAMoneyModel *price;
/// 赠送积分
@property (nonatomic, strong) NSNumber *rewardPoint;
/// 手续费
@property (nonatomic, strong) SAMoneyModel *fee;
/// 是否已评论
@property (nonatomic, assign) BOOL isReviewed;
/// 调整金额
@property (nonatomic, strong) SAMoneyModel *offsetAmount;
/// 已发货数量
@property (nonatomic, strong) NSNumber *shippedQuantity;
/// 编号
@property (nonatomic, copy) NSString *sn;
/// 支付信息
@property (nonatomic, strong) TNOrderDetailsPaymentInfoModel *paymentInfo;
/// 订单号
@property (nonatomic, copy) NSString *unifiedOrderNo;
/// 完成日期
@property (nonatomic, assign) NSTimeInterval completeDate;
/// 重量
@property (nonatomic, strong) NSNumber *weight;
/// 商品
@property (nonatomic, strong) NSArray<TNOrderDetailsGoodsInfoModel *> *items;
/// 配送信息
@property (nonatomic, strong) TNOrderDetailsShippingInfoModel *shippingInfo;
/// 备注
@property (nonatomic, copy) NSString *memo;
/// 金额
@property (nonatomic, strong) SAMoneyModel *amount;
/// 门店信息
@property (nonatomic, strong) TNOrderDetailsStoreInfoModel *storeInfo;
/// 取消时间
@property (nonatomic, assign) NSTimeInterval cancelDate;
/// 是否改价
@property (nonatomic, assign) BOOL isAdjustPrice;
/// 改价原因
@property (nonatomic, copy) NSString *adjustPriceRemark;
/// 订单退补差价备注
@property (nonatomic, copy) NSString *differencePriceRemark;
/// 退补差价修改时间
@property (nonatomic, assign) NSTimeInterval differencePriceModifyTime;
/// 是否做了退补差价
@property (nonatomic, assign) BOOL differenceChanged;
/// 退补差价金额 负数是退差价  正数是补差价
@property (nonatomic, strong) SAMoneyModel *differencePrice;
/// 活动订单所属的任务id
@property (nonatomic, strong) NSString *taskId;
/// 活动订单所属的活动id
@property (nonatomic, strong) NSString *activityId;
/// 物流单信息
@property (nonatomic, strong) TNOrderDetailExpressOrderModel *expressOrder;
/// 优惠券对象
@property (nonatomic, strong) TNOrderDetailsCouponModel *platformCoupon;
/// 订单退款id
@property (nonatomic, strong) NSString *orderRefundsId;
/// 订单顶部提示公告
@property (nonatomic, copy) NSString *orderDetailTopNotice;
/// 海外购物流信息文案
@property (nonatomic, copy) NSString *expressTxt;
/// 海外购运费
@property (nonatomic, strong) SAMoneyModel *overSeaFreightPrice;
/// 运费文案 显示
@property (nonatomic, strong) SAInternationalizationModel *freightMessageLocales;
/// 汇率
@property (nonatomic, copy) NSString *khrExchangeRate;
/// 海外购到付运费
@property (strong, nonatomic) SAMoneyModel *ceWorthTotal;
/// 送货时间
@property (copy, nonatomic) NSString *deliveryTime;
/// 退款状态文案
@property (nonatomic, copy) NSString *refundStatusDes;
/// 中国段运费
@property (nonatomic, strong) SAMoneyModel *freightPriceChina;
/// 在线支付渠道编码
@property (nonatomic, copy) HDCheckStandPaymentTools payChannelCode;
/// 立即送达时间文案
@property (copy, nonatomic) NSString *immediateTime;
/// 瑞尔支付金额
@property (nonatomic, copy) NSString *khrAmount;
/// 优惠码优惠
@property (strong, nonatomic) TNOrderDetailsCouponModel *promotionCodeDTO;
/// 物流公司
@property (nonatomic, copy) NSString *deliveryCorp;
@end

NS_ASSUME_NONNULL_END
