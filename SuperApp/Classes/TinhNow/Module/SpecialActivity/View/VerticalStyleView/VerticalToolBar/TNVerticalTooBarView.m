//
//  TNVerticalTooBarView.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNVerticalTooBarView.h"
#import "TNNotificationConst.h"


@interface TNVerticalTooBarView ()
/// 热卖按钮
@property (strong, nonatomic) HDUIButton *hotSaleBtn;
/// 推荐按钮
@property (strong, nonatomic) HDUIButton *recommendBtn;
/// 改变商品展示样式按钮
@property (strong, nonatomic) HDUIButton *changeStyleBtn;
///
@property (nonatomic, assign) BOOL showHorizontalStyle;
@end


@implementation TNVerticalTooBarView
- (void)hd_setupViews {
    [self addSubview:self.hotSaleBtn];
    [self addSubview:self.recommendBtn];
    [self addSubview:self.changeStyleBtn];
    [self scrollerToRecommdProducts:NO];
    [self setChangeStyleImage];
}
- (void)setChangeStyleImage {
    NSString *imageName;
    if (self.showHorizontalStyle) {
        imageName = @"tn_waterflow_item_two";
    } else {
        imageName = @"tn_waterflow_item_one";
    }
    [self.changeStyleBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
- (void)updateConstraints {
    [self.hotSaleBtn sizeToFit];
    [self.hotSaleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kRealWidth(10));
    }];

    [self.recommendBtn sizeToFit];
    [self.recommendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.hotSaleBtn.mas_right).offset(kRealWidth(10));
    }];

    [self.changeStyleBtn sizeToFit];
    [self.changeStyleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
#pragma mark - 是否滚动到推荐列表
- (void)scrollerToRecommdProducts:(BOOL)isRecommd {
    if (isRecommd) {
        self.recommendBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [self.recommendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.recommendBtn.layer.borderColor = HDAppTheme.TinhNowColor.C1.CGColor;

        self.hotSaleBtn.backgroundColor = [UIColor whiteColor];
        [self.hotSaleBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        self.hotSaleBtn.layer.borderColor = HDAppTheme.TinhNowColor.G2.CGColor;
    } else {
        self.hotSaleBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [self.hotSaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.hotSaleBtn.layer.borderColor = HDAppTheme.TinhNowColor.C1.CGColor;

        self.recommendBtn.backgroundColor = [UIColor whiteColor];
        [self.recommendBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        self.recommendBtn.layer.borderColor = HDAppTheme.TinhNowColor.G2.CGColor;
    }
}
/** @lazy hotSaleBtn */
- (HDUIButton *)hotSaleBtn {
    if (!_hotSaleBtn) {
        _hotSaleBtn = [[HDUIButton alloc] init];
        _hotSaleBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _hotSaleBtn.titleEdgeInsets = UIEdgeInsetsMake(7, 28, 7, 28);
        [_hotSaleBtn setTitle:TNLocalizedString(@"tn_special_offer", @"特价") forState:UIControlStateNormal];
        _hotSaleBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 15;
            view.layer.masksToBounds = YES;
            view.layer.borderWidth = 1;
        };
        @HDWeakify(self);
        [_hotSaleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self scrollerToRecommdProducts:NO];
            !self.hotSaleClickCallBack ?: self.hotSaleClickCallBack();
        }];
    }
    return _hotSaleBtn;
}
/** @lazy recommendBtn */
- (HDUIButton *)recommendBtn {
    if (!_recommendBtn) {
        _recommendBtn = [[HDUIButton alloc] init];
        _recommendBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _recommendBtn.titleEdgeInsets = UIEdgeInsetsMake(7, 28, 7, 28);
        [_recommendBtn setTitle:TNLocalizedString(@"tn_recommend", @"推荐") forState:UIControlStateNormal];
        _recommendBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 15;
            view.layer.masksToBounds = YES;
            view.layer.borderWidth = 1;
        };
        @HDWeakify(self);
        [_recommendBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self scrollerToRecommdProducts:YES];
            !self.recommendClickCallBack ?: self.recommendClickCallBack();
        }];
    }
    return _recommendBtn;
}
/** @lazy changeStyleBtn */
- (HDUIButton *)changeStyleBtn {
    if (!_changeStyleBtn) {
        _changeStyleBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self);
        [_changeStyleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [[NSUserDefaults standardUserDefaults] setBool:!self.showHorizontalStyle forKey:kNSUserDefaultsKeyShowHorizontalProductsStyle];
            //发送更改通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kTNNotificationNameChangedSpecialProductsListDispalyStyle object:nil];
            [self setChangeStyleImage];
            !self.changeProductDisplayStyleCallBack ?: self.changeProductDisplayStyleCallBack();
        }];
    }
    return _changeStyleBtn;
}
- (BOOL)showHorizontalStyle {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsKeyShowHorizontalProductsStyle];
}
@end
