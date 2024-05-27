//
//  TNSpecificationTabView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecificationTabView.h"


@interface TNSpecificationTabView ()
/// 批量买
@property (strong, nonatomic) HDUIButton *batchBtn;
/// 单买
@property (strong, nonatomic) HDUIButton *singleBtn;
/// 单买
@property (strong, nonatomic) UIView *batchLineView;
///
@property (strong, nonatomic) UIView *singleLineViww;
@end


@implementation TNSpecificationTabView
- (void)hd_setupViews {
    [self addSubview:self.batchBtn];
    [self addSubview:self.singleBtn];
    [self addSubview:self.batchLineView];
    [self addSubview:self.singleLineViww];
    self.singleBtn.selected = YES;
    self.batchBtn.selected = NO;
    self.batchLineView.hidden = YES;
    self.singleLineViww.hidden = NO;
}
- (void)updateConstraints {
    [self.batchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.singleBtn.mas_width);
    }];
    [self.singleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.batchBtn.mas_right);
    }];
    [self.batchLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self.batchBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(3)));
    }];
    [self.singleLineViww mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self.singleBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(3)));
    }];
    [super updateConstraints];
}
/** @lazy batchBtn */
- (HDUIButton *)batchBtn {
    if (!_batchBtn) {
        _batchBtn = [[HDUIButton alloc] init];
        _batchBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:16];
        [_batchBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
        [_batchBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_batchBtn setTitle:TNLocalizedString(@"d6Te2ndf", @"批量") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_batchBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.batchBtn.isSelected) {
                return;
            }
            self.singleBtn.selected = NO;
            self.batchBtn.selected = YES;
            self.batchLineView.hidden = NO;
            self.singleLineViww.hidden = YES;
            !self.toggleCallBack ?: self.toggleCallBack(TNSalesTypeBatch);
        }];
    }
    return _batchBtn;
}
/** @lazy singleBtn */
- (HDUIButton *)singleBtn {
    if (!_singleBtn) {
        _singleBtn = [[HDUIButton alloc] init];
        _singleBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:16];
        [_singleBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
        [_singleBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_singleBtn setTitle:TNLocalizedString(@"6jak19x8", @"单买") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_singleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.singleBtn.isSelected) {
                return;
            }
            self.singleBtn.selected = YES;
            self.batchBtn.selected = NO;
            self.batchLineView.hidden = YES;
            self.singleLineViww.hidden = NO;
            !self.toggleCallBack ?: self.toggleCallBack(TNSalesTypeSingle);
        }];
    }
    return _singleBtn;
}
/** @lazy batchLineView */
- (UIView *)batchLineView {
    if (!_batchLineView) {
        _batchLineView = [[UIView alloc] init];
        _batchLineView.backgroundColor = HDAppTheme.TinhNowColor.C1;
    }
    return _batchLineView;
}
/** @lazy singleLineViww */
- (UIView *)singleLineViww {
    if (!_singleLineViww) {
        _singleLineViww = [[UIView alloc] init];
        _singleLineViww.backgroundColor = HDAppTheme.TinhNowColor.C1;
    }
    return _singleLineViww;
}
@end
