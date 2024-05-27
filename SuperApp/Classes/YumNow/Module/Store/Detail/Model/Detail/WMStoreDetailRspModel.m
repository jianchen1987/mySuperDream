//
//  WMStoreDetailRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailRspModel.h"
#import "WMStoreDetailPromotionModel.h"
@class IficationModel;


@implementation IficationModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"subClassifications": IficationModel.class,
    };
}
@end


@implementation WMStoreDetailRspModel

- (instancetype)init {
    if (self = [super init]) {
        self.numberOfLinesOfPromotion = -1;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"businessScopes": SAInternationalizationModel.class,
        @"promotions": WMStoreDetailPromotionModel.class,
        @"businessScopesV2": IficationModel.class,
    };
}

- (NSInteger)shouGiveCouponActivity {
    __block NSInteger result = 0;
    [self.promotions enumerateObjectsUsingBlock:^(WMStoreDetailPromotionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.marketingType == WMStorePromotionMarketingTypeCoupon && obj.isStoreCoupon && !HDIsArrayEmpty(obj.storeCouponActivitys.coupons)) {
            result = 1;
            if (obj.storeCouponActivitys.isReceive && !obj.storeCouponActivitys.hasCouponReceive) { ///查看
                result = 2;
            }
        }
    }];
    _shouGiveCouponActivity = result;
    return _shouGiveCouponActivity;
}

- (NSString *)showDeliveryStr {
    if (!_showDeliveryStr) {
        NSString *fee = @"";
        if (self.deliveryFee.cent.doubleValue > 0) {
            SAMoneyModel *allMoney = SAMoneyModel.new;
            allMoney.cy = self.deliveryFee.cy;
            SAMoneyModel *disMoney = nil;
            BOOL hasDeleviryActivity = NO;
            for (WMStoreDetailPromotionModel *proModel in self.promotions) {
                if (proModel.marketingType == WMStorePromotionMarketingTypeDelievry) {
                    hasDeleviryActivity = YES;
                    if (!HDIsArrayEmpty(proModel.ladderRules)) {
                        NSArray *proArr = [proModel.ladderRules hd_filterWithBlock:^BOOL(WMStoreLadderRuleModel *_Nonnull item) {
                            return item.preferentialRatio > 0;
                        }];
                        if (proArr.count > 0) {
                            for (WMStoreLadderRuleModel *ladderModel in proArr) {
                                if (self.distance >= ladderModel.startDistance * 1000 && self.distance <= ladderModel.endDistance * 1000) {
                                    disMoney = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", self.deliveryFee.cent.integerValue * ladderModel.preferentialRatio / 100]
                                                                    currency:self.deliveryFee.cy];
                                    break;
                                }
                            }
                        } else {
                            disMoney = proModel.ladderRules.firstObject.discountAmt;
                        }
                    }
                }
            }
            ///有减配活动
            if (hasDeleviryActivity) {
                ///减配送费
                if (disMoney && disMoney.cent.doubleValue) {
                    NSInteger cent = MAX(0, self.deliveryFee.cent.integerValue - disMoney.cent.integerValue);
                    allMoney.cent = [NSString stringWithFormat:@"%zd", cent];
                    if (cent == 0) {
                        fee = WMLocalizedString(@"free_delivery", @"免配送费");
                    } else {
                        fee = [NSString stringWithFormat:@"%@ %@", allMoney.thousandSeparatorAmount, WMLocalizedString(@"delivery_fee", @"Delivery Fee")];
                    }
                } else { ///免配送费
                    fee = WMLocalizedString(@"free_delivery", @"免配送费");
                }
            } else {
                fee = [NSString stringWithFormat:@"%@ %@", self.deliveryFee.thousandSeparatorAmount, WMLocalizedString(@"delivery_fee", @"Delivery Fee")];
            }
        } else {
            fee = WMLocalizedString(@"free_delivery", @"免配送费");
        }
        _showDeliveryStr = fee;
    }
    return _showDeliveryStr;
}

@end
