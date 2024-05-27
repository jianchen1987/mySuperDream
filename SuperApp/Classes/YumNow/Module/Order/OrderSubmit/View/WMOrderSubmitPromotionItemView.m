//
//  WMOrderSubmitPromotionItemView.m
//  SuperApp
//
//  Created by Chaos on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitPromotionItemView.h"
#import "WMPromotionItemView.h"


@interface WMOrderSubmitPromotionItemView ()

/// 背景
@property (nonatomic, strong) UIControl *bgControl;
/// 左边view
@property (nonatomic, strong) WMPromotionItemView *itemView;
/// 左边图片
@property (nonatomic, strong) UIImageView *iconIV;
/// 右边label
@property (nonatomic, strong) SALabel *rightLabel;
/// 右边图片
@property (nonatomic, strong) UIImageView *rightIV;

@end


@implementation WMOrderSubmitPromotionItemView

- (void)hd_setupViews {
    [self addSubview:self.bgControl];
    [self.bgControl addSubview:self.itemView];
    [self.bgControl addSubview:self.rightLabel];
    [self.bgControl addSubview:self.iconIV];
    [self.bgControl addSubview:self.rightIV];
}

- (void)updateConstraints {
    [self.bgControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
            if (self.from == 2) {
                make.left.equalTo(self.mas_left).offset(kRealWidth(12));
                ;
            } else {
                make.left.equalTo(self.mas_left).offset(kRealWidth(15));
            }
            make.centerY.equalTo(self.itemView.mas_centerY);
        }
    }];

    [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.from == 2) {
            make.top.equalTo(self.mas_top).offset(kRealWidth(4));
            make.bottom.equalTo(self.mas_bottom).offset(kRealWidth(-4));
        } else {
            make.top.equalTo(self.mas_top).offset(kRealWidth(7));
            make.bottom.equalTo(self.mas_bottom).offset(kRealWidth(-7));
        }
        if (self.iconIV.isHidden) {
            make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        } else {
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
        }
        make.right.lessThanOrEqualTo(self.rightLabel.mas_left).offset(kRealWidth(-5));
    }];

    [self.rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightIV.isHidden) {
            make.size.mas_equalTo(self.rightIV.image.size);
            make.left.equalTo(self.itemView.mas_right).offset(kRealWidth(4));
            make.centerY.equalTo(self.itemView.mas_centerY);
        }
    }];

    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.from == 2) {
            make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
        } else {
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        }
        make.centerY.equalTo(self.itemView.mas_centerY);
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)promotionAction {
    !_blockOnClickPromotion ?: _blockOnClickPromotion();
}

- (void)setMarketingType:(WMStorePromotionMarketingType)marketingType {
    _marketingType = marketingType;

    self.itemView.itemType = marketingType;
    self.iconIV.image = self.itemView.showImage;
}

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;

    self.itemView.showTips = self.leftTitle;
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;

    self.rightLabel.text = self.rightTitle;
}

- (void)setFrom:(NSInteger)from {
    _from = from;
    if (from > 0) {
        self.rightIV.hidden = self.iconIV.hidden = NO;
    } else {
        self.rightIV.hidden = self.iconIV.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIControl *)bgControl {
    if (!_bgControl) {
        _bgControl = [[UIControl alloc] init];
        [_bgControl addTarget:self action:@selector(promotionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgControl;
}

- (SALabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[SALabel alloc] init];
        _rightLabel.textColor = HDAppTheme.WMColor.mainRed;
        _rightLabel.font = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
    }
    return _rightLabel;
}

- (WMPromotionItemView *)itemView {
    if (!_itemView) {
        _itemView = [[WMPromotionItemView alloc] init];
        _itemView.userInteractionEnabled = NO;
        _itemView.hideLeftBTN = YES;
    }
    return _itemView;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.hidden = YES;
    }
    return _iconIV;
}

- (UIImageView *)rightIV {
    if (!_rightIV) {
        _rightIV = UIImageView.new;
        _rightIV.image = [UIImage imageNamed:@"yn_submit_help"];
        _rightIV.hidden = YES;
    }
    return _rightIV;
}

@end
