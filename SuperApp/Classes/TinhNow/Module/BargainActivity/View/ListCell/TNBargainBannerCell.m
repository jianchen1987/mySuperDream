//
//  TNBargainBannerCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainBannerCell.h"
#import "TNBargainRuleViewController.h"


@implementation TNBargainBannerCellModel
- (CGFloat)cellHeight {
    return kRealWidth(236);
}
@end


@interface TNBargainBannerCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) HDUIButton *ruleButton;
@end


@implementation TNBargainBannerCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.ruleButton];
}
- (void)setBanner:(NSString *)banner {
    _banner = banner;
    self.ruleButton.hidden = false;
    [HDWebImageManager setImageWithURL:banner placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, kRealWidth(236))] imageView:self.bgImageView];
}
// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
- (void)updateConstraints {
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.ruleButton sizeToFit];
    [self.ruleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-kRealWidth(27));
        make.right.equalTo(self.bgImageView.mas_right).offset(-kRealWidth(12));
    }];
    [super updateConstraints];
}
- (void)ruleBtnClick:(HDUIButton *)btn {
    TNBargainRuleViewController *vc = [[TNBargainRuleViewController alloc] initWithRouteParameters:@{}];
    [SAWindowManager navigateToViewController:vc];
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.backgroundColor = HDSkeletonColorFromRGB(242.0, 244.0, 247.0);
        _bgImageView.userInteractionEnabled = true;
    }
    return _bgImageView;
}
- (HDUIButton *)ruleButton {
    if (!_ruleButton) {
        _ruleButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_ruleButton setTitle:TNLocalizedString(@"tn_rule", @"规则") forState:UIControlStateNormal];
        [_ruleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ruleButton.titleLabel.font = HDAppTheme.TinhNowFont.standard13;
        _ruleButton.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.50];
        _ruleButton.titleEdgeInsets = UIEdgeInsetsMake(2, 17, 2, 17);
        [_ruleButton addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _ruleButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
        _ruleButton.hidden = true;
    }
    return _ruleButton;
}
@end
