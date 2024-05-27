//
//  SACouponRedemptionCell.m
//  SuperApp
//
//  Created by Chaos on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponRedemptionCell.h"
#import "SACouponTicketModel.h"


@interface SACouponRedemptionCell ()

/// 底部视图
@property (nonatomic, strong) UIView *bgView;
/// 标题
@property (nonatomic, strong) SALabel *nameLB;
/// 金额
@property (nonatomic, strong) SALabel *moneyLB;
/// 有效期
@property (nonatomic, strong) SALabel *dateLB;
/// 消费门槛
@property (nonatomic, strong) SALabel *thresholdLB;
/// 线
@property (nonatomic, strong) UIView *lineView;
/// 详情展开按钮
@property (nonatomic, strong) HDUIButton *viewDetailBTN;
/// 使用按钮
@property (nonatomic, strong) HDUIButton *useBTN;
/// 描述
@property (nonatomic, strong) SALabel *descLB;

@end


@implementation SACouponRedemptionCell

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLB];
    [self.bgView addSubview:self.moneyLB];
    [self.bgView addSubview:self.dateLB];
    [self.bgView addSubview:self.thresholdLB];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.viewDetailBTN];
    [self.bgView addSubview:self.useBTN];
    [self.bgView addSubview:self.descLB];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.model.isFirstCell ? 0 : kRealWidth(5));
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(5));
        make.left.equalTo(self.contentView).offset(kRealWidth(15));
        make.right.equalTo(self.contentView).offset(-kRealWidth(15));
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(10));
        make.top.equalTo(self.bgView).offset(kRealWidth(15));
        make.right.lessThanOrEqualTo(self.moneyLB.mas_left).offset(-kRealWidth(50));
    }];
    [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLB);
        make.right.equalTo(self.bgView).offset(-kRealWidth(20));
    }];
    [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(8));
    }];
    [self.thresholdLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-kRealWidth(10));
        make.centerY.equalTo(self.dateLB);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(10));
        make.right.equalTo(self.bgView).offset(-kRealWidth(10));
        make.top.equalTo(self.thresholdLB.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(1);
    }];
    [self.viewDetailBTN sizeToFit];
    [self.viewDetailBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(10));
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(10));
        make.size.mas_equalTo(self.viewDetailBTN.size);
    }];
    [self.useBTN sizeToFit];
    [self.useBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-kRealWidth(18));
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(10));
        make.width.mas_equalTo(self.useBTN.width);
        make.height.mas_equalTo(kRealWidth(22));
        if (self.descLB.isHidden) {
            make.bottom.equalTo(self.bgView).offset(-kRealWidth(10));
        }
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.descLB.isHidden) {
            make.left.equalTo(self.viewDetailBTN);
            make.top.equalTo(self.viewDetailBTN.mas_bottom);
            make.right.lessThanOrEqualTo(self.useBTN.mas_left).offset(-kRealWidth(75));
            make.bottom.equalTo(self.bgView).offset(-kRealWidth(10));
        }
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SACouponTicketModel *)model {
    _model = model;

    self.nameLB.text = model.couponTitle;
    self.moneyLB.text = model.couponAmount.thousandSeparatorAmount;
    self.dateLB.text = [NSString stringWithFormat:@"%@:%@ - %@", SALocalizedString(@"xij9sKYa", @"Valid Till"), model.effectiveDate, model.expireDate];
    self.thresholdLB.text = [NSString stringWithFormat:@"%@ %@", SALocalizedString(@"lgqfIW4i", @"Min. Spend"), model.thresholdAmount.thousandSeparatorAmount];
    self.descLB.hidden = !model.isExpanded;
    self.descLB.text = model.couponUsageDescribe;
    if (model.isExpanded) {
        self.viewDetailBTN.imageView.layer.transform = CATransform3DMakeRotation(-M_PI, 1.0, 0.0, 0.0);
    } else {
        self.viewDetailBTN.imageView.layer.transform = CATransform3DIdentity;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedViewDetailBTNHandler {
    !self.clickViewDetailBlock ?: self.clickViewDetailBlock(self, self.model);
}

- (void)clickedUseBTNHandler {
    !self.clickUseNowBlock ?: self.clickUseNowBlock(self.model);
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _bgView;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.G1;
        label.font = HDAppTheme.font.standard2Bold;
        label.numberOfLines = 0;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)moneyLB {
    if (!_moneyLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.C1;
        label.font = HDAppTheme.font.standard1Bold;
        _moneyLB = label;
    }
    return _moneyLB;
}

- (SALabel *)dateLB {
    if (!_dateLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.G2;
        label.font = HDAppTheme.font.standard5;
        _dateLB = label;
    }
    return _dateLB;
}

- (SALabel *)thresholdLB {
    if (!_thresholdLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.C1;
        label.font = HDAppTheme.font.standard5;
        _thresholdLB = label;
    }
    return _thresholdLB;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = UIView.new;
        lineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view drawDashLineWithlineLength:2 lineSpacing:2 lineColor:HDAppTheme.color.G4];
        };
        _lineView = lineView;
    }
    return _lineView;
}

- (HDUIButton *)viewDetailBTN {
    if (!_viewDetailBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        button.imagePosition = HDUIButtonImagePositionRight;
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        [button setTitle:SALocalizedString(@"Ug4g71Gm", @"View details") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard4;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        [button addTarget:self action:@selector(clickedViewDetailBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _viewDetailBTN = button;
    }
    return _viewDetailBTN;
}

- (HDUIButton *)useBTN {
    if (!_useBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        button.layer.cornerRadius = kRealWidth(11);
        button.layer.masksToBounds = true;
        button.titleLabel.font = HDAppTheme.font.standard4;
        [button addTarget:self action:@selector(clickedUseBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:SALocalizedString(@"use_now", @"Use now") forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setGradualChangingColorFromColor:HexColor(0xFFC938) toColor:HexColor(0xFD1401)];
        };
        _useBTN = button;
    }
    return _useBTN;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.G3;
        label.font = HDAppTheme.font.standard4;
        label.numberOfLines = 0;
        _descLB = label;
    }
    return _descLB;
}

@end
