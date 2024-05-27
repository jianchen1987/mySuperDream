//
//  TNNewIncomeAssetsCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeAssetsCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNNewProfitIncomeModel.h"


@interface TNNewIncomeAssetsCell ()
/// 容器
@property (strong, nonatomic) UIView *containerView;
/// 已结算吗视图
@property (strong, nonatomic) UIControl *settledContentView;
/// 已结算文案
@property (strong, nonatomic) UILabel *settledTitleLabel;
/// 已结算金额
@property (strong, nonatomic) UILabel *settledAmountLabel;
/// 已结算按钮
@property (strong, nonatomic) HDUIButton *settledQustionBtn;
/// 已结算底部线条
@property (strong, nonatomic) UIImageView *settledLineImageView;
/// 预估视图
@property (strong, nonatomic) UIControl *estimateContentView;
/// 预估文案
@property (strong, nonatomic) UILabel *estimateTitleLabel;
/// 预估金额
@property (strong, nonatomic) UILabel *estimateAmountLabel;
/// 预估按钮
@property (strong, nonatomic) HDUIButton *estimateQustionBtn;
/// 预估底部线条
@property (strong, nonatomic) UIImageView *estimateLineImageView;
///中间分割线
@property (strong, nonatomic) UIView *lineView;
@end


@implementation TNNewIncomeAssetsCell

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.settledContentView];
    [self.settledContentView addSubview:self.settledTitleLabel];
    [self.settledContentView addSubview:self.settledAmountLabel];
    [self.settledContentView addSubview:self.settledQustionBtn];
    [self.settledContentView addSubview:self.settledLineImageView];

    [self.containerView addSubview:self.estimateContentView];
    [self.estimateContentView addSubview:self.estimateTitleLabel];
    [self.estimateContentView addSubview:self.estimateAmountLabel];
    [self.estimateContentView addSubview:self.estimateQustionBtn];
    [self.estimateContentView addSubview:self.estimateLineImageView];

    [self.containerView addSubview:self.lineView];
}
- (void)setIncomeModel:(TNNewProfitIncomeModel *)incomeModel {
    _incomeModel = incomeModel;
    self.settledAmountLabel.text = !HDIsObjectNil(incomeModel.settlementBalance) ? incomeModel.settlementBalance.thousandSeparatorAmount : @"-";
    self.estimateAmountLabel.text = !HDIsObjectNil(incomeModel.frozenCommissionBalance) ? incomeModel.frozenCommissionBalance.thousandSeparatorAmount : @"-";
}
- (void)setQueryMode:(NSInteger)queryMode {
    _queryMode = queryMode;
    if (queryMode == 1) {
        self.settledTitleLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.settledAmountLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.settledLineImageView.hidden = NO;

        self.estimateTitleLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        self.estimateAmountLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        self.estimateLineImageView.hidden = YES;
    } else if (queryMode == 2) {
        self.settledTitleLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        self.settledAmountLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        self.settledLineImageView.hidden = YES;

        self.estimateTitleLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.estimateAmountLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.estimateLineImageView.hidden = NO;
    }
}
///点击已结算
- (void)clickSettled {
    if (self.queryMode == 1) {
        return;
    }
    !self.settledAndPreIncomeToggleCallBack ?: self.settledAndPreIncomeToggleCallBack(1);
}
///点击预估收入
- (void)clickPreIncome {
    if (self.queryMode == 2) {
        return;
    }
    !self.settledAndPreIncomeToggleCallBack ?: self.settledAndPreIncomeToggleCallBack(2);
}
- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.settledContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.containerView);
    }];
    [self.settledTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settledContentView.mas_top).offset(kRealWidth(10));
        make.centerX.equalTo(self.settledContentView);
    }];
    [self.settledQustionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.settledTitleLabel.mas_centerY);
        make.left.equalTo(self.settledTitleLabel.mas_right).offset(20);
    }];
    [self.settledAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.settledContentView);
        make.top.equalTo(self.settledTitleLabel.mas_bottom).offset(kRealWidth(5));
    }];
    [self.settledLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.settledContentView);
        make.top.equalTo(self.settledAmountLabel.mas_bottom).offset(kRealWidth(5));
        make.bottom.equalTo(self.settledContentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, kRealHeight(30)));
    }];
    [self.estimateContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.containerView);
        make.left.equalTo(self.settledContentView.mas_right);
        make.width.equalTo(self.settledContentView.mas_width);
    }];
    [self.estimateTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimateContentView.mas_top).offset(kRealWidth(10));
        make.centerX.equalTo(self.estimateContentView);
    }];
    [self.estimateQustionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.estimateTitleLabel.mas_centerY);
        make.left.equalTo(self.estimateTitleLabel.mas_right).offset(20);
    }];
    [self.estimateAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.estimateContentView);
        make.top.equalTo(self.estimateTitleLabel.mas_bottom).offset(kRealWidth(5));
    }];
    [self.estimateLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.estimateContentView);
        make.top.equalTo(self.estimateAmountLabel.mas_bottom).offset(kRealWidth(5));
        make.bottom.equalTo(self.estimateContentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}
/** @lazy containerView */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
        };
    }
    return _containerView;
}
/** @lazy  settledContentView*/
- (UIControl *)settledContentView {
    if (!_settledContentView) {
        _settledContentView = [[UIControl alloc] init];
        [_settledContentView addTarget:self action:@selector(clickSettled) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settledContentView;
}
/** @lazy settledTitleLabel */
- (UILabel *)settledTitleLabel {
    if (!_settledTitleLabel) {
        _settledTitleLabel = [[UILabel alloc] init];
        _settledTitleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _settledTitleLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _settledTitleLabel.textAlignment = NSTextAlignmentCenter;
        _settledTitleLabel.text = TNLocalizedString(@"pkjnFFIN", @"已结算");
    }
    return _settledTitleLabel;
}
/** @lazy settledAmountLabel */
- (UILabel *)settledAmountLabel {
    if (!_settledAmountLabel) {
        _settledAmountLabel = [[UILabel alloc] init];
        _settledAmountLabel.font = [HDAppTheme.TinhNowFont fontSemibold:16];
        _settledAmountLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _settledAmountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _settledAmountLabel;
}
/** @lazy settledQustionBtn */
- (HDUIButton *)settledQustionBtn {
    if (!_settledQustionBtn) {
        _settledQustionBtn = [[HDUIButton alloc] init];
        [_settledQustionBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        [_settledQustionBtn sizeToFit];
        [_settledQustionBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
            config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
            config.titleColor = HDAppTheme.TinhNowColor.G1;
            config.messageFont = HDAppTheme.TinhNowFont.standard12;
            config.messageColor = HDAppTheme.TinhNowColor.G2;
            HDAlertView *alertView = [HDAlertView alertViewWithTitle:TNLocalizedString(@"pkjnFFIN", @"已结算") message:TNLocalizedString(@"eS9STDsS", @"已结算金额为已到账钱包的累积") config:config];
            alertView.identitableString = @"已结算";
            HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCustom
                                                                   handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                       [alertView dismiss];
                                                                   }];
            [alertView addButtons:@[button]];
            [alertView show];
        }];
    }
    return _settledQustionBtn;
}
/** @lazy settledLineImageView */
- (UIImageView *)settledLineImageView {
    if (!_settledLineImageView) {
        _settledLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_gradient_line"]];
        [_settledLineImageView sizeToFit];
    }
    return _settledLineImageView;
}

/** @lazy  estimateContentView*/
- (UIControl *)estimateContentView {
    if (!_estimateContentView) {
        _estimateContentView = [[UIControl alloc] init];
        [_estimateContentView addTarget:self action:@selector(clickPreIncome) forControlEvents:UIControlEventTouchUpInside];
    }
    return _estimateContentView;
}
/** @lazy estimateTitleLabel */
- (UILabel *)estimateTitleLabel {
    if (!_estimateTitleLabel) {
        _estimateTitleLabel = [[UILabel alloc] init];
        _estimateTitleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _estimateTitleLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _estimateTitleLabel.textAlignment = NSTextAlignmentCenter;
        _estimateTitleLabel.text = TNLocalizedString(@"xHpMQ6s4", @"预估收入");
    }
    return _estimateTitleLabel;
}
/** @lazy estimateAmountLabel */
- (UILabel *)estimateAmountLabel {
    if (!_estimateAmountLabel) {
        _estimateAmountLabel = [[UILabel alloc] init];
        _estimateAmountLabel.font = [HDAppTheme.TinhNowFont fontSemibold:16];
        _estimateAmountLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _estimateAmountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _estimateAmountLabel;
}
/** @lazy estimateQustionBtn */
- (HDUIButton *)estimateQustionBtn {
    if (!_estimateQustionBtn) {
        _estimateQustionBtn = [[HDUIButton alloc] init];
        [_estimateQustionBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        [_estimateQustionBtn sizeToFit];
        [_estimateQustionBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
            config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
            config.titleColor = HDAppTheme.TinhNowColor.G1;
            config.messageFont = HDAppTheme.TinhNowFont.standard12;
            config.messageColor = HDAppTheme.TinhNowColor.G2;
            HDAlertView *alertView = [HDAlertView alertViewWithTitle:TNLocalizedString(@"rhn0c4KT", @"预估收益") message:TNLocalizedString(@"PyKIqvR0", @"尚未到钱包的金额") config:config];
            alertView.identitableString = @"预估收益";
            HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCustom
                                                                   handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                       [alertView dismiss];
                                                                   }];
            [alertView addButtons:@[button]];
            [alertView show];
        }];
    }
    return _estimateQustionBtn;
}
/** @lazy settledLineImageView */
- (UIImageView *)estimateLineImageView {
    if (!_estimateLineImageView) {
        _estimateLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_gradient_line"]];
        [_estimateLineImageView sizeToFit];
    }
    return _estimateLineImageView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _lineView;
}
@end
