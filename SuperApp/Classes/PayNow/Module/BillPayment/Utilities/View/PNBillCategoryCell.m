//
//  PNBillCategoryCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillCategoryCell.h"
#import "PNBillCategoryItemModel.h"


@interface PNBillCategoryCell ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *titleLB;
@end


@implementation PNBillCategoryCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
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

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_top);
        make.width.equalTo(@(kRealWidth(40)));
        make.height.equalTo(@(kRealWidth(40)));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(5));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-5));
    }];

    [super updateConstraints];
}
#pragma mark - getters and setters
- (void)setModel:(PNBillCategoryItemModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:self.model.paymentCategoryIcon placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_middle"] imageView:self.iconImgView];
    self.titleLB.text = self.model.paymentCategory;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = UIImageView.new;
    }
    return _iconImgView;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = HDAppTheme.PayNowColor.c2A251F;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}
@end
