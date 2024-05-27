//
//  SAWaitPayResultViewController.m
//  SuperApp
//
//  Created by Tia on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAWaitPayResultViewController.h"
#import "HDCheckStandViewController.h"
#import "HDTradeBuildOrderModel.h"
#import "SAAppSwitchManager.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "SAOperationButton.h"
#import "UIViewController+NavigationController.h"


@interface SAWaitPayResultViewController ()
/// 下单模型
@property (nonatomic, strong) HDTradeBuildOrderModel *buildModel;
/// 高度，不设置将使用默认高度
@property (nonatomic, assign) CGFloat preferedHeight;
///支付流水次数
@property (nonatomic, assign) NSInteger times;
/// 收银台代理
@property (nonatomic, weak) id<HDCheckStandViewControllerDelegate> resultDelegate;

/// 订单状态图标
@property (nonatomic, strong) UIImageView *statusIV;
/// 提示文案
@property (nonatomic, strong) SALabel *tipLabel;
/// 支付金额文案
@property (nonatomic, strong) SALabel *moneyLabel;
/// 支付遇到问题文案
@property (nonatomic, strong) SALabel *payProblemLabel;

/// 等待容器
@property (nonatomic, strong) UIView *waitView;
/// 等待文案
@property (nonatomic, strong) SALabel *waitLabel;
/// 我知道了按钮
@property (nonatomic, strong) SAOperationButton *waitBTN;

/// 重新支付容器
@property (nonatomic, strong) UIView *repayView;
/// 重新支付提示文言
@property (nonatomic, strong) SALabel *repayLabel;
/// 重新支付按钮
@property (nonatomic, strong) SAOperationButton *repayBTN;
/// 重新支付超出次数警告文案
@property (nonatomic, strong) SALabel *repayTipLabel;
/// 重新支付超出次数警告图标
@property (nonatomic, strong) UIImageView *waringIV;

///以为提示用户重新选择支付通道的 电商才会出现 已经预选了支付方式  备选更改支付方式支付
/// 更换支付方式容器
@property (nonatomic, strong) UIView *changePayMethodView;
/// 更换支付方式提示文言
@property (nonatomic, strong) SALabel *changePayMethodLabel;
/// 更换支付方式按钮
@property (nonatomic, strong) SAOperationButton *changePayMethodBTN;
@end


@implementation SAWaitPayResultViewController

//最大支付流水次数
static int kMaxTimes = 9;

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.buildModel = parameters[@"buildModel"];
    self.preferedHeight = [parameters[@"preferedHeight"] doubleValue] ? [parameters[@"preferedHeight"] doubleValue] : 0;
    self.resultDelegate = parameters[@"resultDelegate"] ?: nil;
    self.times = MIN(kMaxTimes, MAX(0, [parameters[@"times"] integerValue]));
    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.statusIV];
    [self.scrollViewContainer addSubview:self.tipLabel];
    [self.scrollViewContainer addSubview:self.moneyLabel];

    [self.scrollViewContainer addSubview:self.payProblemLabel];

    [self.scrollViewContainer addSubview:self.waitView];
    [self.waitView addSubview:self.waitLabel];
    [self.waitView addSubview:self.waitBTN];

    [self.scrollViewContainer addSubview:self.repayView];
    [self.repayView addSubview:self.repayLabel];
    [self.repayView addSubview:self.repayBTN];
    [self.repayView addSubview:self.repayTipLabel];
    [self.repayView addSubview:self.waringIV];

    [self.scrollViewContainer addSubview:self.changePayMethodView];
    [self.changePayMethodView addSubview:self.changePayMethodLabel];
    [self.changePayMethodView addSubview:self.changePayMethodBTN];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"wait_pay_result_title", @"在线支付结果");
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - layout
- (void)updateViewConstraints {
    CGFloat margin = kRealWidth(15);

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.statusIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollViewContainer);
        make.top.equalTo(self.scrollViewContainer.mas_top).offset(margin * 2);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
    }];

    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer).offset(margin * 2);
        make.right.equalTo(self.scrollViewContainer).offset(-margin * 2);
        make.top.equalTo(self.statusIV.mas_bottom).offset(margin);
    }];

    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(margin);
        make.centerX.equalTo(self.scrollViewContainer);
    }];

    [self.payProblemLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(kRealWidth(65));
        make.left.equalTo(self.scrollViewContainer).offset(margin);
    }];

    [self.waitView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer).offset(margin);
        make.right.equalTo(self.scrollViewContainer).offset(-margin);
        make.top.equalTo(self.payProblemLabel.mas_bottom).offset(margin);
    }];

    [self.waitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitView).offset(kRealWidth(10));
        make.right.equalTo(self.waitView).offset(-kRealWidth(10));
        make.top.mas_equalTo(margin);
    }];

    [self.waitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitLabel);
        make.height.mas_equalTo(kRealWidth(margin * 2));
        make.width.mas_greaterThanOrEqualTo(kRealWidth(120));
        make.top.equalTo(self.waitLabel.mas_bottom).offset(kRealWidth(20));
        make.bottom.equalTo(self.waitView).offset(-margin);
    }];

    [self.repayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer).offset(margin);
        make.right.equalTo(self.scrollViewContainer).offset(-margin);
        make.top.equalTo(self.waitView.mas_bottom).offset(margin);
        if (self.changePayMethodView.isHidden) {
            make.bottom.equalTo(self.scrollViewContainer);
        }
    }];

    [self.repayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repayView).offset(kRealWidth(10));
        make.right.equalTo(self.repayView).offset(-kRealWidth(10));
        make.top.mas_equalTo(margin);
    }];

    [self.repayBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repayLabel);
        make.height.mas_equalTo(margin * 2);
        make.width.mas_greaterThanOrEqualTo(kRealWidth(120));
        make.top.equalTo(self.repayLabel.mas_bottom).offset(kRealWidth(20));
        if (self.repayTipLabel.hidden) {
            make.bottom.equalTo(self.repayView).offset(-margin);
        }
    }];

    if (!self.repayTipLabel.hidden) { //超出重新支付次数时
        self.repayBTN.userInteractionEnabled = NO;
        [self.repayBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.repayBTN.backgroundColor = [UIColor hd_colorWithHexString:@"#D4D6DE"];
        self.repayBTN.borderColor = [UIColor hd_colorWithHexString:@"#D4D6DE"];

        [self.repayTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRealWidth(35));
            make.right.mas_equalTo(-kRealWidth(10));
            make.top.equalTo(self.repayBTN.mas_bottom).offset(kRealWidth(10));
            make.bottom.equalTo(self.repayView).offset(-margin);
        }];

        [self.waringIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
            make.centerY.equalTo(self.repayTipLabel);
        }];
    }

    if (!self.changePayMethodView.isHidden) {
        [self.changePayMethodView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollViewContainer).offset(margin);
            make.right.equalTo(self.scrollViewContainer).offset(-margin);
            make.top.equalTo(self.repayView.mas_bottom).offset(margin);
            make.bottom.equalTo(self.scrollViewContainer);
        }];

        [self.changePayMethodLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.changePayMethodView).offset(kRealWidth(10));
            make.right.equalTo(self.changePayMethodView).offset(-kRealWidth(10));
            make.top.mas_equalTo(margin);
        }];

        [self.changePayMethodBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.changePayMethodLabel);
            make.height.mas_equalTo(margin * 2);
            make.width.mas_greaterThanOrEqualTo(kRealWidth(120));
            make.top.equalTo(self.changePayMethodLabel.mas_bottom).offset(kRealWidth(20));
            make.bottom.equalTo(self.changePayMethodView).offset(-margin);
        }];
    }
    [super updateViewConstraints];
}

#pragma mark - event response
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 100) { //点击我知道了
        [self.navigationController popViewControllerAnimated:YES];
    } else if (btn.tag == 101) { //点击重新支付，拉起收银台
        if (!self.buildModel || !self.resultDelegate)
            return;
        HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:self.buildModel preferedHeight:self.preferedHeight];
        checkStandVC.resultDelegate = self.resultDelegate;
        [self presentViewController:checkStandVC animated:YES completion:^{
            [self remoteViewControllerWithSpecifiedClass:self.class];
        }];
    } else if (btn.tag == 102) { //重新选择支付方式
        if (!self.buildModel || !self.resultDelegate)
            return;
        self.buildModel.selectedPaymentMethod = nil;
        HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:self.buildModel preferedHeight:self.preferedHeight];
        checkStandVC.resultDelegate = self.resultDelegate;
        [self presentViewController:checkStandVC animated:YES completion:^{
            [self remoteViewControllerWithSpecifiedClass:self.class];
        }];
    }
}

#pragma mark - lazy load
- (UIImageView *)statusIV {
    if (!_statusIV) {
        _statusIV = UIImageView.new;
        _statusIV.image = [UIImage imageNamed:@"wait_pay_result_icon"];
    }
    return _statusIV;
}

- (SALabel *)tipLabel {
    if (!_tipLabel) {
        SALabel *l = SALabel.new;
        _tipLabel = l;
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = HDAppTheme.font.standard2Bold;
        _tipLabel.textColor = HDAppTheme.color.G1;
        _tipLabel.text = SALocalizedString(@"wait_pay_result_tips1", @"你有一笔支付正在进行中，正在等待支付结果");
    }
    return _tipLabel;
}

- (SALabel *)moneyLabel {
    if (!_moneyLabel) {
        SALabel *l = SALabel.new;
        _moneyLabel = l;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = HDAppTheme.font.amountOnly;
        _moneyLabel.textColor = HDAppTheme.color.G1;
        _moneyLabel.text = self.buildModel.payableAmount.thousandSeparatorAmount;
    }
    return _moneyLabel;
}

- (SALabel *)payProblemLabel {
    if (!_payProblemLabel) {
        SALabel *l = SALabel.new;
        _payProblemLabel = l;
        _payProblemLabel.textColor = HDAppTheme.color.G1;
        _payProblemLabel.font = HDAppTheme.font.standard3Bold;
        _payProblemLabel.text = SALocalizedString(@"wait_pay_result_problem", @"支付遇到问题？");
    }
    return _payProblemLabel;
}

- (UIView *)waitView {
    if (!_waitView) {
        _waitView = UIView.new;
        _waitView.backgroundColor = HDAppTheme.color.normalBackground;
        _waitView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _waitView;
}

- (SALabel *)waitLabel {
    if (!_waitLabel) {
        SALabel *l = SALabel.new;
        l.font = HDAppTheme.font.standard4;
        l.textColor = HDAppTheme.color.G1;
        l.numberOfLines = 0;
        NSString *jsonStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchWOWNOWPayAgainTip1];
        SAInternationalizationModel *m = [SAInternationalizationModel yy_modelWithJSON:jsonStr];
        l.text = m.desc;
        _waitLabel = l;
    }
    return _waitLabel;
}

- (SAOperationButton *)waitBTN {
    if (!_waitBTN) {
        _waitBTN = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_waitBTN setTitle:SALocalizedString(@"wait_pay_result_i_understand", @"我知道了") forState:UIControlStateNormal];
        _waitBTN.titleLabel.font = HDAppTheme.font.standard3Bold;
        _waitBTN.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _waitBTN.borderColor = [UIColor hd_colorWithHexString:@"#DC4E67"];
        [_waitBTN setTitleColor:[UIColor hd_colorWithHexString:@"#DC4E67"] forState:UIControlStateNormal];
        [_waitBTN addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _waitBTN.tag = 100;
    }
    return _waitBTN;
}

- (UIView *)repayView {
    if (!_repayView) {
        _repayView = UIView.new;
        _repayView.backgroundColor = HDAppTheme.color.normalBackground;
        _repayView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _repayView;
}

- (SALabel *)repayLabel {
    if (!_repayLabel) {
        SALabel *l = SALabel.new;
        l.numberOfLines = 0;
        l.font = HDAppTheme.font.standard4;
        l.textColor = HDAppTheme.color.G1;
        NSString *jsonStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchWOWNOWPayAgainTip2];
        SAInternationalizationModel *m = [SAInternationalizationModel yy_modelWithJSON:jsonStr];
        l.text = m.desc;
        _repayLabel = l;
    }
    return _repayLabel;
}

- (SAOperationButton *)repayBTN {
    if (!_repayBTN) {
        _repayBTN = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _repayBTN.titleLabel.font = HDAppTheme.font.standard3Bold;
        _repayBTN.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _repayBTN.borderColor = [UIColor hd_colorWithHexString:@"#DC4E67"];
        [_repayBTN setTitleColor:[UIColor hd_colorWithHexString:@"#DC4E67"] forState:UIControlStateNormal];
        [_repayBTN setTitle:SALocalizedString(@"wait_pay_result_pay_again", @"重新支付") forState:UIControlStateNormal];
        [_repayBTN addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _repayBTN.tag = 101;
    }
    return _repayBTN;
}

- (SALabel *)repayTipLabel {
    if (!_repayTipLabel) {
        SALabel *l = SALabel.new;
        l.numberOfLines = 0;
        NSString *jsonStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchWOWNOWPayAgainTip3];
        SAInternationalizationModel *m = [SAInternationalizationModel yy_modelWithJSON:jsonStr];
        l.text = m.desc;
        _repayTipLabel = l;
        _repayTipLabel.textColor = [UIColor hd_colorWithHexString:@"#DC4E67"];
        _repayTipLabel.font = HDAppTheme.font.standard4;
        _repayTipLabel.hidden = self.times < kMaxTimes;
    }
    return _repayTipLabel;
}

- (UIImageView *)waringIV {
    if (!_waringIV) {
        _waringIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wait_pay_result_attention"]];
        _waringIV.hidden = self.times < kMaxTimes;
    }
    return _waringIV;
}

- (UIView *)changePayMethodView {
    if (!_changePayMethodView) {
        _changePayMethodView = UIView.new;
        _changePayMethodView.backgroundColor = HDAppTheme.color.normalBackground;
        _changePayMethodView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        //电商业务且预选了支付方式  就展示更换支付方式视图
        if ([self.buildModel.businessLine isEqualToString:SAClientTypeTinhNow] && !HDIsObjectNil(self.buildModel.selectedPaymentMethod)) {
            _changePayMethodView.hidden = NO;
        } else {
            _changePayMethodView.hidden = YES;
        }
    }
    return _changePayMethodView;
}

- (SALabel *)changePayMethodLabel {
    if (!_changePayMethodLabel) {
        SALabel *l = SALabel.new;
        l.numberOfLines = 0;
        l.font = HDAppTheme.font.standard4;
        l.textColor = HDAppTheme.color.G1;
        l.text = TNLocalizedString(@"tn_change_payment_tips", @"如果当前支付方式不稳定，可选择其他支付方式");
        _changePayMethodLabel = l;
    }
    return _changePayMethodLabel;
}

- (SAOperationButton *)changePayMethodBTN {
    if (!_changePayMethodBTN) {
        _changePayMethodBTN = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _changePayMethodBTN.titleLabel.font = HDAppTheme.font.standard3Bold;
        _changePayMethodBTN.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _changePayMethodBTN.borderColor = [UIColor hd_colorWithHexString:@"#DC4E67"];
        [_changePayMethodBTN setTitleColor:[UIColor hd_colorWithHexString:@"#DC4E67"] forState:UIControlStateNormal];
        [_changePayMethodBTN setTitle:TNLocalizedString(@"tn_selected_payment", @"选择支付方式") forState:UIControlStateNormal];
        [_changePayMethodBTN addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _changePayMethodBTN.tag = 102;
    }
    return _changePayMethodBTN;
}

@end
