//
//  TNShopCarTabView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNShopCarTabView.h"


@interface TNShopCarTabView ()
/// 批量点击背景
@property (strong, nonatomic) UIControl *batchControl;
/// 单买点击背景
@property (strong, nonatomic) UIControl *singleControl;
/// 批量文案
@property (strong, nonatomic) UILabel *batchLabel;
/// 单买文案
@property (strong, nonatomic) UILabel *singleLabel;
/// 批量
@property (strong, nonatomic) HDUIButton *batchQuestionBtn;
/// 单买
@property (strong, nonatomic) HDUIButton *singleQuestionBtn;
/// 批量分割线
@property (strong, nonatomic) UIView *batchLineView;
/// 单买分割线
@property (strong, nonatomic) UIView *singleLineView;

/// 类型
@property (nonatomic, copy) TNSalesType salesType;
@end


@implementation TNShopCarTabView

- (void)hd_setupViews {
    [self addSubview:self.batchControl];
    [self addSubview:self.singleControl];
    [self.batchControl addSubview:self.batchLabel];
    [self.batchControl addSubview:self.batchQuestionBtn];
    [self.batchControl addSubview:self.batchLineView];

    [self.singleControl addSubview:self.singleLabel];
    [self.singleControl addSubview:self.singleQuestionBtn];
    [self.singleControl addSubview:self.singleLineView];
}
- (void)setCurrentSalesType:(TNSalesType)salesType {
    self.salesType = salesType;
    [self updateUI];
    [self setNeedsUpdateConstraints];
}
- (void)updateSingleCount:(NSInteger)count {
    self.singleLabel.text = [NSString stringWithFormat:@"%@(%ld)", TNLocalizedString(@"6jak19x8", @"单买"), count];
}

- (void)updateBatchCount:(NSInteger)count {
    self.batchLabel.text = [NSString stringWithFormat:@"%@(%ld)", TNLocalizedString(@"d6Te2ndf", @"批量"), count];
}
#pragma mark -批量点击
- (void)batchClick {
    self.salesType = TNSalesTypeBatch;
    [self updateUI];
    !self.toggleCallBack ?: self.toggleCallBack(self.salesType);
}
#pragma mark -单买点击
- (void)singleClick {
    self.salesType = TNSalesTypeSingle;
    [self updateUI];
    !self.toggleCallBack ?: self.toggleCallBack(self.salesType);
}
- (void)updateUI {
    if ([self.salesType isEqualToString:TNSalesTypeBatch]) {
        [self.batchQuestionBtn setImage:[UIImage imageNamed:@"tn_explan_orange"] forState:UIControlStateNormal];
        self.batchLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.batchLineView.hidden = NO;

        [self.singleQuestionBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        self.singleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.singleLineView.hidden = YES;
    } else if ([self.salesType isEqualToString:TNSalesTypeSingle]) {
        [self.singleQuestionBtn setImage:[UIImage imageNamed:@"tn_explan_orange"] forState:UIControlStateNormal];
        self.singleLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.singleLineView.hidden = NO;

        [self.batchQuestionBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        self.batchLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.batchLineView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.singleControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.batchControl.mas_width);
    }];
    [self.batchControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.singleControl.mas_right);
    }];
    [self.batchLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.batchControl.mas_centerX).offset(-kRealWidth(10));
        make.centerY.equalTo(self.batchControl);
    }];

    [self.batchLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.batchLabel.mas_centerX);
        make.bottom.equalTo(self.batchControl);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(3)));
    }];

    [self.batchQuestionBtn sizeToFit];
    [self.batchQuestionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.batchControl);
        make.left.equalTo(self.batchLabel.mas_right);
        make.width.mas_equalTo(kRealWidth(36));
    }];

    [self.singleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.singleControl.mas_centerX).offset(-kRealWidth(10));
        make.centerY.equalTo(self.singleControl);
    }];

    [self.singleLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.singleLabel.mas_centerX);
        make.bottom.equalTo(self.singleControl);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(3)));
    }];

    [self.singleQuestionBtn sizeToFit];
    [self.singleQuestionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.singleControl);
        make.left.equalTo(self.singleLabel.mas_right);
        make.width.mas_equalTo(kRealWidth(36));
    }];

    [super updateConstraints];
}

/** @lazy batchControl */
- (UIControl *)batchControl {
    if (!_batchControl) {
        _batchControl = [[UIControl alloc] init];
        [_batchControl addTarget:self action:@selector(batchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _batchControl;
}

/** @lazy singleControl */
- (UIControl *)singleControl {
    if (!_singleControl) {
        _singleControl = [[UIControl alloc] init];
        [_singleControl addTarget:self action:@selector(singleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singleControl;
}

/** @lazy batchLabel */
- (UILabel *)batchLabel {
    if (!_batchLabel) {
        _batchLabel = [[UILabel alloc] init];
        _batchLabel.font = [HDAppTheme.TinhNowFont fontMedium:16];
        _batchLabel.text = [NSString stringWithFormat:@"%@(%d)", TNLocalizedString(@"d6Te2ndf", @"批量"), 0];
    }
    return _batchLabel;
}
/** @lazy singleLabel */
- (UILabel *)singleLabel {
    if (!_singleLabel) {
        _singleLabel = [[UILabel alloc] init];
        _singleLabel.font = [HDAppTheme.TinhNowFont fontMedium:16];
        _singleLabel.text = [NSString stringWithFormat:@"%@(%d)", TNLocalizedString(@"6jak19x8", @"单买"), 0];
    }
    return _singleLabel;
}

/** @lazy batchQuestionBtn */
- (HDUIButton *)batchQuestionBtn {
    if (!_batchQuestionBtn) {
        _batchQuestionBtn = [[HDUIButton alloc] init];
        @HDWeakify(self);
        [_batchQuestionBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.buyQustionCallBack ?: self.buyQustionCallBack(TNSalesTypeBatch);
        }];
    }
    return _batchQuestionBtn;
}
/** @lazy singleBtn */
- (HDUIButton *)singleQuestionBtn {
    if (!_singleQuestionBtn) {
        _singleQuestionBtn = [[HDUIButton alloc] init];
        @HDWeakify(self);
        [_singleQuestionBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.buyQustionCallBack ?: self.buyQustionCallBack(TNSalesTypeSingle);
        }];
    }
    return _singleQuestionBtn;
}
/** @lazy batchLineView */
- (UIView *)batchLineView {
    if (!_batchLineView) {
        _batchLineView = [[UIView alloc] init];
        _batchLineView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _batchLineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _batchLineView;
}
/** @lazy singleLineView */
- (UIView *)singleLineView {
    if (!_singleLineView) {
        _singleLineView = [[UIView alloc] init];
        _singleLineView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _singleLineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _singleLineView;
}
@end
