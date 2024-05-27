//
//  TNSearchRankSubItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSearchRankSubItemView.h"
#import "HDAppTheme+TinhNow.h"


@interface TNSearchRankSubItemView ()
/// 点击按钮
@property (nonatomic, strong) HDUIButton *clickBtn;
/// 左边的icon
@property (nonatomic, strong) UIImageView *iconImgView;
/// 值的显示
@property (nonatomic, strong) SALabel *valueLabel;
@end


@implementation TNSearchRankSubItemView
- (void)hd_setupViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.valueLabel];
    [self addSubview:self.clickBtn];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(18), 18));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(6));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(10));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(6));
    }];

    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(10));
    }];

    [self.clickBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

- (void)setModel:(TNSearchRankAndDiscoveryItemModel *)model {
    _model = model;

    self.iconImgView.image = [UIImage imageNamed:model.imageName];
    self.valueLabel.text = model.value;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (CGSize)getSizeFits {
    //    [self setNeedsLayout];
    //    [self layoutIfNeeded];
    CGFloat height = kRealHeight(30);
    /// 整行
    CGFloat width = kScreenWidth - kRealWidth(30);
    return CGSizeMake(width, height);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self getSizeFits];
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (SALabel *)valueLabel {
    if (!_valueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.TinhNowColor.c5d667f;
        label.font = HDAppTheme.TinhNowFont.standard12M;
        _valueLabel = label;
    }
    return _valueLabel;
}

- (HDUIButton *)clickBtn {
    if (!_clickBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.btnClickBlock ?: self.btnClickBlock(self.model);
        }];

        _clickBtn = button;
    }
    return _clickBtn;
}
@end
