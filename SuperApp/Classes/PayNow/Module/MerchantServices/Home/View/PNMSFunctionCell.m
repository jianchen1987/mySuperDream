//
//  PNMSFunctionCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSFunctionCell.h"
#import "PNFunctionCellModel.h"


@interface PNMSFunctionCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) SALabel *titleLB;
@end


@implementation PNMSFunctionCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImage];
    [self.bgView addSubview:self.titleLB];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_top);
        make.width.equalTo(@(kRealWidth(72)));
        make.height.equalTo(@(kRealWidth(72)));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-5));
        //        make.bottom.mas_equalTo(self.bgView.mas_bottom);
    }];

    [super updateConstraints];
}
#pragma mark - getters and setters
- (void)setModel:(PNFunctionCellModel *)model {
    _model = model;
    self.iconImage.image = [UIImage imageNamed:_model.imageName];
    self.titleLB.text = _model.title;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _bgView;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = UIImageView.new;
        _iconImage.contentMode = UIViewContentModeCenter;
        _iconImage.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _iconImage.layer.cornerRadius = kRealWidth(12);
        _iconImage.layer.masksToBounds = YES;
    }
    return _iconImage;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}
@end
