//
//  TNIncomeToggleHeaderView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNIncomeToggleHeaderView.h"
#import "TNView.h"


@interface TNIncomeToggleControl : UIControl
///
@property (strong, nonatomic) UILabel *nameLabel;
/// 疑问按钮
@property (strong, nonatomic) HDUIButton *doubtBtn;
///
@property (strong, nonatomic) UIImageView *lineView;
/// 点击疑问按钮 回调
@property (nonatomic, copy) void (^clickDoubtCallBack)(void);
/// 整个视图点击 回调
@property (nonatomic, copy) void (^itemClickCallBack)(TNIncomeToggleControl *control);
@end


@implementation TNIncomeToggleControl

- (instancetype)init {
    if (self = [super init]) {
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [self addSubview:self.doubtBtn];
    [self addSubview:self.lineView];
    [self addTarget:self action:@selector(onClickItem) forControlEvents:UIControlEventTouchUpInside];
}
- (void)updateConstraints {
    [self.nameLabel sizeToFit];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.lessThanOrEqualTo(self.mas_left).offset(kRealWidth(40)).priorityLow();
        make.right.lessThanOrEqualTo(self.mas_right).offset(-kRealWidth(40)).priorityLow();
    }];
    [self.doubtBtn sizeToFit];
    [self.doubtBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(kRealWidth(5));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        //        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), 2));
    }];
    [super updateConstraints];
}
- (void)onClickItem {
    !self.itemClickCallBack ?: self.itemClickCallBack(self);
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _nameLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
/** @lazy doubtBtn */
- (HDUIButton *)doubtBtn {
    if (!_doubtBtn) {
        _doubtBtn = [[HDUIButton alloc] init];
        [_doubtBtn setImage:[UIImage imageNamed:@"tn_order_explan"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_doubtBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickDoubtCallBack ?: self.clickDoubtCallBack();
        }];
    }
    return _doubtBtn;
}
/** @lazy lineView */
- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_gradient_line"]];
        [_lineView sizeToFit];
    }
    return _lineView;
}
@end


@interface TNIncomeToggleHeaderView ()
/// 圆角背景视图
@property (strong, nonatomic) UIView *containerView;
///
@property (strong, nonatomic) UIStackView *stackView;
/// 普通收益
@property (strong, nonatomic) TNIncomeToggleControl *normalControl;
/// 兼职收益
@property (strong, nonatomic) TNIncomeToggleControl *partTimeControl;
@end


@implementation TNIncomeToggleHeaderView
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.normalControl];
    [self.stackView addArrangedSubview:self.partTimeControl];
    [self.normalControl sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.partTimeControl.hidden = ![TNGlobalData shared].seller.isNeedShowPartTimeIncome;
    ;
}
- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [super updateConstraints];
}
/** @lazy stackView */
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.spacing = 0;
        _stackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _stackView;
}
/** @lazy normalControl */
- (TNIncomeToggleControl *)normalControl {
    if (!_normalControl) {
        _normalControl = [[TNIncomeToggleControl alloc] init];
        _normalControl.nameLabel.text = TNLocalizedString(@"3Rg5syJS", @"普通收益");
        _normalControl.nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _normalControl.clickDoubtCallBack = ^{
            HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
            config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
            config.titleColor = HDAppTheme.TinhNowColor.G1;
            config.messageFont = HDAppTheme.TinhNowFont.standard12;
            config.messageColor = HDAppTheme.TinhNowColor.G2;
            HDAlertView *alertView = [HDAlertView alertViewWithTitle:TNLocalizedString(@"3Rg5syJS", @"普通收益")
                                                             message:TNLocalizedString(@"2FyXKLNM", @"1、普通卖家产生的所有订单结算收益 \n 2、兼职卖家产生的非海外购结算收益")
                                                              config:config];
            alertView.identitableString = @"普通收益";
            HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCustom
                                                                   handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                       [alertView dismiss];
                                                                   }];
            [alertView addButtons:@[button]];
            [alertView show];
        };
        @HDWeakify(self);
        _normalControl.itemClickCallBack = ^(TNIncomeToggleControl *control) {
            @HDStrongify(self);
            if (control.isSelected) {
                return;
            }
            control.selected = YES;
            control.nameLabel.textColor = HDAppTheme.TinhNowColor.C1;
            control.lineView.hidden = NO;

            self.partTimeControl.nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
            self.partTimeControl.lineView.hidden = YES;
            self.partTimeControl.selected = NO;
            !self.itemClickCallBack ?: self.itemClickCallBack(TNSellerIdentityTypeNormal);
        };
    }
    return _normalControl;
}
/** @lazy partTimeControl */
- (TNIncomeToggleControl *)partTimeControl {
    if (!_partTimeControl) {
        _partTimeControl = [[TNIncomeToggleControl alloc] init];
        _partTimeControl.nameLabel.text = TNLocalizedString(@"UYkt3Raq", @"兼职收益");
        _partTimeControl.lineView.hidden = YES;
        _partTimeControl.clickDoubtCallBack = ^{
            HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
            config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
            config.titleColor = HDAppTheme.TinhNowColor.G1;
            config.messageFont = HDAppTheme.TinhNowFont.standard12;
            config.messageColor = HDAppTheme.TinhNowColor.G2;
            HDAlertView *alertView = [HDAlertView alertViewWithTitle:TNLocalizedString(@"UYkt3Raq", @"兼职收益")
                                                             message:TNLocalizedString(@"gBDoAbUa", @"兼职卖家产生海外购订单的已结算收益，不能自行提现，这部分收益请联系客服提现")
                                                              config:config];
            alertView.identitableString = @"兼职收益";
            HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCustom
                                                                   handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                       [alertView dismiss];
                                                                   }];
            [alertView addButtons:@[button]];
            [alertView show];
        };
        @HDWeakify(self);
        _partTimeControl.itemClickCallBack = ^(TNIncomeToggleControl *control) {
            @HDStrongify(self);
            if (control.isSelected) {
                return;
            }
            control.selected = YES;
            control.nameLabel.textColor = HDAppTheme.TinhNowColor.C1;
            control.lineView.hidden = NO;

            self.normalControl.nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
            self.normalControl.lineView.hidden = YES;
            self.normalControl.selected = NO;
            !self.itemClickCallBack ?: self.itemClickCallBack(TNSellerIdentityTypePartTime);
        };
    }
    return _partTimeControl;
}

/** @lazy  containerView*/
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(8)];
        };
    }
    return _containerView;
}
@end
