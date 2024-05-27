//
//  WMPromotionLabel.m
//  SuperApp
//
//  Created by Chaos on 2020/9/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMPromotionLabel.h"
#import "WMAppTheme.h"
#import "WMStoreDetailPromotionModel.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import "SAAppTheme.h"


@implementation WMPromotionLabel

+ (WMUIButton *)createFastServiceBtn {
    return [self createBtnWithBackGroundColor:HDAppTheme.WMColor.mainRed titleColor:UIColor.whiteColor title:WMLocalizedString(@"wm_later_to_pay", @"慢必赔") alpha:1];
}

+ (WMUIButton *)createWMFastServiceBtn {
    WMUIButton *button = WMUIButton.new;
    button.userInteractionEnabled = false;
    [button setTitleColor:HDAppTheme.color.mainOrangeColor forState:UIControlStateNormal];
    [button setTitle:WMLocalizedString(@"wm_fast_service", @"极速服务") forState:UIControlStateNormal];
    button.titleLabel.font = HDAppTheme.font.standard5Bold;
    button.layer.backgroundColor = HexColor(0xFFECDC).CGColor;
    button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    [button sizeToFit];
    // 根据button高度重新设置左边距
    button.titleEdgeInsets = UIEdgeInsetsMake(5, button.height + 5, 5, 10);
    [button sizeToFit];

    UIView *rightView = UIView.new;
    rightView.alpha = 0.82;
    rightView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight radius:CGRectGetHeight(precedingFrame) / 2];
        button.layer.cornerRadius = CGRectGetHeight(precedingFrame) / 2;
        [view setGradualChangingColorFromColor:HexColor(0xFC4A1A) toColor:HexColor(0xF7B733) startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)];
    };
    [button addSubview:rightView];
    [rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(button);
        make.width.mas_equalTo(button.height);
    }];

    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_fast_service"]];
    [rightView addSubview:logoIV];
    [logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView).offset(1);
        make.centerY.equalTo(rightView).offset(1);
    }];

    @HDWeakify(button);
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationNameLanguageChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        @HDStrongify(button);
        [button setTitle:WMLocalizedString(@"wm_fast_service", @"极速服务") forState:UIControlStateNormal];
    }];

    return button;
}

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title {
    return [self createBtnWithBackGroundColor:bgColor titleColor:titleColor title:title alpha:0.1];
}

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title alpha:(CGFloat)alpha {
    return [self createBtnWithBackGroundColor:bgColor titleColor:titleColor title:title alpha:alpha border:nil];
}

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title alpha:(CGFloat)alpha border:(nullable UIColor *)borderColor {
    WMUIButton *button = WMUIButton.new;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:11];
    button.layer.backgroundColor = [UIColor colorWithRed:bgColor.hd_red green:bgColor.hd_green blue:bgColor.hd_blue alpha:alpha].CGColor;
    button.layer.cornerRadius = 2;
    button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
    if (borderColor) {
        button.layer.borderColor = borderColor.CGColor;
        button.layer.borderWidth = 0.5 * (kWidthCoefficientTo6S);
        button.layer.cornerRadius = 2;
        button.layer.backgroundColor = [UIColor colorWithRed:bgColor.hd_red green:bgColor.hd_green blue:bgColor.hd_blue alpha:alpha].CGColor;
    }
    [button sizeToFit];
    return button;
}

+ (WMUIButton *)createBtnWithTitle:(NSString *)title {
    WMUIButton *button = WMUIButton.new;
    [button setTitleColor:[UIColor hd_colorWithHexString:@"#F8647A"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:11];
    button.layer.cornerRadius = 2;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor hd_colorWithHexString:@"#F8647A"].CGColor;
    button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(4), kRealWidth(3), kRealWidth(4));
    [button sizeToFit];
    return button;
}

+ (WMUIButton *)createFastServiceBtnWithNewStyle {
    WMUIButton *button = WMUIButton.new;
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:WMLocalizedString(@"wm_later_to_pay", @"慢必赔") forState:UIControlStateNormal];
    button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:11];
    button.backgroundColor = HDAppTheme.WMColor.mainRed;
    button.layer.cornerRadius = 2;
    //    button.layer.borderWidth = 0.5;
    //    button.layer.borderColor = [UIColor hd_colorWithHexString:@"#F8647A"].CGColor;
    button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(4), kRealWidth(3), kRealWidth(4));
    [button sizeToFit];
    return button;
    //    return [self createBtnWithBackGroundColor:HDAppTheme.WMColor.mainRed titleColor:UIColor.whiteColor title:WMLocalizedString(@"wm_later_to_pay", @"慢必赔") alpha:1];
}

+ (BOOL)showToastWithMaxCount:(NSUInteger)maxCount currentCount:(NSUInteger)currentCount otherSkuCount:(NSUInteger)otherSkuCount promotions:(NSArray<WMStoreDetailPromotionModel *> *)promotions {
    if (maxCount <= 0) {
        return NO;
    }
    __block BOOL hasBestSalePromotion = false;
    __block BOOL hasMutexPromotion = false;
    [promotions enumerateObjectsUsingBlock:^(WMStoreDetailPromotionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.marketingType == WMStorePromotionMarketingTypeBestSale) {
            hasBestSalePromotion = true;
        } else if (obj.marketingType == WMStorePromotionMarketingTypeLabber || obj.marketingType == WMStorePromotionMarketingTypeStoreLabber
                   || obj.marketingType == WMStorePromotionMarketingTypeDiscount) {
            hasMutexPromotion = true;
        }
    }];
    // 未参与爆款活动，参与了其他与爆款互斥的活动时，弹窗提示
    if (!hasBestSalePromotion && hasMutexPromotion) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"best_sale_can_not_use_with_other_promotion", @"Can not be used with other offer.") type:HDTopToastTypeInfo];
        return NO;
    }

    if (currentCount + otherSkuCount == maxCount + 1) {
        [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"668ZBMsK", @"Only %zd items can enjoy discounted prices."), maxCount] type:HDTopToastTypeInfo];
        return NO;
    } else if (currentCount + otherSkuCount > maxCount + 1 && otherSkuCount <= maxCount) {
        return YES;
    }
    return NO;
}

@end
