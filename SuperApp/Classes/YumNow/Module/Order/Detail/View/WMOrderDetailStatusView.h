//
//  WMOrderDetailStatusView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMOrderDetailModel;
@class WMOrderDetailStoreDetailModel;
@class WMOrderDetailOrderInfoModel;
#import "WMUIButton.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailStatusView : SAView
/// 状态标题
@property (nonatomic, strong, readonly) YYLabel *statusTitleLB;
/// 所有操作
@property (nonatomic, strong, readonly) NSArray<UIButton *> *allOperationButton;
/// 联系电话按钮
@property (nonatomic, strong, readonly) HDUIButton *phoneBTN;
/// 确认取餐
@property (nonatomic, strong, readonly) HDUIButton *submitPickUpBTN;
/// 展示箭头
@property (nonatomic, assign, readonly) BOOL showArrow;
/// 状态文本
@property (nonatomic, copy, readonly) NSString *statusTitle;
/// 状态描述
@property (nonatomic, strong, readonly) HDLabel *statusDetailLB;
/// 极速服务标签
@property (nonatomic, strong) WMUIButton *fastServiceBTN;
/// 确认订单
@property (nonatomic, copy) void (^clickedConfirmOrderBlock)(void);
/// 取消订单
@property (nonatomic, copy) void (^clickedCancelOrderBlock)(void);
/// 退款申请
@property (nonatomic, copy) void (^clickedRefundOrderBlock)(void);
/// 评价订单
@property (nonatomic, copy) void (^clickedEvaluationOrderBlock)(void);
/// 点击了立即支付
@property (nonatomic, copy) void (^clickedPayNowBlock)(void);
/// 待支付倒计时时长结束
@property (nonatomic, copy) void (^payTimerCountDownEndedBlock)(void);
/// 催单
@property (nonatomic, copy) void (^clickedUrgeOrderBlock)(void);
/// 再来一单
@property (nonatomic, copy) void (^clickedOnceAgainBlock)(void);
/// 点击了修改地址
@property (nonatomic, copy) void (^clickedModifyAddressBlock)(void);
/// 点击了确认取餐
@property (nonatomic, copy) void (^clickedSubmitPickUpBlock)(void);
/// 打电话
- (void)clickedPhoneBTNHandler;
/// 订单轨迹
- (void)clickedStatusTitleHandler;
/// 更新界面
- (void)configureWithOrderDetailModel:(WMOrderDetailModel *)model storeInfoModel:(WMOrderDetailStoreDetailModel *)storeInfoModel orderSimpleInfo:(WMOrderDetailOrderInfoModel *)orderSimpleInfo;
///更新箭头颜色
- (NSMutableAttributedString *)statusTitleLBAttributedStringWithTitle:(NSString *)title arrowColor:(UIColor *)color font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
