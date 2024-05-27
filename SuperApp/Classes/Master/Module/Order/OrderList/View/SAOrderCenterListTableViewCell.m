//
//  SAOrderCenterListTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/2/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderCenterListTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SACollectionViewCell.h"
#import "SAGeneralUtil.h"
#import "SAOperationButton.h"
#import "SAOrderListWaitPayView.h"
#import "SAShadowBackgroundView.h"
#import "UICollectionViewLeftAlignLayout.h"
#import "WMPromotionLabel.h"


@interface SAOrderCenterListCollectionViewCell : SACollectionViewCell

@property (nonatomic, strong) UIImageView *storeIV;

@property (nonatomic, strong) SALabel *productNameLB;

@property (nonatomic, strong) SAOrderGoodListModel *model;

@end


@implementation SAOrderCenterListCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.storeIV];
    [self.contentView addSubview:self.productNameLB];
}

- (void)updateConstraints {
    [self.storeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64);
        make.left.width.top.equalTo(self.contentView);
    }];

    [self.productNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.height.mas_offset(18);
        make.top.equalTo(self.storeIV.mas_bottom).offset(4);
        make.left.width.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark setter
- (void)setModel:(SAOrderGoodListModel *)model {
    _model = model;

    self.productNameLB.text = model.goodsName.desc;
    [HDWebImageManager setImageWithURL:model.picUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(64, 64)] imageView:self.storeIV];
}

#pragma mark lazy
- (UIImageView *)storeIV {
    if (!_storeIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(64, 64)];
        imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        _storeIV = imageView;
    }
    return _storeIV;
}

- (SALabel *)productNameLB {
    if (!_productNameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard11;
        label.textColor = HDAppTheme.color.sa_C333;
        label.numberOfLines = 1;
        label.text = @"asggdfsfadfsafsdafasdfdsf";
        _productNameLB = label;
    }
    return _productNameLB;
}
@end


@interface SAOrderCenterListTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>
/// 背景
@property (nonatomic, strong) SAShadowBackgroundView *bgView;
/// 描述容器
@property (nonatomic, strong) UIView *descContainer;
/// 店名
@property (nonatomic, strong) SALabel *nameLB;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 原因
@property (nonatomic, strong) SALabel *subDescLB;
/// 分隔线
@property (nonatomic, strong) UIView *sepLine;
/// 业务线 log
@property (nonatomic, strong) UIImageView *businessLineIV;
/// 门店 logo
@property (nonatomic, strong) UIImageView *storeIV;
/// 商品名称
@property (nonatomic, strong) SALabel *productNameLB;
/// 订单总件数
@property (nonatomic, strong) SALabel *countLB;
/// 时间
@property (nonatomic, strong) SALabel *dateLB;
/// 金额
@property (nonatomic, strong) SALabel *moneyLB;
/// 立即支付
@property (nonatomic, strong) SAOperationButton *payNowBTN;
/// 退款详情
@property (nonatomic, strong) SAOperationButton *refundDetailBTN;
/// 确认收货
@property (nonatomic, strong) SAOperationButton *confirmBTN;
/// 评价按钮
@property (nonatomic, strong) SAOperationButton *evaluationBTN;
/// 再次购买按钮
@property (nonatomic, strong) SAOperationButton *rebuyBTN;
/// 转账付款按钮
@property (nonatomic, strong) SAOperationButton *transferBTN;
///< 再来一单
@property (nonatomic, strong) SAOperationButton *oneMoreBTN;
/// 确认取餐
@property (nonatomic, strong) SAOperationButton *pickUpBTN;
/// 待支付倒计时定时器
@property (nonatomic, strong) NSTimer *payTimer;
/// 倒计时支付总时长
@property (nonatomic, assign) NSInteger payTimerSecondsTotal;
/// 倒计时支付剩余时长
@property (nonatomic, assign) NSInteger payTimerSecondsLeft;
/// 开始时间
@property (nonatomic, strong) NSDate *payTimerStartDate;
/// 门店头像边框图层
@property (nonatomic, strong) CAShapeLayer *storeIVBorderLayer;
/// 极速服务标签
//@property (nonatomic, strong) WMUIButton *fastServiceBTN;
/// 电商店铺类型标签
@property (strong, nonatomic) UIImageView *storeTypeTag;
/// 售后icon
@property (strong, nonatomic) UIImageView *afterSaleTag;
///更多功能按钮
@property (strong, nonatomic) UIButton *moreFunctionBTN;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SAOrderListWaitPayView *waitPayView;
/// 到店自取标签
@property (nonatomic, strong) SALabel *pickUpTag;
/// 取餐码
@property (nonatomic, strong) UILabel *pickUpCodeTipLabel;
/// 具体取餐号
@property (nonatomic, strong) UILabel *pickUpCodeLabel;

@end


@implementation SAOrderCenterListTableViewCell

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;

    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.arrowIV];
    [self.contentView addSubview:self.descContainer];
    [self.descContainer addSubview:self.descLB];
    [self.descContainer addSubview:self.subDescLB];
    [self.contentView addSubview:self.sepLine];
    [self.contentView addSubview:self.businessLineIV];
    [self.contentView addSubview:self.storeIV];
    [self.contentView addSubview:self.dateLB];
    //    [self.contentView addSubview:self.fastServiceBTN];
    [self.contentView addSubview:self.productNameLB];
    [self.contentView addSubview:self.countLB];
    [self.contentView addSubview:self.moneyLB];
    [self.contentView addSubview:self.payNowBTN];
    [self.contentView addSubview:self.refundDetailBTN];
    [self.contentView addSubview:self.confirmBTN];
    [self.contentView addSubview:self.evaluationBTN];
    [self.contentView addSubview:self.rebuyBTN];
    [self.contentView addSubview:self.transferBTN];
    [self.contentView addSubview:self.oneMoreBTN];
    [self.contentView addSubview:self.storeTypeTag];
    [self.contentView addSubview:self.afterSaleTag];
    [self.contentView addSubview:self.moreFunctionBTN];
    [self.contentView addSubview:self.pickUpBTN];

    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.waitPayView];
    [self.contentView addSubview:self.pickUpTag];

    [self.contentView addSubview:self.pickUpCodeTipLabel];
    [self.contentView addSubview:self.pickUpCodeLabel];

    [self.nameLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.descContainer setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.storeTypeTag setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.afterSaleTag setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    self.businessLineIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
    };

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];
}

- (void)hd_languageDidChanged {
    NSString *imageName = @"order_as_en";
    if (SAMultiLanguageManager.isCurrentLanguageCN)
        imageName = @"order_as_cn";
    if (SAMultiLanguageManager.isCurrentLanguageKH)
        imageName = @"order_as_kh";
    self.afterSaleTag.image = [UIImage imageNamed:imageName];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_payTimer invalidate];
    _payTimer = nil;
}

#pragma mark - getters and setters
- (void)setModel:(SAOrderModel *)model {
    _model = model;

    self.nameLB.text = model.storeName.desc;
    SAClientType businessLine = model.businessLine;
    NSString *title = model.businessOrderState;
    if ([businessLine isEqualToString:SAClientTypeYumNow] && !HDIsObjectNil(model.businessContent)) { //增加骑手接单、骑手到店节点， 如果到这两个节点  就显示
        if (model.businessContent.deliveryStatus == SADeliveryStatusAccepted) {
            title = WMLocalizedString(@"order_trace_rider_accept", @"骑手已接单");
        } else if (model.businessContent.deliveryStatus == SADeliveryStatusArrivedMerchant) {
            title = WMLocalizedString(@"order_trace_rider_arrive_merchant", @"骑手到达商户");
        }
    }
    NSString *desc;
    if ([businessLine isEqualToString:SAClientTypeYumNow] || [businessLine isEqualToString:SAClientTypeTinhNow] || [businessLine isEqualToString:SAClientTypeGroupBuy]) { // 外卖
        if (model.refundOrderState == SAOrderListAfterSaleStateWaitingRefund) {
            desc = SALocalizedString(@"refunding", @"退款中");
        } else if (model.refundOrderState == SAOrderListAfterSaleStateRefunded) {
            desc = SALocalizedString(@"refunded_success", @"退款成功");
        }
    }
    self.descLB.hidden = HDIsStringEmpty(title);
    self.descLB.text = title;

    //电商店铺标签显示
    if ([businessLine isEqualToString:SAClientTypeTinhNow] && [model.businessContent.storeType isEqualToString:TNStoreTypeOverseasShopping]) {
        self.storeTypeTag.hidden = false;
    } else {
        self.storeTypeTag.hidden = true;
    }

    self.afterSaleTag.hidden = !model.isSale;

    //倒计时处理
    self.waitPayView.hidden = YES;
    self.descContainer.hidden = NO;
    // 电商在订单列表不显示倒计时
    if ([model.operationList containsObject:SAOrderListOperationEventNamePay] && ![businessLine isEqualToString:SAClientTypeTinhNow]) {
        // 计算剩余时间秒数
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval orderPassedSeconds = (nowInterval - model.orderTime / 1000.0);
        NSUInteger maxSeconds = (model.expireTime <= 0 ? 15 : model.expireTime) * 60;
        if (orderPassedSeconds >= maxSeconds) {
            HDLog(@"订单已到最大待支付时间，后端未做取消处理");
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
            self.waitPayView.timeLabel.text = [NSString stringWithFormat:@"%@", [SAGeneralUtil waitPayTimeWithSeconds:self.payTimerSecondsLeft]];
            self.waitPayView.hidden = NO;
            self.descContainer.hidden = YES;
        }
    } else {
        // 解决支付状态更新时倒计时未结束
        if ([_payTimer respondsToSelector:@selector(isValid)]) {
            if ([_payTimer isValid]) {
                [_payTimer invalidate];
                _payTimer = nil;
            }
        }
    }

    self.subDescLB.hidden = HDIsStringEmpty(desc);
    if (!self.subDescLB.isHidden) {
        self.subDescLB.text = desc;
    }

    self.businessLineIV.hidden = model.hideBusinessLogo;
    if (!self.businessLineIV.isHidden) {
        UIImage *businessImage = HDHelper.circlePlaceholderImage;

        if (HDIsStringNotEmpty(model.merchantLogo)) {
            [self.businessLineIV sd_setImageWithURL:[NSURL URLWithString:model.merchantLogo] placeholderImage:businessImage];
        } else {
            if ([model.businessLine isEqualToString:SAClientTypeYumNow]) {
                businessImage = [UIImage imageNamed:@"icon_oc_yumnow"];
                if ([model.businessContent.businessType isEqualToString:WMBusinessTypeDigitelMenu]) {
                    businessImage = [UIImage imageNamed:@"order_list_yumnow_table"];
                }
            } else if ([model.businessLine isEqualToString:SAClientTypeTinhNow]) {
                businessImage = [UIImage imageNamed:@"icon_oc_tinhnow"];
            } else if ([model.businessLine isEqualToString:SAClientTypePhoneTopUp]) {
                businessImage = [UIImage imageNamed:@"icon_oc_top_up"];
            } else if ([model.businessLine isEqualToString:SAClientTypeGroupBuy]) {
                businessImage = [UIImage imageNamed:@"icon_oc_group_buy"];
            } else if ([model.businessLine isEqualToString:SAClientTypeBillPayment]) {
                businessImage = [UIImage imageNamed:@"icon_oc_bill"];
            } else if ([model.businessLine isEqualToString:SAClientTypeGame]) {
                businessImage = [UIImage imageNamed:@"icon_oc_game"];
            } else if ([model.businessLine isEqualToString:SAClientTypeHotel]) {
                businessImage = [UIImage imageNamed:@"icon_oc_hotel"];
            } else {
                businessImage = [UIImage imageNamed:@"business_outsize"];
            }
            self.businessLineIV.image = businessImage;
        }
    }

    [HDWebImageManager setImageWithURL:model.storeLogo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(64, 64)] imageView:self.storeIV];

    self.dateLB.text = model.orderTimeStr;
    //    self.fastServiceBTN.hidden = !model.speedDelivery.boolValue;

    self.productNameLB.hidden = HDIsStringEmpty(model.remark.desc);
    if (!self.productNameLB.isHidden) {
        self.productNameLB.text = model.remark.desc;
    }

    [self updateTotalMoneyTextWithTotalMoney:model.actualPayAmount];

    self.confirmBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNameConfirmReceiving];
    self.evaluationBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNameEvaluation];
    self.refundDetailBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNameRefundDetail];
    self.payNowBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNamePay];
    if ([model.businessLine isEqualToString:SAClientTypeYumNow] || [model.businessLine isEqualToString:SAClientTypeTinhNow] ||
        [model.businessLine isEqualToString:SAClientTypeGroupBuy]) { // 外卖电商业务线才显示再来一单按钮
        self.rebuyBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNameReBuy];
    } else {
        self.rebuyBTN.hidden = true;
    }


    self.pickUpBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNamePickUp];

    //    self.moreFunctionBTN.hidden = self.rebuyBTN.hidden;

    self.transferBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNameTransfer];
    if ([model.businessLine isEqualToString:SAClientTypeTinhNow]) {
        self.oneMoreBTN.hidden = ![model.operationList containsObject:SAOrderListOperationEventNameNearbyBuy];
    } else {
        self.oneMoreBTN.hidden = YES;
    }
    [self.confirmBTN setTitle:SALocalizedString(@"confirm_received_goods", @"确认收货") forState:UIControlStateNormal];
    [self.evaluationBTN setTitle:SALocalizedString(@"evaluate", @"评价") forState:UIControlStateNormal];
    [self.refundDetailBTN setTitle:SALocalizedString(@"refund_detail", @"退款详情") forState:UIControlStateNormal];
    [self.payNowBTN setTitle:SALocalizedString(@"top_up_pay_now", @"立即支付") forState:UIControlStateNormal];
    [self.pickUpBTN setTitle:WMLocalizedString(@"wm_pickup_Confirm receipt", @"确认取餐") forState:UIControlStateNormal];
    if ([model.businessLine isEqualToString:SAClientTypeYumNow] || [model.businessLine isEqualToString:SAClientTypeGroupBuy]) {
        [self.rebuyBTN setTitle:WMLocalizedString(@"zA8ZBMsK", @"再来一单") forState:UIControlStateNormal];
    } else {
        [self.rebuyBTN setTitle:SALocalizedString(@"buy_again", @"再次购买") forState:UIControlStateNormal];
    }
    ///团购评价界面 暂时隐藏
    if ([model.businessLine isEqualToString:SAClientTypeGroupBuy]) {
        self.evaluationBTN.hidden = YES;
        if ((model.payType != SAOrderPaymentTypeOnline)) {
            self.refundDetailBTN.hidden = YES;
        }
    }
    [self.oneMoreBTN setTitle:TNLocalizedString(@"btn_nearby_buy", @"附近购买") forState:UIControlStateNormal];

    self.collectionView.hidden = (!model.goodsInfoList.count || model.goodsInfoList.count < 2);
    //    self.collectionView.hidden = NO;
    if (!self.collectionView.isHidden) {
        [self.collectionView reloadData];
    }

    self.countLB.hidden = model.goodsNum == 0;
    if (!self.countLB.isHidden) {
        self.countLB.text = [NSString stringWithFormat:SALocalizedString(@"oc_total", @"共 %ld 件"), model.goodsNum];
    }

    { //处理更多操作按钮显示逻辑
        NSMutableArray *mArr = NSMutableArray.new;
        if (model.refundOrderState == SAOrderListAfterSaleStateRefunded || model.aggregateOrderFinalState == SAAggregateOrderFinalStateComplete
            || model.aggregateOrderState == SAAggregateOrderStatePayed) {
            if (model.payType != SAOrderPaymentTypeCashOnDelivery) { //非货到付款
                [mArr addObject:SALocalizedString(@"oc_bill", @"支付账单")];
            }
        }

        if (model.refundOrderState == SAOrderListAfterSaleStateRefunded || model.aggregateOrderFinalState == SAAggregateOrderFinalStateCancel
            || model.aggregateOrderFinalState == SAAggregateOrderFinalStateComplete || model.aggregateOrderFinalState == SAAggregateOrderFinalStateClosed) {
            [mArr addObject:SALocalizedString(@"oc_delete_order", @"删除订单")];
        }

        if (mArr.count) {
            self.model.associatedTargetOptionArray = mArr;
        } else {
            self.model.associatedTargetOptionArray = nil;
        }
        self.moreFunctionBTN.hidden = !self.model.associatedTargetOptionArray.count;
    }

    self.pickUpTag.hidden = YES;
    self.pickUpCodeLabel.hidden = self.pickUpCodeTipLabel.hidden = YES;
    if(model.serviceType == 20 && [model.businessLine isEqualToString:SAClientTypeYumNow]) {
        self.pickUpTag.hidden = NO;
        if(HDIsStringNotEmpty(model.pickupCode) && model.businessOrderStateEnum != 10 && model.businessOrderStateEnum != 13 && model.businessOrderStateEnum != 20) {
            self.pickUpCodeLabel.hidden = self.pickUpCodeTipLabel.hidden = NO;
            self.pickUpCodeTipLabel.text = WMLocalizedString(@"wm_pickup_Pickup code", @"取餐码");
            self.pickUpCodeLabel.text = model.pickupCode;
            self.moreFunctionBTN.hidden = YES;
            if(SAMultiLanguageManager.isCurrentLanguageKH) {
                self.pickUpCodeTipLabel.hidden = YES;
            }
        }
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)updateTotalMoneyTextWithTotalMoney:(SAMoneyModel *)totalMoney {
    self.moneyLB.hidden = false;

    NSAttributedString *totalStr = [[NSAttributedString alloc] initWithString:SALocalizedString(@"total_title", @"总共:")
                                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14B, NSForegroundColorAttributeName: HDAppTheme.color.sa_C333}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:totalStr];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];

    if (HDIsStringNotEmpty(totalMoney.thousandSeparatorAmount)) {
        NSAttributedString *moneyStr = [[NSAttributedString alloc] initWithString:totalMoney.thousandSeparatorAmount
                                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14B, NSForegroundColorAttributeName: HDAppTheme.color.sa_C333}];
        [text appendAttributedString:moneyStr];
    }
    self.moneyLB.attributedText = text;
}

#pragma mark - event response
- (void)clickedPayNowBTNHandler {
    !self.clickedPayNowBlock ?: self.clickedPayNowBlock(self.model);
}

- (void)clickedRefundDetailBTNHandler {
    !self.clickedRefundDetailBlock ?: self.clickedRefundDetailBlock(self.model);
}

- (void)clickedEvaluationBTNHandler {
    !self.clickedEvaluationOrderBlock ?: self.clickedEvaluationOrderBlock(self.model);
}

- (void)clickedConfirmBTNHandler {
    !self.clickedConfirmReceivingBlock ?: self.clickedConfirmReceivingBlock(self.model);
}

- (void)clickedStoreTitleHandler {
    !self.clickedStoreTitleBlock ?: self.clickedStoreTitleBlock(self.model);
}
- (void)clickedRebuyBTNHandler {
    !self.clickedRebuyBlock ?: self.clickedRebuyBlock(self.model);
}
- (void)clickedTransferBTNHandler {
    !self.clickedTransferBlock ?: self.clickedTransferBlock(self.model);
}

- (void)clickedMoreFuncBTNHandler {
    self.model.associatedTargetView = self.moreFunctionBTN;
    !self.clickedMoreFunctionBlock ?: self.clickedMoreFunctionBlock(self.model);
}

- (void)clickedPickUpBTNHandler {
    !self.clickedPickUpBlock ?: self.clickedPickUpBlock(self.model);
}

- (void)payTimerInvoked {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_payTimerStartDate];

    self.payTimerSecondsLeft = self.payTimerSecondsTotal - (NSInteger)(deltaTime + 0.5);

    NSString *desc = [NSString stringWithFormat:@"%@", [SAGeneralUtil waitPayTimeWithSeconds:self.payTimerSecondsLeft]];
    self.waitPayView.timeLabel.text = desc;

    if (self.payTimerSecondsLeft <= 0.0) {
        [self invalidatePayTimer];
        self.waitPayView.hidden = YES;
        self.descContainer.hidden = NO;
    }
    [self setNeedsUpdateConstraints];
}

- (void)clickedOneMoreBTNHandler {
    !self.clickedOneMoreBlock ?: self.clickedOneMoreBlock(self.model);
}

#pragma mark - private methods
- (void)invalidatePayTimer {
    if (_payTimer) {
        if ([_payTimer respondsToSelector:@selector(isValid)]) {
            if ([_payTimer isValid]) {
                [_payTimer invalidate];
                _payTimer = nil;
                //暂时不触发
                //                !self.payTimerCountDownEndedBlock ?: self.payTimerCountDownEndedBlock(self.model);
            }
        }
    }
}

- (SAOperationButton *)buttonWithStyle:(SAOperationButtonStyle)style
                                 title:(NSString *)title
                                action:(SEL)action
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor *)borderColor
                             tintColor:(UIColor *)tintColor {
    SAOperationButton *button = [SAOperationButton buttonWithStyle:style];
    button.titleEdgeInsets = UIEdgeInsetsMake(6, 16, 6, 16);
    button.titleLabel.font = HDAppTheme.font.sa_standard14M;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.hidden = true;
    if (borderWidth > 0) {
        [button applyHollowPropertiesWithTintColor:tintColor];
        button.borderWidth = borderWidth;
        button.borderColor = borderColor;
    }
    return button;
}


#pragma mark - layout
- (void)updateConstraints {
    CGFloat margin = 12;

    [self.businessLineIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessLineIV.isHidden) {
            make.left.equalTo(self.bgView).offset(margin);
            make.size.mas_equalTo(CGSizeMake(margin * 2, margin * 2));
            make.top.equalTo(self.bgView).offset(margin);
            make.centerY.equalTo(self.nameLB);
        } else {
            make.left.equalTo(self.bgView);
            make.size.mas_equalTo(CGSizeMake(0.1, margin * 2));
            make.top.equalTo(self.bgView).offset(margin);
            make.centerY.equalTo(self.nameLB);
        }
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.businessLineIV.isHidden) {
            make.left.equalTo(self.businessLineIV).offset(margin);
        } else {
            make.left.equalTo(self.businessLineIV.mas_right).offset(4);
        }
        make.centerY.equalTo(self.descContainer);
    }];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowIV.image.size);
        make.centerY.equalTo(self.nameLB);
        make.left.equalTo(self.nameLB.mas_right);
        if (self.storeTypeTag.isHidden) {
            if (self.afterSaleTag.isHidden) {
                make.right.lessThanOrEqualTo(self.descContainer.mas_left).offset(-30);
            } else {
                make.right.lessThanOrEqualTo(self.afterSaleTag.mas_left).offset(-margin);
            }
        } else {
            make.right.equalTo(self.storeTypeTag.mas_left);
        }
    }];
    if (!self.storeTypeTag.isHidden) {
        [self.storeTypeTag sizeToFit];
        [self.storeTypeTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLB);
            if (self.afterSaleTag.isHidden) {
                if (self.descContainer.isHidden) {
                    make.right.lessThanOrEqualTo(self.waitPayView.mas_left).offset(-margin);
                } else {
                    make.right.lessThanOrEqualTo(self.descContainer.mas_left).offset(-30);
                }
            } else {
                make.right.lessThanOrEqualTo(self.afterSaleTag.mas_left).offset(-margin);
            }
        }];
    }

    if (!self.afterSaleTag.isHidden) {
        [self.afterSaleTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLB);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.right.equalTo(self.descContainer.mas_left).offset(-margin);
        }];
    }

    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.descLB.isHidden) {
            make.right.equalTo(self.bgView).offset(-margin);
            if (!self.subDescLB.isHidden) {
                make.top.equalTo(self.bgView).offset(7);
            } else {
                make.centerY.equalTo(self.arrowIV);
            }
        }
    }];
    [self.subDescLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.subDescLB.isHidden) {
            make.right.equalTo(self.bgView).offset(-margin);
            if (self.descLB.isHidden) {
                make.top.equalTo(self.bgView).offset(margin);
            } else {
                make.top.equalTo(self.descLB.mas_bottom).offset(kRealWidth(4));
            }
        }
    }];

    [self.descLB sizeToFit];
    [self.subDescLB sizeToFit];
    [self.descContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *topView = self.descLB.isHidden ? self.subDescLB : self.descLB;
        make.top.equalTo(topView);
        make.width.equalTo(self.descLB.width > self.subDescLB.width ? self.descLB : self.subDescLB);
        make.right.equalTo(topView);
        UIView *bottomView = self.subDescLB.isHidden ? self.descLB : self.subDescLB;
        make.bottom.equalTo(bottomView);
    }];

    [self.waitPayView sizeToFit];
    [self.waitPayView.timeLabel sizeToFit];
    [self.waitPayView.stateLabel sizeToFit];
    CGFloat width = self.waitPayView.timeLabel.frame.size.width;
    if (width < 32)
        width = 32;
    [self.waitPayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.waitPayView.isHidden) {
            make.right.equalTo(self.bgView).offset(-margin);
            make.centerY.equalTo(self.arrowIV);
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(width + self.waitPayView.stateLabel.frame.size.width + 16);
            if (!self.storeTypeTag.isHidden) {
                //                make.left.mas_greaterThanOrEqualTo(self.storeTypeTag.mas_right).offset(margin);
            } else {
                make.left.mas_greaterThanOrEqualTo(self.arrowIV.mas_right).offset(margin);
            }
        }
    }];

    [self.sepLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.bgView).offset(12);
        make.right.equalTo(self.bgView).offset(-12);
        if (self.descLB.isHidden || self.subDescLB.isHidden) {
            make.top.equalTo(self.descContainer.mas_bottom).offset(margin);
        } else {
            make.top.equalTo(self.descContainer.mas_bottom).offset(kRealWidth(7));
        }
        //        if (!self.businessLineIV.isHidden) {
        make.top.greaterThanOrEqualTo(self.businessLineIV.mas_bottom).offset(margin);
        //        }
    }];


    if (!self.pickUpTag.hidden) {
        [self.pickUpTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sepLine).offset(8);
            make.left.equalTo(self.bgView).offset(margin);
            make.height.mas_equalTo(20);
        }];
    }

    if (!self.collectionView.isHidden) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.pickUpTag.hidden) {
                make.top.equalTo(self.pickUpTag.mas_bottom).offset(8);
            } else {
                make.top.equalTo(self.sepLine).offset(12);
            }
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(82);
        }];

        [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView).offset(-12);
            make.top.equalTo(self.collectionView.mas_bottom).offset(12);
            make.bottom.lessThanOrEqualTo(self.bgView).offset(-margin);
        }];

        [self.countLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.countLB.isHidden) {
                make.right.equalTo(self.moneyLB.mas_left).offset(-8);
                make.centerY.equalTo(self.moneyLB);
            }
        }];

        [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.countLB.isHidden) {
                make.right.equalTo(self.countLB.mas_left).offset(-8);
            } else {
                make.right.equalTo(self.moneyLB.mas_left).offset(-8);
            }
            make.centerY.equalTo(self.moneyLB);
        }];

    } else {
        [self.storeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(64, 64));
            make.left.equalTo(self.bgView).offset(margin);
            if (!self.pickUpTag.hidden) {
                make.top.equalTo(self.pickUpTag.mas_bottom).offset(8);
            } else {
                make.top.equalTo(self.sepLine).offset(margin);
            }
            make.bottom.lessThanOrEqualTo(self.bgView).offset(-margin);
        }];

        if (!self.productNameLB.isHidden) {
            [self.productNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.storeIV.mas_right).offset(4);
                //            make.top.equalTo(self.dateLB.mas_bottom).offset(kRealWidth(8));
                make.top.equalTo(self.storeIV.mas_top);
                make.right.equalTo(self.bgView).offset(-margin);
                make.height.mas_equalTo(20);
            }];
        }

        [self.countLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.countLB.isHidden) {
                make.left.equalTo(self.storeIV.mas_right).offset(4);
                if (!self.productNameLB.isHidden) {
                    make.top.equalTo(self.productNameLB.mas_bottom).offset(4);
                } else {
                    make.top.equalTo(self.storeIV);
                }
                make.right.equalTo(self.bgView).offset(-margin);
                make.height.mas_equalTo(20);
            }
        }];

        [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeIV.mas_right).offset(4);
            if (!self.countLB.isHidden) {
                make.top.equalTo(self.countLB.mas_bottom).offset(4);
            } else if (!self.productNameLB.isHidden) {
                make.top.equalTo(self.productNameLB.mas_bottom).offset(4);
            } else {
                make.top.equalTo(self.storeIV);
            }
            make.height.mas_equalTo(18);
        }];
        //        [self.fastServiceBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.equalTo(self.dateLB);
        //            make.left.equalTo(self.dateLB.mas_right).offset(kRealWidth(5));
        //        }];

        [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            //        make.left.equalTo(self.storeIV.mas_right).offset(kRealWidth(10));
            //        UIView *view = self.productNameLB.isHidden ? self.dateLB : self.productNameLB;
            //        make.top.equalTo(view.mas_bottom).offset(kRealWidth(8));
            //        make.right.equalTo(self.bgView).offset(-kRealWidth(10));
            //        make.bottom.lessThanOrEqualTo(self.bgView).offset(-margin);
            make.right.equalTo(self.bgView).offset(-margin);
            make.bottom.equalTo(self.storeIV);
        }];
    }

    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.confirmBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.confirmBTN.bounds.size);
            if (self.evaluationBTN.isHidden) {
                make.right.equalTo(self.bgView).offset(-margin);
                make.bottom.equalTo(self.bgView).offset(-margin);
            } else {
                make.right.equalTo(self.evaluationBTN.mas_left).offset(-kRealWidth(8));
            }
        }
    }];
    [self.evaluationBTN sizeToFit];
    [self.evaluationBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.evaluationBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.evaluationBTN.bounds.size);
            make.right.equalTo(self.bgView).offset(-margin);
            make.bottom.equalTo(self.bgView).offset(-margin);
        }
    }];
    [self.refundDetailBTN sizeToFit];
    [self.refundDetailBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.refundDetailBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.refundDetailBTN.bounds.size);
            UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
            if (view.isHidden) {
                make.right.equalTo(self.bgView).offset(-margin);
                make.bottom.equalTo(self.bgView).offset(-margin);
            } else {
                make.right.equalTo(view.mas_left).offset(-kRealWidth(8));
            }
        }
    }];
    [self.payNowBTN sizeToFit];
    [self.payNowBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.payNowBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.payNowBTN.bounds.size);
            UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
            if (view.isHidden) {
                make.right.equalTo(self.bgView).offset(-margin);
                make.bottom.equalTo(self.bgView).offset(-margin);
            } else {
                make.right.equalTo(view.mas_left).offset(-kRealWidth(8));
            }
        }
    }];

    [self.pickUpBTN sizeToFit];
    [self.pickUpBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pickUpBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.pickUpBTN.bounds.size);
            if (self.evaluationBTN.isHidden) {
                make.right.equalTo(self.bgView).offset(-margin);
                make.bottom.equalTo(self.bgView).offset(-margin);
            } else {
                make.right.equalTo(self.evaluationBTN.mas_left).offset(-kRealWidth(8));
            }
        }
    }];

    [self.rebuyBTN sizeToFit];
    [self.rebuyBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rebuyBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.rebuyBTN.bounds.size);
            UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
            view = self.refundDetailBTN.hidden ? view : self.refundDetailBTN;
            if (view.isHidden) {
                make.right.equalTo(self.bgView).offset(-margin);
                make.bottom.equalTo(self.bgView).offset(-margin);
            } else {
                make.right.equalTo(view.mas_left).offset(-kRealWidth(8));
            }
        }
    }];

    [self.moreFunctionBTN sizeToFit];
    [self.moreFunctionBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.moreFunctionBTN.isHidden) {
            if (!self.rebuyBTN.isHidden) {
                make.centerY.equalTo(self.rebuyBTN);
            } else {
                UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
                view = self.refundDetailBTN.hidden ? view : self.refundDetailBTN;
                view = self.pickUpBTN.hidden ? view : self.pickUpBTN;
                if (!view.isHidden) {
                    make.centerY.equalTo(view);
                } else if (self.model.goodsInfoList.count > 1) {
                    make.centerY.equalTo(self.moneyLB);
                } else {
                    make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
                    make.bottom.equalTo(self.bgView).offset(-margin);
                    //                    make.centerY.equalTo(self.moneyLB);
                }
            }
            make.size.mas_equalTo(self.moreFunctionBTN.bounds.size);
            make.left.equalTo(self.bgView).offset(margin);
        }
    }];


    [self.pickUpCodeTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pickUpCodeTipLabel.isHidden) {
            if (!self.rebuyBTN.isHidden) {
                make.centerY.equalTo(self.rebuyBTN);
            } else {
                UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
                view = self.refundDetailBTN.hidden ? view : self.refundDetailBTN;
                view = self.pickUpBTN.hidden ? view : self.pickUpBTN;
                if (!view.isHidden) {
                    make.centerY.equalTo(view);
                } else {
                    make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin * 1.5);
                    make.bottom.mas_lessThanOrEqualTo(self.bgView).offset(-margin);
                }
            }
            make.left.equalTo(self.bgView).offset(margin);
        }
    }];


    [self.pickUpCodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pickUpCodeLabel.isHidden) {
            if (!self.pickUpCodeTipLabel.isHidden) {
                make.left.equalTo(self.pickUpCodeTipLabel.mas_right).offset(4);
                make.centerY.equalTo(self.pickUpCodeTipLabel);
            }else{
                if (!self.rebuyBTN.isHidden) {
                    make.centerY.equalTo(self.rebuyBTN);
                } else {
                    UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
                    view = self.refundDetailBTN.hidden ? view : self.refundDetailBTN;
                    view = self.pickUpBTN.hidden ? view : self.pickUpBTN;
                    if (!view.isHidden) {
                        make.centerY.equalTo(view);
                    } else {
                        make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin * 1.5);
                        make.bottom.mas_lessThanOrEqualTo(self.bgView).offset(-margin);
                    }
                }
                make.left.equalTo(self.bgView).offset(margin);
            }
        }
    }];
    

    [self.transferBTN sizeToFit];
    [self.transferBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.transferBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.transferBTN.bounds.size);
            UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
            if (view.isHidden) {
                make.right.equalTo(self.bgView).offset(-margin);
                make.bottom.equalTo(self.bgView).offset(-margin);
            } else {
                make.right.equalTo(view.mas_left).offset(-kRealWidth(8));
            }
        }
    }];

    [self.oneMoreBTN sizeToFit];
    [self.oneMoreBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.oneMoreBTN.isHidden) {
            make.top.greaterThanOrEqualTo(self.storeIV.mas_bottom).offset(margin);
            make.top.greaterThanOrEqualTo(self.moneyLB.mas_bottom).offset(margin);
            make.size.mas_equalTo(self.oneMoreBTN.bounds.size);
            UIView *view = self.evaluationBTN.hidden ? self.confirmBTN : self.evaluationBTN;
            if (view.isHidden) {
                make.right.equalTo(self.bgView).offset(-margin);
                make.bottom.equalTo(self.bgView).offset(-margin);
            } else {
                make.right.equalTo(view.mas_left).offset(-kRealWidth(8));
            }
        }
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView).offset(self.model.isLastCell ? -8 : 0);
    }];
    [super updateConstraints];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.model.goodsInfoList.count, 9);
    //    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAOrderCenterListCollectionViewCell *cell = [SAOrderCenterListCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                 identifier:NSStringFromClass(SAOrderCenterListCollectionViewCell.class)];
    cell.model = self.model.goodsInfoList[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(64, 82);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.didSelectRowBlock ?: self.didSelectRowBlock();
}

#pragma mark - tap event
- (void)clickCollectionView {
    !self.didSelectRowBlock ?: self.didSelectRowBlock();
}

#pragma mark - lazy load
- (SAShadowBackgroundView *)bgView {
    if (!_bgView) {
        SAShadowBackgroundView *view = SAShadowBackgroundView.new;
        view.clipsToBounds = true;
        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard14B;
        label.textColor = HDAppTheme.color.sa_C333;
        label.numberOfLines = 1;
        label.userInteractionEnabled = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
        [label addGestureRecognizer:recognizer];
        _nameLB = label;
    }
    return _nameLB;
}

- (UIView *)descContainer {
    if (!_descContainer) {
        _descContainer = UIView.new;
    }
    return _descContainer;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard12M;
        label.textColor = HDAppTheme.color.sa_C333;
        label.numberOfLines = 1;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)subDescLB {
    if (!_subDescLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard12;
        label.textColor = HDAppTheme.color.sa_C1;
        //        label.numberOfLines = 0;
        _subDescLB = label;
    }
    return _subDescLB;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = UIView.new;
        _sepLine.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _sepLine;
}

- (UIImageView *)businessLineIV {
    if (!_businessLineIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = HDHelper.circlePlaceholderImage;
        imageView.userInteractionEnabled = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
        [imageView addGestureRecognizer:recognizer];
        _businessLineIV = imageView;
    }
    return _businessLineIV;
}

- (UIImageView *)storeIV {
    if (!_storeIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(64, 64)];
        imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        _storeIV = imageView;
    }
    return _storeIV;
}

- (SALabel *)productNameLB {
    if (!_productNameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard14M;
        label.textColor = HDAppTheme.color.sa_C333;
        label.numberOfLines = 1;
        _productNameLB = label;
    }
    return _productNameLB;
}

- (SALabel *)countLB {
    if (!_countLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard12;
        label.textColor = HDAppTheme.color.sa_C999;
        label.numberOfLines = 1;

        _countLB = label;
    }
    return _countLB;
}

- (SALabel *)dateLB {
    if (!_dateLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard12;
        label.textColor = HDAppTheme.color.sa_C999;
        label.numberOfLines = 1;
        _dateLB = label;
    }
    return _dateLB;
}

- (SALabel *)moneyLB {
    if (!_moneyLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard14B;
        label.textColor = HDAppTheme.color.sa_C333;
        label.numberOfLines = 1;
        _moneyLB = label;
    }
    return _moneyLB;
}

- (SAOperationButton *)payNowBTN {
    if (!_payNowBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleSolid title:SALocalizedString(@"top_up_pay_now", @"立即支付") action:@selector(clickedPayNowBTNHandler) borderWidth:0
                                              borderColor:nil
                                                tintColor:nil];
        _payNowBTN = button;
    }
    return _payNowBTN;
}

- (SAOperationButton *)pickUpBTN {
    if (!_pickUpBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleSolid title:WMLocalizedString(@"wm_pickup_Confirm receipt", @"确认取餐") action:@selector(clickedPickUpBTNHandler)
                                              borderWidth:0
                                              borderColor:nil
                                                tintColor:nil];
        _pickUpBTN = button;
    }
    return _pickUpBTN;
}

- (SAOperationButton *)refundDetailBTN {
    if (!_refundDetailBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleHollow title:SALocalizedString(@"refund_detail", @"退款详情") action:@selector(clickedRefundDetailBTNHandler)
                                              borderWidth:1
                                              borderColor:HDAppTheme.color.sa_C666
                                                tintColor:HDAppTheme.color.sa_C666];
        _refundDetailBTN = button;
    }
    return _refundDetailBTN;
}

- (SAOperationButton *)confirmBTN {
    if (!_confirmBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleHollow title:SALocalizedString(@"confirm_received_goods", @"确认收货") action:@selector(clickedConfirmBTNHandler)
                                              borderWidth:1
                                              borderColor:HDAppTheme.color.sa_C666
                                                tintColor:HDAppTheme.color.sa_C666];
        _confirmBTN = button;
    }
    return _confirmBTN;
}

- (SAOperationButton *)evaluationBTN {
    if (!_evaluationBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleSolid title:SALocalizedString(@"evaluate", @"评价") action:@selector(clickedEvaluationBTNHandler) borderWidth:0
                                              borderColor:nil
                                                tintColor:nil];
        _evaluationBTN = button;
    }
    return _evaluationBTN;
}
- (SAOperationButton *)rebuyBTN {
    if (!_rebuyBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleHollow title:SALocalizedString(@"buy_again", @"再次购买") action:@selector(clickedRebuyBTNHandler) borderWidth:1
                                              borderColor:HDAppTheme.color.sa_C1
                                                tintColor:HDAppTheme.color.sa_C1];
        _rebuyBTN = button;
    }
    return _rebuyBTN;
}

- (SAOperationButton *)oneMoreBTN {
    if (!_oneMoreBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleHollow title:TNLocalizedString(@"btn_nearby_buy", @"附近购买") action:@selector(clickedOneMoreBTNHandler) borderWidth:1
                                              borderColor:HDAppTheme.color.sa_C666
                                                tintColor:HDAppTheme.color.sa_C666];
        _oneMoreBTN = button;
    }
    return _oneMoreBTN;
}

- (SAOperationButton *)transferBTN {
    if (!_transferBTN) {
        SAOperationButton *button = [self buttonWithStyle:SAOperationButtonStyleHollow title:TNLocalizedString(@"tn_transfer_pay", @"转账付款") action:@selector(clickedTransferBTNHandler)
                                              borderWidth:1
                                              borderColor:HDAppTheme.color.sa_C666
                                                tintColor:HDAppTheme.color.sa_C666];
        _transferBTN = button;
    }
    return _transferBTN;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"icon_oc_arrow"];
        imageView.userInteractionEnabled = true;
        imageView.contentMode = UIViewContentModeCenter;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
        [imageView addGestureRecognizer:recognizer];
        _arrowIV = imageView;
    }
    return _arrowIV;
}

- (NSTimer *)payTimer {
    if (!_payTimer) {
        _payTimer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payTimerInvoked) userInfo:nil repeats:true];
    }
    return _payTimer;
}

- (UIImageView *)storeTypeTag {
    if (!_storeTypeTag) {
        _storeTypeTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_global_k"]];
    }
    return _storeTypeTag;
}

- (UIImageView *)afterSaleTag {
    if (!_afterSaleTag) {
        NSString *imageName = @"order_as_en";
        if (SAMultiLanguageManager.isCurrentLanguageCN)
            imageName = @"order_as_cn";
        if (SAMultiLanguageManager.isCurrentLanguageKH)
            imageName = @"order_as_kh";
        _afterSaleTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    return _afterSaleTag;
}

- (UIButton *)moreFunctionBTN {
    if (!_moreFunctionBTN) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_oc_more"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedMoreFuncBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = true;
        _moreFunctionBTN = button;
    }
    return _moreFunctionBTN;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.minimumInteritemSpacing = 12.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCollectionView)];
        [_collectionView addGestureRecognizer:tap];
    }
    return _collectionView;
}

- (SAOrderListWaitPayView *)waitPayView {
    if (!_waitPayView) {
        _waitPayView = SAOrderListWaitPayView.new;
        _waitPayView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:view.frame.size.height / 2];
        };
        _waitPayView.clipsToBounds = YES;
    }
    return _waitPayView;
}

- (SALabel *)pickUpTag {
    if (!_pickUpTag) {
        _pickUpTag = SALabel.new;
        _pickUpTag.font = HDAppTheme.font.sa_standard12;
        _pickUpTag.textColor = UIColor.whiteColor;
        _pickUpTag.hd_edgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        _pickUpTag.text = WMLocalizedString(@"wm_pickup_Pickup", @"到店自取");
        _pickUpTag.hidden = YES;
        _pickUpTag.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        _pickUpTag.backgroundColor = UIColor.sa_C1;
    }
    return _pickUpTag;
}

- (UILabel *)pickUpCodeTipLabel {
    if (!_pickUpCodeTipLabel) {
        _pickUpCodeTipLabel = UILabel.new;
        _pickUpCodeTipLabel.textColor = UIColor.sa_C999;
        _pickUpCodeTipLabel.font = HDAppTheme.font.sa_standard11;
        _pickUpCodeTipLabel.text = WMLocalizedString(@"wm_pickup_Pickup code", @"取餐码");
    }
    return _pickUpCodeTipLabel;
}

- (UILabel *)pickUpCodeLabel {
    if (!_pickUpCodeLabel) {
        _pickUpCodeLabel = UILabel.new;
        _pickUpCodeLabel.textColor = UIColor.sa_C333;
        _pickUpCodeLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
        _pickUpCodeLabel.text = @"A123";
    }
    return _pickUpCodeLabel;
}

@end


@implementation SAOrderCenterListTableViewCell (Skeleton)
#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth * 0.5);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(15);
        make.top.hd_equalTo(15);
    }];
    HDSkeletonLayer *r1_1 = [[HDSkeletonLayer alloc] init];
    [r1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(40);
        make.height.hd_equalTo(r1.hd_height);
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.top.hd_equalTo(r1.hd_top);
    }];

    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 60;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(r1.hd_bottom).offset(20);
        make.left.hd_equalTo(r1.hd_left);
    }];
    circle.skeletonCornerRadius = iconW * 0.5;

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_right).offset(10);
        make.width.hd_equalTo(kScreenWidth * 0.4);
        make.top.hd_equalTo(circle.hd_top).offset(3);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r2.hd_left);
        make.width.hd_equalTo(kScreenWidth * 0.3);
        make.top.hd_equalTo(r2.hd_bottom + 10);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.width.hd_equalTo(80);
        make.top.hd_equalTo(circle.hd_bottom).offset(15);
        make.height.hd_equalTo(26);
    }];
    r4.cornerRadius = 13;

    return @[r1, r1_1, circle, r2, r3, r4];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 171;
}

@end
