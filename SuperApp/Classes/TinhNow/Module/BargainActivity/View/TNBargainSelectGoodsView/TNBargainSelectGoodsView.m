//
//  TNBargainSelectGoodsView.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainSelectGoodsView.h"
#import "TNBargainSelectBottomView.h"
#import "TNBargainDetailViewController.h"


@interface TNBargainSelectGoodsView ()
///背景视图
@property (strong, nonatomic) UIView *bgView;
/// 上部分视图
@property (strong, nonatomic) UIView *topView;
/// 选择视图
@property (strong, nonatomic) TNBargainSelectBottomView *bottomView;
///< iPhoneX 系列底部填充
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;
@end


@implementation TNBargainSelectGoodsView
- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topView];
    [self.bgView addSubview:self.bottomView];
    if (iPhoneXSeries) {
        [self addSubview:self.iphoneXSeriousSafeAreaFillView];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
    [self.topView addGestureRecognizer:tap];
}
- (void)updateConstraints {
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    BOOL hasBottomFillView = _iphoneXSeriousSafeAreaFillView;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(self.bottomView.height + kiPhoneXSeriesSafeBottomHeight);
        if (hasBottomFillView) {
            make.bottom.equalTo(self.iphoneXSeriousSafeAreaFillView.mas_top);
        } else {
            make.bottom.equalTo(self.bgView);
        }
    }];
    if (hasBottomFillView) {
        [_iphoneXSeriousSafeAreaFillView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(kiPhoneXSeriesSafeBottomHeight);
        }];
    }
    [super updateConstraints];
}
- (void)setViewModel:(TNBargainViewModel *)viewModel {
    _viewModel = viewModel;
    self.bottomView.viewModel = viewModel;
    [self.bottomView layoutyImmediately];
}
#pragma mark - 显示和隐藏
- (void)show:(UIView *)inView {
    [inView addSubview:self];
    self.frame = kScreenBounds;
    self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.60];
    self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished){

    }];
}
- (void)dissmiss {
    if (_viewModel) {
        [_viewModel clearChooseGoodSpecData];
    }
    [self setNeedsUpdateConstraints];
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect newRect = self.frame;
        newRect.origin.y = kScreenHeight;
        self.frame = newRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - method
- (UILabel *)getCircleLabel:(UIColor *)color text:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.font = HDAppTheme.TinhNowFont.standard12;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = color;
    label.text = text;
    if ([text isEqualToString:@"1"]) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = HDAppTheme.TinhNowColor.G1;
    }
    label.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width * 0.5];
    };
    return label;
}
- (UIView *)getLineView:(UIColor *)color {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = color;
    return lineView;
}
- (UILabel *)getTipsLabel:(NSString *)tips {
    UILabel *label = [[UILabel alloc] init];
    label.font = HDAppTheme.TinhNowFont.standard14;
    label.textColor = HDAppTheme.TinhNowColor.C1;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = tips;
    return label;
}
/** @lazy  */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        //第一步
        UILabel *oneLabel = [self getCircleLabel:HDAppTheme.TinhNowColor.C1 text:@"1"];
        UIView *oneLineView = [self getLineView:HDAppTheme.TinhNowColor.C1];
        UILabel *oneTipsLabel = [self getTipsLabel:TNLocalizedString(@"tn_bargain_choose_good_tips_k", @"选择商品，完善地址信息")];
        [_topView addSubview:oneLabel];
        [_topView addSubview:oneLineView];
        [_topView addSubview:oneTipsLabel];
        [oneTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topView.mas_bottom).offset(-kRealWidth(50));
            make.right.equalTo(_topView.mas_centerX);
            make.width.mas_equalTo(150);
        }];
        [oneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_topView.mas_centerX);
            make.bottom.equalTo(oneTipsLabel.mas_top).offset(-kRealWidth(22));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(65), kRealHeight(2)));
        }];
        [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(oneLineView.mas_left);
            make.centerY.equalTo(oneLineView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
        }];

        //第二步
        UILabel *twoLabel = [self getCircleLabel:[UIColor hd_colorWithHexString:@"#EAF4FE"] text:@"2"];
        UIView *twoLineView = [self getLineView:[UIColor hd_colorWithHexString:@"#EAF4FE"]];
        UILabel *twoTipsLabel = [self getTipsLabel:TNLocalizedString(@"tn_bargain_people_help_tips_k", @"拉人助力")];
        [_topView addSubview:twoLabel];
        [_topView addSubview:twoLineView];
        [_topView addSubview:twoTipsLabel];

        [twoTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(oneTipsLabel.mas_top);
            make.left.equalTo(_topView.mas_centerX);
            make.width.mas_equalTo(150);
        }];
        [twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView.mas_centerX);
            make.bottom.equalTo(twoTipsLabel.mas_top).offset(-kRealWidth(22));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(65), kRealHeight(2)));
        }];
        [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(twoLineView.mas_right);
            make.centerY.equalTo(twoLineView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
        }];
    }
    return _topView;
}

/** @lazy  */
- (TNBargainSelectBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TNBargainSelectBottomView alloc] init];
        _bottomView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:16];
        };
        //        [_bottomView layoutyImmediately];
        @HDWeakify(self);
        _bottomView.bargainCloseCallBack = ^{
            @HDStrongify(self);
            [self dissmiss];
        };
        _bottomView.bargainConfirmCallBack = ^{
            @HDStrongify(self);
            if (self.createTaskClickCallBack) {
                self.createTaskClickCallBack(self);
            }
        };
    }
    return _bottomView;
}
- (UIView *)iphoneXSeriousSafeAreaFillView {
    if (!_iphoneXSeriousSafeAreaFillView) {
        _iphoneXSeriousSafeAreaFillView = [[UIView alloc] init];
        _iphoneXSeriousSafeAreaFillView.backgroundColor = [UIColor whiteColor];
    }
    return _iphoneXSeriousSafeAreaFillView;
}
@end
