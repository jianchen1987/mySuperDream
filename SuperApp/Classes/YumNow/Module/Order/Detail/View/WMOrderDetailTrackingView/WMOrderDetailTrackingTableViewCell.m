//
//  WMOrderDetailTrackingTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailTrackingTableViewCell.h"


@interface WMOrderDetailTrackingTableViewCell ()
/// 上部线
@property (nonatomic, strong) UIView *topLine;
/// 下部线
@property (nonatomic, strong) UIView *bottomLine;
/// name
@property (nonatomic, strong) HDLabel *nameLB;
/// 下部线
@property (nonatomic, strong) HDLabel *detailLB;
/// 图标
@property (nonatomic, strong) UIImageView *iconIV;

@end


@implementation WMOrderDetailTrackingTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.detailLB];
    [self.contentView addSubview:self.iconIV];
}

- (void)updateConstraints {
    UIView *lineView = self.topLine.isHidden ? self.bottomLine : self.topLine;

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.iconIV.image) {
            make.size.mas_equalTo(self.iconIV.image.size);
            make.top.mas_equalTo((kRealWidth(44) - self.iconIV.image.size.height) / 2.0);
            make.bottom.mas_equalTo(-(kRealWidth(44) - self.iconIV.image.size.height) / 2.0);
        } else {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(8), kRealWidth(8)));
            make.top.mas_equalTo(kRealWidth(18));
            make.bottom.mas_equalTo(-kRealWidth(18));
        }
        make.centerX.equalTo(lineView);
        make.centerY.mas_equalTo(0);
        if (self.topLine.isHidden && self.bottomLine.isHidden) {
            make.left.mas_equalTo(kRealWidth(11));
        }
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.detailLB.mas_left).offset(-5);
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.mas_equalTo(0);
    }];

    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.topLine.isHidden) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.iconIV.mas_top);
            make.left.equalTo(self.contentView).offset(kRealWidth(21));
            make.width.mas_equalTo(1);
        }
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.top.equalTo(self.iconIV.mas_bottom);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(kRealWidth(21));
            make.width.mas_equalTo(1);
        }
    }];

    [self.detailLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(WMOrderDetailTrackingTableViewCellModel *)model {
    _model = model;
    NSString *imageName;
    UIColor *textLabelColor = HDAppTheme.WMColor.B6;
    UIColor *topLineColor = HDAppTheme.WMColor.mainRed;
    UIColor *bottomLineColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1];
    UIFont *textFont = [HDAppTheme.WMFont wm_ForSize:14];
    if (model.status == WMOrderDetailTrackingStatusCompleted) {
        imageName = @"yn_order_track_radio_sel";
        bottomLineColor = HDAppTheme.WMColor.mainRed;
        textFont = [HDAppTheme.WMFont wm_boldForSize:14];
        textLabelColor = HDAppTheme.WMColor.B3;
    } else if (model.status == WMOrderDetailTrackingStatusExpected && !model.hightNode) {
        topLineColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1];
    }
    self.topLine.backgroundColor = topLineColor;
    self.bottomLine.backgroundColor = bottomLineColor;
    self.iconIV.layer.cornerRadius = 0;
    self.iconIV.layer.backgroundColor = UIColor.clearColor.CGColor;
    if (imageName) {
        self.iconIV.image = [UIImage imageNamed:imageName];
    } else {
        self.iconIV.image = nil;
        self.iconIV.layer.backgroundColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1].CGColor;
        self.iconIV.layer.cornerRadius = kRealWidth(4);
    }
    self.nameLB.text = model.title;
    self.nameLB.textColor = textLabelColor;
    self.nameLB.font = textFont;
    self.topLine.hidden = !model.showUpLine;
    self.bottomLine.hidden = !model.showDownLine;
    self.detailLB.text = model.desc;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.new;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
    }
    return _bottomLine;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.numberOfLines = 0;
    }
    return _nameLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        _detailLB = HDLabel.new;
        _detailLB.numberOfLines = 0;
        _detailLB.textAlignment = NSTextAlignmentRight;
        _detailLB.textColor = HDAppTheme.WMColor.CCCCCC;
        _detailLB.font = [HDAppTheme.WMFont wm_ForSize:11];
    }
    return _detailLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

@end
