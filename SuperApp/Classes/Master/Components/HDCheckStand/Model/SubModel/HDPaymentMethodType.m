//
//  HDPaymentMethodType.m
//  SuperApp
//
//  Created by seeu on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDPaymentMethodType.h"


@interface HDPaymentMethodType ()

@property (nonatomic, copy) NSString *payToolName;

@end


@implementation HDPaymentMethodType

+ (instancetype)onlineMethodWithPaymentTool:(HDCheckStandPaymentTools)toolCode {
    return [self onlineMethodWithPaymentTool:toolCode marketing:nil];
}

+ (instancetype)onlineMethodWithPaymentTool:(HDCheckStandPaymentTools)toolCode marketing:(NSArray<NSString *> *)marking {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeOnline;
    model.toolCode = toolCode;
    model.marketing = [marking copy];
    return model;
}

+ (instancetype)onlineMethodWithPaymentModel:(HDOnlinePaymentToolsModel *)paymentModel {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeOnline;
    model.toolCode = paymentModel.vipayCode;
    model.marketing = [paymentModel.marketing copy];
    model.payToolName = paymentModel.payToolNameDTO.desc;
    model.subIcon = paymentModel.subIcon;
    model.icon = paymentModel.icon;
    model.subToolName = paymentModel.subTitleDTO.desc;
    model.isShow = paymentModel.isShow;
    return model;
}

+ (instancetype)online {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeOnline;
    return model;
}

+ (instancetype)cashOnDelivery {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeCashOnDelivery;
    return model;
}
+ (instancetype)cashOnTransfer {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeTransfer;
    return model;
}

+ (instancetype)cashOnDeliveryForbidden {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeCashOnDeliveryForbidden;
    return model;
}

+ (instancetype)cashOnDeliveryForbiddenByToStore {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeCashOnDeliveryForbiddenByToStore;
    return model;
}

+ (instancetype)qrCodePay {
    HDPaymentMethodType *model = HDPaymentMethodType.new;
    model.method = SAOrderPaymentTypeCashOnDeliveryForbiddenByToStore;
    return model;
}

- (NSString *)toolName {
    if (self.method == SAOrderPaymentTypeTransfer) {
        return SALocalizedString(@"payment_method_offline_transfer", @"线下转账");
    } else if (self.method == SAOrderPaymentTypeCashOnDelivery) {
        return SALocalizedString(@"5K8ZBMsK", @"货到付款");
    } else if (self.method == SAOrderPaymentTypeCashOnDeliveryForbidden) {
        return SALocalizedString(@"5K8ZBMsK", @"货到付款");
    } else if (self.method == SAOrderPaymentTypeCashOnDeliveryForbiddenByToStore) {
        return SALocalizedString(@"5K8ZBMsK", @"货到付款");
    } else if (self.method == SAOrderPaymentTypeQRCode) {
        return SALocalizedString(@"pay_khqr_KHQR​_Scan_Pay", @"KHQR扫码支付");

    } else if (self.method == SAOrderPaymentTypeOnline) {
        if (HDIsStringNotEmpty(self.payToolName))
            return self.payToolName;

        if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsWechat]) {
            return SALocalizedString(@"pay_wechat", @"微信");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsAlipay]) {
            return SALocalizedString(@"pay_alipay", @"支付宝");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsCredit]) {
            return SALocalizedString(@"pay_credit", @"Credit/Debit Card");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsABAPay]) {
            return SALocalizedString(@"pay_ABAPay", @"ABA Pay");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsWing]) {
            return SALocalizedString(@"pay_wing", @"Wing Bank");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) {
            return SALocalizedString(@"wallet", @"钱包");
        }
#if !TARGET_IPHONE_SIMULATOR
        else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsPrince]) {
            return SALocalizedString(@"pay_prince_bank", @"太子银行");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsHuiOneV2]) {
            return SALocalizedString(@"", @"汇旺");
        }
#endif
        else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsACLEDABank]) {
            return SALocalizedString(@"", @"ACLEDA Bank");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsABAKHQR]) {
            return SALocalizedString(@"", @"ABA KHQR");
        } else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsSmartPay]) {
            return SALocalizedString(@"", @"SmartPay");
        }
//        else if ([self.toolCode isEqualToString:HDCheckStandPaymentToolsAlipayPlus]) {
//            return SALocalizedString(@"", @"Alipay+");
//        }
    }
    return @"";
}

@end
