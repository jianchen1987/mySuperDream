//
//  WMStoreCartBottomDock.m
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreCartBottomDock.h"
#import "SAGeneralUtil.h"
#import "SAMoneyModel.h"
#import "WMActionSheetView.h"
#import "WMCustomViewActionView.h"
#import "WMManage.h"
#import "WMNextServiceTimeModel.h"
#import "WMOperationButton.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMSimilarStoresView.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreShoppingCartPromotionInfoView.h"


@interface WMStoreCartBottomDock ()
/// 用于绘制阴影
@property (nonatomic, strong) UIView *shadowView;
/// 阴影图层
@property (nonatomic, strong) CAShapeLayer *shadowLayer;
/// 优惠信息
@property (nonatomic, strong) WMStoreShoppingCartPromotionInfoView *promotionInfo;
/// 是否隐藏优惠信息
@property (nonatomic, assign) BOOL hiddenPromotionInfo;
/// 按钮容器
@property (nonatomic, strong) UIView *buttonContainer;
/// 按钮左部分容器
@property (nonatomic, strong) UIView *buttonLeftContainer;
/// 图片
@property (nonatomic, strong) UIImageView *manIV;
/// 主标题
@property (nonatomic, strong) SALabel *mainTitleLB;
/// 下单按钮
@property (nonatomic, strong) WMOperationButton *orderBTN;
/// 起步价提高视图
@property (nonatomic, strong) UIView *startPriceHighView;
/// 起步价提高文本
@property (nonatomic, strong) SALabel *startPriceHighLB;
/// 起送价
@property (nonatomic, strong) SAMoneyModel *deliveryStartPointPrice;
/// 试算信息
@property (nonatomic, strong) WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel;
/// 门店状态
@property (nonatomic, copy) WMStoreStatus storeStatus;
/// 门店营业时间
@property (nonatomic, copy) NSArray<NSArray<NSString *> *> *businessHours;
/// 设置状态
@property (nonatomic, assign, readonly, getter=isEnabled) BOOL enabled;
/// 下次服务时间
@property (nonatomic, strong) WMNextServiceTimeModel *nextServiceTime;
/// 下次营业时间
@property (nonatomic, copy) NSString *nextBusinessTime;
/// 暂停营业时间
@property (nonatomic, copy) NSString *effectTime;
/// 展示过配送价提高的提醒
@property (nonatomic, assign) BOOL showDelevilyUpTip;
/// 爆单
@property (nonatomic, assign) BOOL fullOrder;
/// storeNo
@property (nonatomic, copy) NSString *storeNo;
@end


@implementation WMStoreCartBottomDock
- (void)hd_setupViews {
    [self addSubview:self.startPriceHighView];
    [self.startPriceHighView addSubview:self.startPriceHighLB];

    [self addSubview:self.promotionInfo];
    [self addSubview:self.shadowView];
    [self addSubview:self.buttonContainer];
    [self.buttonContainer addSubview:self.buttonLeftContainer];
    [self addSubview:self.manIV];
    [self.buttonLeftContainer addSubview:self.mainTitleLB];
    [self.buttonContainer addSubview:self.orderBTN];

    [self adjustContentRender];

    @HDWeakify(self);
    self.shadowView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.shadowLayer) {
            [self.shadowLayer removeFromSuperlayer];
            self.shadowLayer = nil;
        }
        self.shadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5 shadowRadius:3 shadowOpacity:1
                                       shadowColor:[UIColor colorWithRed:52 / 255.0 green:59 / 255.0 blue:77 / 255.0 alpha:0.16].CGColor
                                         fillColor:UIColor.whiteColor.CGColor
                                      shadowOffset:CGSizeMake(0, 3)];
    };
    self.buttonContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
    };
    self.buttonLeftContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        UIRectCorner rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        if (self.orderBTN.isHidden) {
            rectCorner = UIRectCornerAllCorners;
        }
        [view setRoundedCorners:rectCorner radius:precedingFrame.size.height * 0.5];
    };
    self.orderBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        if (precedingFrame.size.width > 0) {
            [view setRoundedCorners:UIRectCornerBottomRight | UIRectCornerTopRight radius:precedingFrame.size.height * 0.5];
        }
    };
}

#pragma mark - event response
- (void)clickedOrderBTNHandler {
    ///爆单弹窗
    if (self.fullOrder) {
        HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
        config.containerMinHeight = kScreenHeight * 0.3;
        config.textAlignment = HDCustomViewActionViewTextAlignmentLeft;
        config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
        config.title = WMLocalizedString(@"wm_store_similar", @"Similar stores near");
        config.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
        config.titleColor = HDAppTheme.WMColor.B3;
        config.style = HDCustomViewActionViewStyleClose;
        config.shouldAddScrollViewContainer = NO;
        config.iPhoneXFillViewBgColor = UIColor.whiteColor;
        config.contentHorizontalEdgeMargin = 0;
        WMSimilarStoresView *reasonView = [[WMSimilarStoresView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.8)];
        reasonView.storeNo = self.storeNo;
        WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:reasonView config:config];
        [actionView show];
        reasonView.clickedConfirmBlock = ^(WMStoreListItemModel *_Nonnull model) {
            [actionView dismiss];
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{@"storeNo": model.storeNo}];
        };
        return;
    }
    if (!self.isEnabled)
        return;
    !self.clickedOrdeNowBlock ?: self.clickedOrdeNowBlock();
}

- (void)clickedStoreCartDockHandler {
    // 只要选择了商品就可以展开购物车
    if (!self.isStoreResting && !HDIsObjectNil(self.payFeeTrialCalRspModel.showPrice)) {
        !self.clickedStoreCartDockBlock ?: self.clickedStoreCartDockBlock();
    }
}

#pragma mark - private methods
- (void)adjustContentRender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self adjustPromotionInfoLabelText];
        [self adjustMainTitleLabelText];
        [self adjustOrderButtonState];
        [self adjustManImage];
        [self setNeedsUpdateConstraints];
    });
}

- (void)adjustPromotionInfoLabelText {
    if (self.hiddenPromotionInfo) {
        return;
    }
    [self.promotionInfo updateUIWithPayFeeTrialCalRspModel:self.payFeeTrialCalRspModel isStoreResting:self.isStoreResting];
}

- (void)adjustMainTitleLabelText {
    if (self.isEnabled) {
        [self adjustStoreCartPriceInfo];
    } else {
        if (self.isStoreResting) {
            ///爆单
            if (self.fullOrder) {
                [self adjustStoreFullOrderContent];
            } else {
                ///暂停配送
                if (self.effectTime) {
                    [self adjustStoreEffectTimeContent];
                } else {
                    // 休息
                    if (self.nextBusinessTime) {
                        [self adjustStoreBuinessRestingContent];
                    } else {
                        if (self.nextServiceTime) {
                            [self adjustStoreRestingContent];
                        } else {
                            [self adjustStoreRestingContentClose];
                        }
                    }
                }
            }
        } else if (HDIsObjectNil(self.payFeeTrialCalRspModel.showPrice)) {
            // 判断有没有选择商品
            self.mainTitleLB.text = WMLocalizedString(@"no_items_added", @"还没有添加商品");
        } else if (!HDIsObjectNil(self.deliveryStartPointPrice)) {
            // 未达到起送价
            [self adjustStoreCartPriceInfo];
        }
    }
}

- (void)adjustOrderButtonState {
    // 判断显示下单还是起送价
    self.orderBTN.hidden = [self.storeStatus isEqualToString:WMStoreStatusResting] || (HDIsObjectNil(self.deliveryStartPointPrice) && HDIsObjectNil(self.payFeeTrialCalRspModel.showPrice));
    if (self.nextBusinessTime || self.effectTime) {
        self.orderBTN.hidden = YES;
    }
    ///爆单
    if (self.fullOrder) {
        self.orderBTN.hidden = NO;
    }
    if (!self.orderBTN.isHidden) {
        if (self.fullOrder) {
            self.orderBTN.userInteractionEnabled = YES;
            [self.orderBTN applyPropertiesWithBackgroundColor:HDAppTheme.WMColor.mainRed];
            [self.orderBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [self.orderBTN setTitle:WMLocalizedString(@"wm_store_similar", @"相似门店") forState:UIControlStateNormal];
            self.orderBTN.titleEdgeInsets = UIEdgeInsetsMake(10, kRealWidth(16), 10, kRealWidth(16));
            self.orderBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
            [self.orderBTN setCornerRadius:self.orderBTN.hd_height / 2.0];
        } else {
            // 如果有起送
            BOOL showStartPointPrice = (!HDIsObjectNil(self.deliveryStartPointPrice) && HDIsObjectNil(self.payFeeTrialCalRspModel.showPrice))
                                       || self.deliveryStartPointPrice.cent.doubleValue > self.payFeeTrialCalRspModel.showPrice.cent.doubleValue;
            self.orderBTN.userInteractionEnabled = !showStartPointPrice;
            if (showStartPointPrice) {
                [self.orderBTN applyPropertiesWithBackgroundColor:UIColor.clearColor];
                [self.orderBTN setTitleColor:HDAppTheme.color.G3 forState:UIControlStateNormal];
                [self.orderBTN setTitle:[NSString stringWithFormat:WMLocalizedString(@"some_money_to_send", @"%@起送"), self.deliveryStartPointPrice.thousandSeparatorAmount]
                               forState:UIControlStateNormal];
            } else {
                [self.orderBTN applyPropertiesWithBackgroundColor:HDAppTheme.WMColor.mainRed];
                [self.orderBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                [self.orderBTN setTitle:WMLocalizedString(@"store_order_now", @"下单") forState:UIControlStateNormal];
            }
        }
    }
}

- (void)adjustStoreCartPriceInfo {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendingStr;
    appendingStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:", WMLocalizedString(@"sub_total", @"小计")]
                                                   attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:12], NSForegroundColorAttributeName: HDAppTheme.WMColor.CCCCCC}];
    [text appendAttributedString:appendingStr];

    if (!HDIsObjectNil(self.payFeeTrialCalRspModel.showPrice)) {
        appendingStr = [[NSAttributedString alloc] initWithString:self.payFeeTrialCalRspModel.showPrice.thousandSeparatorAmount
                                                       attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:16], NSForegroundColorAttributeName: UIColor.whiteColor}];

        [text appendAttributedString:appendingStr];
    }

    // 无优惠不显示原价，优惠价就是原价
    if (!HDIsObjectNil(self.payFeeTrialCalRspModel.linePrice)) {
        // 空格
        NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
        [text appendAttributedString:whiteSpace];

        appendingStr = [[NSAttributedString alloc] initWithString:self.payFeeTrialCalRspModel.linePrice.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:12],
            NSForegroundColorAttributeName: HDAppTheme.WMColor.CCCCCC,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: HDAppTheme.WMColor.CCCCCC
        }];
        [text appendAttributedString:appendingStr];
    }
    self.mainTitleLB.attributedText = text;
}

- (void)adjustStoreRestingContentClose {
    // 取离当前时间最近的下一个将来时间段
    // businessHours，格式 @[@[@"3:00", @"6:00"], @[@"1:00", @"2:00"], @[@"13:00", @"19:00"]]
    // 从早到晚排序
    NSArray<NSArray<NSString *> *> *sortedBusinessHours = [self.businessHours sortedArrayUsingComparator:^NSComparisonResult(NSArray<NSString *> *_Nonnull obj1, NSArray<NSString *> *_Nonnull obj2) {
        // 24 小时制
        NSString *startTime = [obj1.firstObject stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *startTime2 = [obj2.firstObject stringByReplacingOccurrencesOfString:@":" withString:@""];
        return startTime.integerValue > startTime2.integerValue;
    }];

    NSInteger nowTime = [[SAGeneralUtil getCurrentDateStrByFormat:@"HH:mm"] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;

    // 如果所有时间段都没有找到下一个最近时间点，则取下一天最早的营业时间
    NSUInteger descIndex = 0;
    for (NSArray<NSString *> *timeSection in sortedBusinessHours) {
        NSInteger startTime = [timeSection.firstObject stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
        if (startTime > nowTime) {
            descIndex = [sortedBusinessHours indexOfObject:timeSection];
            break;
        }
    }
    if (descIndex >= sortedBusinessHours.count) {
        return;
    }

    NSArray<NSString *> *destSectionTimeArr = [sortedBusinessHours objectAtIndex:descIndex];
    self.mainTitleLB.textColor = UIColor.whiteColor;
    self.mainTitleLB.font = HDAppTheme.font.standard3;
    self.mainTitleLB.text = [NSString stringWithFormat:@"%@,%@:%@",
                                                       WMLocalizedString(@"store_detail_is_closed", @"门店休息中"),
                                                       WMLocalizedString(@"store_detail_business_hours", @"营业时间"),
                                                       [destSectionTimeArr componentsJoinedByString:@"-"]];
}

- (void)adjustStoreBuinessRestingContent {
    if (!self.nextBusinessTime)
        return;
    self.mainTitleLB.textColor = UIColor.whiteColor;
    self.mainTitleLB.font = HDAppTheme.font.standard3;
    self.mainTitleLB.text =
        [NSString stringWithFormat:@"%@，%@：\n%@", WMLocalizedString(@"cart_resting", @"休息中"), WMLocalizedString(@"store_detail_business_hours", @"营业时间"), self.nextBusinessTime];
    self.mainTitleLB.textAlignment = NSTextAlignmentCenter;
}

- (void)adjustStoreEffectTimeContent {
    if (!self.effectTime)
        return;
    self.mainTitleLB.textColor = UIColor.whiteColor;
    self.mainTitleLB.font = HDAppTheme.font.standard3;
    self.mainTitleLB.text = [NSString stringWithFormat:@"%@：%@", WMLocalizedString(@"wm_pause", @"暂停配送时间"), self.effectTime];
    self.mainTitleLB.textAlignment = NSTextAlignmentCenter;
}

- (void)adjustStoreRestingContent {
    if (!self.nextServiceTime)
        return;
    self.mainTitleLB.textColor = UIColor.whiteColor;
    self.mainTitleLB.font = HDAppTheme.font.standard3;
    self.mainTitleLB.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                                       WMLocalizedString(@"store_detail_is_closed", @"门店休息中"),
                                                       WMLocalizedString(@"store_detail_business_hours", @"营业时间"),
                                                       self.nextServiceTime.weekday.message ? WMManage.shareInstance.weekInfo[self.nextServiceTime.weekday.code] : @"",
                                                       self.nextServiceTime.time ?: @""];
}

- (void)adjustStoreFullOrderContent {
    if (!self.fullOrder)
        return;
    self.mainTitleLB.textColor = UIColor.whiteColor;
    self.mainTitleLB.font = HDAppTheme.font.standard3;
    self.mainTitleLB.text = WMLocalizedString(@"wm_store_busy_to_select", @"门店繁忙·不可下单");
    self.mainTitleLB.textAlignment = NSTextAlignmentCenter;
}

- (void)adjustManImage {
    // 只要选择了商品就显示正常的图片
    if (!HDIsObjectNil(self.payFeeTrialCalRspModel.showPrice) && !self.isStoreResting) {
        self.manIV.image = [UIImage imageNamed:@"store_info_man"];
    } else {
        self.manIV.image = [UIImage imageNamed:@"store_info_man_gray"];
    }
}

#pragma mark - public methods
- (void)updateUIWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel {
    self.payFeeTrialCalRspModel = payFeeTrialCalRspModel;
    self.startPriceHighView.hidden = YES;
    [self adjustContentRender];
}

- (void)setDeliveryStartPointPrice:(SAMoneyModel *_Nullable)startPointPrice startPointPriceDiff:(NSString *)startPointPriceDiff {
    _deliveryStartPointPrice = startPointPrice;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.startPriceHighView.hidden = !startPointPriceDiff || ([startPointPriceDiff isKindOfClass:NSString.class] && !startPointPriceDiff.length);
        ///已经展示过了 触发操作不展示
        if (!self.startPriceHighView.hidden) {
            if (self.showDelevilyUpTip) {
                self.startPriceHighView.hidden = YES;
            } else {
                self.showDelevilyUpTip = YES;
            }
        }
        self.startPriceHighLB.text = WMFillEmpty(startPointPriceDiff);
        [self adjustContentRender];
    });
}

- (void)emptyPriceInfo {
    self.payFeeTrialCalRspModel = nil;

    [self adjustContentRender];
}

- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status businessHours:(NSArray<NSArray<NSString *> *> *)businessHours {
    self.storeStatus = status;
    self.businessHours = businessHours;
    [self adjustContentRender];
}

- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status nextServiceTimeModel:(WMNextServiceTimeModel *)serviceTimeModel {
    self.storeStatus = status;
    self.nextServiceTime = serviceTimeModel;
    [self adjustContentRender];
}

- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status nextBuinessTimeModel:(NSString *)buinessTime {
    self.storeStatus = status;
    self.nextBusinessTime = buinessTime;
    [self adjustContentRender];
}

- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status effectTimeTimeModel:(NSString *)effectTime {
    self.storeStatus = status;
    self.effectTime = effectTime;
    [self adjustContentRender];
}

- (void)setFullOrderState:(WMStoreFullOrderState)state storeNo:(NSString *)storeNo {
    self.fullOrder = (state == WMStoreFullOrderStateFullAndStop);
    self.storeNo = storeNo;
    [self adjustContentRender];
}

- (void)showPromotionInfo {
    self.hiddenPromotionInfo = NO;
    [self adjustPromotionInfoLabelText];
    [self setNeedsUpdateConstraints];
}

- (void)dismissPromotionInfo {
    self.promotionInfo.hidden = self.hiddenPromotionInfo = YES;
    [self setNeedsUpdateConstraints];
    [self.superview layoutIfNeeded];
}

- (void)setOrderButtonUnClick {
    self.orderBTN.userInteractionEnabled = false;
}

#pragma mark - getter
- (BOOL)isEnabled {
    if (self.isStoreResting) {
        return false;
    }
    if (HDIsObjectNil(self.payFeeTrialCalRspModel.showPrice)) {
        return false;
    }
    if (!HDIsObjectNil(self.deliveryStartPointPrice)) {
        // 比较最后优惠金额是否达到起送价
        return self.payFeeTrialCalRspModel.showPrice.cent.doubleValue >= self.deliveryStartPointPrice.cent.doubleValue;
    }
    return true;
}

- (BOOL)isStoreResting {
    if (self.nextServiceTime || [self.storeStatus isEqualToString:WMStoreStatusResting] || self.nextBusinessTime || self.effectTime || self.fullOrder)
        return YES;
    return NO;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.startPriceHighLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.startPriceHighView.isHidden) {
            make.edges.mas_equalTo(0);
        }
    }];

    [self.startPriceHighView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.startPriceHighView.isHidden) {
            make.left.right.equalTo(self.buttonContainer);
            make.bottom.equalTo(self.buttonContainer.mas_top).offset(kRealWidth(22));
        }
    }];

    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.buttonLeftContainer);
    }];
    [self.buttonLeftContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.buttonContainer);
        if (self.orderBTN.isHidden) {
            make.right.equalTo(self);
        } else {
            make.right.equalTo(self.orderBTN.mas_left);
        }
    }];
    [self.manIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.effectTime || self.fullOrder) {
            make.left.equalTo(self.buttonContainer).offset(0);
            make.width.mas_equalTo(0);
        } else {
            make.left.equalTo(self.buttonContainer).offset(kRealWidth(12));
            make.width.equalTo(self.manIV.mas_height).multipliedBy(138 / 128.0);
        }
        make.bottom.equalTo(self.buttonContainer);
        make.height.equalTo(self.buttonContainer).offset(kRealWidth(18));
        if (self.promotionInfo.isHidden) {
            make.top.equalTo(self);
        }
    }];
    [self.mainTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.manIV.mas_right).offset(kRealWidth(5));
        make.bottom.equalTo(self.buttonLeftContainer).offset(-kRealWidth(12));
        make.centerY.equalTo(self.buttonLeftContainer);
        make.right.equalTo(self.buttonLeftContainer).offset(-kRealWidth(5));
    }];
    [self.orderBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.orderBTN.isHidden) {
            make.width.mas_greaterThanOrEqualTo([self.orderBTN sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width);
            make.width.greaterThanOrEqualTo(self.orderBTN.mas_height);
            make.width.mas_greaterThanOrEqualTo(kRealWidth(66));
            make.height.centerY.equalTo(self.buttonLeftContainer);
            make.right.equalTo(self);
        }
    }];
    [self.promotionInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.promotionInfo.isHidden) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.top.equalTo(self.buttonContainer.mas_top).offset(-kRealWidth(30));
            make.bottom.equalTo(self.buttonContainer.mas_centerY);
        }
    }];
    [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buttonContainer);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = UIView.new;
    }
    return _shadowView;
}

- (UIImageView *)manIV {
    if (!_manIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"store_info_man_gray"];
        _manIV = imageView;
    }
    return _manIV;
}

- (SALabel *)mainTitleLB {
    if (!_mainTitleLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 2;
        label.textColor = UIColor.whiteColor;
        label.font = HDAppTheme.font.standard4;
        label.text = WMLocalizedString(@"no_items_added", @"还没有添加商品");
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _mainTitleLB = label;
    }
    return _mainTitleLB;
}

- (UIView *)buttonContainer {
    if (!_buttonContainer) {
        _buttonContainer = UIView.new;
        _buttonContainer.backgroundColor = HDAppTheme.color.G1;
    }
    return _buttonContainer;
}

- (UIView *)buttonLeftContainer {
    if (!_buttonLeftContainer) {
        _buttonLeftContainer = UIView.new;
        _buttonLeftContainer.backgroundColor = HDAppTheme.color.G1;
        [_buttonLeftContainer setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreCartDockHandler)];
        [_buttonLeftContainer addGestureRecognizer:recognizer];
    }
    return _buttonLeftContainer;
}

- (WMOperationButton *)orderBTN {
    if (!_orderBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleSolid];
        button.cornerRadius = 0;
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"store_order_now", @"下单") forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(12, 10, 12, 12);
        [button addTarget:self action:@selector(clickedOrderBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        button.hidden = true;
        _orderBTN = button;
    }
    return _orderBTN;
}

- (WMStoreShoppingCartPromotionInfoView *)promotionInfo {
    if (!_promotionInfo) {
        _promotionInfo = WMStoreShoppingCartPromotionInfoView.new;
    }
    return _promotionInfo;
}

- (UIView *)startPriceHighView {
    if (!_startPriceHighView) {
        _startPriceHighView = UIView.new;
        _startPriceHighView.hidden = YES;
        _startPriceHighView.backgroundColor = HDAppTheme.WMColor.FDF8E5;
        [_startPriceHighView setHd_frameDidChangeBlock:^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kRealWidth(10), kRealWidth(10))];
        }];
    }
    return _startPriceHighView;
}

- (SALabel *)startPriceHighLB {
    if (!_startPriceHighLB) {
        _startPriceHighLB = SALabel.new;
        _startPriceHighLB.textAlignment = NSTextAlignmentCenter;
        _startPriceHighLB.numberOfLines = 0;
        _startPriceHighLB.textColor = HDAppTheme.WMColor.mainRed;
        _startPriceHighLB.font = [HDAppTheme.WMFont wm_ForSize:12];
        _startPriceHighLB.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(8.5), kRealWidth(5), kRealWidth(30.5), kRealWidth(5));
    }
    return _startPriceHighLB;
}

@end
