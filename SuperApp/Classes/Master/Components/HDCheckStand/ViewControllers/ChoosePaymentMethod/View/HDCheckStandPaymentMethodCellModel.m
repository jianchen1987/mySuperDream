//
//  HDCheckStandPaymentMethodCellModel.m
//  SuperApp
//
//  Created by VanJay on 2020/9/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandPaymentMethodCellModel.h"
#import "HDCheckStandEnum.h"
#import "HDOnlinePaymentToolsModel.h"
#import "HDPaymentMethodType.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "SAWalletBalanceModel.h"


@implementation HDCheckStandPaymentMethodCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.textFont = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        self.textColor = HDAppTheme.color.G1;
        self.subTitleFont = HDAppTheme.font.standard4;
        self.subTitleColor = HDAppTheme.color.G3;
        self.selectedImage = [UIImage imageNamed:@"chckstand_selected"];
        self.unselectedImage = [UIImage imageNamed:@"chckstand_unselected"];
        self.isSelected = NO;
    }
    return self;
}

#pragma mark - public methods
+ (HDCheckStandPaymentMethodCellModel *)modelWithPaymentMethodModel:(HDPaymentMethodType *)model {
    CGFloat imageWidth = 40;
    HDCheckStandPaymentMethodCellModel *cellModel = HDCheckStandPaymentMethodCellModel.new;
    cellModel.isUsable = true;
    cellModel.associatedObject = model;
    cellModel.paymentMethod = model.method;

    cellModel.isShow = YES;

    if (model.method == SAOrderPaymentTypeCashOnDelivery) {
        cellModel.text = SALocalizedString(@"5K8ZBMsK", @"货到付款");
        UIImage *image = [UIImage imageNamed:@"payment_method_cashOnDelivery"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
    } else if (model.method == SAOrderPaymentTypeCashOnDeliveryForbidden) {
        cellModel.text = SALocalizedString(@"5K8ZBMsK", @"货到付款");
        UIImage *image = [UIImage imageNamed:@"payment_method_cashOnDelivery"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
        cellModel.subTitle = WMLocalizedString(@"wm_pickup_tips07", @"不支持货到付款");
        cellModel.isShow = NO;
    } else if (model.method == SAOrderPaymentTypeCashOnDeliveryForbiddenByToStore) {
        cellModel.text = SALocalizedString(@"5K8ZBMsK", @"货到付款");
        UIImage *image = [UIImage imageNamed:@"payment_method_cashOnDelivery"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
        cellModel.subTitle = WMLocalizedString(@"wm_pickup_tips02", @"到店自取订单不支持货到付款");
        cellModel.isShow = NO;
    } else if (model.method == SAOrderPaymentTypeTransfer) {
        cellModel.text = SALocalizedString(@"payment_method_offline_transfer", @"线下转账");
        UIImage *image = [UIImage imageNamed:@"payment_method_offlineTransfer"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
    } else if (model.method == SAOrderPaymentTypeQRCode) {
        cellModel.text = SALocalizedString(@"pay_khqr_KHQR​_Scan_Pay", @"KHQR扫码支付");
        UIImage *image = [UIImage imageNamed:@"payment_method_khqr"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
    } else {
        cellModel = nil;
    }

    return cellModel;
}

+ (HDCheckStandPaymentMethodCellModel *)modelWithPaymentMethodModel:(HDPaymentMethodType *)model balance:(SAWalletBalanceModel *)balanceRspModel payAmount:(SAMoneyModel *)payAmount {
    CGFloat imageWidth = 40;
    HDCheckStandPaymentMethodCellModel *cellModel = HDCheckStandPaymentMethodCellModel.new;
    cellModel.isUsable = true;

    HDCheckStandPaymentTools toolCode = model.toolCode;

    cellModel.toolCode = toolCode;
    cellModel.paymentMethod = SAOrderPaymentTypeOnline;
    cellModel.text = model.toolName;
    cellModel.icon = model.icon;
    cellModel.subIcon = model.subIcon;
    cellModel.subToolName = model.subToolName;

    cellModel.isShow = model.isShow;


    if ([toolCode isEqualToString:HDCheckStandPaymentToolsWechat]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"pay_wechat", @"微信");
        UIImage *image = [UIImage imageNamed:@"payment_method_wechat"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsAlipay]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"pay_alipay", @"支付宝");
        cellModel.image = nil;
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsCredit]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"pay_credit", @"Credit/Debit Card");
        UIImage *image = [UIImage imageNamed:@"payment_method_credit"];
        cellModel.image = image;
        //        cellModel.subImageNames = @[ @"checkstand_credit_bottom" ];
        cellModel.subImageNames = @[@"checkstand_credit_bottom1"];
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsABAPay]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"pay_ABAPay", @"ABA Pay");
        UIImage *image = [UIImage imageNamed:@"payment_method_aba"];
        cellModel.image = image;
        cellModel.subTitle = SALocalizedString(@"pay_aba_mobile", @"Tap to pay with ABA Mobile");
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsWing]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"pay_wing", @"Wing Bank");
        UIImage *image = [UIImage imageNamed:@"payment_method_wing"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, (image.size.height / image.size.width * imageWidth) < 30 ? 30 : (image.size.height / image.size.width * imageWidth));
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsPrince]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"pay_prince_bank", @"太子银行");
        UIImage *image = [UIImage imageNamed:@"payment_method_prince"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
#if !TARGET_IPHONE_SIMULATOR
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsHuiOneV2]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"", @"汇旺");
        UIImage *image = [UIImage imageNamed:@"payment_method_wechat"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
#endif
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsACLEDABank]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"", @"ACLEDA Bank");
        UIImage *image = [UIImage imageNamed:@"payment_method_acledaBank"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsABAKHQR]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"", @"ABA KHQR");
        UIImage *image = [UIImage imageNamed:@"payment_method_aba_khqr"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
        
    } else if([toolCode isEqualToString:HDCheckStandPaymentToolsSmartPay]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"", @"SmartPay");
        UIImage *image = [UIImage imageNamed:@"payment_method_credit"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
        
    }
//    else if([toolCode isEqualToString:HDCheckStandPaymentToolsAlipayPlus]) {
//        if (!cellModel.text.length)
//            cellModel.text = SALocalizedString(@"", @"SmartPay");
//        UIImage *image = [UIImage imageNamed:@"payment_method_credit"];
//        cellModel.image = image;
//        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
//        
//    }
    else if ([toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) {
        if (!cellModel.text.length)
            cellModel.text = SALocalizedString(@"wallet", @"钱包");
        UIImage *image = [UIImage imageNamed:@"payment_method_balance"];
        cellModel.image = image;
        cellModel.imageSize = CGSizeMake(imageWidth, image.size.height / image.size.width * imageWidth);
        if (balanceRspModel && balanceRspModel.walletCreated) {
            if ([balanceRspModel.accountStatus isEqualToString:PNWAlletAccountStatusNotActive]) {
                cellModel.subTitle = PNLocalizedString(@"pn_to_be_activated", @"已注册未激活");
                cellModel.isUsable = false;
            } else {
                if (payAmount && (payAmount.cent.doubleValue > balanceRspModel.amountBalance.cent.doubleValue)) {
                    cellModel.isUsable = false;
                }
                cellModel.subTitle = [NSString stringWithFormat:@"%@: %@", SALocalizedString(@"pay_Dollar_Balance", @"美元余额"), balanceRspModel.balance.thousandSeparatorAmount];
                cellModel.subSubTitle = [NSString stringWithFormat:@"%@: %@(=%@)",
                                                                   SALocalizedString(@"pay_Riels_Balance", @"瑞尔余额"),
                                                                   balanceRspModel.khrBalance.thousandSeparatorAmount,
                                                                   balanceRspModel.exchangedBalance.thousandSeparatorAmount];
            }
        } else {
            cellModel.subTitle = SALocalizedString(@"open_balance", @"点击开通钱包");
            cellModel.isUsable = false;
        }
    } else {
        // 过滤不支持的
        cellModel = nil;
    }

    return cellModel;
}

@end
