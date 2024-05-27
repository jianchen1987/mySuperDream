//
//  GNOrderCellModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderCellModel.h"
#import "GNEnum.h"
#import "GNMultiLanguageManager.h"


@implementation GNQrCodeInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"codeState": GNMessageCode.class,
        @"cancelState": GNMessageCode.class,
    };
}

- (NSString *)codeStateStr {
    if (!_codeStateStr) {
        if (self.codeState && self.codeState.codeId && [self.codeState.codeId isKindOfClass:NSString.class]) {
            if ([self.codeState.codeId isEqualToString:GNOrderCodeStateUse]) {
                _codeStateStr = GNLocalizedString(@"gn_order_unuse", @"gn_order_unuse");
            } else if ([self.codeState.codeId isEqualToString:GNOrderCodeStateCancel]) {
                _codeStateStr = GNLocalizedString(@"gn_order_canced", @"gn_order_canced");
            } else if ([self.codeState.codeId isEqualToString:GNOrderCodeStateFinish]) {
                _codeStateStr = GNLocalizedString(@"gn_code_used", @"gn_code_used");
            } else if ([self.codeState.codeId isEqualToString:GNOrderCodeStateUnPay]) {
                _codeStateStr = GNLocalizedString(@"gn_pending_payment", @"待付款");
            } else {
                _codeStateStr = self.codeState.message ?: @"";
            }
        } else {
            _codeStateStr = @"";
        }
    }
    return _codeStateStr;
}

@end


@implementation GNOrderCellModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"neCancelState": @"newCancelState"};
}

- (void)setQrCodeInfo:(NSArray<GNQrCodeInfo *> *)qrCodeInfo {
    _qrCodeInfo = qrCodeInfo;
    if (!HDIsArrayEmpty(qrCodeInfo)) {
        self.unuseCount = 0;
        for (GNQrCodeInfo *qrInfo in qrCodeInfo) {
            if ([qrInfo.codeState.codeId isEqualToString:GNOrderStatusUse] || [qrInfo.codeState.codeId isEqualToString:GNOrderStatusUnPay]) {
                if (!self.firstUnUseCode) {
                    self.firstUnUseCode = qrInfo;
                }
                self.unuseCount++;
            }
        }
    }
}

- (NSString *)bitStateStr {
    if (!_bitStateStr) {
        if (self.bizState && self.bizState.codeId && [self.bizState.codeId isKindOfClass:NSString.class]) {
            if ([self.bizState.codeId isEqualToString:GNOrderStatusUse]) {
                _bitStateStr = GNLocalizedString(@"gn_order_unuse", @"gn_order_unuse");
            } else if ([self.bizState.codeId isEqualToString:GNOrderStatusFinish]) {
                _bitStateStr = GNLocalizedString(@"gn_order_finish", @"gn_order_finish");
            } else if ([self.bizState.codeId isEqualToString:GNOrderStatusCancel]) {
                _bitStateStr = GNLocalizedString(@"gn_order_canced", @"gn_order_canced");
            } else if ([self.bizState.codeId isEqualToString:GNOrderStatusUnPay]) {
                _bitStateStr = GNLocalizedString(@"gn_to_pay", @"去付款");
            } else {
                _bitStateStr = self.bizState.message ?: @"";
            }
        } else {
            _bitStateStr = @"";
        }
    }
    return _bitStateStr;
}

- (NSString *)bitStateImageStr {
    if (!_bitStateImageStr) {
        if (self.bizState && self.bizState.codeId && [self.bizState.codeId isKindOfClass:NSString.class]) {
            if ([self.bizState.codeId isEqualToString:GNOrderStatusUse]) {
                _bitStateImageStr = @"gn_order_icon_use";
            } else if ([self.bizState.codeId isEqualToString:GNOrderStatusFinish]) {
                _bitStateImageStr = @"gn_order_icon_finish";
            } else if ([self.bizState.codeId isEqualToString:GNOrderStatusCancel]) {
                _bitStateImageStr = @"gn_order_icon_cancel";
            } else if ([self.bizState.codeId isEqualToString:GNOrderStatusUnPay]) {
                _bitStateImageStr = @"gn_order_icon_pay";
            }
        }
    }
    return _bitStateImageStr;
}

- (NSString *)refundStr {
    if (!_refundStr) {
        if (self.refundState && self.refundState.codeId && [self.refundState.codeId isKindOfClass:NSString.class]) {
            if ([self.refundState.codeId isEqualToString:GNOrderRefundStatusIng]) {
                _refundStr = GNLocalizedString(@"gn_refund_ing", @"gn_refund_ing");
            } else if ([self.refundState.codeId isEqualToString:GNOrderRefundStatusWait]) {
                _refundStr = GNLocalizedString(@"gn_refund_penging", @"gn_refund_penging");
            } else if ([self.refundState.codeId isEqualToString:GNOrderRefundStatusFinidh]) {
                _refundStr = GNLocalizedString(@"gn_refund_finish", @"gn_refund_finish");
            } else {
                _refundStr = self.refundState.message ?: @"";
            }
        } else {
            _refundStr = @"";
        }
    }

    return _refundStr;
}

- (NSString *)paymentMethodStr {
    if (!_paymentMethodStr) {
        if (self.paymentMethod && self.paymentMethod.codeId && [self.paymentMethod.codeId isKindOfClass:NSString.class]) {
            if ([self.paymentMethod.codeId isEqualToString:GNPayMetnodTypeAll]) {
                _paymentMethodStr = GNLocalizedString(@"gn_fail_reason_user", @"gn_fail_reason_user");
            } else if ([self.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline]) {
                _paymentMethodStr = GNLocalizedString(@"gn_pay_online", @"gn_pay_online");
            } else if ([self.paymentMethod.codeId isEqualToString:GNPayMetnodTypeCash]) {
                _paymentMethodStr = GNLocalizedString(@"gn_order_cash", @"gn_order_cash");
            } else {
                _paymentMethodStr = self.paymentMethod.message ?: @"";
            }
        } else {
            _paymentMethodStr = @"";
        }
    }
    return _paymentMethodStr;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productInfo": GNProductModel.class, @"merchantInfo": GNStoreCellModel.class, @"qrCodeInfo": GNQrCodeInfo.class, @"type": GNMessageCode.class, @"bizState": GNMessageCode.class};
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellClass = NSClassFromString(@"GNOrderTableViewCell");
    }
    return self;
}

@end
