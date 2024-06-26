//
//  SAOrderRefundDetailHeaderView.m
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderRefundDetailHeaderView.h"
#import "SAOrderRefundInfoModel.h"


@interface SAOrderRefundDetailHeaderView ()
/// icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation SAOrderRefundDetailHeaderView

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
    [self addSubview:self.bottomLine];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconIV.image.size);
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.top.greaterThanOrEqualTo(self).offset(kRealWidth(20));
        make.centerY.equalTo(self.titleLB);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(5));
        make.top.equalTo(self).offset(kRealWidth(20));
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.iconIV.mas_bottom).offset(kRealWidth(20));
        make.top.greaterThanOrEqualTo(self.titleLB.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(PixelOne);
        make.left.mas_equalTo(self).offset(HDAppTheme.value.padding.left);
        make.right.mas_equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self);
    }];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, kScreenWidth, size.height);

    [super updateConstraints];
}

#pragma mark - public methods
- (void)updateUIWithOrderDetailRefundInfo:(SAOrderRefundInfoModel *)model {
    if (model.refundState == SAOrderDetailRefundStateApplying) {
        self.iconIV.image = [UIImage imageNamed:@"refund_processing"];
        self.titleLB.text = SALocalizedString(@"refunding", @"退款中");
    } else if (model.refundState == SAOrderDetailRefundStateSuccess) {
        self.iconIV.image = [UIImage imageNamed:@"refund_success"];
        self.titleLB.text = SALocalizedString(@"refunded_success", @"退款成功");
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:22];
        label.textColor = HDAppTheme.color.C1;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
