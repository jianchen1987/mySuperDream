//
//  GNOrderRefundFlowCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderRefundFlowCell.h"


@interface GNOrderRefundFlowCell ()

@property (nonatomic, strong) UIView *pointView;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) HDLabel *nameLB;

@property (nonatomic, strong) HDLabel *timeLB;

@property (nonatomic, strong) HDLabel *detailLB;

@end


@implementation GNOrderRefundFlowCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.pointView];
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.detailLB];
}

- (void)updateConstraints {
    [self.pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(6), kRealWidth(6)));
        make.centerY.equalTo(self.nameLB);
        make.left.mas_equalTo(kRealWidth(15));
    }];

    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.topLine.isHidden) {
            make.centerX.equalTo(self.pointView);
            make.top.equalTo(self.nameLB);
            make.bottom.equalTo(self.pointView.mas_top).offset(-kRealWidth(2));
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(kRealWidth(4));
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.centerX.equalTo(self.pointView);
            make.top.equalTo(self.pointView.mas_bottom).offset(kRealWidth(2));
            make.width.mas_equalTo(0.5);
            make.bottom.equalTo(self.detailLB.mas_bottom);
        }
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_right).offset(kRealWidth(20));
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-kRealWidth(15));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(10));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.timeLB.mas_bottom).offset(kRealWidth(10));
        if (self.model.last) {
            make.bottom.mas_equalTo(-kRealWidth(15));
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.nameLB.text = GNFillEmptySpace(data.title);
    self.timeLB.text = GNFillEmptySpace(data.time);
    self.detailLB.text = GNFillEmptySpace(data.detail);
    self.pointView.layer.backgroundColor = data.nameColor.CGColor;
    self.nameLB.textColor = data.detailColor;
    self.topLine.hidden = data.first;
    self.bottomLine.hidden = data.last;
    [self setNeedsUpdateConstraints];
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.new;
        _topLine.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _bottomLine;
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = UIView.new;
        _pointView.layer.cornerRadius = kRealWidth(3);
    }
    return _pointView;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_boldForSize:13];
        label.textColor = HDAppTheme.color.gn_333Color;
        label.numberOfLines = 0;
        _nameLB = label;
    }
    return _nameLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.font gn_ForSize:12];
        label.textColor = [UIColor hd_colorWithHexString:@"B3333333"];
        _timeLB = label;
    }
    return _timeLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.font gn_ForSize:12];
        label.textColor = [UIColor hd_colorWithHexString:@"82333333"];
        _detailLB = label;
    }
    return _detailLB;
}

@end
