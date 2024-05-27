//
//  TNInconmeAssetsView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNInconmeAssetsCell.h"
#import "TNIncomeModel.h"
#import "TNView.h"


@interface TNAssetsItemView : TNView
/// 文本
@property (strong, nonatomic) UILabel *nameLabel;
/// 价格
@property (strong, nonatomic) UILabel *priceLabel;
/// 疑问按钮
@property (strong, nonatomic) HDUIButton *doubtBtn;
///
@property (strong, nonatomic) UIView *lineView;
/// 点击疑问按钮 回调
@property (nonatomic, copy) void (^clickDoubtCallBack)(void);
/// 整个视图点击 回调
@property (nonatomic, copy) void (^itemClickCallBack)(void);
@end


@implementation TNAssetsItemView
- (void)hd_setupViews {
    self.userInteractionEnabled = YES;
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.doubtBtn];
    [self addSubview:self.lineView];
    [self addGestureRecognizer:self.hd_tapRecognizer];
}
- (void)hd_clickedViewHandler {
    !self.itemClickCallBack ?: self.itemClickCallBack();
}
- (void)updateConstraints {
    [self.doubtBtn sizeToFit];
    [self.doubtBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-2);
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
    }];
    CGFloat space = self.doubtBtn.imageView.image.size.width + 5;
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.mas_left).offset(space);
        make.right.equalTo(self.mas_right).offset(-space);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(space);
        make.right.equalTo(self.mas_right).offset(-space);
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(0.5, kRealWidth(30)));
    }];
    [super updateConstraints];
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard12;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _priceLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14];
        _priceLabel.numberOfLines = 2;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}
/** @lazy doubtBtn */
- (HDUIButton *)doubtBtn {
    if (!_doubtBtn) {
        _doubtBtn = [[HDUIButton alloc] init];
        [_doubtBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        _doubtBtn.hidden = YES;
        @HDWeakify(self);
        [_doubtBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickDoubtCallBack ?: self.clickDoubtCallBack();
        }];
    }
    return _doubtBtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _lineView;
}
@end


@interface TNInconmeAssetsCell ()
///背景图片
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) HDLabel *totalTitleLabel;
@property (nonatomic, strong) HDLabel *totalValueLabel;
@property (nonatomic, strong) HDUIButton *helpButton;
/// 中间view [可提现 + 预估收入 + 发起提现]
@property (nonatomic, strong) UIView *centerCardView;
/// 金额视图
@property (strong, nonatomic) UIStackView *amountStackView;
/// 可提现金额
@property (strong, nonatomic) TNAssetsItemView *canWithDrawItemView;
/// 兼职收益
@property (strong, nonatomic) TNAssetsItemView *partTimeIncomeItemView;
/// 预估收益
@property (strong, nonatomic) TNAssetsItemView *preIncomeItemView;
@property (nonatomic, strong) HDUIButton *withdrawButton;
@end


@implementation TNInconmeAssetsCell
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self.contentView addSubview:self.bgImgView];
    [self.contentView addSubview:self.totalTitleLabel];
    [self.contentView addSubview:self.totalValueLabel];
    [self.contentView addSubview:self.helpButton];
    [self.contentView addSubview:self.centerCardView];
    [self.centerCardView addSubview:self.amountStackView];
    [self.amountStackView addArrangedSubview:self.canWithDrawItemView];
    [self.amountStackView addArrangedSubview:self.partTimeIncomeItemView];
    [self.amountStackView addArrangedSubview:self.preIncomeItemView];
    [self.centerCardView addSubview:self.withdrawButton];

    self.partTimeIncomeItemView.hidden = ![TNGlobalData shared].seller.isNeedShowPartTimeIncome;
}
- (void)setIncomeModel:(TNIncomeModel *)incomeModel {
    _incomeModel = incomeModel;
    [self updateData];
}
- (void)updateData {
    self.totalValueLabel.text = !HDIsObjectNil(self.incomeModel.totalAssetsMoney) ? self.incomeModel.totalAssetsMoney.thousandSeparatorAmount : @"--";
    self.canWithDrawItemView.priceLabel.text = !HDIsObjectNil(self.incomeModel.commissionBalanceMoney) ? self.incomeModel.commissionBalanceMoney.thousandSeparatorAmount : @"--";
    self.preIncomeItemView.priceLabel.text = !HDIsObjectNil(self.incomeModel.frozenCommissionBalanceMoney) ? self.incomeModel.frozenCommissionBalanceMoney.thousandSeparatorAmount : @"--";
    self.partTimeIncomeItemView.priceLabel.text = !HDIsObjectNil(self.incomeModel.partTimeCommissionMoney) ? self.incomeModel.partTimeCommissionMoney.thousandSeparatorAmount : @"--";
    ;
    if (self.incomeModel.isExistWithdrawal) {
        self.withdrawButton.enabled = NO;
        self.withdrawButton.backgroundColor = HDAppTheme.TinhNowColor.G3;
        [self.withdrawButton setTitle:TNLocalizedString(@"VX7rIgUv", @"提现审核中") forState:UIControlStateNormal];
    } else {
        if (!HDIsObjectNil(self.incomeModel.commissionBalanceMoney) && [self.incomeModel.commissionBalanceMoney.cent doubleValue] > 0) {
            self.withdrawButton.enabled = YES;
            self.withdrawButton.backgroundColor = HDAppTheme.TinhNowColor.C1;
            [self.withdrawButton setTitle:TNLocalizedString(@"2DeMSpwN", @"发起提现") forState:UIControlStateNormal];
        } else {
            self.withdrawButton.enabled = NO;
            self.withdrawButton.backgroundColor = HDAppTheme.TinhNowColor.G3;
            [self.withdrawButton setTitle:TNLocalizedString(@"2DeMSpwN", @"发起提现") forState:UIControlStateNormal];
        }
    }
}
- (void)updateConstraints {
    [self.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        make.size.mas_equalTo(self.bgImgView.image.size);
    }];

    [self.totalTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(45));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-45));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(10));
    }];

    [self.totalValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.totalTitleLabel.mas_bottom).offset(kRealWidth(10));
    }];

    [self.helpButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.size.equalTo(@(CGSizeMake(kRealWidth(45), kRealWidth(45))));
        make.top.mas_equalTo(self.contentView.mas_top);
    }];

    [self.centerCardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.totalValueLabel.mas_bottom).offset(kRealWidth(10));
        make.height.equalTo(@(145));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.amountStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.centerCardView);
        make.height.mas_equalTo(kRealWidth(80));
    }];
    [self.withdrawButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerCardView.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.centerCardView.mas_right).offset(kRealWidth(-20));
        make.height.equalTo(@(40));
        make.bottom.mas_equalTo(self.centerCardView.mas_bottom).offset(kRealWidth(-15));
    }];
    [super updateConstraints];
}
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"tn_income_bg"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImgView;
}

- (HDLabel *)totalTitleLabel {
    if (!_totalTitleLabel) {
        _totalTitleLabel = [[HDLabel alloc] init];
        _totalTitleLabel.textColor = HDAppTheme.TinhNowColor.cFFFFFF;
        _totalTitleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _totalTitleLabel.textAlignment = NSTextAlignmentCenter;
        _totalTitleLabel.text = TNLocalizedString(@"RSiIEIYW", @"总资产");
    }
    return _totalTitleLabel;
}

- (HDLabel *)totalValueLabel {
    if (!_totalValueLabel) {
        _totalValueLabel = [[HDLabel alloc] init];
        _totalValueLabel.textColor = HDAppTheme.TinhNowColor.cFFFFFF;
        _totalValueLabel.font = [HDAppTheme.TinhNowFont fontSemibold:30];
        _totalValueLabel.textAlignment = NSTextAlignmentCenter;
        _totalValueLabel.text = @"--";
    }
    return _totalValueLabel;
}

- (HDUIButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setImage:[UIImage imageNamed:@"tn_income_help"] forState:UIControlStateNormal];

        [_helpButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [SAWindowManager openUrl:[[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowIncomeHelp] withParameters:nil];
            //            [SATalkingData trackEvent:@"[电商]卖家收益-帮助" label:@"" parameters:@{}];
        }];
    }
    return _helpButton;
}

- (UIView *)centerCardView {
    if (!_centerCardView) {
        _centerCardView = [[UIView alloc] init];
        _centerCardView.backgroundColor = HDAppTheme.TinhNowColor.cFFFFFF;
        _centerCardView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
        };
    }
    return _centerCardView;
}
/** @lazy  amountStackView*/
- (UIStackView *)amountStackView {
    if (!_amountStackView) {
        _amountStackView = [[UIStackView alloc] init];
        _amountStackView.axis = UILayoutConstraintAxisHorizontal;
        _amountStackView.spacing = 0;
        _amountStackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _amountStackView;
}
- (HDUIButton *)withdrawButton {
    if (!_withdrawButton) {
        _withdrawButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawButton setTitleColor:HDAppTheme.TinhNowColor.cFFFFFF forState:UIControlStateNormal];
        _withdrawButton.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        _withdrawButton.backgroundColor = HDAppTheme.TinhNowColor.G3;
        [_withdrawButton setTitle:TNLocalizedString(@"2DeMSpwN", @"发起提现") forState:UIControlStateNormal];
        _withdrawButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(20)];
        };
        @HDWeakify(self);
        [_withdrawButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.withDrawClickCallBack ?: self.withDrawClickCallBack();
        }];
        _withdrawButton.enabled = NO;
    }
    return _withdrawButton;
}
/** @lazy canWithDrawItemView */
- (TNAssetsItemView *)canWithDrawItemView {
    if (!_canWithDrawItemView) {
        _canWithDrawItemView = [[TNAssetsItemView alloc] init];
        _canWithDrawItemView.nameLabel.text = TNLocalizedString(@"rwVSz8v3", @"可提现");
    }
    return _canWithDrawItemView;
}
/** @lazy partTimeIncomeItemView */
- (TNAssetsItemView *)partTimeIncomeItemView {
    if (!_partTimeIncomeItemView) {
        _partTimeIncomeItemView = [[TNAssetsItemView alloc] init];
        _partTimeIncomeItemView.nameLabel.text = TNLocalizedString(@"UYkt3Raq", @"兼职收益");
        _partTimeIncomeItemView.doubtBtn.hidden = NO;
        _partTimeIncomeItemView.clickDoubtCallBack = ^{
            HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
            config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
            config.titleColor = HDAppTheme.TinhNowColor.G1;
            config.messageFont = HDAppTheme.TinhNowFont.standard12;
            config.messageColor = HDAppTheme.TinhNowColor.G2;
            HDAlertView *alertView = [HDAlertView alertViewWithTitle:TNLocalizedString(@"UYkt3Raq", @"兼职收益")
                                                             message:TNLocalizedString(@"gBDoAbUa", @"兼职收益：兼职卖家产生海外购订单的已结算收益，不能自行提现，这部分收益请联系客服提现")
                                                              config:config];
            alertView.identitableString = @"兼职收益";
            HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCustom
                                                                   handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                       [alertView dismiss];
                                                                   }];
            [alertView addButtons:@[button]];
            [alertView show];
        };
    }
    return _partTimeIncomeItemView;
}
/** @lazy preIncomeItemView */
- (TNAssetsItemView *)preIncomeItemView {
    if (!_preIncomeItemView) {
        _preIncomeItemView = [[TNAssetsItemView alloc] init];
        _preIncomeItemView.nameLabel.text = TNLocalizedString(@"xHpMQ6s4", @"预估收入");
        _preIncomeItemView.lineView.hidden = YES;
        @HDWeakify(self);
        _preIncomeItemView.itemClickCallBack = ^{
            @HDStrongify(self);
            if (HDIsObjectNil(self.incomeModel)) {
                return;
            }
            !self.preIncomeClickCallBack ?: self.preIncomeClickCallBack();
        };
    }
    return _preIncomeItemView;
}
@end
