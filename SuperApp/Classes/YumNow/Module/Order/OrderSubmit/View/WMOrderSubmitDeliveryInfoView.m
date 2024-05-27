//
//  WMOrderSubmitDeliveryInfoView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitDeliveryInfoView.h"
#import "NSDate+SAExtension.h"
#import "SAAppSwitchManager.h"
#import "SAAvailablePaymentMethodViewController.h"
#import "SACacheManager.h"
#import "SAChoosePaymentMethodPresenter.h"
#import "SACompleteAddressTipsView.h"
#import "SAGeneralUtil.h"
#import "SAGoodsModel.h"
#import "SAInfoView.h"
#import "SAQueryAvaliableChannelRspModel.h"
#import "SAShadowBackgroundView.h"
#import "SAShoppingAddressModel.h"
#import "WMCustomViewActionView.h"
#import "WMHorizontalTreeView.h"
#import "WMOrderSubmitAggregationRspModel.h"
#import "WMOrderSubmitPayFeeTrialCalRspModel.h"
#import "WMOrderSubmitV2ViewModel.h"
#import "WMPayMarketingView.h"
#import "WMPromotionLabel.h"
#import "WMQueryOrderInfoRspModel.h"
#import "WMShoppingCartStoreProduct.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "SAWindowManager.h"


@interface WMOrderSubmitDeliveryInfoView ()
/// 当前选择的地址
@property (nonatomic, strong) SAShoppingAddressModel *addressModel;
/// 地址背景视图
@property (nonatomic, strong) UIView *addressBgView;
/// icon
@property (nonatomic, strong) UIImageView *addressIconIV;
/// 地址
@property (nonatomic, strong) SALabel *deliveryAddressLB;
/// 收货人信息
@property (nonatomic, strong) SALabel *receiverInfoLB;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;
///地址底部横线
@property (nonatomic, strong) UIView *addressLine;
/// 配送时间付款方式背景视图
@property (nonatomic, strong) UIView *timeAndpayMethodBgView;
/// 配送时间
@property (nonatomic, strong) SAInfoView *deliveryTimeView;
/// 付款方式
@property (nonatomic, strong) SAInfoView *paymentMethodView;
///< 支付营销信息
@property (nonatomic, strong) WMPayMarketingView *marketingInfoView;
/// 聚合服务返回的模型
@property (nonatomic, strong) WMOrderSubmitAggregationRspModel *orderPreSubmitRspModel;
/// 配送时间数据源
@property (nonatomic, strong) NSMutableArray<WMStoreFilterTableViewCellModel *> *deliveryTimeDataSource;
/// 配送时间
@property (nonatomic, strong) WMOrderSubscribeTimeModel *subscribeTimeModel;
/// 完善地址提示
@property (nonatomic, strong) SACompleteAddressTipsView *tipsView;
///< viewModel
@property (nonatomic, strong) WMOrderSubmitV2ViewModel *viewModel;
///< viewModel
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *firstTempSelectTimeModel;
///< viewModel
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *firstSelectTimeModel;
///< viewModel
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *secondSelectTimeModel;

@end


@implementation WMOrderSubmitDeliveryInfoView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.addressBgView];
    [self.addressBgView addSubview:self.addressIconIV];
    [self.addressBgView addSubview:self.deliveryAddressLB];
    [self.addressBgView addSubview:self.receiverInfoLB];
    [self.addressBgView addSubview:self.arrowIV];
    [self.addressBgView addSubview:self.addressLine];

    [self addSubview:self.timeAndpayMethodBgView];
    [self.timeAndpayMethodBgView addSubview:self.deliveryTimeView];
    [self.timeAndpayMethodBgView addSubview:self.paymentMethodView];
    [self.timeAndpayMethodBgView addSubview:self.marketingInfoView];

    [self addSubview:self.tipsView];
}

#pragma mark - event response
- (void)clickedChooseAddressHander {
    !self.chooseAddressBlock ?: self.chooseAddressBlock();
}

#pragma mark - public methods
- (void)updateUIWithAddressModel:(SAShoppingAddressModel *)addressModel {
    self.addressModel = addressModel;

    NSString *address = addressModel.address;
    NSString *consigneeAddress = addressModel.consigneeAddress;
    NSString *consigneeName = addressModel.consigneeName;
    NSString *mobile = addressModel.mobile;

    NSString *addressStr = address.copy;
    if (HDIsStringNotEmpty(consigneeAddress)) {
        addressStr = [addressStr stringByAppendingString:consigneeAddress];
    }
    self.deliveryAddressLB.text = addressStr ? addressStr : WMLocalizedString(@"delivery_to", @"配送到");
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    [paragraphStyle setLineSpacing:kRealWidth(4)];

    self.deliveryAddressLB.attributedText = [[NSMutableAttributedString alloc] initWithString:self.deliveryAddressLB.text attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    [self.deliveryAddressLB sizeToFit];

    NSString *receiverInfoStr = @"";
    if (HDIsStringNotEmpty(consigneeName) || HDIsStringNotEmpty(mobile)) {
        if (HDIsStringNotEmpty(consigneeName)) {
            receiverInfoStr = [receiverInfoStr stringByAppendingString:consigneeName];
        }
        if (HDIsStringNotEmpty(mobile)) {
            receiverInfoStr = [receiverInfoStr stringByAppendingString:[NSString stringWithFormat:@",%@", mobile]];
        }
    } else {
        receiverInfoStr = WMLocalizedString(@"order_sumit_choose_address", @"请选择收货地址");
    }
    self.receiverInfoLB.text = receiverInfoStr;

    self.receiverInfoLB.attributedText = [[NSMutableAttributedString alloc] initWithString:self.receiverInfoLB.text attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    self.tipsView.hidden = ![addressModel isNeedCompleteAddressInClientType:SAClientTypeYumNow];
    [self setNeedsUpdateConstraints];
}

- (void)updateUIWithOrderPreSubmitRspModel:(WMOrderSubmitAggregationRspModel *)aggregationRspModel userHasRisk:(BOOL)userHasRisk {
    self.orderPreSubmitRspModel = aggregationRspModel;

    // 异步处理数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [self generateDeliveryTimeDataSource];
        }
    });

    self.deliveryTimeView.hidden = HDIsArrayEmpty(aggregationRspModel.storeInfo.availableTime);
    if (!self.deliveryTimeView.isHidden && HDIsObjectNil(self.subscribeTimeModel)) {
        // 默认选中立即送出的时间
        NSArray<WMOrderSubscribeTimeModel *> *rightNowDeliveryTimeArray = [aggregationRspModel.storeInfo.availableTime hd_filterWithBlock:^BOOL(WMOrderSubscribeTimeModel *_Nonnull item) {
            return [item.type isEqualToString:WMOrderDeliveryTimeTypeRightNow];
        }];
        if (HDIsArrayEmpty((rightNowDeliveryTimeArray))) {
            rightNowDeliveryTimeArray = [aggregationRspModel.storeInfo.availableTime hd_filterWithBlock:^BOOL(WMOrderSubscribeTimeModel *_Nonnull item) {
                return ![item.type isEqualToString:WMOrderDeliveryTimeTypeRightNow];
            }];
        }
        if (!HDIsArrayEmpty(rightNowDeliveryTimeArray)) {
            WMOrderSubscribeTimeModel *rightNowTimeModel = rightNowDeliveryTimeArray.firstObject;
            // 用立即送出的时间填充
            [self adjustDeliveryTimeValueWithDeliveryTimeModel:rightNowTimeModel];
        }
    }
    ///风控
    if ([aggregationRspModel.storeInfo.paymentMethods containsObject:HDSupportedPaymentMethodCashOnDelivery] && userHasRisk) {
        NSMutableArray *marr = [NSMutableArray arrayWithArray:aggregationRspModel.storeInfo.paymentMethods];
        [marr removeObject:HDSupportedPaymentMethodCashOnDelivery];
        aggregationRspModel.storeInfo.paymentMethods = [NSArray arrayWithArray:marr];
    }
    self.paymentMethodView.hidden = HDIsArrayEmpty(aggregationRspModel.storeInfo.paymentMethods);
    if (!self.paymentMethodView.isHidden) {
        // 判断支付方式是否只有一种，如果只有一种，自动填充
        void (^adjustShouldAutoFillPaymentMethodBlock)(void) = ^(void) {
            if (aggregationRspModel.storeInfo.paymentMethods.count == 1 && [aggregationRspModel.storeInfo.paymentMethods.firstObject isEqualToString:WMOrderAvailablePaymentTypeOffline]) {
                [self adjustPaymemntMethodValueWithPaymentType:[HDPaymentMethodType cashOnDelivery] discountAmount:nil];
            }

            [self setNeedsUpdateConstraints];
        };

        // 只有一种支付方式,且为线下付款 不显示箭头
        if ((aggregationRspModel.storeInfo.paymentMethods.count == 1 && [aggregationRspModel.storeInfo.paymentMethods.firstObject isEqualToString:WMOrderAvailablePaymentTypeOnline])
            || aggregationRspModel.storeInfo.paymentMethods.count > 1) {
            self.paymentMethodView.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        } else {
            self.paymentMethodView.model.rightButtonImage = nil;
        }

        if ([aggregationRspModel.storeInfo.paymentMethods containsObject:HDSupportedPaymentMethodOnline]) {
            // 支持在线支付，再查公告
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                @autoreleasepool {
                    [self generatePaymentActivitys];
                }
            });

        } else {
            self.marketingInfoView.hidden = YES;
        }

        // 获取上次选择支付方式
        HDPaymentMethodType *lastChooseMethod = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserLastTimeChoosedPaymentMethod type:SACacheTypeDocumentNotPublic];
        if (!HDIsObjectNil(lastChooseMethod)) {
            // 选择过，判断上次选择的支付方式否可用
            if ([aggregationRspModel.storeInfo.paymentMethods containsObject:WMOrderAvailablePaymentTypeOffline] && (lastChooseMethod.method == SAOrderPaymentTypeCashOnDelivery)) {
                // 如果可用的支付方式包含货到付款且上次选的是货到付款，直接设置
                [self adjustPaymemntMethodValueWithPaymentType:lastChooseMethod discountAmount:nil];
            } else if ([aggregationRspModel.storeInfo.paymentMethods containsObject:WMOrderAvailablePaymentTypeOnline]) {
                // 如果可用的支付方式包含在线支付，且上次选择的是在线支付，判断上次选的支付工具是否可用
                @HDWeakify(self);
                [SAChoosePaymentMethodPresenter trialWithPayableAmount:self.viewModel.aggregationRspModel.trial.totalTrialPrice businessLine:SAClientTypeYumNow
                                               supportedPaymentMethods:aggregationRspModel.storeInfo.paymentMethods
                                                            merchantNo:self.viewModel.aggregationRspModel.wmTrial.merchantNo
                                                               storeNo:self.viewModel.aggregationRspModel.wmTrial.storeNo
                                                                 goods:@[]
                                                 selectedPaymentMethod:lastChooseMethod completion:^(BOOL available, NSString *_Nullable ruleNo, SAMoneyModel *_Nullable discountAmount) {
                                                     @HDStrongify(self);
                                                     if (available) {
                                                         self.viewModel.paymentDiscountAmount = discountAmount;
                                                         lastChooseMethod.ruleNo = ruleNo;
                                                         [self adjustPaymemntMethodValueWithPaymentType:lastChooseMethod discountAmount:discountAmount];
                                                     } else {
                                                         self.viewModel.paymentDiscountAmount = nil;
                                                         adjustShouldAutoFillPaymentMethodBlock();
                                                     }
                                                 }];

            } else {
                adjustShouldAutoFillPaymentMethodBlock();
            }
        } else {
            adjustShouldAutoFillPaymentMethodBlock();
        }
    }
    [self setNeedsUpdateConstraints];
}

- (HDPaymentMethodType *)paymentType {
    return (HDPaymentMethodType *)self.paymentMethodView.model.associatedObject;
}

#pragma mark - private methods
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    model.keyColor = HDAppTheme.WMColor.B3;
    model.backgroundColor = UIColor.whiteColor;
    model.valueColor = HDAppTheme.WMColor.B3;
    model.keyText = key;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:14];
    model.rightButtonContentEdgeInsets = UIEdgeInsetsZero;
    model.rightButtonImageEdgeInsets = UIEdgeInsetsZero;
    return model;
}

- (void)adjustShowChooseOrderDeliveryTimeView {
    const CGFloat width = kScreenWidth;
    WMHorizontalTreeView *view = [[WMHorizontalTreeView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    view.dataSource = self.deliveryTimeDataSource;
    view.cellHeight = kRealWidth(44);
    view.minHeight = kScreenHeight * 0.4;
    view.maxHeight = kScreenHeight * 0.8;

    [view layoutyImmediately];
    WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.title = WMLocalizedString(@"sort_delivery_time", @"选择配送时间");
        config.shouldAddScrollViewContainer = false;
        config.contentHorizontalEdgeMargin = 0;
    }];

    @HDWeakify(actionView);
    @HDWeakify(self);
    view.didSelectMainTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
        @HDStrongify(self);
        self.firstTempSelectTimeModel = model;
    };
    view.didSelectSubTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellBaseModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
        @HDStrongify(self);
        @HDStrongify(actionView);
        self.firstSelectTimeModel = self.firstTempSelectTimeModel;
        self.secondSelectTimeModel = model;
        [self adjustDeliveryTimeValueWithDeliveryTimeModel:model.associatedParamsModel];
        [actionView dismiss];
    };
    [actionView show];
}

/// 点击选择支付方式view
- (void)adjustShowChoosePaymentMethodView {
    if (self.orderPreSubmitRspModel.storeInfo.paymentMethods.count < 1) {
        return;
    } else if (self.orderPreSubmitRspModel.storeInfo.paymentMethods.count == 1
               && ![self.orderPreSubmitRspModel.storeInfo.paymentMethods.firstObject isEqualToString:WMOrderAvailablePaymentTypeOnline]) {
        return;
    }

    @HDWeakify(self);
    NSMutableArray *paymentMethods = self.orderPreSubmitRspModel.storeInfo.paymentMethods.mutableCopy;
    if (paymentMethods.count > 0 && ![paymentMethods containsObject:HDSupportedPaymentMethodCashOnDelivery]) {
        if (self.viewModel.serviceType == 20) {
            [paymentMethods addObject:HDSupportedPaymentMethodCashOnDeliveryForbiddenByToStore];
        } else {
            [paymentMethods addObject:HDSupportedPaymentMethodCashOnDeliveryForbidden];
        }
    }
    [SAChoosePaymentMethodPresenter showPreChoosePaymentMethodViewWithPayableAmount:self.orderPreSubmitRspModel.trial.totalTrialPrice businessLine:SAClientTypeYumNow
                                                            supportedPaymentMethods:paymentMethods
                                                                         merchantNo:self.orderPreSubmitRspModel.wmTrial.merchantNo
                                                                            storeNo:self.orderPreSubmitRspModel.wmTrial.storeNo
                                                                              goods:@[]
                                                              selectedPaymentMethod:self.paymentMethodView.model.associatedObject
                                                         choosedPaymentMethodHander:^(HDPaymentMethodType *_Nonnull paymentMethod, SAMoneyModel *_Nullable paymentDiscountAmount) {
                                                             @HDStrongify(self);
                                                             // 保存用户选择的支付方式
                                                             [SACacheManager.shared setObject:paymentMethod forKey:kCacheKeyYumNowUserLastTimeChoosedPaymentMethod type:SACacheTypeDocumentNotPublic];

                                                             [self adjustPaymemntMethodValueWithPaymentType:paymentMethod discountAmount:paymentDiscountAmount];
                                                             self.viewModel.paymentDiscountAmount = paymentDiscountAmount;
                                                         }];
}

- (void)adjustPaymemntMethodValueWithPaymentType:(HDPaymentMethodType *_Nullable)paymentMethod discountAmount:(SAMoneyModel * _Nullable)discountAmount {
    self.paymentMethodView.hidden = HDIsObjectNil(paymentMethod);
    if (!self.paymentMethodView.isHidden) {
        self.paymentMethodView.model.associatedObject = paymentMethod;
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:paymentMethod.toolName attributes:@{
            NSForegroundColorAttributeName : HDAppTheme.WMColor.B3, NSFontAttributeName : HDAppTheme.font.standard3
        }];
        if(!HDIsObjectNil(discountAmount) && ![discountAmount isZero]) {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"-%@", [discountAmount thousandSeparatorAmount]] attributes:@{
                NSForegroundColorAttributeName : HDAppTheme.color.C1, NSFontAttributeName : HDAppTheme.font.standard3Bold
            }]];
        }
        
        self.paymentMethodView.model.attrValue = attStr;
        
        [self.paymentMethodView setNeedsUpdateContent];
    }
    [self setNeedsUpdateConstraints];
}

- (void)adjustDeliveryTimeValueWithDeliveryTimeModel:(WMOrderSubscribeTimeModel *)subscribeTimeModel {
    self.subscribeTimeModel = subscribeTimeModel;
    !self.choosedDeliveryTimeBlock ?: self.choosedDeliveryTimeBlock(subscribeTimeModel);

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:subscribeTimeModel.date.integerValue / 1000.0];
    NSString *timeStr;
    if ([date sa_isToday]) {
        timeStr = [SAGeneralUtil getDateStrWithTimeInterval:subscribeTimeModel.date.integerValue / 1000.0 format:@"HH:mm"];
    } else {
        timeStr = [SAGeneralUtil getDateStrWithTimeInterval:subscribeTimeModel.date.integerValue / 1000.0 format:@"dd/MM HH:mm"];
    }
    NSString *value = [NSString stringWithFormat:WMLocalizedString(@"order_about", @"预计 %@"), timeStr];
    if ([subscribeTimeModel.type isEqualToString:WMOrderDeliveryTimeTypeRightNow]) {
        value = WMLocalizedString(@"quickly_delivery", @"尽快送达");
    }
    self.deliveryTimeView.model.valueText = value;
    [self.deliveryTimeView setNeedsUpdateContent];
}

- (void)generatePaymentActivitys {
    NSArray<SAGoodsModel *> *goods = [self.orderPreSubmitRspModel.storeShoppingCart mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
        SAGoodsModel *goods = SAGoodsModel.new;
        goods.goodsId = obj.goodsId;
        goods.snapshotId = obj.inEffectVersionId;
        goods.skuId = obj.goodsSkuId;
        goods.propertys = [obj.propertyArray copy];
        return goods;
    }];

    @HDWeakify(self);
    [SAChoosePaymentMethodPresenter queryAvailablePaymentActivityAnnouncementWithMerchantNo:self.orderPreSubmitRspModel.wmTrial.merchantNo storeNo:self.orderPreSubmitRspModel.wmTrial.storeNo
        businessLine:SAClientTypeYumNow
        goods:goods
        payableAmount:self.orderPreSubmitRspModel.trial.payableMoney success:^(NSArray<NSString *> *_Nonnull activitys) {
            @HDStrongify(self);
            self.marketingInfoView.hidden = HDIsArrayEmpty(activitys);
            self.marketingInfoView.marketingInfo = activitys;
            if (self.marketingInfoView.isHidden) {
                self.paymentMethodView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
            } else {
                self.paymentMethodView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(4), kRealWidth(15));
            }
            [self.paymentMethodView setNeedsUpdateContent];
            [self setNeedsUpdateConstraints];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.marketingInfoView.hidden = YES;
            [self setNeedsUpdateConstraints];
        }];
}

- (void)generateDeliveryTimeDataSource {
    NSArray<WMOrderSubscribeTimeModel *> *availableTimeList = self.orderPreSubmitRspModel.storeInfo.availableTime;
    NSMutableArray<WMOrderSubscribeTimeModel *> *dataSource = availableTimeList.mutableCopy;
    // 先把原始数据排序
    [dataSource sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(WMOrderSubscribeTimeModel *_Nonnull obj1, WMOrderSubscribeTimeModel *_Nonnull obj2) {
        return [obj1.date compare:obj2.date] == NSOrderedDescending;
    }];

    // 获取所有时间值
    NSArray<NSDate *> *dateArray = [[dataSource valueForKey:@"date"] mapObjectsUsingBlock:^NSDate *_Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:obj.integerValue / 1000.0];
        return date;
    }];

    // 按日期去重
    NSMutableDictionary<NSString *, NSDate *> *tmpDict = [NSMutableDictionary dictionary];
    for (NSDate *date in dateArray) {
        NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy"];
        [tmpDict setObject:date forKey:dateStr];
    }

    // 移除原来的数据
    [self.deliveryTimeDataSource removeAllObjects];

    // 日期排序
    NSArray<NSDate *> *filterDateArray = [tmpDict.allValues sortedArrayUsingComparator:^NSComparisonResult(NSDate *_Nonnull obj1, NSDate *_Nonnull obj2) {
        return obj1.timeIntervalSince1970 > obj2.timeIntervalSince1970;
    }];

    [filterDateArray enumerateObjectsUsingBlock:^(NSDate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray<WMOrderSubscribeTimeModel *> *array = [dataSource hd_filterWithBlock:^BOOL(WMOrderSubscribeTimeModel *_Nonnull item) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:item.date.integerValue / 1000.0];
            return [date sa_isSameDay:obj];
        }];

        NSString *dayStr = [obj sa_isToday] ? WMLocalizedString(@"today", @"今天") : [SAGeneralUtil getDayStringWithDate:obj];
        NSString *monthDayStr = [SAGeneralUtil getDateStrWithDate:obj format:@"dd/MM"];

        NSString *title = [NSString stringWithFormat:@"%@(%@)", dayStr, monthDayStr];

        NSRange dayRange = [title rangeOfString:dayStr];
        NSMutableAttributedString *attStr =
            [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11], NSForegroundColorAttributeName: HDAppTheme.WMColor.B9}];
        [attStr addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14], NSForegroundColorAttributeName: HDAppTheme.WMColor.B6} range:dayRange];

        NSMutableAttributedString *attSelwctStr =
            [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11], NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed}];
        [attSelwctStr addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium], NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed} range:dayRange];

        __block WMStoreFilterTableViewCellModel *rightModel = nil;
        NSArray<WMStoreFilterTableViewCellModel *> *subArrList = [array mapObjectsUsingBlock:^id _Nonnull(WMOrderSubscribeTimeModel *_Nonnull obj, NSUInteger idx) {
            NSString *hourStr = [SAGeneralUtil getDateStrWithTimeInterval:obj.date.integerValue / 1000.0 format:@"HH:mm"];
            NSString *subTitle = [NSString stringWithFormat:WMLocalizedString(@"order_about", @"大概 %@"), hourStr];
            if ([obj.type isEqualToString:WMOrderDeliveryTimeTypeRightNow]) {
                subTitle = WMLocalizedString(@"quickly_delivery", @"尽快送达");
            }

            NSMutableAttributedString *subAttStr =
                [[NSMutableAttributedString alloc] initWithString:subTitle attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:12], NSForegroundColorAttributeName: HDAppTheme.WMColor.B9}];
            NSRange timeRange = [subTitle rangeOfString:hourStr];
            NSRange SAPARange = [subTitle rangeOfString:WMLocalizedString(@"order_ASAP", @"ASAP")];
            NSDictionary *timeAndSAPAAtt = @{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3};
            [subAttStr addAttributes:timeAndSAPAAtt range:timeRange];
            [subAttStr addAttributes:timeAndSAPAAtt range:SAPARange];

            NSAttributedString *selectedTitle =
                [[NSAttributedString alloc] initWithString:subTitle attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14], NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed}];

            WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithAttributedTitle:subAttStr selectedAttributedTitle:selectedTitle associatedParamsModel:obj];
            model.canSelect = YES;
            model.unShowNormal = YES;
            if ([obj.type isEqualToString:WMOrderDeliveryTimeTypeRightNow]) {
                model.selected = true;
                rightModel = model;
            }

            //            if(self.firstSelectTimeModel &&
            //               self.secondSelectTimeModel &&
            //               [obj.date isEqualToString:[self.secondSelectTimeModel.associatedParamsModel valueForKey:@"date"]]){
            //                model.selected = YES;
            //                if(rightModel.selected){
            //                    rightModel.selected = NO;
            //                }
            //            }
            return model;
        }];

        WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithAttributedTitle:attStr selectedAttributedTitle:attSelwctStr associatedParamsModel:title];
        //        if(self.firstSelectTimeModel && [title isEqualToString:self.firstSelectTimeModel.associatedParamsModel]){
        //            model.selected = YES;
        //        }

        model.subArrList = subArrList;
        //        if(!self.firstSelectTimeModel){
        //            self.firstSelectTimeModel = subArrList.firstObject;
        //        }
        [self.deliveryTimeDataSource addObject:model];
    }];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.addressBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    [self.addressIconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.addressIconIV.image.size);
        make.left.equalTo(self.addressBgView).offset(kRealWidth(15));
        make.top.equalTo(self.addressBgView.mas_top).offset(kRealWidth(17));
    }];

    [self.deliveryAddressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowIV.mas_left).offset(-kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
        make.top.equalTo(self.addressIconIV).offset(-kRealWidth(5));
        make.left.equalTo(self.addressIconIV.mas_right).offset(kRealWidth(5));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(kRealWidth(24));
        make.right.equalTo(self.addressBgView).offset(-kRealWidth(15));
        make.centerY.equalTo(self.addressBgView);
    }];
    [self.receiverInfoLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deliveryAddressLB.mas_bottom).offset(kRealWidth(2));
        make.left.right.equalTo(self.deliveryAddressLB);
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.addressLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(-kRealWidth(15));
    }];

    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipsView.isHidden) {
            make.left.equalTo(self).offset(kRealWidth(15));
            make.top.equalTo(self.addressBgView.mas_bottom).offset(kRealWidth(8));
            make.centerX.equalTo(self);
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.timeAndpayMethodBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.timeAndpayMethodBgView.isHidden) {
            make.left.right.equalTo(self.addressBgView);
            make.bottom.mas_lessThanOrEqualTo(0);
            if (self.tipsView.isHidden) {
                make.top.equalTo(self.addressBgView.mas_bottom);
            } else {
                make.top.equalTo(self.tipsView.mas_bottom);
            }
        }
    }];

    __block UIView *lastView = nil;
    [self.deliveryTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryTimeView.isHidden) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            lastView = self.deliveryTimeView;
        }
    }];

    [self.paymentMethodView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.paymentMethodView.isHidden) {
            make.left.right.mas_equalTo(0);
            if (!lastView) {
                make.top.mas_equalTo(0);
            } else {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(8));
            }
            make.bottom.mas_lessThanOrEqualTo(0);
            lastView = self.paymentMethodView;
        }
    }];

    [self.marketingInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.marketingInfoView.isHidden) {
            make.left.right.mas_equalTo(0);
            if (!lastView) {
                make.top.mas_equalTo(0);
            } else {
                make.top.equalTo(lastView.mas_bottom);
                ;
            }
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)addressIconIV {
    if (!_addressIconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"yn_submit_address"];
        _addressIconIV = imageView;
    }
    return _addressIconIV;
}

- (SALabel *)deliveryAddressLB {
    if (!_deliveryAddressLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"delivery_to", @"配送到");
        _deliveryAddressLB = label;
    }
    return _deliveryAddressLB;
}

- (SALabel *)receiverInfoLB {
    if (!_receiverInfoLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        label.textColor = HDAppTheme.WMColor.B6;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"order_sumit_choose_address", @"请选择收货地址");
        _receiverInfoLB = label;
    }
    return _receiverInfoLB;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"yn_submit_gengd"];
        imageView.contentMode = UIViewContentModeCenter;
        _arrowIV = imageView;
    }
    return _arrowIV;
}

- (SAInfoView *)deliveryTimeView {
    if (!_deliveryTimeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"arrive_time", @"送达时间")];
        view.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        view.model.rightButtonImageEdgeInsets = UIEdgeInsetsZero;
        view.model.enableTapRecognizer = true;
        view.model.lineWidth = 0;
        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            [self adjustShowChooseOrderDeliveryTimeView];
        };
        view.hidden = true;
        [view setNeedsUpdateContent];
        _deliveryTimeView = view;
    }
    return _deliveryTimeView;
}

- (SAInfoView *)paymentMethodView {
    if (!_paymentMethodView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_payment_method", @"付款方式")];
        view.model.valueText = WMLocalizedString(@"order_choose_payment_method", @"请选择付款方式");
        view.model.valueColor = HDAppTheme.WMColor.B9;
        view.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        view.model.rightButtonImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        view.model.enableTapRecognizer = true;
        view.model.rightButtonaAlignKey = YES;
        view.model.lineWidth = 0;
        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            @HDWeakify(self);
            [SAWindowManager
                navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                      @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                    SALocalizedString(@"login_new2_Food Delivery Order", @"外卖点餐")] bindSuccessBlock:^{
                    @HDStrongify(self);
                    [self adjustShowChoosePaymentMethodView];
                }
                                         cancelBindBlock:nil];
        };
        view.hidden = true;
        [view setNeedsUpdateContent];
        _paymentMethodView = view;
    }
    return _paymentMethodView;
}

- (NSMutableArray<WMStoreFilterTableViewCellModel *> *)deliveryTimeDataSource {
    if (!_deliveryTimeDataSource) {
        _deliveryTimeDataSource = [NSMutableArray arrayWithCapacity:7];
    }
    return _deliveryTimeDataSource;
}

- (UIView *)addressBgView {
    if (!_addressBgView) {
        _addressBgView = UIView.new;
        _addressBgView.backgroundColor = UIColor.whiteColor;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedChooseAddressHander)];
        [_addressBgView addGestureRecognizer:recognizer];
    }
    return _addressBgView;
}

- (SACompleteAddressTipsView *)tipsView {
    if (!_tipsView) {
        _tipsView = SACompleteAddressTipsView.new;
        _tipsView.hidden = true;
    }
    return _tipsView;
}

- (UIView *)timeAndpayMethodBgView {
    if (!_timeAndpayMethodBgView) {
        _timeAndpayMethodBgView = UIView.new;
        _timeAndpayMethodBgView.backgroundColor = HDAppTheme.WMColor.bgGray;
    }
    return _timeAndpayMethodBgView;
}

- (WMPayMarketingView *)marketingInfoView {
    if (!_marketingInfoView) {
        _marketingInfoView = WMPayMarketingView.new;
        _marketingInfoView.hidden = YES;
    }
    return _marketingInfoView;
}

- (UIView *)addressLine {
    if (!_addressLine) {
        _addressLine = UIView.new;
        _addressLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _addressLine;
}

@end
