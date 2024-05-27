//
//  TNOrderDetailsViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "NSDate+SAExtension.h"
#import "NSString+extend.h"
#import "SAInfoViewModel.h"
#import "SAMoneyTools.h"
#import "TNAdressChangeTipsAlertView.h"
#import "TNCheckRegionModel.h"
#import "TNDecimalTool.h"
#import "TNExplanationAlertView.h"
#import "TNExpressTrackingStatusCell.h"
#import "TNModel.h"
#import "TNOrderDTO.h"
#import "TNOrderDetailAdressCell.h"
#import "TNOrderDetailContactCell.h"
#import "TNOrderDetailExpressCell.h"
#import "TNOrderDetailsGoodsSummarizeTableViewCell.h"
#import "TNOrderDetailsStatusTableViewCell.h"
#import "TNOrderSkuSpecifacationCell.h"
#import "TNOrderStoreHeaderView.h"
#import "TNOrderSubmitGoodsTableViewCell.h"
#import "TNOrderTipCell.h"
#import "TNProductDTO.h"
#import "TNQueryOrderDetailsRspModel.h"
#import "TNRefundDTO.h"
#import "TNDeliveryComponyAlertView.h"

@interface TNOrderDetailsViewModel ()
/// 订单dto
@property (nonatomic, strong) TNOrderDTO *orderDTO;
/// DTO
@property (nonatomic, strong) TNRefundDTO *refundDTO;
/// 计费标准数据
@property (nonatomic, strong) NSArray<TNDeliveryComponyModel *> *deliveryComponylist;
/// dto
@property (nonatomic, strong) TNProductDTO *productDTO;

@end


@implementation TNOrderDetailsViewModel

- (void)getNewDataWithOrderNo:(NSString *)orderNo {
    @HDWeakify(self);
    [self.orderDTO queryOrderDetailsWithOrderNo:orderNo success:^(TNQueryOrderDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.orderDetails = rspModel;
        if (!HDIsObjectNil(rspModel) && !HDIsObjectNil(rspModel.orderDetail) && HDIsStringNotEmpty(rspModel.orderDetail._id)) {
            [self generateDataWithRspModel:rspModel];
        }
        if ([rspModel.orderDetail.type isEqualToString:TNOrderTypeOverseas]) {
            self.trackPrefixName = TNTrackEventPrefixNameOverseas;
        } else if ([rspModel.orderDetail.type isEqualToString:TNOrderTypeGeneral]) {
            self.trackPrefixName = TNTrackEventPrefixNameFastConsume;
        } else {
            self.trackPrefixName = TNTrackEventPrefixNameOther;
        }
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.networkFailBlock ?: self.networkFailBlock();
    }];
}

- (void)generateDataWithRspModel:(TNQueryOrderDetailsRspModel *)rspModel {
    NSMutableArray<HDTableViewSectionModel *> *dataSource = NSMutableArray.new;
    HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;

    NSMutableArray *firstSectionArr = [NSMutableArray array];
    ///海外购  待审核的订单  提示文本
    if ([rspModel.orderDetail.type isEqualToString:TNOrderTypeOverseas] && [rspModel.orderDetail.status isEqualToString:TNOrderStatePendingReview]) {
        TNOrderTipCellModel *tipModel = TNOrderTipCellModel.new;
        tipModel.tipText = TNLocalizedString(@"I2a76cxo", @"订单将在1分钟内进行审核，审核通过后请及时支付，如长时间还是待审核，请联系客服人员");
        tipModel.isFromOrderDetail = YES;
        tipModel.isNeedShowRefreshBtn = YES;
        [firstSectionArr addObject:tipModel];
    }

    //提示信息   不需要展示提示信息
    if (HDIsStringNotEmpty(rspModel.orderDetail.orderDetailTopNotice)
        && (![rspModel.orderDetail.status isEqualToString:TNOrderStateCompleted] && ![rspModel.orderDetail.status isEqualToString:TNOrderStatePendingReview]
            && ![rspModel.orderDetail.status isEqualToString:TNOrderStateCanceled] && ![rspModel.orderDetail.status isEqualToString:TNOrderStatePendingPayment])) {
        TNOrderTipCellModel *tipModel = TNOrderTipCellModel.new;
        tipModel.tipText = rspModel.orderDetail.orderDetailTopNotice;
        tipModel.isFromOrderDetail = YES;
        [firstSectionArr addObject:tipModel];
    }
    // 状态
    TNOrderDetailsStatusTableViewCellModel *stateModel = TNOrderDetailsStatusTableViewCellModel.new;
    stateModel.orderState = rspModel.orderDetail.status;
    stateModel.statusTitle = rspModel.orderDetail.statusTitle;
    stateModel.statusDes = rspModel.orderDetail.statusDes;
    stateModel.expireTime = rspModel.orderDetail.expire;
    stateModel.paymentInfo = rspModel.orderDetail.paymentInfo;
    //显示送货时间
    if ([rspModel.orderDetail.status isEqualToString:TNOrderStatePendingReview] || [rspModel.orderDetail.status isEqualToString:TNOrderStatePendingPayment] ||
        [rspModel.orderDetail.status isEqualToString:TNOrderStatePendingShipment] || [rspModel.orderDetail.status isEqualToString:TNOrderStateShipped]) {
        if (HDIsStringNotEmpty(rspModel.orderDetail.immediateTime)) {
            stateModel.deliverTime = rspModel.orderDetail.immediateTime;
        } else if (HDIsStringNotEmpty(rspModel.orderDetail.deliveryTime)) {
            stateModel.deliverTime = rspModel.orderDetail.deliveryTime;
        }
    }
    [firstSectionArr addObject:stateModel];

    //显示物流
    if ([rspModel.orderDetail.type isEqualToString:TNOrderTypeOverseas]) {
        //海外购
        if (HDIsStringNotEmpty(rspModel.orderDetail.expressTxt) && ![rspModel.orderDetail.status isEqualToString:TNOrderStateCanceled]) {
            TNOrderDetailExpressCellModel *expressModel = [[TNOrderDetailExpressCellModel alloc] init];
            expressModel.isOverseas = YES;
            expressModel.content = rspModel.orderDetail.expressTxt;
            expressModel.orderNo = rspModel.orderInfo.orderNo;
            [firstSectionArr addObject:expressModel];
        }
    } else {
        //本地购
        if (!HDIsObjectNil(rspModel.orderDetail.expressOrder)) {
            TNOrderDetailExpressCellModel *expressModel = [[TNOrderDetailExpressCellModel alloc] init];
            expressModel.isOverseas = NO;
            NSString *nameStr = rspModel.orderDetail.expressOrder.name ?: @"";
            expressModel.content = [NSString stringWithFormat:@"%@%@%@", nameStr, HDIsStringNotEmpty(nameStr) ? @":" : @"", rspModel.orderDetail.expressOrder.trackingNo ?: @""];

            NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[rspModel.orderDetail.expressOrder.createTime doubleValue] / 1000.0];
            expressModel.time = [SAGeneralUtil getDateStrWithDate:orderDate format:@"dd/MM/yyyy HH:mm:ss"];
            expressModel.riderPhone = rspModel.orderDetail.expressOrder.riderPhone;
            expressModel.riderOperatorNo = rspModel.orderDetail.expressOrder.riderOperatorNo;
            expressModel.trackingNo = rspModel.orderDetail.expressOrder.trackingNo;
            expressModel.orderNo = rspModel.orderInfo.orderNo;
            [firstSectionArr addObject:expressModel];
        }
    }

    sectionModel.list = firstSectionArr;
    [dataSource addObject:sectionModel];

    self.statusIndexPath = [NSIndexPath indexPathForRow:[firstSectionArr indexOfObject:stateModel] inSection:(dataSource.count - 1)];

    NSMutableArray *secondSectionArr = [NSMutableArray array];
    // 收货地址
    sectionModel = HDTableViewSectionModel.new;
    TNOrderDetailAdressCellModel *addressModel = TNOrderDetailAdressCellModel.new;
    addressModel.name = rspModel.orderDetail.shippingInfo.consignee;
    addressModel.gender = @"";
    addressModel.address = rspModel.orderDetail.shippingInfo.address;
    addressModel.phone = rspModel.orderDetail.shippingInfo.phone;
    addressModel.status = rspModel.orderDetail.status;
    // ps: 这里取反一下， canEdit 返回是否可以修改， 而 isShowEdit 是决定是否显示
    addressModel.isShowEdit = ![self canEdit:rspModel.orderDetail.status];

    [secondSectionArr addObject:addressModel];

    sectionModel.list = secondSectionArr;
    [dataSource addObject:sectionModel];

    // 商品数据
    HDTableViewSectionModel *storeSection = HDTableViewSectionModel.new;
    TNOrderStoreHeaderModel *gooderHeader = TNOrderStoreHeaderModel.new;
    gooderHeader.storeName = rspModel.orderDetail.storeInfo.name;
    gooderHeader.storeId = rspModel.orderDetail.storeInfo.storeNo;
    gooderHeader.isNeedShowStoreRightIV = YES;
    gooderHeader.storeType = rspModel.orderDetail.storeInfo.type;
    storeSection.commonHeaderModel = gooderHeader;

    if ([rspModel.orderDetail.type isEqualToString:TNOrderTypeOverseas]) {
        //海外购订单
        //免邮商品组
        NSMutableArray *freeShippingGoodList = [NSMutableArray array];
        //到付商品组
        NSMutableArray *cashOnDeliveryGoodList = [NSMutableArray array];
        int i = 0;
        for (TNOrderDetailsGoodsInfoModel *item in rspModel.orderDetail.items) {
            if (item.freightSetting) {
                [freeShippingGoodList addObject:item];
            } else {
                [cashOnDeliveryGoodList addObject:item];
            }
            i += 1;
        }
        if (!HDIsArrayEmpty(cashOnDeliveryGoodList)) {
            NSMutableArray *goodSelectList = [self getCashOnDeliveryProductsCellModelsWithGoodArr:cashOnDeliveryGoodList isNeedHeader:YES];
            storeSection.list = goodSelectList;
            [dataSource addObject:storeSection];
        }

        if (!HDIsArrayEmpty(freeShippingGoodList)) {
            sectionModel = HDTableViewSectionModel.new;
            if (HDIsArrayEmpty(cashOnDeliveryGoodList)) {
                sectionModel = storeSection;
            }
            NSMutableArray *goodSelectList = [self getFreeShippingProductsCellModelsWithGoodArr:freeShippingGoodList isNeedHeader:YES];
            sectionModel.list = goodSelectList;
            [dataSource addObject:sectionModel];
        }

    } else {
        //普通订单显示
        NSMutableArray *goodSelectList = [self getNomalProductsCellModelsWithGoodArr:rspModel.orderDetail.items];
        storeSection.list = goodSelectList;
        [dataSource addObject:storeSection];
    }

    /// 补/退差价
    if (rspModel.orderDetail.differenceChanged == true) {
        sectionModel = HDTableViewSectionModel.new;
        SAInfoViewModel *repairModel = SAInfoViewModel.new;
        repairModel.keyText = TNLocalizedString(@"tn_difference_amount", @"补/退差价记录");
        repairModel.valueText = rspModel.orderDetail.differencePrice.thousandSeparatorAmount;
        repairModel.keyToValueWidthRate = 0.6;
        repairModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        repairModel.keyColor = HDAppTheme.TinhNowColor.G1;
        repairModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        repairModel.valueColor = HDAppTheme.TinhNowColor.G1;
        repairModel.valueNumbersOfLines = 1;
        repairModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        repairModel.rightButtonImagePosition = HDUIButtonImagePositionRight;
        repairModel.rightButtonTitle = @" ";
        repairModel.associatedObject = @"record";
        sectionModel.list = @[repairModel];
        [dataSource addObject:sectionModel];
    }

    ///价格优惠券相关
    sectionModel = HDTableViewSectionModel.new;
    SAInfoViewModel *infoViewModel = SAInfoViewModel.new;
    NSMutableArray *infoList = NSMutableArray.new;
    //中国段运费显示
    if ([rspModel.orderDetail.type isEqualToString:TNOrderTypeOverseas] && !HDIsObjectNil(rspModel.orderDetail.freightPriceChina)) {
        infoViewModel = [[SAInfoViewModel alloc] init];
        infoViewModel.keyText = TNLocalizedString(@"LR4nKEjJ", @"中国段运费");
        infoViewModel.valueText = rspModel.orderDetail.freightPriceChina.thousandSeparatorAmount;
        infoViewModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        infoViewModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        infoViewModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        infoViewModel.valueColor = HDAppTheme.TinhNowColor.G1;
        [infoList addObject:infoViewModel];
    }
    //平台优惠券
    if (!HDIsObjectNil(rspModel.orderDetail.platformCoupon)) {
        //平台优惠券
        infoViewModel = SAInfoViewModel.new;
        infoViewModel.keyText = TNLocalizedString(@"tn_platfrom_coupon", @"平台优惠券");
        infoViewModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        infoViewModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        infoViewModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        infoViewModel.valueColor = [UIColor hd_colorWithHexString:@"#F83E00"];
        infoViewModel.valueText = [NSString stringWithFormat:@"(%@)", rspModel.orderDetail.platformCoupon.title];
        infoViewModel.lineWidth = 0;
        infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(10), kRealWidth(15));
        [infoList addObject:infoViewModel];

        //优惠券金额
        infoViewModel = SAInfoViewModel.new;
        infoViewModel.keyText = @"";
        infoViewModel.valueText = [NSString stringWithFormat:@"-%@", rspModel.orderDetail.platformCoupon.discount.thousandSeparatorAmount];
        infoViewModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        infoViewModel.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
        infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        [infoList addObject:infoViewModel];
    }

    if (!HDIsObjectNil(rspModel.orderDetail.promotionCodeDTO) && !HDIsObjectNil(rspModel.orderDetail.promotionCodeDTO.promotionCodeDiscount)) {
        infoViewModel = [[SAInfoViewModel alloc] init];
        infoViewModel.keyText = TNLocalizedString(@"OkaO8L5F", @"优惠码");
        infoViewModel.valueText = [NSString stringWithFormat:@"-%@", rspModel.orderDetail.promotionCodeDTO.promotionCodeDiscount.thousandSeparatorAmount];
        infoViewModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        infoViewModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        infoViewModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        infoViewModel.valueColor = HDAppTheme.TinhNowColor.G1;
        [infoList addObject:infoViewModel];
    }

    if (!HDIsObjectNil(rspModel.orderDetail.amount) && [rspModel.orderDetail.amount.cent doubleValue] >= 0) {
        //总计
        SAInfoViewModel *totolInfoViewModel = SAInfoViewModel.new;
        totolInfoViewModel.keyText = TNLocalizedString(@"tn_total", @"总计");
        totolInfoViewModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        totolInfoViewModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;

        if (HDIsStringNotEmpty(rspModel.orderDetail.khrAmount)) {
            NSString *amount = rspModel.orderDetail.amount.thousandSeparatorAmount;
            NSString *khrAmount = [NSString stringWithFormat:@"(%@)", [SAMoneyTools thousandSeparatorAmountYuan:rspModel.orderDetail.khrAmount currencyCode:@"KHR"]];
            NSString *showStr = [amount stringByAppendingString:khrAmount];
            NSMutableAttributedString *attr = [NSString highLightString:khrAmount inLongString:showStr font:HDAppTheme.TinhNowFont.standard12 color:HDAppTheme.TinhNowColor.G2
                                                                norFont:HDAppTheme.TinhNowFont.standard17
                                                               norColor:HDAppTheme.TinhNowColor.R1];
            [attr addAttribute:NSBaselineOffsetAttributeName value:@(1.5) range:[showStr rangeOfString:khrAmount]];
            totolInfoViewModel.attrValue = attr;
        } else {
            totolInfoViewModel.valueText = rspModel.orderDetail.amount.thousandSeparatorAmount;
        }
        totolInfoViewModel.valueFont = HDAppTheme.TinhNowFont.standard17;
        totolInfoViewModel.valueColor = HDAppTheme.TinhNowColor.R1;

        [infoList addObject:totolInfoViewModel];

        //汇率
        if (HDIsStringNotEmpty(rspModel.orderDetail.khrExchangeRate)) {
            infoViewModel = SAInfoViewModel.new;
            infoViewModel.keyText = @"";
            infoViewModel.valueText = [NSString stringWithFormat:@"%@ 1:%@", TNLocalizedString(@"tn_exchange_rate_k", @"汇率"), rspModel.orderDetail.khrExchangeRate];
            infoViewModel.valueFont = HDAppTheme.TinhNowFont.standard12;
            infoViewModel.valueColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
            infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
            [infoList addObject:infoViewModel];
            //设置总计 金额样式显示
            totolInfoViewModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(10), kRealWidth(15));
            totolInfoViewModel.lineWidth = 0;
        }
        // 有支付营销
        if (!HDIsObjectNil(rspModel.orderInfo.payDiscountAmount) && rspModel.orderInfo.payDiscountAmount.cent.integerValue > 0) {
            SAInfoViewModel *payDiscount = SAInfoViewModel.new;
            payDiscount.keyText = SALocalizedString(@"payment_coupon", @"支付优惠");
            payDiscount.keyFont = HDAppTheme.TinhNowFont.standard15;
            payDiscount.keyColor = HDAppTheme.TinhNowColor.c5E6681;
            payDiscount.valueText = [NSString stringWithFormat:@"-%@", rspModel.orderInfo.payDiscountAmount.thousandSeparatorAmount];
            payDiscount.valueFont = HDAppTheme.TinhNowFont.standard17;
            payDiscount.valueColor = HDAppTheme.TinhNowColor.R1;
            [infoList addObject:payDiscount];

            SAInfoViewModel *actuallyPay = SAInfoViewModel.new;
            actuallyPay.keyText = SALocalizedString(@"checksd_actuallyPaid", @"实付");
            actuallyPay.keyFont = HDAppTheme.TinhNowFont.standard17;
            actuallyPay.keyColor = HDAppTheme.TinhNowColor.c5E6681;
            actuallyPay.valueText = rspModel.orderInfo.payActualPayAmount.thousandSeparatorAmount;
            actuallyPay.valueFont = HDAppTheme.TinhNowFont.standard17;
            actuallyPay.valueColor = HDAppTheme.TinhNowColor.R1;
            [infoList addObject:actuallyPay];
        }
    }

    //添加联系方式
    TNOrderDetailContactCellModel *cellModel = [TNOrderDetailContactCellModel new];
    cellModel.storeNo = self.orderDetails.orderDetail.storeInfo.storeNo;
    [infoList addObject:cellModel];

    sectionModel.list = [NSArray arrayWithArray:infoList];
    [dataSource addObject:sectionModel];

    ///订单信息
    sectionModel = HDTableViewSectionModel.new;
    infoList = NSMutableArray.new;
    void (^configInfoViewModel)(SAInfoViewModel *) = ^void(SAInfoViewModel *infoModel) {
        infoModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        infoModel.keyColor = HDAppTheme.TinhNowColor.G3;
        infoModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
    };

    infoViewModel = SAInfoViewModel.new;
    infoViewModel.keyText = [TNLocalizedString(@"tn_order_orderno", @"订单编号") stringByAppendingString:@":"];
    infoViewModel.valueText = rspModel.orderDetail.unifiedOrderNo;
    infoViewModel.valueImage = [UIImage imageNamed:@"tn_orderNo_copy"];
    infoViewModel.valueImagePosition = HDUIButtonImagePositionRight;
    infoViewModel.valueAlignmentToOther = NSTextAlignmentLeft;
    infoViewModel.valueTextAlignment = NSTextAlignmentLeft;
    infoViewModel.lineWidth = 0;
    infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    configInfoViewModel(infoViewModel);
    infoViewModel.clickedValueButtonHandler = ^{
        if (HDIsStringNotEmpty(rspModel.orderDetail.unifiedOrderNo)) {
            [UIPasteboard generalPasteboard].string = rspModel.orderDetail.unifiedOrderNo;
            [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
        }
    };
    infoViewModel.enableTapRecognizer = YES;
    [infoList addObject:infoViewModel];

    infoViewModel = SAInfoViewModel.new;
    infoViewModel.keyText = [TNLocalizedString(@"AegA4yhW", @"下单时间") stringByAppendingString:@":"];
    infoViewModel.valueText = [[NSDate dateWithTimeIntervalSince1970:rspModel.orderInfo.createTime / 1000] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];
    infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
    infoViewModel.lineWidth = 0;
    configInfoViewModel(infoViewModel);
    infoViewModel.valueAlignmentToOther = NSTextAlignmentLeft;
    [infoList addObject:infoViewModel];

    infoViewModel = SAInfoViewModel.new;
    infoViewModel.keyText = [TNLocalizedString(@"tn_order_paymentType", @"付款方式") stringByAppendingString:@":"];
    infoViewModel.valueText = rspModel.orderDetail.paymentInfo.paymentMethodName;
    infoViewModel.valueAlignmentToOther = NSTextAlignmentLeft;
    infoViewModel.valueTextAlignment = NSTextAlignmentLeft;
    infoViewModel.lineWidth = 0;
    infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
    configInfoViewModel(infoViewModel);
    [infoList addObject:infoViewModel];

    // 送货时间
    if (HDIsStringNotEmpty(rspModel.orderDetail.deliveryTime)) {
        infoViewModel = SAInfoViewModel.new;
        infoViewModel.keyText = [TNLocalizedString(@"Tw0pO3zY", @"送货时间") stringByAppendingString:@":"];
        infoViewModel.valueText = rspModel.orderDetail.deliveryTime;
        infoViewModel.valueAlignmentToOther = NSTextAlignmentLeft;
        infoViewModel.valueTextAlignment = NSTextAlignmentLeft;
        infoViewModel.lineWidth = 0;
        infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        configInfoViewModel(infoViewModel);
        [infoList addObject:infoViewModel];
    }

    if ([rspModel.orderDetail.status isEqualToString:TNOrderStateCanceled]) {
        infoViewModel = SAInfoViewModel.new;
        infoViewModel.keyText = [TNLocalizedString(@"tn_order_cancelTime", @"取消时间") stringByAppendingString:@":"];
        infoViewModel.valueText = [[NSDate dateWithTimeIntervalSince1970:rspModel.orderDetail.cancelDate / 1000] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];
        infoViewModel.valueAlignmentToOther = NSTextAlignmentLeft;
        infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        infoViewModel.lineWidth = 0;
        configInfoViewModel(infoViewModel);
        [infoList addObject:infoViewModel];
    }

    infoViewModel = SAInfoViewModel.new;
    infoViewModel.keyText = [TNLocalizedString(@"tn_order_memo_title", @"订单备注") stringByAppendingString:@":"];
    if (HDIsStringNotEmpty(rspModel.orderDetail.memo)) {
        infoViewModel.valueText = rspModel.orderDetail.memo;
    } else {
        infoViewModel.valueText = TNLocalizedString(@"tn_order_memo_none", @"无");
    }
    infoViewModel.valueNumbersOfLines = 0;
    infoViewModel.valueAlignmentToOther = NSTextAlignmentLeft;
    infoViewModel.valueTextAlignment = NSTextAlignmentLeft;
    infoViewModel.lineWidth = 0;
    infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(20), kRealWidth(15));
    configInfoViewModel(infoViewModel);
    [infoList addObject:infoViewModel];

    sectionModel.list = [NSArray arrayWithArray:infoList];
    [dataSource addObject:sectionModel];

    if (HDIsStringNotEmpty(rspModel.orderDetail.orderRefundsId)) {
        sectionModel = HDTableViewSectionModel.new;
        infoViewModel = SAInfoViewModel.new;
        infoViewModel.leftImage = [UIImage imageNamed:@"tn_refund_icon_record"];
        infoViewModel.rightButtonImage = [UIImage imageNamed:@"arrow_narrow_gray"];
        infoViewModel.keyText = TNLocalizedString(@"tn_refund_record", @"退款记录");
        infoViewModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:17.f];
        infoViewModel.keyColor = HDAppTheme.TinhNowColor.c343B4D;
        infoViewModel.associatedObject = @"refund_record";
        sectionModel.list = @[infoViewModel];
        [dataSource addObject:sectionModel];
    }

    self.dataSource = [NSArray arrayWithArray:dataSource];
}

/// 普通订单  商品组显示
- (NSMutableArray *)getNomalProductsCellModelsWithGoodArr:(NSArray<TNOrderDetailsGoodsInfoModel *> *)goodsArr {
    NSMutableArray *arr = [NSMutableArray array];
    //商品列表  商品总额  计价
    [self addProductCellDataWithSectionArr:arr productItemArr:goodsArr isNeedCalculateTotalPrice:NO];

    //运费
    NSString *calsFreightStr = nil;                                                       //优惠后的运费
    NSString *freightStr = self.orderDetails.orderDetail.freight.thousandSeparatorAmount; //原运费
    NSMutableAttributedString *showAttr = nil;                                            //有优惠运费的展示
    if (!HDIsObjectNil(self.orderDetails.orderDetail.freightDiscount) && [self.orderDetails.orderDetail.freightDiscount.cent doubleValue] > 0) {
        double discountCent = [self.orderDetails.orderDetail.freightDiscount.cent doubleValue];
        double freightCent = [self.orderDetails.orderDetail.freight.cent doubleValue];
        double calcCent = freightCent - discountCent;
        if (calcCent < 0) {
            calcCent = 0; //最多0运费
        }
        SAMoneyModel *cModel = SAMoneyModel.new;
        cModel.currencySymbol = self.orderDetails.orderDetail.freightDiscount.currencySymbol;
        cModel.cy = self.orderDetails.orderDetail.freightDiscount.cy;
        cModel.centFace = self.orderDetails.orderDetail.freightDiscount.centFace;
        cModel.cent = [NSString stringWithFormat:@"%f", calcCent];
        calsFreightStr = cModel.thousandSeparatorAmount;

        if (HDIsStringNotEmpty(calsFreightStr) && HDIsStringNotEmpty(freightStr)) {
            NSString *showStr = [freightStr stringByAppendingFormat:@"  %@", calsFreightStr];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:showStr];
            [attr addAttributes:@{
                NSFontAttributeName: HDAppTheme.TinhNowFont.standard13,
                NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#BAB8B7"],
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSBaselineOffsetAttributeName: @(0), // iOS13 不添加这个属性可能显示不出删除线
                NSStrikethroughColorAttributeName: [UIColor hd_colorWithHexString:@"#BAB8B7"]
            }
                          range:[showStr rangeOfString:freightStr]];
            [attr addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard15, NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#F83E00"]}
                          range:[showStr rangeOfString:calsFreightStr]];
            showAttr = attr;
        }
    }
    SAInfoViewModel *infoModel = SAInfoViewModel.new;
    infoModel.keyText = TNLocalizedString(@"tn_page_deliveryfee_title", @"运费");
    infoModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    infoModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
    infoModel.valueFont = HDAppTheme.TinhNowFont.standard15;
    infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
    if (!HDIsObjectNil(self.orderDetails.orderDetail.overSeaFreightPrice)) {
        //海外购订单有运费文案就显示
        infoModel.valueText = self.orderDetails.orderDetail.freightMessageLocales.desc;
        infoModel.valueColor = HDAppTheme.TinhNowColor.R1;
    } else {
        if (showAttr != nil) {
            infoModel.attrValue = showAttr;
        } else {
            infoModel.valueText = self.orderDetails.orderDetail.freight.thousandSeparatorAmount;
        }
    }
    [arr addObject:infoModel];
    return arr;
}

///免邮 商品组  模型数据
- (NSMutableArray *)getFreeShippingProductsCellModelsWithGoodArr:(NSArray<TNOrderDetailsGoodsInfoModel *> *)goodsArr isNeedHeader:(BOOL)isNeedHeader {
    NSMutableArray *arr = [NSMutableArray array];
    if (isNeedHeader) {
        //标题
        SAInfoViewModel *titleModel = [[SAInfoViewModel alloc] init];
        titleModel.keyImagePosition = HDUIButtonImagePositionLeft;
        titleModel.keyTitletEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        titleModel.keyImage = [UIImage imageNamed:@"tn_small_freeshipping"];
        titleModel.keyText = TNLocalizedString(@"0jPkiTIb", @"免邮商品");
        titleModel.keyFont = [HDAppTheme.TinhNowFont fontSemibold:15];
        titleModel.keyColor = HDAppTheme.TinhNowColor.G1;
        [arr addObject:titleModel];
    }

    //商品列表  商品总额  计价
    [self addProductCellDataWithSectionArr:arr productItemArr:goodsArr isNeedCalculateTotalPrice:YES];
    //    //商品总额
    //    NSDecimalNumber *totolCent = NSDecimalNumber.zero;
    //    SAMoneyModel *totolMoney = nil;
    //    //商品行
    //    for (TNOrderDetailsGoodsInfoModel *goodsInfo in goodsArr) {
    //        TNOrderSubmitGoodsTableViewCellModel *goodsCellModel = TNOrderSubmitGoodsTableViewCellModel.new;
    //        goodsCellModel.productId = goodsInfo.productId;
    //        goodsCellModel.logoUrl = goodsInfo.thumbnail;
    //        goodsCellModel.goodsName = goodsInfo.name;
    //        goodsCellModel.skuName = [goodsInfo.specificationValue componentsJoinedByString:@","];
    //        goodsCellModel.quantify = goodsInfo.quantity;
    //        goodsCellModel.price = goodsInfo.price;
    //        goodsCellModel.taskId = self.orderDetails.orderDetail.taskId;
    //        goodsCellModel.activityId = self.orderDetails.orderDetail.activityId;
    //        goodsCellModel.type = self.orderDetails.orderDetail.type;
    //        goodsCellModel.showWeight = goodsInfo.showWight;
    //        goodsCellModel.sp = goodsInfo.sp;
    //        totolCent = [TNDecimalTool decimalAddingBy:totolCent num2:[TNDecimalTool stringDecimalMultiplyingBy:goodsInfo.price.cent num2:goodsInfo.quantity.stringValue]];
    //        //        if ([item isEqual:self.storeModel.selectedItems.lastObject]) {
    //        //            goodsCellModel.lineHeight = 0.5f;
    //        //        }
    //        if (HDIsObjectNil(totolMoney)) {
    //            totolMoney = [[SAMoneyModel alloc] init];
    //            totolMoney.currencySymbol = goodsInfo.price.currencySymbol;
    //            totolMoney.cy = goodsInfo.price.cy;
    //        }
    //        [arr addObject:goodsCellModel];
    //    }
    //
    //    totolMoney.cent = [NSString stringWithFormat:@"%f", totolCent.doubleValue];
    //
    //    //共计%@商品  以及改价原因
    //    TNOrderDetailsGoodsSummarizeTableViewCellModel *summarizeModel = TNOrderDetailsGoodsSummarizeTableViewCellModel.new;
    //    summarizeModel.goodsQuantity = self.orderDetails.orderDetail.quantity.integerValue;
    //    summarizeModel.totalPrice = self.orderDetails.orderDetail.price;
    //    summarizeModel.storeNo = self.orderDetails.orderDetail.storeInfo.storeNo;
    //    if (self.orderDetails.orderDetail.isAdjustPrice) {
    //        summarizeModel.changeReason = self.orderDetails.orderDetail.adjustPriceRemark;
    //    }
    //    [arr addObject:summarizeModel];
    //
    //    //商品总额
    //    SAInfoViewModel *totolModel = [[SAInfoViewModel alloc] init];
    //    totolModel.keyText = TNLocalizedString(@"tn_page_total_amount_title", @"商品总额");
    //    totolModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    //    totolModel.keyColor = HDAppTheme.TinhNowColor.G3;
    //    totolModel.valueText = totolMoney.thousandSeparatorAmount;
    //    totolModel.valueFont = HDAppTheme.TinhNowFont.standard15;
    //    totolModel.valueColor = HDAppTheme.TinhNowColor.R1;
    //    [arr addObject:totolModel];

    //运费
    SAInfoViewModel *feeModel = [[SAInfoViewModel alloc] init];
    feeModel.keyText = TNLocalizedString(@"7YWbzBzV", @"国际运费");
    feeModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    feeModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
    feeModel.valueColor = HDAppTheme.TinhNowColor.G1;
    feeModel.valueFont = HDAppTheme.TinhNowFont.standard15;
    feeModel.valueNumbersOfLines = 0;
    feeModel.valueText = TNLocalizedString(@"QnZH0Z83", @"免邮");
    feeModel.lineWidth = 0;
    [arr addObject:feeModel];
    return arr;
}

///到付 商品组  模型数据
- (NSMutableArray *)getCashOnDeliveryProductsCellModelsWithGoodArr:(NSArray<TNOrderDetailsGoodsInfoModel *> *)goodsArr isNeedHeader:(BOOL)isNeedHeader {
    NSMutableArray *arr = [NSMutableArray array];
    if (isNeedHeader) {
        //标题
        SAInfoViewModel *titleModel = [[SAInfoViewModel alloc] init];
        titleModel.keyTitletEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        titleModel.keyImagePosition = HDUIButtonImagePositionLeft;
        titleModel.keyImage = [UIImage imageNamed:@"tn_cash_delivery"];
        titleModel.keyText = TNLocalizedString(@"SBJwEl0y", @"到付商品");
        titleModel.keyFont = [HDAppTheme.TinhNowFont fontSemibold:15];
        titleModel.keyColor = HDAppTheme.TinhNowColor.G1;
        [arr addObject:titleModel];
    }
    //商品列表  商品总额  计价
    [self addProductCellDataWithSectionArr:arr productItemArr:goodsArr isNeedCalculateTotalPrice:YES];
    //    //商品总额
    //    NSDecimalNumber *totolCent = NSDecimalNumber.zero;
    //    SAMoneyModel *totolMoney = nil;
    //    //商品行
    //    for (TNOrderDetailsGoodsInfoModel *goodsInfo in goodsArr) {
    //        TNOrderSubmitGoodsTableViewCellModel *goodsCellModel = TNOrderSubmitGoodsTableViewCellModel.new;
    //        goodsCellModel.productId = goodsInfo.productId;
    //        goodsCellModel.logoUrl = goodsInfo.thumbnail;
    //        goodsCellModel.goodsName = goodsInfo.name;
    //        goodsCellModel.skuName = [goodsInfo.specificationValue componentsJoinedByString:@","];
    //        goodsCellModel.quantify = goodsInfo.quantity;
    //        goodsCellModel.price = goodsInfo.price;
    //        goodsCellModel.taskId = self.orderDetails.orderDetail.taskId;
    //        goodsCellModel.activityId = self.orderDetails.orderDetail.activityId;
    //        goodsCellModel.type = self.orderDetails.orderDetail.type;
    //        goodsCellModel.showWeight = goodsInfo.showWight;
    //        goodsCellModel.sp = goodsInfo.sp;
    //        totolCent = [TNDecimalTool decimalAddingBy:totolCent num2:[TNDecimalTool stringDecimalMultiplyingBy:goodsInfo.price.cent num2:goodsInfo.quantity.stringValue]];
    //        //        if ([item isEqual:self.storeModel.selectedItems.lastObject]) {
    //        //            goodsCellModel.lineHeight = 0.5f;
    //        //        }
    //        if (HDIsObjectNil(totolMoney)) {
    //            totolMoney = [[SAMoneyModel alloc] init];
    //            totolMoney.currencySymbol = goodsInfo.price.currencySymbol;
    //            totolMoney.cy = goodsInfo.price.cy;
    //        }
    //        [arr addObject:goodsCellModel];
    //    }
    //    totolMoney.cent = [NSString stringWithFormat:@"%f", totolCent.doubleValue];
    //
    //    //共计%@商品  以及改价原因
    //    TNOrderDetailsGoodsSummarizeTableViewCellModel *summarizeModel = TNOrderDetailsGoodsSummarizeTableViewCellModel.new;
    //    summarizeModel.goodsQuantity = self.orderDetails.orderDetail.quantity.integerValue;
    //    summarizeModel.totalPrice = self.orderDetails.orderDetail.price;
    //    summarizeModel.storeNo = self.orderDetails.orderDetail.storeInfo.storeNo;
    //    if (self.orderDetails.orderDetail.isAdjustPrice) {
    //        summarizeModel.changeReason = self.orderDetails.orderDetail.adjustPriceRemark;
    //    }
    //    [arr addObject:summarizeModel];
    //
    //    //商品总额
    //    SAInfoViewModel *totolModel = [[SAInfoViewModel alloc] init];
    //    totolModel.keyText = TNLocalizedString(@"tn_page_total_amount_title", @"商品总额");
    //    totolModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    //    totolModel.keyColor = HDAppTheme.TinhNowColor.G3;
    //    totolModel.valueText = totolMoney.thousandSeparatorAmount;
    //    totolModel.valueFont = HDAppTheme.TinhNowFont.standard15;
    //    totolModel.valueColor = HDAppTheme.TinhNowColor.R1;
    //    [arr addObject:totolModel];
    //运费
    SAInfoViewModel *feeModel = [[SAInfoViewModel alloc] init];
    feeModel.keyText = TNLocalizedString(@"7YWbzBzV", @"国际运费");
    feeModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    feeModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
    //运费样式显示
    feeModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(10), kRealWidth(15));
    feeModel.lineWidth = 0;
    [arr addObject:feeModel];

    SAInfoViewModel *tipsModel = SAInfoViewModel.new;
    tipsModel.keyText = [TNLocalizedString(@"2j4L6C52", @"运费到付，点击查看物流计费标准") stringByAppendingString:@" >"];
    tipsModel.keyFont = HDAppTheme.TinhNowFont.standard14;
    tipsModel.keyColor = [UIColor hd_colorWithHexString:@"#FF2323"];
    tipsModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
    tipsModel.enableTapRecognizer = YES;
    tipsModel.lineWidth = 0;
    @HDWeakify(self);
    tipsModel.eventHandler = ^{
        @HDStrongify(self);
        [self showFreightCostsAlertView];
    };
    [arr addObject:tipsModel];

    if (!HDIsObjectNil(self.orderDetails.orderDetail.ceWorthTotal)) {
        //有了运费明细  点击调往查看明细
        SAInfoViewModel *feeDetailModel = SAInfoViewModel.new;

        feeDetailModel.keyText = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"fup2KiKa", @"预计到付运费总额"), self.orderDetails.orderDetail.ceWorthTotal.thousandSeparatorAmount];
        feeDetailModel.keyFont = HDAppTheme.TinhNowFont.standard12;
        feeDetailModel.keyColor = HexColor(0x5D667F);
        feeDetailModel.valueAlignmentToOther = NSTextAlignmentLeft;
        NSString *detail = TNLocalizedString(@"ZN1vdoq2", @"查看明细");
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:detail];
        [attr addAttributes:@{
            NSFontAttributeName: HDAppTheme.TinhNowFont.standard12,
            NSForegroundColorAttributeName: HexColor(0xFF2323),
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSBaselineOffsetAttributeName: @(0), // iOS13 不添加这个属性可能显示不出删除线
        }
                      range:NSMakeRange(0, detail.length)];
        feeDetailModel.attrValue = attr;

        feeDetailModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        feeDetailModel.enableTapRecognizer = YES;
        feeDetailModel.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveToTinhNowExpressTrackingViewController:@{@"orderNo": self.orderDetails.orderInfo.orderNo}];
        };
        [arr addObject:feeDetailModel];
    }
    return arr;
}

/// 添加商品模型数据
- (void)addProductCellDataWithSectionArr:(NSMutableArray *)arr productItemArr:(NSArray<TNOrderDetailsGoodsInfoModel *> *)productItemArr isNeedCalculateTotalPrice:(BOOL)isNeedCalculateTotalPrice {
    //先排序  将相同的商品放一块
    productItemArr = [productItemArr sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(TNOrderDetailsGoodsInfoModel *_Nonnull obj1, TNOrderDetailsGoodsInfoModel *_Nonnull obj2) {
        return [obj1.productId isEqualToString:obj2.productId];
    }];
    //商品总额
    NSDecimalNumber *totolCent = NSDecimalNumber.zero;
    SAMoneyModel *totolMoney = nil;
    //商品行  规格行  也要加
    TNOrderDetailsGoodsInfoModel *lastItem = nil;         // 最新一个item 一个商品可能多规格
    TNOrderSubmitGoodsTableViewCellModel *goodsCellModel; //商品级别模型
    NSInteger weight = 0;                                 //计算重量
    for (TNOrderDetailsGoodsInfoModel *goodsInfo in productItemArr) {
        //添加商品
        if (lastItem == nil || ![lastItem.productId isEqualToString:goodsInfo.productId]) {
            weight = 0; //重置
            goodsCellModel = TNOrderSubmitGoodsTableViewCellModel.new;
            goodsCellModel.productId = goodsInfo.productId;
            goodsCellModel.logoUrl = goodsInfo.thumbnail;
            goodsCellModel.goodsName = goodsInfo.name;
            goodsCellModel.skuName = [goodsInfo.specificationValue componentsJoinedByString:@","];
            goodsCellModel.quantify = goodsInfo.quantity;
            goodsCellModel.price = goodsInfo.price;
            goodsCellModel.taskId = self.orderDetails.orderDetail.taskId;
            goodsCellModel.activityId = self.orderDetails.orderDetail.activityId;
            goodsCellModel.type = self.orderDetails.orderDetail.type;
            goodsCellModel.weight = self.orderDetails.orderDetail.weight;
            goodsCellModel.sp = goodsInfo.sp;
            [arr addObject:goodsCellModel];
        }

        if (goodsInfo.weight != nil) {
            NSInteger temp = goodsInfo.weight.integerValue * goodsInfo.quantity.integerValue;
            weight += temp;
        }

        goodsCellModel.weight = @(weight);

        totolCent = [TNDecimalTool decimalAddingBy:totolCent num2:[TNDecimalTool stringDecimalMultiplyingBy:goodsInfo.price.cent num2:goodsInfo.quantity.stringValue]];
        if (HDIsObjectNil(totolMoney)) {
            totolMoney = [[SAMoneyModel alloc] init];
            totolMoney.currencySymbol = goodsInfo.price.currencySymbol;
            totolMoney.cy = goodsInfo.price.cy;
        }
        //添加规格
        TNOrderSkuSpecifacationCellModel *specModel = [[TNOrderSkuSpecifacationCellModel alloc] init];
        specModel.spec = [goodsInfo.specificationValue componentsJoinedByString:@","];
        specModel.skuId = goodsInfo.skuId;
        specModel.price = goodsInfo.price;
        specModel.quantity = goodsInfo.quantity;
        specModel.thumbnail = goodsInfo.thumbnail;
        if ([goodsInfo isEqual:productItemArr.lastObject]) {
            specModel.lineHeight = 0.5f;
        }
        [arr addObject:specModel];

        lastItem = goodsInfo;
    }

    //共计%@商品  以及改价原因
    TNOrderDetailsGoodsSummarizeTableViewCellModel *summarizeModel = TNOrderDetailsGoodsSummarizeTableViewCellModel.new;
    summarizeModel.goodsQuantity = self.orderDetails.orderDetail.quantity.integerValue;
    summarizeModel.totalPrice = self.orderDetails.orderDetail.price;
    summarizeModel.storeNo = self.orderDetails.orderDetail.storeInfo.storeNo;
    if (self.orderDetails.orderDetail.isAdjustPrice) {
        summarizeModel.changeReason = self.orderDetails.orderDetail.adjustPriceRemark;
    }
    [arr addObject:summarizeModel];

    totolMoney.cent = [NSString stringWithFormat:@"%f", totolCent.doubleValue];
    //商品总额
    SAInfoViewModel *totolModel = [[SAInfoViewModel alloc] init];
    totolModel.keyText = TNLocalizedString(@"tn_page_total_amount_title", @"商品总额");
    totolModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    totolModel.keyColor = HDAppTheme.TinhNowColor.G2;
    if (isNeedCalculateTotalPrice) {
        totolModel.valueText = totolMoney.thousandSeparatorAmount;
    } else {
        totolModel.valueText = self.orderDetails.orderDetail.price.thousandSeparatorAmount;
    }
    totolModel.valueFont = HDAppTheme.TinhNowFont.standard15;
    totolModel.valueColor = HDAppTheme.TinhNowColor.R1;
    [arr addObject:totolModel];
}

//展示物流计费弹窗
- (void)showFreightCostsAlertView {
    if (!HDIsArrayEmpty(self.deliveryComponylist)) {
        TNDeliveryComponyModel *model;
        for (int i = 0; i < self.deliveryComponylist.count; i++) {
            TNDeliveryComponyModel *temp = self.deliveryComponylist[i];
            if ([temp.deliveryCorp isEqualToString:self.orderDetails.orderDetail.deliveryCorp]) {
                model = temp;
                break;
            }
        }
        TNDeliveryComponyAlertView *alertView = [[TNDeliveryComponyAlertView alloc] initWithTitle:TNLocalizedString(@"5JiVnZRY", @"物流计费标准") list:@[model] showTitle:false];
        [alertView show];
    } else {
        [self.view showloading];
        @HDWeakify(self);
        [self.productDTO queryFreightStandardCostsByStoreNo:self.orderDetails.orderInfo.storeNo success:^(NSArray<TNDeliveryComponyModel *> *_Nonnull list) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.deliveryComponylist = list;
            TNDeliveryComponyModel *model;
            for (int i = 0; i < self.deliveryComponylist.count; i++) {
                TNDeliveryComponyModel *temp = self.deliveryComponylist[i];
                if ([temp.deliveryCorp isEqualToString:self.orderDetails.orderDetail.deliveryCorp]) {
                    model = temp;
                    break;
                }
            }
            TNDeliveryComponyAlertView *alertView = [[TNDeliveryComponyAlertView alloc] initWithTitle:TNLocalizedString(@"5JiVnZRY", @"物流计费标准") list:@[model] showTitle:false];
            [alertView show];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}

- (void)cancalOrderWithOrderNo:(NSString *)orderNo completed:(void (^)(void))completed {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO cancelOrderWithOrderNo:orderNo success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completed) {
            completed();
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completed) {
            completed();
        }
    }];
}

- (void)cancelApplyRefundWithOrderNo:(NSString *)orderNo completed:(void (^)(void))completed {
    [self.view showloading];
    @HDWeakify(self);
    [self.refundDTO cancelApplyRefundWithOrderNo:orderNo success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completed) {
            completed();
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completed) {
            completed();
        }
    }];
}

- (void)confirmOrderWithOrderNo:(NSString *)orderNo completed:(void (^)(void))completed {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO confirmOrderWithOrderNo:orderNo success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completed) {
            completed();
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completed) {
            completed();
        }
    }];
}

- (void)rebuyOrderWithOrderNo:(NSString *)orderNo completed:(nonnull void (^)(NSArray *_Nonnull))completed {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO rebuyOrderWithOrderNo:orderNo success:^(NSArray *_Nonnull skuIds) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completed) {
            completed(skuIds);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)queryExchangeOrderExplainSuccess:(void (^_Nullable)(TNQueryExchangeOrderExplainRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.orderDTO exchangeOrderExplainSuccess:successBlock failure:failureBlock];
}

- (void)changeOrderAddressWithOrderNo:(NSString *)orderNo addressNo:(NSString *)addressNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.orderDTO changeOrderAddressWithOrderNo:orderNo addressNo:addressNo success:successBlock failure:failureBlock];
}
- (void)checkAdressIsOnTargetAreaWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude completed:(void (^)(void))completed {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO checkRegionAreaWithLatitude:latitude longitude:longitude storeNo:self.orderDetails.orderDetail.storeInfo.storeNo paymentMethod:self.orderDetails.orderDetail.paymentInfo.method
        scene:@"1" Success:^(TNCheckRegionModel *_Nonnull checkModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            if (checkModel.deliveryValid == YES) {
                !completed ?: completed();
            } else {
                if (checkModel.takeawayStore) {
                    //酒水店铺的提示
                    TNAdressChangeTipsAlertConfig *config = [TNAdressChangeTipsAlertConfig configWithCheckModel:checkModel.regionTipsInfoDTO isJustShow:YES];
                    TNAlertAction *doneAction = [TNAlertAction actionWithTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(TNAlertAction *_Nonnull action){
                    }];
                    config.actions = @[doneAction];
                    TNAdressChangeTipsAlertView *alertView = [TNAdressChangeTipsAlertView alertViewWithConfig:config];
                    [alertView show];
                } else {
                    [NAT showAlertWithMessage:HDIsStringNotEmpty(checkModel.tipsInfo) ? checkModel.tipsInfo : TNLocalizedString(@"tn_check_region_tip", @"商品仅配送至金边主城区，请修改收货地址")
                                  buttonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
                }
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
}
#pragma mark -
- (BOOL)canEdit:(TNOrderState)orderStatus {
    /// 等待付款、等待审核、等待发货 这三种状态可以修改 订单地址
    if ([orderStatus isEqualToString:TNOrderStatePendingPayment] || [orderStatus isEqualToString:TNOrderStatePendingReview] || [orderStatus isEqualToString:TNOrderStatePendingShipment] ||
        [orderStatus isEqualToString:TNOrderStateShipped]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -

/** @lazy orderDTO */
- (TNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[TNOrderDTO alloc] init];
    }
    return _orderDTO;
}

- (TNRefundDTO *)refundDTO {
    if (!_refundDTO) {
        _refundDTO = [[TNRefundDTO alloc] init];
    }
    return _refundDTO;
}
/** @lazy productDTO */
- (TNProductDTO *)productDTO {
    if (!_productDTO) {
        _productDTO = [[TNProductDTO alloc] init];
    }
    return _productDTO;
}
@end
