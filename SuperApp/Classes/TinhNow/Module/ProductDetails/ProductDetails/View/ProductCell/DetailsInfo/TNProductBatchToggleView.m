//
//  TNProductBatchToggleView.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBatchToggleView.h"


@interface TNProductBatchToggleView ()
/// 背景视图
@property (strong, nonatomic) UIImageView *backgroudImageView;
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
@property (strong, nonatomic) UIImageView *batchLineView;
/// 单买分割线
@property (strong, nonatomic) UIImageView *singleLineView;
@end


@implementation TNProductBatchToggleView

- (void)hd_setupViews {
    [self addSubview:self.backgroudImageView];
    [self.backgroudImageView addSubview:self.batchControl];
    [self.backgroudImageView addSubview:self.singleControl];
    [self.batchControl addSubview:self.batchLabel];
    [self.batchControl addSubview:self.batchQuestionBtn];
    [self.batchControl addSubview:self.batchLineView];

    [self.singleControl addSubview:self.singleLabel];
    [self.singleControl addSubview:self.singleQuestionBtn];
    [self.singleControl addSubview:self.singleLineView];
}
- (void)setModel:(TNProductBatchToggleCellModel *)model {
    _model = model;
    [self updateUI];
    [self setNeedsUpdateConstraints];
}
#pragma mark -批量点击
- (void)batchClick {
    self.model.salesType = TNSalesTypeBatch;
    [self updateUI];
    !self.model.toggleCallBack ?: self.model.toggleCallBack(self.model.salesType);
}
#pragma mark -单买点击
- (void)singleClick {
    self.model.salesType = TNSalesTypeSingle;
    [self updateUI];
    !self.model.toggleCallBack ?: self.model.toggleCallBack(self.model.salesType);
}
- (void)updateUI {
    if (self.model.hiddenQuestionBtn) {
        self.batchQuestionBtn.hidden = YES;
        self.singleQuestionBtn.hidden = YES;
    }
    if ([self.model.salesType isEqualToString:TNSalesTypeBatch]) {
        [self.batchQuestionBtn setImage:[UIImage imageNamed:@"tn_explan_orange"] forState:UIControlStateNormal];
        self.batchLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.batchLineView.hidden = NO;

        [self.singleQuestionBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        self.singleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.singleLineView.hidden = YES;

        self.backgroudImageView.image = [UIImage imageNamed:@"tn_batchbuy_backgroud"];
    } else if ([self.model.salesType isEqualToString:TNSalesTypeSingle]) {
        [self.singleQuestionBtn setImage:[UIImage imageNamed:@"tn_explan_orange"] forState:UIControlStateNormal];
        self.singleLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.singleLineView.hidden = NO;

        [self.batchQuestionBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        self.batchLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.batchLineView.hidden = YES;

        self.backgroudImageView.image = [UIImage imageNamed:@"tn_singlebuy_backgroud"];
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.backgroudImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.batchControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.backgroudImageView);
        make.width.equalTo(self.singleControl.mas_width);
    }];
    [self.singleControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.backgroudImageView);
        make.left.equalTo(self.batchControl.mas_right);
    }];
    [self.batchLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.batchControl.mas_centerX).offset(!self.batchQuestionBtn.isHidden ? -kRealWidth(10) : 0);
        make.centerY.equalTo(self.batchControl);
    }];

    [self.batchLineView sizeToFit];
    [self.batchLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.batchLabel.mas_centerX);
        make.bottom.equalTo(self.batchControl);
        //        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(3)));
    }];
    if (!self.batchQuestionBtn.isHidden) {
        [self.batchQuestionBtn sizeToFit];
        [self.batchQuestionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.batchControl);
            make.left.equalTo(self.batchLabel.mas_right);
            make.width.mas_equalTo(kRealWidth(36));
        }];
    }

    [self.singleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.singleControl.mas_centerX).offset(!self.singleQuestionBtn.isHidden ? -kRealWidth(10) : 0);
        make.centerY.equalTo(self.singleControl);
    }];

    [self.singleLineView sizeToFit];
    [self.singleLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.singleLabel.mas_centerX);
        make.bottom.equalTo(self.singleControl);
        //        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(3)));
    }];

    if (!self.singleQuestionBtn.isHidden) {
        [self.singleQuestionBtn sizeToFit];
        [self.singleQuestionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.singleControl);
            make.left.equalTo(self.singleLabel.mas_right);
            make.width.mas_equalTo(kRealWidth(36));
        }];
    }
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
        _batchLabel.text = TNLocalizedString(@"d6Te2ndf", @"批量");
    }
    return _batchLabel;
}
/** @lazy singleLabel */
- (UILabel *)singleLabel {
    if (!_singleLabel) {
        _singleLabel = [[UILabel alloc] init];
        _singleLabel.font = [HDAppTheme.TinhNowFont fontMedium:16];
        _singleLabel.text = TNLocalizedString(@"6jak19x8", @"单买");
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
            !self.model.buyQustionCallBack ?: self.model.buyQustionCallBack(TNSalesTypeBatch);
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
            !self.model.buyQustionCallBack ?: self.model.buyQustionCallBack(TNSalesTypeSingle);
        }];
    }
    return _singleQuestionBtn;
}
/** @lazy batchLineView */
- (UIView *)batchLineView {
    if (!_batchLineView) {
        _batchLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_gradient_line"]];
        //        _batchLineView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        //        _batchLineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        //        };
    }
    return _batchLineView;
}
/** @lazy singleLineView */
- (UIImageView *)singleLineView {
    if (!_singleLineView) {
        _singleLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_gradient_line"]];
        //        _singleLineView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        //        _singleLineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        //        };
    }
    return _singleLineView;
}
/** @lazy backgroudImageView */
- (UIImageView *)backgroudImageView {
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] init];
        _backgroudImageView.userInteractionEnabled = YES;
    }
    return _backgroudImageView;
}

@end
