//
//  SAWalletTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletTableViewCell.h"
#import "SAShadowBackgroundView.h"


@interface SAWalletTableViewCell ()
/// 背景
@property (nonatomic, strong) SAShadowBackgroundView *bgView;
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 背景
@property (nonatomic, strong) UIImageView *bgIV;
/// 内容
@property (nonatomic, strong) SALabel *contentLB;
/// 不可提现余额
@property (nonatomic, strong) SALabel *restrictLB;
@end


@implementation SAWalletTableViewCell
#pragma mark - SATableViewCellProtocol
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.bgIV];
    [self.contentView addSubview:self.logoIV];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.contentLB];
    [self.contentView addSubview:self.restrictLB];
}

- (void)hd_bindViewModel {
}

#pragma mark - setter
- (void)setModel:(SAWalletItemModel *)model {
    _model = model;

    self.logoIV.image = [UIImage imageNamed:model.logoImageName];
    self.titleLB.text = model.title;
    self.bgIV.image = [UIImage imageNamed:model.bgImageName];
    self.contentLB.text = model.content;

    //如果“不可提现余额”为0，则隐藏不可提现余额这部分内容；
    if (model.nonCashBalance.doubleValue > 0) {
        self.restrictLB.hidden = NO;
        self.restrictLB.text = [NSString stringWithFormat:@"%@：%@", SALocalizedString(@"Restrict", @"不可提现余额"), model.nonCashBalanceStr];
    } else {
        self.restrictLB.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods

#pragma mark - layout
- (void)updateConstraints {
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIV).offset(kRealWidth(24));
        make.top.equalTo(self.bgIV).offset(kRealWidth(19));
        make.size.mas_equalTo(self.logoIV.image.size);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoIV);
        make.left.equalTo(self.logoIV.mas_right).offset(kRealWidth(10));
        make.right.mas_equalTo(self.contentLB.mas_left).offset(-kRealWidth(10));
    }];

    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLB.mas_centerY);
        make.right.equalTo(self.bgIV).offset(-HDAppTheme.value.padding.right);
    }];

    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    if (!self.restrictLB.hidden) {
        [self.restrictLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgIV).offset(-kRealWidth(19));
            make.right.equalTo(self.bgIV).offset(-HDAppTheme.value.padding.right);
            make.left.equalTo(self.logoIV.mas_right).offset(kRealWidth(10));
        }];
    }

    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgIV).offset(-HDAppTheme.value.padding.right);
        make.edges.equalTo(self.bgView);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(self.model.isFirst ? 15 : 7.5));
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(self.model.isLast ? 15 : 7.5));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SAShadowBackgroundView *)bgView {
    if (!_bgView) {
        SAShadowBackgroundView *view = SAShadowBackgroundView.new;
        _bgView = view;
    }
    return _bgView;
}

- (UIImageView *)logoIV {
    if (!_logoIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = HDHelper.circlePlaceholderImage;
        _logoIV = imageView;
    }
    return _logoIV;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [HDHelper placeholderImageWithCornerRadius:5 size:CGSizeMake(360, 180)];
        _bgIV = imageView;
    }
    return _bgIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2;
        label.textColor = UIColor.whiteColor;
        label.numberOfLines = 1;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)contentLB {
    if (!_contentLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:30];
        label.textColor = UIColor.whiteColor;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.adjustsFontSizeToFitWidth = YES;
        _contentLB = label;
    }
    return _contentLB;
}


- (SALabel *)restrictLB {
    if (!_restrictLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = UIColor.whiteColor;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        _restrictLB = label;
    }
    return _restrictLB;
}

@end
