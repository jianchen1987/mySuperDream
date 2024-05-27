//
//  TNHomeSectionHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHomeSectionHeaderView.h"


@interface TNHomeSectionHeaderView ()
/// 左边图片
@property (strong, nonatomic) UIImageView *leftImageView;
/// 右边图片
@property (strong, nonatomic) UIImageView *rightImageView;
/// 文案
@property (strong, nonatomic) UILabel *titleLabel;
@end


@implementation TNHomeSectionHeaderView
- (void)hd_setupViews {
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.titleLabel];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.lessThanOrEqualTo(@(kScreenWidth - kRealWidth(60)));
    }];
    [self.leftImageView sizeToFit];
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_left).offset(-kRealWidth(20));
    }];
    [self.rightImageView sizeToFit];
    [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.titleLabel.mas_right).offset(kRealWidth(20));
    }];
    [super updateConstraints];
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_title_left"]];
    }
    return _leftImageView;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_title_right"]];
    }
    return _rightImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}

@end
