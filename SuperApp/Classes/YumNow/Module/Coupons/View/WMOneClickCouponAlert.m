//
//  WMOneClickCouponAlert.m
//  SuperApp
//
//  Created by wmz on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOneClickCouponAlert.h"
#import "WMOneClickCouponTableViewCell.h"
#import "WMTableView.h"


@interface WMOneClickCouponAlert () <GNTableViewProtocol, CAAnimationDelegate>
///下次不再展示按钮
@property (nonatomic, strong, readwrite) HDUIButton *showAgainBTN;
///关闭按钮
@property (nonatomic, strong, readwrite) HDUIButton *closeBTN;
/// title
@property (nonatomic, strong, readwrite) YYLabel *titleLB;
/// tableView
@property (nonatomic, strong, readwrite) WMTableView *tableView;
///券区域的内容
@property (nonatomic, strong, readwrite) UIView *containView;
///阴影
@property (nonatomic, strong, readwrite) UIView *shadomView;
///整体内容
@property (nonatomic, strong, readwrite) UIView *contenView;
///背景图片
@property (nonatomic, strong, readwrite) UIImageView *bgIV;
///前置背景图片
@property (nonatomic, strong, readwrite) UIImageView *frontIV;
///领取按钮
@property (nonatomic, strong, readwrite) HDUIButton *confirmBTN;
///描边
@property (nonatomic, strong, readwrite) UIView *borderView;
///填充
@property (nonatomic, strong, readwrite) UIView *fillView;

@end


@implementation WMOneClickCouponAlert

- (void)hd_setupViews {
    [self addSubview:self.shadomView];
    [self addSubview:self.contenView];

    [self.contenView addSubview:self.bgIV];
    [self.contenView addSubview:self.containView];

    [self.contenView addSubview:self.fillView];

    [self.containView addSubview:self.borderView];
    [self.containView addSubview:self.titleLB];
    [self.containView addSubview:self.tableView];

    [self.contenView addSubview:self.frontIV];
    [self.contenView addSubview:self.closeBTN];
    [self.contenView addSubview:self.confirmBTN];
    [self.contenView addSubview:self.showAgainBTN];
    [self.contenView sendSubviewToBack:self.shadomView];
}

- (void)setRspModel:(WMCouponActivityContentModel *)rspModel {
    _rspModel = rspModel;
    self.dataSource = rspModel.coupons;
    self.tableView.scrollEnabled = (rspModel.coupons.count > 3);
    NSMutableAttributedString *mstar = [[NSMutableAttributedString alloc] initWithString:rspModel.title];
    mstar.yy_lineSpacing = kRealWidth(4);
    mstar.yy_font = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
    mstar.yy_color = HexColor(0xDD0200);
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    mstar.yy_paragraphStyle = paragraph;
    self.titleLB.attributedText = mstar;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.contenView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];

    [self.shadomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(24));
        make.right.mas_equalTo(-kRealWidth(24));
        make.top.mas_equalTo(kRealWidth(16));
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(22));
        make.right.mas_equalTo(-kRealWidth(22));
        make.top.mas_equalTo(kRealWidth(16));
    }];
    CGFloat height = kRealWidth(82) * MIN(3, self.dataSource.count);
    if (self.dataSource.count == 3) {
        height -= kRealWidth(10);
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(16));
        make.height.mas_equalTo(height);
        make.bottom.mas_equalTo(0);
    }];

    [self.fillView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.right.equalTo(self.tableView);
        make.height.mas_equalTo(50);
    }];

    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(kRealWidth(-12));
        make.bottom.equalTo(self.containView.mas_bottom).offset(kRealWidth(110));
        make.top.mas_equalTo(kRealWidth(64));
    }];

    [self.frontIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth - kRealWidth(24));
        make.bottom.equalTo(self.bgIV.mas_bottom);
    }];

    [self.borderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(6));
        make.right.mas_equalTo(-kRealWidth(6));
        ;
        make.bottom.mas_equalTo(0);
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(50));
        make.right.mas_equalTo(kRealWidth(-50));
        make.bottom.equalTo(self.bgIV.mas_bottom).offset(-kRealWidth(23));
        make.height.mas_equalTo(kRealWidth(61));
    }];

    [self.showAgainBTN sizeToFit];
    [self.showAgainBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgIV.mas_bottom).offset(kRealWidth(12));
        make.centerX.mas_equalTo(0);
    }];

    [self.closeBTN sizeToFit];
    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showAgainBTN.mas_bottom).offset(kRealWidth(24));
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    [self.titleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [super updateConstraints];
}

- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return (id)self.dataSource;
}

- (Class)classOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return WMOneClickCouponTableViewCell.class;
}

- (BOOL)xibOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)show {
    if (self.show)
        return;
    self.hidden = NO;
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = [NSNumber numberWithFloat:0];
    scale.toValue = [NSNumber numberWithFloat:1];

    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:0];
    showViewAnn.toValue = [NSNumber numberWithFloat:1];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale, showViewAnn];
    group.duration = 0.25;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self.contenView.layer addAnimation:group forKey:nil];

    self.shadomView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.shadomView.alpha = 1;
    }];
    self.show = YES;
}

- (void)dissmiss {
    if (!self.show)
        return;
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = [NSNumber numberWithFloat:1];
    scale.toValue = [NSNumber numberWithFloat:1.25];

    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1];
    showViewAnn.toValue = [NSNumber numberWithFloat:0];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale, showViewAnn];
    group.duration = 0.25;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [self.contenView.layer addAnimation:group forKey:nil];

    [UIView animateWithDuration:0.25 animations:^{
        self.shadomView.alpha = 0;
    }];
    self.show = NO;
}

#pragma - mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
}
- (UIView *)contenView {
    if (!_contenView) {
        _contenView = UIView.new;
    }
    return _contenView;
}

- (UIView *)containView {
    if (!_containView) {
        _containView = UIView.new;
        _containView.layer.backgroundColor = HexColor(0xFFF3E8).CGColor;
        _containView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kRealWidth(24), kRealWidth(24))];
        };
    }
    return _containView;
}

- (YYLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = YYLabel.new;
        _titleLB.numberOfLines = 2;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(116);
    }
    return _titleLB;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        //        UIImage *image = [UIImage imageNamed:@"yn_coupon_oneclick_bg"];
        _bgIV.image = [UIImage imageNamed:@"yn_coupon_oneclick_bg"];
    }
    return _bgIV;
}

- (UIImageView *)frontIV {
    if (!_frontIV) {
        _frontIV = UIImageView.new;
        UIImage *image = [UIImage imageNamed:@"yn_coupon_oneclick_bg_brint"];
        _frontIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.2, image.size.width * 0.5, image.size.height * 0.6, image.size.width * 0.5)
                                               resizingMode:UIImageResizingModeStretch];
    }
    return _frontIV;
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_oneclick_close"] forState:UIControlStateNormal];
        btn.adjustsButtonWhenHighlighted = NO;
        [btn addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBTN = btn;
    }
    return _closeBTN;
}

- (HDUIButton *)showAgainBTN {
    if (!_showAgainBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_oneclick_protocol_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_coupon_oneclick_protocol_sel"] forState:UIControlStateSelected];
        [btn setTitle:WMLocalizedString(@"wm_dont_show_again", @"Don't Show This Activity Again") forState:UIControlStateNormal];
        btn.adjustsButtonWhenHighlighted = NO;
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        btn.imagePosition = HDUIButtonImagePositionLeft;
        btn.spacingBetweenImageAndTitle = kRealWidth(5);
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) btn.selected = !btn.isSelected;
            NSString *key = [NSString stringWithFormat:@"%@_%@", SAUser.shared.operatorNo, self.rspModel.activityNo];
            if (btn.isSelected) {
                [NSUserDefaults.standardUserDefaults setValue:@(YES) forKey:key];
            } else {
                [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
            }
        }];
        btn.alpha = 0.7;
        _showAgainBTN = btn;
    }
    return _showAgainBTN;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
            [btn setImage:[UIImage imageNamed:@"yn_coupon_oneclick_confirm_zh"] forState:UIControlStateNormal];
        } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeEN]) {
            [btn setImage:[UIImage imageNamed:@"yn_coupon_oneclick_confirm_en"] forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"yn_coupon_oneclick_confirm_km"] forState:UIControlStateNormal];
        }
        btn.adjustsButtonWhenHighlighted = NO;
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (!SAUser.hasSignedIn) {
                [SAWindowManager switchWindowToLoginViewController];
                return;
            }
            if (self.clickedConfirmBlock) {
                self.clickedConfirmBlock(self.rspModel);
            }
        }];
        _confirmBTN = btn;
    }
    return _confirmBTN;
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.GNdelegate = self;
        _tableView.backgroundColor = HexColor(0xFFF3E8);
    }
    return _tableView;
}

- (UIView *)shadomView {
    if (!_shadomView) {
        _shadomView = UIView.new;
        _shadomView.backgroundColor = [HDAppTheme.WMColor.B0 colorWithAlphaComponent:0.7];
    }
    return _shadomView;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = UIView.new;
        _borderView.layer.borderWidth = 0.5;
        _borderView.layer.borderColor = HexColor(0xFFE4AD).CGColor;
        _borderView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kRealWidth(20), kRealWidth(20))];
        };
    }
    return _borderView;
}

- (UIView *)fillView {
    if (!_fillView) {
        _fillView = UIView.new;
        _fillView.backgroundColor = HexColor(0xFFF3E8);
    }
    return _fillView;
}

@end
