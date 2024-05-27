//
//  WMOrderDetailStatusView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailStatusView.h"
#import "GNAlertUntils.h"
#import "HDUIButton.h"
#import "SACacheManager.h"
#import "SAGeneralUtil.h"
#import "SAShadowBackgroundView.h"
#import "WMCustomViewActionView.h"
#import "WMOrderDetailContactPersonView.h"
#import "WMOrderDetailDTO.h"
#import "WMOrderDetailModel.h"
#import "WMOrderDetailOrderInfoModel.h"
#import "WMOrderDetailStatusStepView.h"
#import "WMOrderDetailStoreDetailModel.h"
#import "WMOrderDetailTrackingTableViewCellModel.h"
#import "WMOrderDetailTrackingView.h"
#import "WMPromotionLabel.h"
#import <YYImage/YYAnimatedImageView.h>


@interface WMOrderDetailStatusView ()
/// 状态标题
@property (nonatomic, strong, readwrite) YYLabel *statusTitleLB;
/// 顶部点击视图
@property (nonatomic, strong) UIView *topClickView;
/// 状态描述
@property (nonatomic, strong) HDLabel *statusDescLB;
/// 详细描述
@property (nonatomic, strong, readwrite) HDLabel *statusDetailLB;
/// lineView
@property (nonatomic, strong) UIView *lineView;
/// 联系电话按钮
@property (nonatomic, strong, readwrite) HDUIButton *phoneBTN;
/// 联系骑手
@property (nonatomic, strong) HDUIButton *callRiderBTN;
/// 确认收货
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// 取消
@property (nonatomic, strong) HDUIButton *cancelBTN;
/// 退款
@property (nonatomic, strong) HDUIButton *refundBTN;
/// 评价按钮
@property (nonatomic, strong) HDUIButton *evaluationBTN;
/// 立即支付
@property (nonatomic, strong) HDUIButton *payNowBTN;
/// 催单按钮
@property (nonatomic, strong) HDUIButton *urgeBtn;
/// 再来一单按钮
@property (nonatomic, strong) HDUIButton *againBtn;
/// 修改地址
@property (nonatomic, strong) HDUIButton *modifyAddressBTN;
/// 确认取餐
@property (nonatomic, strong) HDUIButton *submitPickUpBTN;
/// 引用
@property (nonatomic, weak) WMOrderDetailModel *detailInfoModel;
/// 门店信息
@property (nonatomic, weak) WMOrderDetailStoreDetailModel *storeDetailInfoModel;
/// 订单信息
@property (nonatomic, strong) WMOrderDetailOrderInfoModel *orderSimpleInfo;
/// 待支付倒计时定时器
@property (nonatomic, strong) NSTimer *payTimer;
/// 倒计时支付总时长
@property (nonatomic, assign) NSInteger payTimerSecondsTotal;
/// 倒计时支付剩余时长
@property (nonatomic, assign) NSInteger payTimerSecondsLeft;
/// 开始时间
@property (nonatomic, strong) NSDate *payTimerStartDate;
/// 按钮所在view
@property (nonatomic, strong) UIStackView *floatLayoutView;
/// 所有底部操作按钮
@property (nonatomic, strong, readwrite) NSArray<UIButton *> *allOperationButton;
/// 订单进程视图
@property (nonatomic, strong) WMOrderDetailStatusStepView *orderDetailStatusStepView;
/// 展示箭头
@property (nonatomic, assign, readwrite) BOOL showArrow;

@property (nonatomic, copy, readwrite) NSString *statusTitle;
/// detailDTO
@property (nonatomic, strong) WMOrderDetailDTO *detailDTO;

@property (nonatomic, strong) UIView *pickUpCodeView;
@property (nonatomic, strong) UILabel *pickUpCodeLabel;
@property (nonatomic, strong) UILabel *pickUpCodeTipLabel;

@end


@implementation WMOrderDetailStatusView
- (void)hd_setupViews {
    [self initBTN];
    self.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.topClickView];
    [self addSubview:self.statusTitleLB];
    [self addSubview:self.fastServiceBTN];
    [self addSubview:self.statusDescLB];
    [self addSubview:self.orderDetailStatusStepView];

    [self addSubview:self.pickUpCodeView];
    [self.pickUpCodeView addSubview:self.pickUpCodeLabel];
    [self.pickUpCodeView addSubview:self.pickUpCodeTipLabel];

    [self addSubview:self.floatLayoutView];
    [self addSubview:self.statusDetailLB];
    [self addSubview:self.lineView];
}

- (void)initBTN {
    @HDWeakify(self) self.callRiderBTN = [self customBTN:WMLocalizedString(@"xTPtslzD", @"联系骑手") image:@"yn_order_detail_contact" color:HDAppTheme.WMColor.B3 block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) WMOrderDetailRiderModel *rider = self.detailInfoModel.deliveryInfo.rider;
        NSDictionary *dict = @{
            @"title": rider.riderName,
            @"operatorType": @(9),
            @"operatorNo": rider.riderNo ?: @"",
            @"prepareSendTxt": [NSString stringWithFormat:WMLocalizedString(@"NyF6Fg39", @"我想咨询订单号：%@"), self.detailInfoModel.orderNo],
            @"phoneNo": rider.riderPhone ?: @"",
            @"scene": SAChatSceneTypeYumNowDelivery
        };
        [[HDMediator sharedInstance] navigaveToIMViewController:dict];
    }];

    self.phoneBTN = [self customBTN:WMLocalizedString(@"contact", @"联系电话") image:@"yn_order_detail_contact" color:HDAppTheme.WMColor.B3 block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self)[self clickedPhoneBTNHandler];
    }];

    self.submitPickUpBTN = [self customBTN:WMLocalizedString(@"wm_pickup_Confirm receipt", @"确认取餐") image:@"yn_icon_submitPickUp" color:HDAppTheme.WMColor.B3 block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedSubmitPickUpBlock ?: self.clickedSubmitPickUpBlock();
    }];

    self.confirmBTN = [self customBTN:WMLocalizedString(@"confirm_received_goods", @"确认收货") image:@"yn_order_detail_submit" color:HDAppTheme.WMColor.mainRed block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedConfirmOrderBlock ?: self.clickedConfirmOrderBlock();
    }];

    self.cancelBTN = [self customBTN:WMLocalizedStringFromTable(@"cancel", @"取消", @"Buttons") image:@"yn_order_detail_cancel" color:HDAppTheme.WMColor.B3 block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedCancelOrderBlock ?: self.clickedCancelOrderBlock();
    }];

    self.urgeBtn = [self customBTN:WMLocalizedStringFromTable(@"reminder", @"催单", @"Buttons") image:@"yn_order_detail_remind" color:HDAppTheme.WMColor.B3 block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedUrgeOrderBlock ?: self.clickedUrgeOrderBlock();
    }];

    self.refundBTN = [self customBTN:WMLocalizedString(@"refund", @"退款") image:@"yn_order_detail_refund" color:HDAppTheme.WMColor.B3 block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedRefundOrderBlock ?: self.clickedRefundOrderBlock();
    }];

    self.evaluationBTN = [self customBTN:WMLocalizedString(@"evaluate", @"评价") image:@"yn_order_detail_comment" color:HDAppTheme.WMColor.B3 block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedEvaluationOrderBlock ?: self.clickedEvaluationOrderBlock();
    }];

    self.againBtn = [self customBTN:WMLocalizedString(@"zA8ZBMsK", @"再来一单") image:@"yn_order_detail_buy_again" color:HDAppTheme.WMColor.mainRed block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedOnceAgainBlock ?: self.clickedOnceAgainBlock();
    }];

    self.payNowBTN = [self customBTN:SALocalizedString(@"top_up_pay_now", @"立即支付") image:@"yn_order_detail_payimdy" color:HDAppTheme.WMColor.mainRed block:^(UIButton *_Nonnull btn) {
        @HDStrongify(self) !self.clickedPayNowBlock ?: self.clickedPayNowBlock();
    }];

    self.modifyAddressBTN = [self customBTN:WMLocalizedString(@"wm_modify_address_name", @"修改地址") image:@"yn_order_detail_modifyAddress" color:HDAppTheme.WMColor.B3
                                      block:^(UIButton *_Nonnull btn) {
                                          @HDStrongify(self) !self.clickedModifyAddressBlock ?: self.clickedModifyAddressBlock();
                                      }];
}

#pragma mark - layout
- (void)updateConstraints {
    __block UIView *view = nil;
    [self.statusTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.statusTitleLB.isHidden) {
            make.left.equalTo(self).offset(kRealWidth(12));
            make.top.equalTo(self).offset(kRealWidth(12));
            if (self.fastServiceBTN.hidden) {
                make.right.mas_equalTo(-kRealWidth(12));
            } else {
                make.right.equalTo(self.fastServiceBTN.mas_left).offset(-kRealWidth(4));
            }
            make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
            view = self.statusTitleLB;
        }
    }];

    [self.fastServiceBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.fastServiceBTN.isHidden) {
            if (!self.statusTitleLB.isHidden) {
                make.right.mas_lessThanOrEqualTo(-kRealWidth(12));
                make.centerY.equalTo(self.statusTitleLB);
            } else {
                make.right.mas_equalTo(kScreenWidth);
            }
        }
    }];

    [self.statusDescLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(12));
        make.right.mas_lessThanOrEqualTo(-kRealWidth(12));
        if (self.statusTitleLB.isHidden) {
            make.top.equalTo(self).offset(kRealWidth(12));
        } else {
            make.top.equalTo(self.statusTitleLB.mas_bottom);
        }
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        view = self.statusDescLB;
    }];

    [self.statusDetailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.statusDetailLB.isHidden) {
            make.left.right.equalTo(self.statusDescLB);
            make.top.equalTo(self.statusDescLB.mas_bottom).offset(kRealWidth(4));
            view = self.statusDetailLB;
        }
    }];

    [self.orderDetailStatusStepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.orderDetailStatusStepView.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(16));
            if (view) {
                make.top.equalTo(view.mas_bottom).offset(kRealWidth(18));
            } else {
                make.top.equalTo(self).offset(kRealWidth(12));
            }
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(18));
        }
    }];

    [self.pickUpCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pickUpCodeView.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            if (view) {
                make.top.equalTo(view.mas_bottom).offset(0);
            } else {
                make.top.equalTo(self).offset(kRealWidth(12));
            }
            make.bottom.mas_lessThanOrEqualTo(-0);
        }
    }];

    [self.pickUpCodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kRealWidth(16));
    }];

    [self.pickUpCodeTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pickUpCodeLabel);
        make.top.equalTo(self.pickUpCodeLabel.mas_bottom).offset(4);
        make.bottom.mas_equalTo(-kRealWidth(16));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.lineView.isHidden) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(HDAppTheme.WMValue.line);
            if (!self.orderDetailStatusStepView.isHidden) {
                make.top.equalTo(self.orderDetailStatusStepView.mas_bottom).offset(kRealWidth(18));
            } else {
                make.top.equalTo(self.pickUpCodeView.mas_bottom);
            }
        }
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            make.top.equalTo(self.lineView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kRealWidth(60));
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.topClickView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.statusDescLB.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)dealloc {
    [_payTimer invalidate];
    _payTimer = nil;
}

#pragma mark - public methods
- (void)configureWithOrderDetailModel:(WMOrderDetailModel *)model storeInfoModel:(WMOrderDetailStoreDetailModel *)storeInfoModel orderSimpleInfo:(WMOrderDetailOrderInfoModel *)orderSimpleInfo {
    self.detailInfoModel = model;
    self.storeDetailInfoModel = storeInfoModel;
    self.orderSimpleInfo = orderSimpleInfo;

    WMBusinessStatus bizState = model.bizState;
    // 是否在线付款待支付
    // 在线支付且业务状态为初始化，1.5 版本即判断为待支付状态
    BOOL isOnlineWaitingPay = (model.paymentMethod == SAOrderPaymentTypeOnline && bizState == WMBusinessStatusWaitingInitialized);
    NSString *title;
    id desc;
    NSString *detailStr;
    self.statusDescLB.textColor = HDAppTheme.WMColor.B3;
    ;
    ///当前时间
    NSTimeInterval currentTime = self.detailInfoModel.serviceTime ? self.detailInfoModel.serviceTime.doubleValue : (NSDate.date.timeIntervalSince1970 * 1000);

    /// 判断商家是否点击已出餐
    BOOL merchantConfirm = [model.orderEventList hd_filterWithBlock:^BOOL(WMOrderEventModel *_Nonnull item) {
                               return item.eventType == WMOrderEventTypeMerchantPreparedMeal;
                           }].count > 0;


    self.orderDetailStatusStepView.hidden = NO;
    self.pickUpCodeView.hidden = YES;
    if (model.serviceType == 20) {
        self.orderDetailStatusStepView.hidden = YES;
        self.pickUpCodeView.hidden = NO;
        if (HDIsStringEmpty(model.pickUpCode)) {
            self.pickUpCodeLabel.text = @"";
            self.pickUpCodeTipLabel.text = @"";
        } else {
            self.pickUpCodeLabel.text = model.pickUpCode;
            self.pickUpCodeTipLabel.text = WMLocalizedString(@"wm_pickup_Pickup code", @"取餐码");
            
        }
    }


#pragma - mark 等待商家接单
    if (bizState == WMBusinessStatusWaitingOrderReceiving) {
        title = WMLocalizedString(@"order_detail_accept_soon", @"等待商家接单");
        // 商家剩余可接单时间 = 当前时间 -（提交订单时间/用户支付成功时间）
        NSTimeInterval time = currentTime - (self.detailInfoModel.paymentTime ? self.detailInfoModel.paymentTime.doubleValue : self.detailInfoModel.orderTime.doubleValue);
        CGFloat min = [self changeToMin:time];
        if ((15 - min) > 5) {
            desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_5-15_minutes", @"预计5-15分钟") changeTexts:@[@"5-15"]];
        } else if (1 <= (15 - min) || (15 - min) < 5) {
            desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Less_than_5_minutes", @"预计小于5分钟") changeTexts:@[@"5"]];
        } else {
            desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Less_than_1_minutes", @"预计小于1分钟") changeTexts:@[@"1"]];
        }
        detailStr = WMLocalizedString(@"order_submit_Your_order_has_been_submitted_and_waiting_for_merchant_to_accept", @"您的订单已提交，等待商家接单");
        _allOperationButton = @[self.cancelBTN, self.phoneBTN];
        self.orderDetailStatusStepView.step = 1;
        
        self.pickUpCodeLabel.text = @"";
        self.pickUpCodeTipLabel.text = @"";
    }
#pragma - mark 商家已接单
    else if (bizState == WMBusinessStatusMerchantAcceptedOrder) {

#pragma - mark 未出餐
        if (!merchantConfirm) {
            if (self.detailInfoModel.serviceType == 20) {
                _allOperationButton = @[self.cancelBTN, self.phoneBTN, self.submitPickUpBTN];
                title = WMLocalizedString(@"wm_pickup_Waiting for self pickup", @"等待自取");
                desc = self.etaTimeStrWithoutDayAndMonth;
                detailStr = nil;

            } else {
                self.orderDetailStatusStepView.step = 2;
                _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.phoneBTN];
                /// 超时 当前时间 > 预计出餐时间
#pragma - mark 出餐超时
                if (currentTime > model.estimatePrepareTime.doubleValue) {
                    // 按钮组显示联系、退款、取消
                    _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.urgeBtn, self.phoneBTN];
                    title = WMLocalizedString(@"order_submit_Prepare_overtime", @"商家出餐超时");
                    detailStr = WMLocalizedString(@"order_submit_Merchant_prepare_late", @"商家出餐已超时，可以点击“催单”按钮提醒商家，如有疑问，请联系商家。");

                    // 显示逻辑
                    // 商家出餐超时时间 =当前时间 - 商家预计备餐时间
                    NSTimeInterval merchantOverTime = currentTime - model.estimatePrepareTime.doubleValue;
                    // 转换成多少分钟
                    CGFloat min = [self changeToMin:merchantOverTime];
                    NSString *overTimeDesc;

                    desc = self.etaTimeStrWithoutDayAndMonth;

                } else {
#pragma - mark 等待商家出餐
                    _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.phoneBTN];
                    title = WMLocalizedString(@"order_submit_Waiting_for_merchant_to_prepare_order", @"等待商家出餐");
                    if (self.detailInfoModel.serviceType == 20) {
                        _allOperationButton = @[self.cancelBTN, self.phoneBTN, self.submitPickUpBTN];
                    }

                    detailStr = WMLocalizedString(@"order_submit_Merchant_received_order", @"商家已接单，请耐心等待商家备餐");
                    ///即时单
                    if ([model.deliveryTimelinessType isEqualToString:WMOrderDeliveryTimeTypeRightNow]) {
                        desc = self.etaTimeStrWithoutDayAndMonth;
                    }
#pragma - mark 预约单
                    else {
                        _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.phoneBTN];


                        NSTimeInterval ti = self.detailInfoModel.deliveryInfo.eta;
                        NSString *changeText = [SAGeneralUtil getDateStrWithTimeInterval:ti / 1000 format:@"dd/MM HH:mm"];

                        NSString *allText = [NSString stringWithFormat:WMLocalizedString(@"order_detail_about_delivery", @"预计 %@ 送达"), changeText];

                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allText];
                        [attributedString setYy_color:HDAppTheme.WMColor.B3];
                        [attributedString setYy_font:[HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium]];
                        [attributedString yy_setColor:HDAppTheme.WMColor.B3 range:[allText rangeOfString:changeText]];
                        [attributedString yy_setFont:[HDAppTheme.WMFont wm_boldForSize:20] range:[allText rangeOfString:changeText]];

                        desc = attributedString;
                    }
                }
            }
        } else {
#pragma - mark 等待骑手接单
            if (self.detailInfoModel.serviceType == 20) {
                title = WMLocalizedString(@"wm_pickup_Waiting for self pickup", @"等待自取");
                desc = WMLocalizedString(@"wm_pickup_tips04", @"门店已出餐，请尽快到店取餐");

                _allOperationButton = @[self.cancelBTN, self.phoneBTN, self.submitPickUpBTN];

            } else {
                if (model.deliveryInfo.deliveryStatus == WMDeliveryStatusWaitingAccept || model.deliveryInfo.deliveryStatus == WMDeliveryStatusWaitingDeploy) {
                    self.orderDetailStatusStepView.step = 2;
                    title = WMLocalizedString(@"order_submit_Waiting_for_rider_to_receive_order", @"等待骑手接单");
                    BOOL timeout = ([self changeToMin:currentTime - model.actualPrepareTime.doubleValue] > 10);
#pragma - mark 骑手较少
                    if (timeout) {
                        //                    desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_There_are_few_riders_nearby", @"附近骑手较少，请耐心等待")
                        //                    changeTexts:@[]];
                        detailStr = WMLocalizedString(@"order_submit_Rider_received_order_late", @"您的骑手接单超时，如有疑问，请联系客服");
                        _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.urgeBtn, self.phoneBTN];
                    } else {
#pragma - mark 等待骑手接单ing
                        //                    desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Less_than_10_minutes", @"预计小于10分钟") changeTexts:@[@"10"]];

                        _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.phoneBTN];
                        detailStr = WMLocalizedString(@"order_submit_Order_prepared", @"商家已出餐，等待骑手接单，预计10分钟");
                    }
                    desc = self.etaTimeStrWithoutDayAndMonth;
                }
#pragma - mark 骑手已接单
                else if (model.deliveryInfo.deliveryStatus == WMDeliveryStatusAccepted) {
                    self.orderDetailStatusStepView.step = 3;
                    _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.urgeBtn, self.phoneBTN];
                    CGFloat time = [self changeToMin:currentTime - model.deliveryInfo.riderAcceptTime];
#pragma - mark 骑手到店超时
                    if (time > 10) {
                        title = WMLocalizedString(@"order_submit_Rider_arrive_store_late", @"骑手到店超时");
                        //                    desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Notifying_rider_to_shop", @"正在通知骑手到店") changeTexts:@[]];
                        detailStr = WMLocalizedString(@"order_submit_Rider_is_rushing_to_merchant_detail", @"骑手正在赶往商家，请耐心等待。如有疑问，请联系骑手");
                    } else {
                        title = WMLocalizedString(@"order_submit_Waiting_for_rider_to_get_to_store", @"等待骑手到店");
                        //                    desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Less_than_10_minutes", @"预计小于10分钟") changeTexts:@[@"10"]];
                        detailStr = WMLocalizedString(@"order_submit_Rider_is_rushing_to_merchant", @"骑手正在赶往商家，请耐心等待");
                    }
                    desc = self.etaTimeStrWithoutDayAndMonth;
                }
#pragma - mark 骑手已到店
                else if (model.deliveryInfo.deliveryStatus == WMDeliveryStatusArrivedMerchant) {
                    self.orderDetailStatusStepView.step = 3;
                    _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.urgeBtn, self.phoneBTN];
                    CGFloat time = [self changeToMin:currentTime - model.deliveryInfo.riderArrivedStoreTime];
#pragma - mark 骑手取餐超时
                    if (time > 10) {
                        title = WMLocalizedString(@"order_submit_Pick-up_ovetime", @"骑手取餐超时");
                        //                    desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Notifying_rider_to_pick_up_goods", @"正在通知骑手取餐")
                        //                    changeTexts:@[]];
                        detailStr = WMLocalizedString(@"order_submit_Rider_pick_up_late", @"骑手取餐超时，如有疑问，请联系骑手");
                    } else {
#pragma - mark 骑手正在取餐
                        title = WMLocalizedString(@"order_submit_Waiting_for_rider_to_pick_up", @"等待骑手取餐");
                        //                    desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Less_than_10_minutes", @"预计小于10分钟") changeTexts:@[@"10"]];
                        detailStr = WMLocalizedString(@"order_submit_Rider_is_pick-uping_goods", @"骑手正在取餐，请耐心等待");
                    }
                    desc = self.etaTimeStrWithoutDayAndMonth;
                }
            }

            if (!merchantConfirm) {
                self.orderDetailStatusStepView.step = 2;
            }
        }

        NSMutableAttributedString *mdesc;
        if ([desc isKindOfClass:NSMutableAttributedString.class]) {
            mdesc = desc;
        } else {
            mdesc = [[NSMutableAttributedString alloc] initWithString:desc];
        }
        id result = [self descForRejectCancelEventWithBizStateDeliveryingOrAcceptedOrderWithDecs:mdesc];
        if (result) {
            desc = result;
        }
    }
#pragma - mark 取消申请中
    else if (bizState == WMBusinessStatusOrderCancelling) {
        _allOperationButton = @[self.againBtn, self.phoneBTN];
        self.orderDetailStatusStepView.step = 0;
        title = WMLocalizedString(@"order_detail_cancelling", @"取消申请中");
        desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_detail_cancelling_desc", @"门店将尽快处理您的申请") changeTexts:@[]];
    }
#pragma - mark 已取消
    else if (bizState == WMBusinessStatusOrderCancelled) {
        _allOperationButton = @[self.phoneBTN, self.againBtn];
        self.orderDetailStatusStepView.step = 0;
        title = WMLocalizedString(@"order_detail_cancelled", @"已取消");
        desc = [self descForRejectOrCancelEventWithBizStateCancelled];

        self.pickUpCodeLabel.text = @"";
        self.pickUpCodeTipLabel.text = @"";
    }
#pragma - mark 配送中
    else if (bizState == WMBusinessStatusDelivering) {
        _allOperationButton = @[self.cancelBTN, self.modifyAddressBTN, self.urgeBtn, self.phoneBTN];
        self.orderDetailStatusStepView.step = 3;
        BOOL timeout = currentTime > model.deliveryInfo.eta;
#pragma - mark 配送超时
        if (timeout) {
            title = WMLocalizedString(@"wm_submit_order_deliving_over", @"配送超时");

            // 显示逻辑
            // 计算超出预计时间
            NSTimeInterval time = currentTime - model.deliveryInfo.eta;
            // 转换成多少分钟
            CGFloat min = [self changeToMin:time];
            NSString *overTimeDesc;
            if (min < 60) {
                overTimeDesc = WMLocalizedString(@"order_submit_Timed_out_M_S", @"已超时{%1}分钟，原定{%2}出餐");

            } else {
                overTimeDesc = WMLocalizedString(@"order_submit_Timed_out_H_M_S", @"已超时{%3}小时{%1}分钟，原定{%2}出餐");
            }

            if (min < 60) {
                if (min < 1) {
                    min = 1;
                }
                overTimeDesc = [overTimeDesc stringByReplacingOccurrencesOfString:@"{%1}" withString:[NSString stringWithFormat:@"%.0f", min]];
                NSString *expectedDeliverytime = [SAGeneralUtil getDateStrWithTimeInterval:model.deliveryInfo.eta / 1000 format:@"HH:mm"];
                overTimeDesc = [overTimeDesc stringByReplacingOccurrencesOfString:@"{%2}" withString:expectedDeliverytime];
                NSArray *changeTexts = @[[NSString stringWithFormat:@"%.0f", min], expectedDeliverytime];
                desc = [self statusDescLBAttributedStringWithAllText:overTimeDesc changeTexts:changeTexts changeColor:HDAppTheme.WMColor.mainRed];
            } else {
                // 超过的时间和分钟
                NSString *overTimeHourMin = [NSString stringWithFormat:@"%.2f", min / 60];
                NSArray<NSString *> *arrayHourMin = [overTimeHourMin componentsSeparatedByString:@"."];
                NSString *overHour = arrayHourMin.firstObject;
                NSString *overMin = [NSString stringWithFormat:@"%.0f", arrayHourMin.lastObject.floatValue * 0.6];
                // dd/MM HH:mm
                NSString *expectedDeliverytime = [SAGeneralUtil getDateStrWithTimeInterval:model.deliveryInfo.eta / 1000 format:@"HH:mm"];
                overTimeDesc = [overTimeDesc stringByReplacingOccurrencesOfString:@"{%3}" withString:overHour];
                overTimeDesc = [overTimeDesc stringByReplacingOccurrencesOfString:@"{%1}" withString:overMin];
                overTimeDesc = [overTimeDesc stringByReplacingOccurrencesOfString:@"{%2}" withString:expectedDeliverytime];

                NSArray *changeTexts = @[overHour, overMin, expectedDeliverytime];
                desc = [self statusDescLBAttributedStringWithAllText:overTimeDesc changeTexts:changeTexts changeColor:HDAppTheme.WMColor.mainRed];
            }
            detailStr = WMLocalizedString(@"order_submit_Order_delivery_is_overtime", @"您的订单配送已超时，如有疑问，请联系骑手");

        } else {
#pragma - mark 配送未超时
            title = WMLocalizedString(@"order_trace_delivering", @"配送中");
            // 显示逻辑
            // 计算实际时间与预计时间差值
            //            NSTimeInterval time = model.deliveryInfo.eta - currentTime;
            //            // 计算与当前时间的差值
            //            CGFloat min = [self changeToMin:time];
            //            if (min > 30) {
            //                desc = WMLocalizedString(@"order_submit_More_than_30_minutes", @"预计30分钟以上");
            //            } else if (min > 15 && min <= 30) {
            //                desc = WMLocalizedString(@"order_submit_15-30_minutes", @"预计15-30分钟");
            //            } else if (min > 5 && min <= 15) {
            //                desc = WMLocalizedString(@"order_submit_5-15_minutes", @"预计5-15分钟");
            //            } else if (min > 1 && min <= 5) {
            //                desc = WMLocalizedString(@"order_submit_Less_than_5_minutes", @"预计小于5分钟");
            //            } else {
            //                desc = WMLocalizedString(@"order_submit_Less_than_1_minutes", @"预计小于1分钟");
            //            }
            //            NSArray *changeTexts = @[
            //                @"30",
            //                @"5",
            //                @"15",
            //                @"1",
            //                @"-",
            //            ];
            //            desc = [self statusDescLBAttributedStringWithAllText:desc changeTexts:changeTexts];

            if (self.detailInfoModel.riderEstimateArriveTime > 0 && self.detailInfoModel.riderEstimateArriveTime < self.detailInfoModel.deliveryInfo.eta) {
                NSTimeInterval ti = self.detailInfoModel.deliveryInfo.eta;
                NSString *changeText = [SAGeneralUtil getDateStrWithTimeInterval:ti / 1000 format:@"HH:mm"];
                NSString *changeText2 = [SAGeneralUtil getDateStrWithTimeInterval:self.detailInfoModel.riderEstimateArriveTime / 1000 format:@"HH:mm"];
                changeText = [NSString stringWithFormat:@"%@-%@", changeText2, changeText];

                NSString *allText = [NSString stringWithFormat:WMLocalizedString(@"order_detail_about_delivery", @"预计 %@ 送达"), changeText];

                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allText];
                [attributedString setYy_color:HDAppTheme.WMColor.B3];
                [attributedString setYy_font:[HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium]];
                [attributedString yy_setColor:HDAppTheme.WMColor.B3 range:[allText rangeOfString:changeText]];
                [attributedString yy_setFont:[HDAppTheme.WMFont wm_boldForSize:20] range:[allText rangeOfString:changeText]];

                desc = attributedString;
            } else {
                desc = self.etaTimeStrWithoutDayAndMonth;
            }

            detailStr = WMLocalizedString(@"order_submit_Delivering_your_order", @"您的订单正在配送，请耐心等待");
        }
        NSMutableAttributedString *mdesc;
        if ([desc isKindOfClass:[NSMutableAttributedString class]]) {
            mdesc = desc;
        } else {
            mdesc = [[NSMutableAttributedString alloc] initWithString:desc];
        }
        id result = [self descForRejectCancelEventWithBizStateDeliveryingOrAcceptedOrderWithDecs:mdesc];
        if (result) {
            desc = result;
        }
    }
#pragma - mark 已送达
    else if (bizState == WMBusinessStatusDeliveryArrived) {
        _allOperationButton = @[
            self.refundBTN,
            self.phoneBTN,
            self.confirmBTN,
        ];
        self.orderDetailStatusStepView.step = 4;
        title = WMLocalizedString(@"order_detail_delivered", @"已送达");
        desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_submit_Your_order_has_been_delivered", @"您的订单已送达，期待下次光临") changeTexts:@[]];
    }
#pragma - mark 退款申请中
    else if (bizState == WMBusinessStatusUserRefundApplying) {
        self.orderDetailStatusStepView.step = 0;
        title = WMLocalizedString(@"order_detail_refund_processing", @"退款申请中");
        desc = [self statusDescLBAttributedStringWithAllText:WMLocalizedString(@"order_detail_refund_processing_desc", @"我们将尽快处理你的申请。") changeTexts:@[]];
    }
#pragma - mark 已完成
    else if (bizState == WMBusinessStatusCompleted) {
        _allOperationButton = @[self.phoneBTN, self.evaluationBTN, self.againBtn];
        if (self.detailInfoModel.serviceType == 20) {
            //          _allOperationButton = @[self.phoneBTN, self.evaluationBTN, self.againBtn];
            self.pickUpCodeLabel.text = @"";
            self.pickUpCodeTipLabel.text = @"";
        }
        self.orderDetailStatusStepView.step = 4;
        title = WMLocalizedString(@"order_detail_completed", @"已完成");
        desc = [self descForRejectRefundEventWithBizStateCompleted];


    }
    ///异常支付处理
    else if (bizState == WMBusinessStatusWaitingInitialized && !isOnlineWaitingPay) {
        self.orderDetailStatusStepView.step = 1;
        title = SALocalizedString(@"top_up_to_be_paid", @"等待支付结果");
        desc = self.descStrAfterHandlingOrderExpireTime;
        detailStr = WMLocalizedString(@"order_submit_Please_complete_the_payment_within_15_minutes",
                                      @"请在15分钟内完成订单支付，超时支付系统会自动取消订单，如果已支付，请耐心等待结果，如有疑问，请联系客服");
        _allOperationButton = @[self.cancelBTN, self.phoneBTN, self.payNowBTN];
    }

    NSArray<NSString *> *successPayedOrderNoList = [SACacheManager.shared objectPublicForKey:kCacheKeyCheckStandSuccessPayedOrderNoList];
    BOOL isCurrentOrderPayedSuccess = false;
    if (!HDIsArrayEmpty(successPayedOrderNoList)) {
        isCurrentOrderPayedSuccess = [successPayedOrderNoList containsObject:model.orderNo];
    }

#pragma - mark 待支付
    if (isOnlineWaitingPay) {
        self.orderDetailStatusStepView.step = 1;
        if (isCurrentOrderPayedSuccess) {
            title = WMLocalizedString(@"paying", @"支付中");
            desc = WMLocalizedString(@"paying_desc", @"支付处理中");
        } else {
            title = SALocalizedString(@"top_up_to_be_paid", @"等待支付结果");
            // 计算剩余时间秒数
            desc = self.descStrAfterHandlingOrderExpireTime;
            detailStr = WMLocalizedString(@"order_submit_Please_complete_the_payment_within_15_minutes",
                                          @"请在15分钟内完成订单支付，超时支付系统会自动取消订单，如果已支付，请耐心等待结果，如有疑问，请联系客服");
        }
        _allOperationButton = @[self.cancelBTN, self.phoneBTN, self.payNowBTN];
    } else {
        // 解决支付状态更新时倒计时未结束
        if ([_payTimer respondsToSelector:@selector(isValid)]) {
            if ([_payTimer isValid]) {
                [_payTimer invalidate];
                _payTimer = nil;
            }
        }
    }
    // 订单完成后不需要显示箭头
    self.showArrow = (bizState != WMBusinessStatusCompleted) ? YES : NO;
    NSArray<NSString *> *operationList = [orderSimpleInfo.operationList mapObjectsUsingBlock:^id _Nonnull(WMOrderDetailOperationEventModel *_Nonnull obj, NSUInteger idx) {
        return obj.orderOperation;
    }];
    self.evaluationBTN.hidden = ![operationList containsObject:SAOrderListOperationEventNameEvaluation];
    self.payNowBTN.hidden = isCurrentOrderPayedSuccess || !isOnlineWaitingPay;
    self.refundBTN.hidden = !model.canApplyRefund;
    self.cancelBTN.hidden = !model.canCancel;
    self.confirmBTN.hidden = bizState != WMBusinessStatusDeliveryArrived;
    self.againBtn.hidden = !(bizState == WMBusinessStatusOrderCancelled || bizState == WMBusinessStatusCompleted);
    self.callRiderBTN.hidden = YES;
    NSTimeInterval now = [NSDate.new timeIntervalSince1970] * 1000.0;
    // 时间差 （分钟）
    double timeDiff;
    if (bizState == WMBusinessStatusMerchantAcceptedOrder) {
        timeDiff = (model.estimatePrepareTime.doubleValue - now) / 1000.0 / 60.0;
        if (timeDiff < 0) {
            self.urgeBtn.hidden = NO;
        }
    } else if (bizState == WMBusinessStatusDelivering) {
        timeDiff = (model.deliveryInfo.eta - now) / 1000.0 / 60.0;
        if (timeDiff < 0) {
            self.urgeBtn.hidden = NO;
        }
    } else {
        self.urgeBtn.hidden = YES;
    }

    self.modifyAddressBTN.hidden = !(model.isUpdateAddress == WMOrderModifyCAN);
    [self configFloatLayoutView];

    self.fastServiceBTN.hidden = !model.speedDelivery.boolValue;
    self.statusTitleLB.attributedText = [self statusTitleLBAttributedStringWithTitle:title arrowColor:HDAppTheme.WMColor.B3 font:[HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium]];

    NSMutableAttributedString *statusDescStr = NSMutableAttributedString.new;
    if ([desc isKindOfClass:NSAttributedString.class]) {
        statusDescStr = desc;
    } else if ([desc isKindOfClass:NSString.class]) {
        [statusDescStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:desc]];
    }
    statusDescStr.yy_lineSpacing = kRealWidth(4);
    statusDescStr.yy_alignment = NSTextAlignmentLeft;
    self.statusDescLB.attributedText = statusDescStr;
    NSMutableAttributedString *statusDetailStr = [[NSMutableAttributedString alloc] initWithString:detailStr];
    statusDetailStr.yy_color = HDAppTheme.WMColor.B9;
    statusDetailStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11];
    statusDetailStr.yy_lineSpacing = kRealWidth(4);
    self.statusDetailLB.attributedText = statusDetailStr;
    self.statusDetailLB.hidden = HDIsStringEmpty(detailStr);

    [self setNeedsUpdateConstraints];
}

///转换成多少分钟
- (CGFloat)changeToMin:(double)time {
    return time / 1000 / 60.0;
}

- (void)payTimerInvoked {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_payTimerStartDate];

    self.payTimerSecondsLeft = self.payTimerSecondsTotal - (NSInteger)(deltaTime + 0.5);
    if (self.payTimerSecondsLeft <= 0.0) {
        self.payTimerSecondsLeft = 0;
        [self invalidatePayTimer];
    }

    NSString *changeText = [SAGeneralUtil timeWithSeconds:self.payTimerSecondsLeft];
    NSString *allText = [NSString
        stringWithFormat:WMLocalizedString(@"order_submit_Waiting_for_payment_Your_order_has_been_submitted", @"请在 %@ 内完成支付"), [SAGeneralUtil timeWithSeconds:self.payTimerSecondsLeft]];

    NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] initWithString:allText];
    [descAttributedString setYy_color:HDAppTheme.WMColor.B3];
    [descAttributedString setYy_font:[HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium]];
    [descAttributedString yy_setColor:HDAppTheme.WMColor.mainRed range:[allText rangeOfString:changeText]];
    [descAttributedString yy_setFont:[HDAppTheme.WMFont wm_boldForSize:20] range:[allText rangeOfString:changeText]];
    self.statusDescLB.attributedText = descAttributedString;

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)configFloatLayoutView {
    [self.floatLayoutView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.floatLayoutView removeArrangedSubview:obj];
        [obj removeFromSuperview];
    }];
    NSArray *btnArr = [self.allOperationButton hd_filterWithBlock:^BOOL(UIButton *_Nonnull item) {
        return !item.isHidden;
    }];
    [btnArr enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.floatLayoutView addArrangedSubview:obj];
    }];
}
/// 预计送达时间
- (NSMutableAttributedString *)etaTimeStr {
    NSString *changeText = [SAGeneralUtil getDateStrWithTimeInterval:self.detailInfoModel.deliveryInfo.eta / 1000 format:@"dd/MM HH:mm"];

    NSString *allText = [NSString stringWithFormat:WMLocalizedString(@"order_detail_about_delivery", @"预计 %@ 送达"), changeText];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allText];
    [attributedString setYy_color:HDAppTheme.WMColor.B3];
    [attributedString setYy_font:[HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium]];
    [attributedString yy_setColor:HDAppTheme.WMColor.mainRed range:[allText rangeOfString:changeText]];
    [attributedString yy_setFont:[HDAppTheme.WMFont wm_boldForSize:20] range:[allText rangeOfString:changeText]];
    return attributedString;
}

- (NSMutableAttributedString *)etaTimeStrWithoutDayAndMonth {
    NSTimeInterval ti = self.detailInfoModel.deliveryInfo.eta;
    NSString *changeText = [SAGeneralUtil getDateStrWithTimeInterval:ti / 1000 format:@"HH:mm"];


    NSString *allText = [NSString stringWithFormat:WMLocalizedString(@"order_detail_about_delivery", @"预计 %@ 送达"), changeText];
    if (self.detailInfoModel.serviceType == 20) {
        ti = self.detailInfoModel.estimatePrepareTime.doubleValue;
        changeText = [SAGeneralUtil getDateStrWithTimeInterval:ti / 1000 format:@"HH:mm"];
        allText = [NSString stringWithFormat:@"预计 %@ 可取餐", changeText];
    }


    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allText];
    [attributedString setYy_color:HDAppTheme.WMColor.B3];
    [attributedString setYy_font:[HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium]];
    [attributedString yy_setColor:UIColor.sa_C1 range:[allText rangeOfString:changeText]];
    [attributedString yy_setFont:[HDAppTheme.WMFont wm_boldForSize:20] range:[allText rangeOfString:changeText]];
    return attributedString;
}

- (id)descStrAfterHandlingOrderExpireTime {
    // 计算剩余时间秒数
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval orderPassedSeconds = (nowInterval - self.orderSimpleInfo.orderTimeStamp.longLongValue / 1000.0);
    NSUInteger maxSeconds = (self.orderSimpleInfo.expireTime <= 0 ? 15 : self.orderSimpleInfo.expireTime) * 60;

    if (orderPassedSeconds >= maxSeconds) {
        HDLog(@"订单已到最大待支付时间，后端未做取消处理");
        return WMLocalizedString(@"unpaid_overtime", @"超时未支付");
    } else {
        // 开启倒计时
        if (_payTimer) {
            [_payTimer invalidate];
            _payTimer = nil;
        }
        _payTimerStartDate = [NSDate date];
        self.payTimer.fireDate = [NSDate distantPast];

        self.payTimerSecondsTotal = maxSeconds - orderPassedSeconds;
        self.payTimerSecondsLeft = self.payTimerSecondsTotal;
        [[NSRunLoop currentRunLoop] addTimer:self.payTimer forMode:NSRunLoopCommonModes];

        //        self.statusDescLB.textColor = HDAppTheme.color.mainColor;
        NSString *changeText = [SAGeneralUtil timeWithSeconds:self.payTimerSecondsLeft < 0 ? 0 : self.payTimerSecondsLeft];
        NSString *allText = [NSString stringWithFormat:WMLocalizedString(@"order_submit_Waiting_for_payment_Your_order_has_been_submitted", @"请在 %@ 内完成支付"), changeText];

        NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] initWithString:allText];
        descAttributedString.yy_color = HDAppTheme.WMColor.B3;
        descAttributedString.yy_font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
        [descAttributedString yy_setColor:HDAppTheme.WMColor.mainRed range:[allText rangeOfString:changeText]];
        [descAttributedString yy_setFont:[HDAppTheme.WMFont wm_boldForSize:20] range:[allText rangeOfString:changeText]];
        return descAttributedString;
    }
}

/// 已取消的业务状态是前提，判断是否拒单或者系统、渠道取消订单事件，生成描述
- (NSMutableAttributedString *)descForRejectOrCancelEventWithBizStateCancelled {
    NSString *desc;
    // 判断是否 BOOS、门店、系统自动、渠道取消
    WMOrderEventModel *rejectOrCancelEventModel;
    for (WMOrderEventModel *eventModel in self.detailInfoModel.orderEventList) {
        if (eventModel.eventType == WMOrderEventTypeMerchantReject || eventModel.eventType == WMOrderEventTypeOrderCancelled || eventModel.eventType == WMOrderEventTypeUserCancelApplying) {
            rejectOrCancelEventModel = eventModel;
            break;
        }
    }
    if (rejectOrCancelEventModel) {
        // 判断操作平台
        if (rejectOrCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformMerchant) {
            // 门店取消
            if(self.detailInfoModel.serviceType == 20) {
                desc = [NSString stringWithFormat:SALocalizedString(@"wm_pickup_tips06", @"您的订单已取消，原因:%@") ,rejectOrCancelEventModel.orderCancelReason.name ?: @""];
            }else{
                desc = [NSString stringWithFormat:WMLocalizedString(@"store_cancel_tips", @"门店取消订单，原因：%@，可重新下单"), rejectOrCancelEventModel.orderCancelReason.name ?: @""];
            }
        } else if (rejectOrCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformOperationalStaff) {
            // 运营人员取消
            if(self.detailInfoModel.serviceType == 20) {
                desc = [NSString stringWithFormat:SALocalizedString(@"wm_pickup_tips06", @"您的订单已取消，原因:%@") ,rejectOrCancelEventModel.orderCancelReason.name ?: @""];
            }else{
                desc = [NSString stringWithFormat:WMLocalizedString(@"unpaid_overtime_tips", @"客服取消订单，原因：%@，可重新下单"), rejectOrCancelEventModel.orderCancelReason.name ?: @""];
            }
        } else if (rejectOrCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformChannel) {
            // 超时未支付，系统自动取消订单，可重新下单，系统取消
            desc = WMLocalizedString(@"user_unpaid_overtime_tips", @"超时未支付，系统自动取消订单，可重新下单");
        } else if (rejectOrCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformSystem) {
            // 门店超时未接单，系统自动取消订单，可重新下单，渠道取消
            desc = WMLocalizedString(@"store_failed_receive_order_tips", @"门店超时未接单，系统自动取消订单，可重新下单");
        } else if (rejectOrCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformUser) {
            // 用户取消
            desc = WMLocalizedString(@"order_detail_cancelled_desc_custumer", @"您的订单已取消，可重新下单");
        } else {
            desc = WMLocalizedString(@"order_detail_cancelled_desc_custumer", @"您的订单已取消，可重新下单");
            //            desc = [NSString stringWithFormat:WMLocalizedString(@"order_detail_cancelled_desc_custumer", @"你的订单已取消，原因：%@，可重新下单。"),
            //            rejectOrCancelEventModel.orderCancelReason.name ?: @""];
        }
    } else {
        desc = WMLocalizedString(@"order_detail_cancelled_desc", @"你的订单已取消，可重新下单。");
        HDLog(@"业务状态为取消，但事件列表不存在取消或者拒单事件，进入此状态代表后端数据有误");
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:desc];
    [attributeStr addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3}
                          range:NSMakeRange(0, desc.length)];
    return attributeStr;
}

/// 已结单或者配送中的业务状态是前提，判断是否拒绝取消事件，生成描述
- (id)descForRejectCancelEventWithBizStateDeliveryingOrAcceptedOrderWithDecs:(NSMutableAttributedString *)mdesc {
    NSMutableAttributedString *desc;
    // 判断是否是客服拒绝取消订单
    WMOrderEventModel *rejectCancelEventModel;
    for (WMOrderEventModel *eventModel in self.detailInfoModel.orderEventList) {
        if (eventModel.eventType == WMOrderEventTypeRejectCancel) {
            rejectCancelEventModel = eventModel;
            break;
        }
    }
    if (rejectCancelEventModel) {
        // 拒绝取消，判断平台
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
        text.yy_font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
        text.yy_color = HDAppTheme.WMColor.B3;
        NSString *rejectReasonDesc;
        // 再判断操作平台
        if (rejectCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformMerchant) {
            // 门店拒绝取消
            rejectReasonDesc = [NSString stringWithFormat:WMLocalizedString(@"store_refund_cancel", @"门店拒绝取消订单，原因：%@。"), rejectCancelEventModel.eventDesc];
        } else if (rejectCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformOperationalStaff) {
            // 运营人员拒绝取消
            rejectReasonDesc = [NSString stringWithFormat:WMLocalizedString(@"user_refund_cancel", @"客服拒绝取消订单，原因：%@。"), rejectCancelEventModel.eventDesc];
        } else if (rejectCancelEventModel.operatePlatform == WMOrderEventOperatorPlatformSystem) {
            // 用户取消订单，商户超时N分钟未操作，系统自动拒绝取消
            rejectReasonDesc = [NSString stringWithFormat:WMLocalizedString(@"system_refund_cancel", @"系统拒绝取消订单，原因：%@。"), rejectCancelEventModel.eventDesc];
        }
        NSMutableAttributedString *appendingStr;
        if (HDIsStringNotEmpty(rejectReasonDesc)) {
            appendingStr = [[NSMutableAttributedString alloc] initWithString:rejectReasonDesc attributes:nil];
            [text appendAttributedString:appendingStr];
        }
        if (mdesc) {
            NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:@"\n"];
            [timeStr appendAttributedString:mdesc];
            appendingStr = timeStr;
        }
        if (appendingStr) {
            [text appendAttributedString:appendingStr];
        }
        desc = text;
    } else {
        // 预计送达时间
        if (mdesc) {
            desc = mdesc;
        } else {
            desc = self.etaTimeStr;
        }
    }
    return desc;
}

/// 已完成的业务状态是前提，判断是否拒绝退款事件，生成描述
- (NSString *)descForRejectRefundEventWithBizStateCompleted {
    NSString *desc;
    // 判断是否是拒绝退款
    WMOrderEventModel *rejectRefundEventModel;
    for (WMOrderEventModel *eventModel in self.detailInfoModel.orderEventList) {
        if (eventModel.eventType == WMOrderEventTypeMerchantRejectRefund) {
            rejectRefundEventModel = eventModel;
            break;
        }
    }
    if (rejectRefundEventModel) {
        // 拒绝退款
        desc = WMLocalizedString(@"refund_request_rejected_tips", @"您的退款申请已被拒绝，请查看退款详情");
    } else {
        // 不是拒绝退款的已完成
        if(self.detailInfoModel.serviceType == 20) {
            desc = WMLocalizedString(@"wm_pickup_tips08", @"您的订单已完成，期待下次光临");
        }else{
            desc = WMLocalizedString(@"order_submit_Your_order_has_been_delivered", @"您的订单已送达，期待下次光临");
        }
    }
    return desc;
}

/// 获取状态的富文本文字
- (NSMutableAttributedString *)statusTitleLBAttributedStringWithTitle:(NSString *)title arrowColor:(UIColor *)color font:(UIFont *)font {
    self.statusTitle = title;
    NSMutableAttributedString *statusTitleLBAttributedString = [[NSMutableAttributedString alloc] initWithString:title];
    statusTitleLBAttributedString.yy_color = color;
    statusTitleLBAttributedString.yy_font = font;
    statusTitleLBAttributedString.yy_lineSpacing = kRealWidth(4);
    if (self.showArrow) {
        UIImage *arrowIV = [[UIImage imageNamed:@"yn_submit_gengd"] hd_imageWithTintColor:color];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:arrowIV contentMode:UIViewContentModeLeft
                                                                                           attachmentSize:CGSizeMake(kRealWidth(16), kRealWidth(16))
                                                                                              alignToFont:[HDAppTheme.WMFont wm_ForSize:14]
                                                                                                alignment:YYTextVerticalAlignmentCenter];
        [statusTitleLBAttributedString appendAttributedString:attachText];
    }
    return statusTitleLBAttributedString;
}

/// 获取描述des的富文本文字
- (NSMutableAttributedString *)statusDescLBAttributedStringWithAllText:(NSString *)alltext changeTexts:(NSArray<NSString *> *)changeTexts {
    return [self statusDescLBAttributedStringWithAllText:alltext changeTexts:changeTexts changeColor:HDAppTheme.WMColor.B3];
}

/// 获取描述des的富文本文字
- (NSMutableAttributedString *)statusDescLBAttributedStringWithAllText:(NSString *)alltext changeTexts:(NSArray<NSString *> *)changeTexts changeColor:(UIColor *)changeColor {
    NSString *allText = alltext;
    NSMutableAttributedString *statusDescLBAttributedString = [[NSMutableAttributedString alloc] initWithString:allText];
    [statusDescLBAttributedString setYy_color:HDAppTheme.WMColor.B3];
    [statusDescLBAttributedString setYy_font:[HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium]];
    for (NSString *changeText in changeTexts) {
        [statusDescLBAttributedString yy_setFont:[HDAppTheme.WMFont wm_boldForSize:20] range:[allText rangeOfString:changeText]];
        if (changeColor) {
            [statusDescLBAttributedString yy_setColor:changeColor range:[allText rangeOfString:changeText]];
        }
    }
    statusDescLBAttributedString.yy_lineSpacing = kRealWidth(4);
    return statusDescLBAttributedString;
}

- (void)invalidatePayTimer {
    if (_payTimer) {
        if ([_payTimer respondsToSelector:@selector(isValid)]) {
            if ([_payTimer isValid]) {
                [_payTimer invalidate];
                _payTimer = nil;
                !self.payTimerCountDownEndedBlock ?: self.payTimerCountDownEndedBlock();
            }
        }
    }
}

#pragma mark 订单轨迹
- (void)clickedStatusTitleHandler {
    WMOrderEventType submitOrderType = WMOrderEventTypeSuccessOrder;
    if (self.detailInfoModel.paymentMethod == SAOrderPaymentTypeOnline) {
        submitOrderType = WMOrderEventTypePaySuccess;
    }
    NSArray<NSDictionary *> *configs = @[
        @{@"eventType": @(submitOrderType), @"title": WMLocalizedString(@"order_trace_submit_order", @"提交订单")},
        @{@"eventType": @(WMOrderEventTypeMerchantAcceptedOrder), @"title": WMLocalizedString(@"order_trace_merchant_received", @"商户已接单")},
        @{@"eventType": @(WMOrderEventTypeDeliverReceive), @"title": WMLocalizedString(@"order_trace_rider_accept", @"骑手已接单")},
        @{@"eventType": @(WMOrderEventTypeDeliverArriveStore), @"title": WMLocalizedString(@"order_trace_rider_arrive_merchant", @"骑手到达商户")},
        @{@"eventType": @(WMOrderEventTypeConfirmReceiveFood), @"title": WMLocalizedString(@"order_trace_delivering", @"配送中")},
        @{@"eventType": @(WMOrderEventTypeChangeDeliveringArrived), @"title": WMLocalizedString(@"order_trace_arrived", @"已送达")},
        @{@"eventType": @(WMOrderEventTypeOrderCancelled), @"title": WMLocalizedString(@"order_trace_cancelled", @"已取消")}
    ];

    if (self.detailInfoModel.serviceType == 20) {
        configs = @[
            @{@"eventType": @(submitOrderType), @"title": WMLocalizedString(@"order_trace_submit_order", @"提交订单")},
            @{@"eventType": @(WMOrderEventTypeMerchantAcceptedOrder), @"title": WMLocalizedString(@"order_trace_merchant_received", @"商户已接单")},
            @{@"eventType": @(WMOrderEventTypeMerchantPreparedMeal), @"title": WMLocalizedString(@"wm_pickup_Waiting for self pickup", @"等待自取")},
            @{@"eventType": @(WMOrderEventTypeComplete), @"title": WMLocalizedString(@"order_list_completed", @"已完成")},
            @{@"eventType": @(WMOrderEventTypeOrderCancelled), @"title": WMLocalizedString(@"order_trace_cancelled", @"已取消")}
        ];
    }

    NSArray<NSNumber *> *neededEventTypeList = [configs mapObjectsUsingBlock:^id _Nonnull(NSDictionary *_Nonnull obj, NSUInteger idx) {
        return obj[@"eventType"];
    }];

    // 只取需要的事件类型
    NSArray<WMOrderEventModel *> *orderEventList = [self.detailInfoModel.orderEventList hd_filterWithBlock:^BOOL(WMOrderEventModel *_Nonnull item) {
        return [neededEventTypeList containsObject:[NSNumber numberWithInteger:item.eventType]];
    }];

    // 单独根据业务状态判断是不是已经取消
    WMBusinessStatus bizState = self.detailInfoModel.bizState;
    // 业务状态取消是大前提
    if (bizState == WMBusinessStatusOrderCancelled) {
        // 其次还要满足已发生事件不包含无效，否则会重复
        BOOL isEventListContainsCancelEvent = false;
        for (WMOrderEventModel *eventModel in orderEventList) {
            if (eventModel.eventType == WMOrderEventTypeOrderCancelled) {
                isEventListContainsCancelEvent = true;
                break;
            }
        }

        if (!isEventListContainsCancelEvent) {
            NSMutableArray<WMOrderEventModel *> *newOrderEventList = orderEventList.mutableCopy;
            WMOrderEventModel *cancelEventModel = WMOrderEventModel.new;
            cancelEventModel.eventType = WMOrderEventTypeOrderCancelled;
            cancelEventModel.eventTime = self.detailInfoModel.cancelTime;
            [newOrderEventList addObject:cancelEventModel];
            orderEventList = newOrderEventList;
        }
    } else if (bizState == WMBusinessStatusCompleted) {
        // 业务状态取消是大前提（处理直接完成情况）
        // 其次还要满足已发生事件不包含无效，否则会重复
        BOOL isEventListContainsCompletedEvent = false;
        for (WMOrderEventModel *eventModel in orderEventList) {
            if (eventModel.eventType == WMOrderEventTypeChangeDeliveringArrived) {
                isEventListContainsCompletedEvent = true;
                break;
            }
        }

        if (!isEventListContainsCompletedEvent) {
            NSMutableArray<WMOrderEventModel *> *newOrderEventList = orderEventList.mutableCopy;
            WMOrderEventModel *completedEventModel = WMOrderEventModel.new;
            completedEventModel.eventType = WMOrderEventTypeChangeDeliveringArrived;
            completedEventModel.eventTime = self.detailInfoModel.finishTime;
            [newOrderEventList addObject:completedEventModel];
            orderEventList = newOrderEventList;
        }
    }

    NSArray<NSNumber *> *orderEventTypeList = [orderEventList mapObjectsUsingBlock:^id _Nonnull(WMOrderEventModel *_Nonnull obj, NSUInteger idx) {
        return [NSNumber numberWithInteger:obj.eventType];
    }];
    NSMutableArray<WMOrderDetailTrackingTableViewCellModel *> *modelList = [NSMutableArray array];
    WMOrderDetailTrackingTableViewCellModel *cellModel;
    WMOrderEventModel *eventModel;
    NSDate *date;
    NSString *dateStr;

    NSArray<NSNumber *> *orderEndedFlagTypes = @[@(WMOrderEventTypeChangeDeliveringArrived), @(WMOrderEventTypeOrderCancelled)];
    if(self.detailInfoModel.serviceType == 20) {
        orderEndedFlagTypes = @[@(WMOrderEventTypeOrderCancelled)];
    }
    BOOL hasOrderEnd = false;
    for (NSNumber *alreadyType in orderEventTypeList) {
        for (NSNumber *endType in orderEndedFlagTypes) {
            if (alreadyType.integerValue == endType.integerValue) {
                hasOrderEnd = true;
                break;
            }
        }
    }

    NSMutableArray<NSNumber *> *addedTypeList = [NSMutableArray arrayWithCapacity:5];
    for (NSDictionary *config in configs) {
        WMOrderEventType type = [config[@"eventType"] integerValue];
        NSString *title = config[@"title"];
        if ([orderEventTypeList containsObject:@(type)]) {
            eventModel = [orderEventList objectAtIndex:[orderEventTypeList indexOfObject:@(type)]];
            // 时间戳转时间
            date = [NSDate dateWithTimeIntervalSince1970:eventModel.eventTime.integerValue / 1000.0];
            dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
            cellModel = [WMOrderDetailTrackingTableViewCellModel modelWithStatus:WMOrderDetailTrackingStatusCompleted title:title desc:dateStr];
            [modelList addObject:cellModel];
            [addedTypeList addObject:@(type)];
        } else {
            // 不包含则判断最后一项是不是取消或者已送达
            if (hasOrderEnd) {
                // 取剩下的生成预期数据
                NSArray<WMOrderEventModel *> *leftEventTypeList = [orderEventList hd_filterWithBlock:^BOOL(WMOrderEventModel *_Nonnull item) {
                    return ![addedTypeList containsObject:@(item.eventType)];
                }];
                for (WMOrderEventModel *leftEvent in leftEventTypeList) {
                    title = [configs hd_filterWithBlock:^BOOL(NSDictionary *_Nonnull mustExistedConfig) {
                                return [mustExistedConfig[@"eventType"] integerValue] == leftEvent.eventType;
                            }].firstObject[@"title"];
                    // 时间戳转时间
                    date = [NSDate dateWithTimeIntervalSince1970:leftEvent.eventTime.integerValue / 1000.0];
                    dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
                    cellModel = [WMOrderDetailTrackingTableViewCellModel modelWithStatus:WMOrderDetailTrackingStatusCompleted title:title desc:dateStr];
                    [modelList addObject:cellModel];
                }
                break;
            }
            if (type == orderEventTypeList.lastObject.integerValue + 1) {
                // 判断是不是最后进度的下一个事件
                cellModel = [WMOrderDetailTrackingTableViewCellModel modelWithStatus:WMOrderDetailTrackingStatusProcessing title:title
                                                                                desc:WMLocalizedString(@"order_trace_waiting_delivery", @"请等待配送")];
                [modelList addObject:cellModel];
            } else {
                // 推测的将来，移除取消和一个送达（因为配置里有两个送达）
                if (self.detailInfoModel.serviceType == 20) {
                    if (type == WMOrderEventTypeOrderCancelled) {
                        continue;
                    }

                    cellModel = [WMOrderDetailTrackingTableViewCellModel modelWithStatus:WMOrderDetailTrackingStatusExpected title:title desc:WMLocalizedString(@"", @"等待中")];
                } else {
                    if (type == WMOrderEventTypeOrderCancelled || type == WMOrderEventTypeMerchantPreparedMeal) {
                        continue;
                    }
                    // 判断是不是预计到达时间预计
                    if (type == WMOrderEventTypeChangeDeliveringArrived) {
                        // 时间戳转时间
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.detailInfoModel.deliveryInfo.eta / 1000.0];
                        NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
                        cellModel =
                            [WMOrderDetailTrackingTableViewCellModel modelWithStatus:WMOrderDetailTrackingStatusExpected title:title
                                                                                desc:[NSString stringWithFormat:WMLocalizedString(@"prospect_arrive_time_with_param", @"预计到达\n%@"), dateStr]];
                    } else {
                        cellModel = [WMOrderDetailTrackingTableViewCellModel modelWithStatus:WMOrderDetailTrackingStatusExpected title:title
                                                                                        desc:WMLocalizedString(@"order_trace_waiting_delivery", @"请等待配送")];
                    }
                }

                [modelList addObject:cellModel];
            }
        }
    }
    WMOrderDetailTrackingView *view = [[WMOrderDetailTrackingView alloc] initWithTrackingModel:modelList];
    [view layoutyImmediately];
    WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.title = WMLocalizedString(@"order_trace", @"订单轨迹");
        config.shouldAddScrollViewContainer = NO;
    }];
    [actionView show];
}
#pragma mark 打电话
- (void)clickedPhoneBTNHandler {
    ///显示骑手联系方式
    BOOL isShowRider = NO;
    ///客服
    NSMutableArray<WMAlertCallPopModel *> *marr = NSMutableArray.new;
    [marr addObject:[WMAlertCallPopModel hotServerModel]];
    // 订单状态为取消、完成和退款的单，不显示商户和骑手电话
    WMBusinessStatus bizState = self.detailInfoModel.bizState;

    if (bizState != WMBusinessStatusOrderCancelled && bizState != WMBusinessStatusCompleted) {
        WMDeliveryStatus status = self.detailInfoModel.deliveryInfo.deliveryStatus;
        isShowRider = (status == WMDeliveryStatusAccepted || status == WMDeliveryStatusArrivedMerchant || status == WMDeliveryStatusDelivering);
        [marr addObject:[WMAlertCallPopModel initName:WMLocalizedString(@"wm_contact_store", @"联系门店") image:@"yn_order_callStore" data:self.storeDetailInfoModel.contactNumber
                                                 type:WMCallPhoneTypeServerStore]];
        if (isShowRider && HDIsStringEmpty(self.detailInfoModel.imGroupId)) {
            [marr addObject:[WMAlertCallPopModel initName:WMLocalizedString(@"xTPtslzD", @"联系骑手") image:@"yn_order_rider" data:self.detailInfoModel.deliveryInfo.rider
                                                     type:WMCallPhoneTypeServerRider]];
        }
    }
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{
        @"orderNo": self.detailInfoModel.orderNo,
        @"telegramLink": @"https://t.me/wownow_cs_bot",
    }];

    if (isShowRider && !HDIsStringEmpty(self.detailInfoModel.imGroupId)) {
        mdic[@"groupID"] = self.detailInfoModel.imGroupId;
    }
    [self callActionWithArr:marr info:mdic];
}

- (void)callActionWithArr:(NSMutableArray *)marr info:(NSDictionary *)mdic {
    [GNAlertUntils commonCallWithArray:marr info:mdic];
}

#pragma mark - lazy load
- (YYLabel *)statusTitleLB {
    if (!_statusTitleLB) {
        YYLabel *label = YYLabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
        label.textColor = HDAppTheme.WMColor.B3;
        label.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(40);
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        _statusTitleLB = label;
    }
    return _statusTitleLB;
}

- (HDLabel *)statusDescLB {
    if (!_statusDescLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 0;
        _statusDescLB = label;
    }
    return _statusDescLB;
}

- (HDUIButton *)customBTN:(NSString *)title image:(NSString *)image color:(UIColor *)color block:(nullable ButtonBlock)block {
    HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
    button.imagePosition = HDUIButtonImagePositionTop;
    button.spacingBetweenImageAndTitle = kRealWidth(4);
    button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:11];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    if (block)
        [button addTouchUpInsideHandler:block];
    button.hidden = NO;
    return button;
}

- (NSTimer *)payTimer {
    if (!_payTimer) {
        _payTimer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payTimerInvoked) userInfo:nil repeats:true];
    }
    return _payTimer;
}

- (WMUIButton *)fastServiceBTN {
    if (!_fastServiceBTN) {
        _fastServiceBTN = [WMPromotionLabel createWMFastServiceBtn];
        _fastServiceBTN.hidden = true;
    }
    return _fastServiceBTN;
}

- (UIStackView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[UIStackView alloc] init];
        _floatLayoutView.axis = UILayoutConstraintAxisHorizontal;
        _floatLayoutView.distribution = UIStackViewDistributionFillEqually;
        _floatLayoutView.spacing = 0;
        _floatLayoutView.alignment = UIStackViewAlignmentFill;
    }
    return _floatLayoutView;
}

- (UIView *)topClickView {
    if (!_topClickView) {
        _topClickView = UIView.new;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStatusTitleHandler)];
        [_topClickView addGestureRecognizer:recognizer];
    }
    return _topClickView;
}

- (HDLabel *)statusDetailLB {
    if (!_statusDetailLB) {
        _statusDetailLB = HDLabel.new;
        _statusDetailLB.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), 0, 0, 0);
        _statusDetailLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _statusDetailLB.textColor = HDAppTheme.WMColor.B9;
        _statusDetailLB.numberOfLines = 0;
    }
    return _statusDetailLB;
}

- (WMOrderDetailStatusStepView *)orderDetailStatusStepView {
    if (!_orderDetailStatusStepView) {
        _orderDetailStatusStepView = [[WMOrderDetailStatusStepView alloc] init];
    }
    return _orderDetailStatusStepView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _lineView;
}

- (WMOrderDetailDTO *)detailDTO {
    if (!_detailDTO) {
        _detailDTO = WMOrderDetailDTO.new;
    }
    return _detailDTO;
}

- (UIView *)pickUpCodeView {
    if (!_pickUpCodeView) {
        _pickUpCodeView = UIView.new;
        _pickUpCodeView.backgroundColor = UIColor.whiteColor;
    }
    return _pickUpCodeView;
}

- (UILabel *)pickUpCodeLabel {
    if (!_pickUpCodeLabel) {
        _pickUpCodeLabel = UILabel.new;
        _pickUpCodeLabel.text = @"A123";
        _pickUpCodeLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
        _pickUpCodeLabel.textColor = UIColor.sa_C333;
    }
    return _pickUpCodeLabel;
}

- (UILabel *)pickUpCodeTipLabel {
    if (!_pickUpCodeTipLabel) {
        _pickUpCodeTipLabel = UILabel.new;
        _pickUpCodeTipLabel.text = SALocalizedString(@"wm_pickup_Pickup code", @"取餐码");
        _pickUpCodeTipLabel.font = HDAppTheme.font.sa_standard12;
        _pickUpCodeTipLabel.textColor = UIColor.sa_C333;
    }
    return _pickUpCodeTipLabel;
}

@end
