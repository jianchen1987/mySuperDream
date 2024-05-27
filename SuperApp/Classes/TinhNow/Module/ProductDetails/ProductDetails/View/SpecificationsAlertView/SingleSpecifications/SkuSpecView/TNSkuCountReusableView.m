//
//  TNSkuCountReusableView.m
//  SuperApp
//
//  Created by 张杰 on 2021/8/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSkuCountReusableView.h"

#import "HDAppTheme+TinhNow.h"


@interface TNSkuCountReusableView ()
@property (nonatomic, strong) UIView *line;
/// 背景视图
@property (strong, nonatomic) UIView *backgroundView;
/// 数量标签
@property (nonatomic, strong) UILabel *quantityTitleLabel;

@end


@implementation TNSkuCountReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hd_setupViews];
    }
    return self;
}
- (void)hd_setupViews {
    [self addSubview:self.line];
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.quantityTitleLabel];
    [self.backgroundView addSubview:self.countView];
}
- (void)updateConstraints {
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(PixelOne);
    }];
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [self.quantityTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView);
        make.centerY.equalTo(self.backgroundView.mas_centerY);
        make.right.lessThanOrEqualTo(self.countView.mas_left).offset(-15);
    }];
    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self.countView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]);
        make.right.equalTo(self.backgroundView.mas_right);
        make.centerY.equalTo(self.backgroundView.mas_centerY);
    }];
    [super updateConstraints];
}
/** @lazy quantityTitleLabel */
- (UILabel *)quantityTitleLabel {
    if (!_quantityTitleLabel) {
        _quantityTitleLabel = [[UILabel alloc] init];
        _quantityTitleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _quantityTitleLabel.font = HDAppTheme.TinhNowFont.standard15;
        _quantityTitleLabel.text = TNLocalizedString(@"tn_product_quantity", @"Quantity");
    }
    return _quantityTitleLabel;
}

- (TNModifyShoppingCountView *)countView {
    if (!_countView) {
        _countView = TNModifyShoppingCountView.new;
        [_countView updateCount:1];
        _countView.minCount = 1;
    }
    return _countView;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hd_colorWithHexString:@"E1E1E1"];
    }
    return _line;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}
@end
