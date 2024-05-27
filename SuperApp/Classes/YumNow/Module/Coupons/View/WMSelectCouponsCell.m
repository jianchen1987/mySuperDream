//
//  WMSelectCouponsCell.m
//  SuperApp
//
//  Created by wmz on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSelectCouponsCell.h"
#import "GNTheme.h"
#import "SAGeneralUtil.h"


@interface WMSelectCouponsCell ()
///标签
@property (nonatomic, strong) HDLabel *tagLb;
///券背景
@property (nonatomic, strong) UIView *bgView;
///背景图片
@property (nonatomic, strong) UIImageView *bgIV;
///选中按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// money
@property (nonatomic, strong) YYLabel *moneyLB;
/// title
@property (nonatomic, strong) HDLabel *titleLB;
/// time
@property (nonatomic, strong) HDLabel *timeLB;
///不可用视图
@property (nonatomic, strong) UIView *unavaiableBg;
///不可用文本
@property (nonatomic, strong) HDLabel *unavaiableTitleLB;
///不可用原因
@property (nonatomic, strong) HDLabel *unavaiableReasonLB;
///展开按钮
@property (nonatomic, strong) HDUIButton *openBTN;
///遮罩
@property (nonatomic, strong) UIView *shadomView;
///渐变图层
@property (nonatomic, strong) UIView *customMaskView;

@end


@implementation WMSelectCouponsCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.bgIV];
    [self.bgView addSubview:self.tagLb];
    [self.bgView addSubview:self.selectBTN];
    [self.bgView addSubview:self.moneyLB];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.timeLB];
    [self.bgView sendSubviewToBack:self.bgIV];
    [self.contentView addSubview:self.unavaiableBg];
    [self.unavaiableBg addSubview:self.customMaskView];
    [self.unavaiableBg addSubview:self.unavaiableTitleLB];
    [self.unavaiableBg addSubview:self.unavaiableReasonLB];
    [self.unavaiableBg addSubview:self.openBTN];
    [self.contentView addSubview:self.shadomView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(12));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(0);
    }];

    [self.shadomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.shadomView.isHidden) {
            make.left.top.bottom.equalTo(self.bgView);
            make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(56));
        }
    }];

    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.tagLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
    }];

    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(16));
        make.centerY.mas_equalTo(0);
    }];

    [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(14));
        make.top.equalTo(self.tagLb.mas_bottom).offset(kRealWidth(14));
        make.right.equalTo(self.selectBTN.mas_left).offset(-kRealWidth(28));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLB.mas_bottom).offset(kRealWidth(4));
        make.left.right.equalTo(self.moneyLB);
    }];
    self.titleLB.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {

    };

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(6));
        make.left.right.equalTo(self.moneyLB);
        make.bottom.mas_equalTo(-kRealWidth(15));
    }];

    [self.unavaiableBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.unavaiableBg.isHidden) {
            make.left.mas_equalTo(kRealWidth(18));
            make.right.mas_equalTo(-kRealWidth(18));
            make.top.equalTo(self.bgView.mas_bottom);
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.unavaiableTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.unavaiableBg.isHidden) {
            make.left.mas_equalTo(kRealWidth(13));
            make.top.mas_equalTo(kRealWidth(8));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
        }
    }];

    [self.unavaiableReasonLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.unavaiableBg.isHidden) {
            if (self.model.isOpen) {
                make.left.equalTo(self.unavaiableTitleLB);
                make.right.mas_equalTo(-kRealWidth(12));
                make.top.equalTo(self.unavaiableTitleLB.mas_bottom).offset(kRealWidth(2));
            } else {
                make.left.equalTo(self.unavaiableTitleLB.mas_right).offset(kRealWidth(4));
                make.right.equalTo(self.openBTN.mas_left).offset(-kRealWidth(8));
                make.top.equalTo(self.unavaiableTitleLB);
            }
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
        }
    }];

    [self.openBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.unavaiableBg.isHidden) {
            make.right.mas_equalTo(-kRealWidth(12));
            make.centerY.equalTo(self.unavaiableTitleLB);
        }
    }];

    [self.customMaskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.customMaskView.isHidden) {
            make.left.right.top.equalTo(self.unavaiableBg);
            make.height.mas_equalTo(kRealWidth(12));
        }
    }];

    [self.selectBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.selectBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.openBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.openBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [self.titleLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];

    [self.unavaiableTitleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.unavaiableTitleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setGNModel:(WMOrderSubmitCouponModel *)data {
    self.model = data;
    if(data.activitySubject == WMPromotionSubjectTypeMerchant){
        self.tagLb.text = SALocalizedString(@"coupon_match_StoreCoupon", @"门店券");
    }else{
        self.tagLb.text = SALocalizedString(@"coupon_match_APPCoupon", @"平台券");
    }

    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *money = [[NSMutableAttributedString alloc] initWithString:data.couponMoney.thousandSeparatorAmount];
    money.yy_color = HDAppTheme.WMColor.mainRed;
    money.yy_font = [HDAppTheme.WMFont wm_ForMoneyDinSize:32];
    [money addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14]} range:[money.string rangeOfString:data.couponMoney.currencySymbol]];
    [titleStr appendAttributedString:money];

    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                      attachmentSize:CGSizeMake(kRealWidth(2), 1)
                                                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                                                           alignment:YYTextVerticalAlignmentCenter];
    [titleStr appendAttributedString:spaceText];
    NSString *lableStr = @"";
    if (data.thresholdMoney.cent.doubleValue == 0) {
        lableStr = SALocalizedString(@"no_threshold", @"无门槛");
    } else {
        lableStr = [NSString stringWithFormat:SALocalizedString(@"coupon_threshold", @"满%@可用"), data.thresholdMoney.thousandSeparatorAmount];
    }
    spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                              alignToFont:[UIFont systemFontOfSize:0]
                                                                alignment:YYTextVerticalAlignmentCenter];

    [titleStr appendAttributedString:spaceText];

    NSMutableAttributedString *mLabs = [[NSMutableAttributedString alloc] initWithString:lableStr];
    mLabs.yy_color = HDAppTheme.WMColor.B6;
    mLabs.yy_font = [HDAppTheme.WMFont wm_ForSize:11];
    [titleStr appendAttributedString:mLabs];
    self.moneyLB.attributedText = titleStr;
    self.titleLB.text = WMFillEmpty(data.title);
    self.timeLB.text = [NSString stringWithFormat:@"%@: %@ - %@", WMLocalizedString(@"valid_time", @"Validity period"), data.effectiveDate, data.expireDate];
    self.unavaiableBg.hidden = [data.usable isEqualToString:SABoolValueTrue];
    self.unavaiableTitleLB.text = [WMLocalizedString(@"wm_coupon_cannot_reason", @"Unavailable reason") stringByAppendingString:@": "];
    self.unavaiableReasonLB.text = self.model.unavaliableResonStr;
    self.unavaiableReasonLB.numberOfLines = self.model.isOpen ? 0 : 1;
    self.contentView.backgroundColor = HDAppTheme.WMColor.bgGray;
    self.openBTN.selected = self.model.isOpen;
    self.bgView.userInteractionEnabled = [data.usable isEqualToString:SABoolValueTrue];
    self.customMaskView.hidden = self.shadomView.hidden = [data.usable isEqualToString:SABoolValueTrue];
    self.selectBTN.selected = data.isSelected;
    [self setNeedsUpdateConstraints];
}

- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_select_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_select_sel"] forState:UIControlStateSelected];
        btn.adjustsButtonWhenHighlighted = NO;
        btn.userInteractionEnabled = NO;
        _selectBTN = btn;
    }
    return _selectBTN;
}

- (HDUIButton *)openBTN {
    if (!_openBTN) {
        @HDWeakify(self) HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_open"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_close"] forState:UIControlStateSelected];
        btn.adjustsButtonWhenHighlighted = NO;
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) self.model.open = !self.model.isOpen;
            self.openBTN.selected = !self.openBTN.selected;
            UIView *view = self;
            while (view.superview) {
                if ([view isKindOfClass:UITableView.class]) {
                    UITableView *tableView = (UITableView *)view;
                    [tableView reloadData];
                    break;
                }
                view = view.superview;
            }
        }];
        _openBTN = btn;
    }
    return _openBTN;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        UIImage *image = [UIImage imageNamed:@"yn_coupon_select_bg"];
        _bgIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.5, image.size.width * 0.5)
                                            resizingMode:UIImageResizingModeStretch];
    }
    return _bgIV;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

- (UIView *)unavaiableBg {
    if (!_unavaiableBg) {
        _unavaiableBg = UIView.new;
        _unavaiableBg.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _unavaiableBg.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(kRealWidth(8), kRealWidth(8))];
        };
    }
    return _unavaiableBg;
}

- (HDLabel *)tagLb {
    if (!_tagLb) {
        HDLabel *label = HDLabel.new;
        label.textColor = UIColor.whiteColor;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(kRealWidth(4)), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        label.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(kRealWidth(8), kRealWidth(8))];
            view.layer.backgroundColor = [HDAppTheme.color gn_ColorGradientChangeWithSize:precedingFrame.size direction:GNGradientChangeDirectionLevel startColor:HDAppTheme.WMColor.mainRed
                                                                                 endColor:HexColor(0xFE4374)]
                                             .CGColor;
        };
        _tagLb = label;
    }
    return _tagLb;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.numberOfLines = 2;
        _titleLB = label;
    }
    return _titleLB;
}

- (YYLabel *)moneyLB {
    if (!_moneyLB) {
        YYLabel *label = YYLabel.new;
        _moneyLB = label;
    }
    return _moneyLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B9;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        _timeLB = label;
    }
    return _timeLB;
}

- (HDLabel *)unavaiableTitleLB {
    if (!_unavaiableTitleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HexColor(0xE9605B);
        label.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
        _unavaiableTitleLB = label;
    }
    return _unavaiableTitleLB;
}

- (HDLabel *)unavaiableReasonLB {
    if (!_unavaiableReasonLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B6;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.numberOfLines = 0;
        _unavaiableReasonLB = label;
    }
    return _unavaiableReasonLB;
}

- (UIView *)shadomView {
    if (!_shadomView) {
        _shadomView = UIView.new;
        _shadomView.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.67].CGColor;
        _shadomView.layer.cornerRadius = kRealWidth(8);
    }
    return _shadomView;
}

- (UIView *)customMaskView {
    if (!_customMaskView) {
        _customMaskView = UIView.new;
        _customMaskView.userInteractionEnabled = NO;
        _customMaskView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.backgroundColor = [HDAppTheme.color gn_ColorGradientChangeWithSize:view.size direction:GNGradientChangeDirectionVertical startColor:HexColor(0xF3F4FA)
                                                                           endColor:[HexColor(0xF3F4FA) colorWithAlphaComponent:0]];
        };
    }
    return _customMaskView;
}

@end
