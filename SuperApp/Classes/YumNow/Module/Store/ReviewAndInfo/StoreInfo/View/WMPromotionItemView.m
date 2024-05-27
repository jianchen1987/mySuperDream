//
//  WMPromotionItemView.m
//  SuperApp
//
//  Created by Chaos on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMPromotionItemView.h"


@interface WMPromotionItemView ()

/// 标题
@property (nonatomic, strong) HDUIButton *titleBTN;
/// 内容
@property (nonatomic, strong) YYLabel *contentLabel;

@end


@implementation WMPromotionItemView

- (void)hd_setupViews {
    [self addSubview:self.titleBTN];
    [self addSubview:self.contentLabel];
}

- (void)updateConstraints {
    [self.titleBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleBTN.isHidden) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(kRealWidth(20));
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(kRealWidth(-5));
        }
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleBTN.isHidden) {
            make.top.equalTo(self.titleBTN);
            make.left.equalTo(self.titleBTN.mas_right).offset(kRealWidth(8));
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(kRealWidth(-5));
        } else {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(0);
        }
        make.right.equalTo(self.mas_right);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.titleBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

#pragma mark - public methods
- (void)setColor:(UIColor *)color title:(NSString *)title {
    self.titleBTN.backgroundColor = color;
    if ([title isKindOfClass:NSAttributedString.class]) {
        [self.titleBTN setAttributedTitle:(id)title forState:UIControlStateNormal];
    } else {
        [self.titleBTN setTitle:[NSString stringWithFormat:@" %@ ", title] forState:UIControlStateNormal];
    }
}

- (void)setGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor title:(NSString *)title imageName:(NSString *)imageName {
    [self.titleBTN setTitle:[NSString stringWithFormat:@" %@ ", title] forState:UIControlStateNormal];
    [self.titleBTN setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.titleBTN.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 3);
    self.titleBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        [view setGradualChangingColorFromColor:fromColor toColor:toColor];
    };
}

#pragma mark - setter
- (void)setShowTips:(NSString *)showTips {
    _showTips = showTips;
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        self.contentLabel.textColor = HDAppTheme.WMColor.B6;
        self.contentLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
    } else {
        self.contentLabel.textColor = HDAppTheme.WMColor.B9;
        self.contentLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
    }
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.hd_width;
    if ([showTips isKindOfClass:NSAttributedString.class]) {
        self.contentLabel.attributedText = (id)self.showTips;
    } else {
        self.contentLabel.text = self.showTips;
    }
}

- (void)setItemType:(WMStorePromotionMarketingType)itemType {
    _itemType = itemType;

    UIColor *bgColor = HDAppTheme.WMColor.mainRed;
    NSString *title = nil;
    UIImage *image = [UIImage imageNamed:@"yn_submit_FRO"];
    switch (self.itemType) {
        case WMStorePromotionMarketingTypeDiscount:
            title = WMLocalizedString(@"item_discount", @"Discount");
            break;
        case WMStorePromotionMarketingTypeLabber:
        case WMStorePromotionMarketingTypeStoreLabber:
            title = WMLocalizedString(@"item_money_off", @"满减");
            break;
        case WMStorePromotionMarketingTypeDelievry:
            bgColor = HexColor(0x21C348);
            title = WMLocalizedString(@"item_delivery", @"Delivery");
            break;
        case WMStorePromotionMarketingTypeFirst:
            bgColor = HexColor(0xFFB800);
            title = WMLocalizedString(@"item_1st_order", @"1st Order");
            image = [UIImage imageNamed:@"yn_submit_FOD"];
            break;
        case WMStorePromotionMarketingTypeCoupon:
            title = WMLocalizedString(@"order_detail_coupon_ticket", @"Coupon");
            break;
        case WMStorePromotionMarketingTypeFillGift:
            bgColor = HexColor(0x72ADFF);
            title = WMLocalizedString(@"wm_fill_gift_name", @"满赠");
            break;

        case WMStorePromotionMarketingTypePromoCode:
            title = WMLocalizedString(@"OkaO8L5F", @"优惠码");
            break;
        default:
            break;
    }
    self.showImage = image;
    [self setColor:bgColor title:title];
}

- (void)setHideLeftBTN:(BOOL)hideLeftBTN {
    _hideLeftBTN = hideLeftBTN;
    self.titleBTN.hidden = hideLeftBTN;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)titleBTN {
    if (!_titleBTN) {
        _titleBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _titleBTN.userInteractionEnabled = false;
        _titleBTN.adjustsButtonWhenHighlighted = NO;
        _titleBTN.backgroundColor = HDAppTheme.WMColor.mainRed;
        _titleBTN.titleLabel.font = HDAppTheme.font.standard4;
        [_titleBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _titleBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _titleBTN;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
