//
//  WMOrderSubmitToStoreInfoView.m
//  SuperApp
//
//  Created by Tia on 2023/8/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitToStoreInfoView.h"
#import "WMOrderSubmitV2ViewModel.h"
#import "SAInfoView.h"
#import "WMPayMarketingView.h"
#import "SAAvailablePaymentMethodViewController.h"
#import "WMStoreFilterTableViewCellModel.h"
#import "SAAvailablePaymentMethodViewController.h"
#import "SACacheManager.h"
#import "SAChoosePaymentMethodPresenter.h"
#import "NSDate+SAExtension.h"
#import "SAGoodsModel.h"
#import "WMHorizontalTreeView.h"
#import "WMCustomViewActionView.h"
#import "GNAlertUntils.h"
#import "WMToStoreContactView.h"
#import "SAShoppingAddressModel.h"
#import "SAGeneralUtil.h"


@interface WMOrderSubmitToStoreInfoView ()
/// 地址背景视图
@property (nonatomic, strong) UIView *storeAddressView;

@property (nonatomic, strong) SALabel *storeAddressLabel;

@property (nonatomic, strong) HDUIButton *storeNaviBtn;
///地址底部横线
@property (nonatomic, strong) UIView *storeAddressLine;

@property (nonatomic, strong) UIView *contactView;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) HDUIButton *numberBtn;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) HDUIButton *contactBtn;
@property (nonatomic, strong) UIView *contactLine;

/// 配送时间付款方式背景视图
@property (nonatomic, strong) UIView *timeAndpayMethodBgView;
/// 配送时间
@property (nonatomic, strong) SAInfoView *deliveryTimeView;
/// 付款方式
@property (nonatomic, strong) SAInfoView *paymentMethodView;
///< 支付营销信息
@property (nonatomic, strong) WMPayMarketingView *marketingInfoView;


///< viewModel
@property (nonatomic, strong) WMOrderSubmitV2ViewModel *viewModel;

/// 聚合服务返回的模型
@property (nonatomic, strong) WMOrderSubmitAggregationRspModel *orderPreSubmitRspModel;
/// 配送时间数据源
@property (nonatomic, strong) NSMutableArray<WMStoreFilterTableViewCellModel *> *deliveryTimeDataSource;
/// 配送时间
@property (nonatomic, strong) WMOrderSubscribeTimeModel *subscribeTimeModel;
///< viewModel
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *firstTempSelectTimeModel;
///< viewModel
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *firstSelectTimeModel;
///< viewModel
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *secondSelectTimeModel;

@property (nonatomic, assign) double storeLat;
@property (nonatomic, assign) double storeLon;
@property (nonatomic, copy) NSString *storeAddress;

@property (nonatomic, strong) SAShoppingAddressModel *addressModel;

@end


@implementation WMOrderSubmitToStoreInfoView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.orangeColor;

    [self addSubview:self.storeAddressView];
    [self.storeAddressView addSubview:self.storeAddressLabel];
    [self.storeAddressView addSubview:self.storeNaviBtn];
    [self.storeAddressView addSubview:self.storeAddressLine];

    [self addSubview:self.contactView];
    [self.contactView addSubview:self.contactLabel];
    [self.contactView addSubview:self.contactBtn];
    [self.contactView addSubview:self.numberBtn];
    [self.contactView addSubview:self.numberTextField];
    [self.contactView addSubview:self.contactLine];


    [self addSubview:self.timeAndpayMethodBgView];
    [self.timeAndpayMethodBgView addSubview:self.deliveryTimeView];
    [self.timeAndpayMethodBgView addSubview:self.paymentMethodView];
    [self.timeAndpayMethodBgView addSubview:self.marketingInfoView];

    [self.storeNaviBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateConstraints {
    [self.storeAddressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];

    [self.storeAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.bottom.equalTo(self.storeAddressView).offset(-15);
        make.right.mas_lessThanOrEqualTo(self.storeNaviBtn.mas_left).offset(-15);
    }];

    [self.storeNaviBtn sizeToFit];
    [self.storeNaviBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.top.mas_greaterThanOrEqualTo(12);
        make.bottom.lessThanOrEqualTo(self.storeAddressView).offset(-12);
    }];

    [self.storeAddressLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];

    [self.contactView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.storeAddressView.mas_bottom);
        //        make.bottom.equalTo(self);
    }];

    [self.contactLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];

    [self.contactBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];

    [self.numberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contactBtn.mas_left);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];

    [self.numberBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberTextField.mas_left).offset(-15);
        make.centerY.mas_equalTo(0);
    }];

    [self.contactLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];

    [self.timeAndpayMethodBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.timeAndpayMethodBgView.isHidden) {
            make.left.right.equalTo(self);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.top.equalTo(self.contactView.mas_bottom);
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
            }
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [super updateConstraints];
}

- (void)updateUIWithOrderPreSubmitRspModel:(WMOrderSubmitAggregationRspModel *)aggregationRspModel userHasRisk:(BOOL)userHasRisk {
    self.orderPreSubmitRspModel = aggregationRspModel;

    // 异步处理数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            [self generateDeliveryTimeDataSource];
        }
    });

    self.storeLat = aggregationRspModel.storeInfo.lat;
    self.storeLon = aggregationRspModel.storeInfo.lon;
    self.storeAddress = aggregationRspModel.storeInfo.address;
    self.storeAddressLabel.text = self.storeAddress;

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
                [self adjustPaymemntMethodValueWithPaymentType:[HDPaymentMethodType cashOnDelivery]];
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
                [self adjustPaymemntMethodValueWithPaymentType:lastChooseMethod];
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
                                                         [self adjustPaymemntMethodValueWithPaymentType:lastChooseMethod];
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
                subTitle = WMLocalizedString(@"wm_pickup_Almost arrive", @"马上到店");
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


/// 点击选择支付方式view
- (void)adjustShowChoosePaymentMethodView {
    if (self.orderPreSubmitRspModel.storeInfo.paymentMethods.count < 1) {
        return;
    } else if (self.orderPreSubmitRspModel.storeInfo.paymentMethods.count == 1
               && ![self.orderPreSubmitRspModel.storeInfo.paymentMethods.firstObject isEqualToString:WMOrderAvailablePaymentTypeOnline]) {
        return;
    }

    NSMutableArray *paymentMethods = self.orderPreSubmitRspModel.storeInfo.paymentMethods.mutableCopy;
    if (paymentMethods.count > 0 && ![paymentMethods containsObject:HDSupportedPaymentMethodCashOnDelivery]) {
        if (self.viewModel.serviceType == 20) {
            [paymentMethods addObject:HDSupportedPaymentMethodCashOnDeliveryForbiddenByToStore];
        } else {
            [paymentMethods addObject:HDSupportedPaymentMethodCashOnDeliveryForbidden];
        }
    }

    @HDWeakify(self);
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

                                                             [self adjustPaymemntMethodValueWithPaymentType:paymentMethod];
                                                             self.viewModel.paymentDiscountAmount = paymentDiscountAmount;
                                                         }];
}

- (HDPaymentMethodType *)paymentType {
    return (HDPaymentMethodType *)self.paymentMethodView.model.associatedObject;
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
        value = WMLocalizedString(@"wm_pickup_Almost arrive", @"马上到店");
    }
    self.deliveryTimeView.model.valueText = value;
    [self.deliveryTimeView setNeedsUpdateContent];
}

- (void)adjustPaymemntMethodValueWithPaymentType:(HDPaymentMethodType *_Nullable)paymentMethod {
    self.paymentMethodView.hidden = HDIsObjectNil(paymentMethod);
    if (!self.paymentMethodView.isHidden) {
        self.paymentMethodView.model.associatedObject = paymentMethod;
        self.paymentMethodView.model.valueText = paymentMethod.toolName;
        self.paymentMethodView.model.valueColor = HDAppTheme.WMColor.B3;
        [self.paymentMethodView setNeedsUpdateContent];
    }
    [self setNeedsUpdateConstraints];
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
        config.title = WMLocalizedString(@"wm_pickup_Select arrival time", @"到店时间");
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

- (void)textFieldDidChange:(UITextField *)tf {
    if (tf.text.length > 10) {
        tf.text = [tf.text substringToIndex:10];
    }
    if (self.addressModel) {
        if ([tf.text hasPrefix:@"0"]) {
            self.viewModel.addressModel.mobile = [NSString stringWithFormat:@"855%@", tf.text];
        } else {
            self.viewModel.addressModel.mobile = [NSString stringWithFormat:@"8550%@", tf.text];
        }
        self.addressModel = nil;
    }
}

#pragma mark - lazy load
- (UIView *)storeAddressView {
    if (!_storeAddressView) {
        _storeAddressView = UIView.new;
        _storeAddressView.backgroundColor = UIColor.whiteColor;
    }
    return _storeAddressView;
}

- (SALabel *)storeAddressLabel {
    if (!_storeAddressLabel) {
        _storeAddressLabel = SALabel.new;
        //        _storeAddressLabel.text = @"Apple 1 Infinite Loop Cupertino, CA 95014 408.996.1010";
        _storeAddressLabel.numberOfLines = 0;
        _storeAddressLabel.font = HDAppTheme.font.sa_standard16B;
        _storeAddressLabel.hd_lineSpace = 5;
    }
    return _storeAddressLabel;
}

- (HDUIButton *)storeNaviBtn {
    if (!_storeNaviBtn) {
        _storeNaviBtn = HDUIButton.new;
        _storeNaviBtn.imagePosition = HDUIButtonImagePositionTop;
        [_storeNaviBtn setImage:[UIImage imageNamed:@"yn_icon_daohang"] forState:UIControlStateNormal];
        [_storeNaviBtn setTitleColor:UIColor.sa_C333 forState:UIControlStateNormal];
        _storeNaviBtn.titleLabel.font = HDAppTheme.font.sa_standard12M;
        _storeNaviBtn.spacingBetweenImageAndTitle = 4;
        [_storeNaviBtn setTitle:WMLocalizedString(@"wm_pickup_Navigation", @"Navigation") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_storeNaviBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            //导航
            @HDStrongify(self);
            [GNAlertUntils navigation:self.storeAddress lat:self.storeLat lon:self.storeLon];
        }];
    }
    return _storeNaviBtn;
}

- (UIView *)storeAddressLine {
    if (!_storeAddressLine) {
        _storeAddressLine = UIView.new;
        _storeAddressLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _storeAddressLine;
}

- (UIView *)contactView {
    if (!_contactView) {
        _contactView = UIView.new;
        _contactView.backgroundColor = UIColor.whiteColor;
    }
    return _contactView;
}

- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = UILabel.new;
        _contactLabel.textColor = UIColor.sa_C333;
        _contactLabel.text = WMLocalizedString(@"wm_pickup_Telephone", @"联系电话");
        _contactLabel.font = HDAppTheme.font.sa_standard14M;
    }
    return _contactLabel;
}

- (HDUIButton *)contactBtn {
    if (!_contactBtn) {
        _contactBtn = HDUIButton.new;
        _contactBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        [_contactBtn setImage:[UIImage imageNamed:@"yn_icon_contact"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_contactBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            NSArray *arr = self.viewModel.contactlist;
            NSMutableArray *dataSource = NSMutableArray.new;
            NSMutableArray *keyList = NSMutableArray.new;
            for (SAShoppingAddressModel *m in arr) {
                NSString *key = [NSString stringWithFormat:@"%@%@%@", m.consigneeName, m.gender, m.mobile];
                if (![keyList containsObject:key]) {
                    [dataSource addObject:m];
                    [keyList addObject:key];
                }
            }

            if (dataSource.count) {
                WMToStoreContactView *view = [[WMToStoreContactView alloc] initWithDataSource:dataSource selectData:self.addressModel completion:^(SAShoppingAddressModel *_Nonnull model) {
                    if (model) {
                        self.addressModel = model;
                        self.numberTextField.text = [SAGeneralUtil getShortAccountNoFromFullAccountNo:model.mobile];
                        SAShoppingAddressModel *addressModel = SAShoppingAddressModel.new;
                        addressModel.mobile = model.mobile;
                        addressModel.consigneeName = model.consigneeName;
                        self.viewModel.addressModel = addressModel;
                    }
                }];
                [view show];
            }
        }];
    }
    return _contactBtn;
}

- (UITextField *)numberTextField {
    if (!_numberTextField) {
        _numberTextField = UITextField.new;
        _numberTextField.textColor = UIColor.sa_C333;
        _numberTextField.font = HDAppTheme.font.sa_standard14H;
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextField.placeholder = WMLocalizedString(@"wm_pickup_Select contact phone number", @"选择联系电话");
        [_numberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        if ([SAUser.shared.mobile hasPrefix:@"855"]) {
            _numberTextField.text = [SAGeneralUtil getShortAccountNoFromFullAccountNo:SAUser.shared.mobile];
        }
    }
    return _numberTextField;
}

- (HDUIButton *)numberBtn {
    if (!_numberBtn) {
        _numberBtn = HDUIButton.new;
        _numberBtn.imagePosition = HDUIButtonImagePositionRight;
        [_numberBtn setTitle:@"855" forState:UIControlStateNormal];
        [_numberBtn setTitleColor:UIColor.sa_C333 forState:UIControlStateNormal];
        [_numberBtn setImage:[UIImage imageNamed:@"yn_icon_down_arrow"] forState:UIControlStateNormal];
        _numberBtn.titleLabel.font = HDAppTheme.font.sa_standard14H;
        _numberBtn.userInteractionEnabled = NO;
    }
    return _numberBtn;
}

- (UIView *)contactLine {
    if (!_contactLine) {
        _contactLine = UIView.new;
        _contactLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _contactLine;
}

- (UIView *)timeAndpayMethodBgView {
    if (!_timeAndpayMethodBgView) {
        _timeAndpayMethodBgView = UIView.new;
        _timeAndpayMethodBgView.backgroundColor = HDAppTheme.WMColor.bgGray;
    }
    return _timeAndpayMethodBgView;
}

- (SAInfoView *)deliveryTimeView {
    if (!_deliveryTimeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"wm_pickup_Arrival time", @"到店时间")];
        view.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        view.model.rightButtonImageEdgeInsets = UIEdgeInsetsZero;
        view.model.enableTapRecognizer = true;
        view.model.lineWidth = 0;
        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            [self adjustShowChooseOrderDeliveryTimeView];
        };
        //        view.hidden = true;
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
        //        view.hidden = true;
        [view setNeedsUpdateContent];
        _paymentMethodView = view;
    }
    return _paymentMethodView;
}

- (WMPayMarketingView *)marketingInfoView {
    if (!_marketingInfoView) {
        _marketingInfoView = WMPayMarketingView.new;
        _marketingInfoView.hidden = YES;
    }
    return _marketingInfoView;
}

- (NSMutableArray<WMStoreFilterTableViewCellModel *> *)deliveryTimeDataSource {
    if (!_deliveryTimeDataSource) {
        _deliveryTimeDataSource = [NSMutableArray arrayWithCapacity:7];
    }
    return _deliveryTimeDataSource;
}

- (NSString *)numberTextFieldText {
    NSString *text = self.numberTextField.text;
    if ([text hasPrefix:@"0"]) {
        return [NSString stringWithFormat:@"855%@", text];
    }
    return [NSString stringWithFormat:@"8550%@", text];
}

@end
