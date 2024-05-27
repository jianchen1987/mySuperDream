//
//  TNWithdrawConfirmAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawConfirmAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInfoView.h"
#import "TNCustomerServiceView.h"
#import "TNMultiLanguageManager.h"
#import "TNPhoneActionAlertView.h"
#import "TNQuestionAndContactView.h"
#import "TNWithdrawBindDTO.h"
#import "TNWithdrawBindRequestModel.h"
#import <HDKitCore.h>
#import <Masonry.h>


@interface TNWithdrawConfirmAlertView ()
@property (strong, nonatomic) HDLabel *titleLabel;                   /// 标题
@property (strong, nonatomic) UILabel *moneyLabel;                   ///<  金额字段
@property (strong, nonatomic) HDUIButton *confirBtn;                 ///<
@property (strong, nonatomic) HDUIButton *cancelBtn;                 ///<
@property (strong, nonatomic) SAInfoView *drawMethodView;            ///<  提现方式
@property (strong, nonatomic) SAInfoView *companyNameView;           ///<  公司名称
@property (strong, nonatomic) SAInfoView *acountView;                ///<  账号
@property (strong, nonatomic) SAInfoView *accountNameView;           ///<  账户名称
@property (strong, nonatomic) TNQuestionAndContactView *contactView; ///< 联系平台按钮
@property (strong, nonatomic) TNWithdrawBindRequestModel *model;     ///<
@property (strong, nonatomic) TNWithdrawBindDTO *dto;                ///<
@end


@implementation TNWithdrawConfirmAlertView
- (instancetype)initWithWithDrawModel:(TNWithdrawBindRequestModel *)model {
    if (self = [super init]) {
        self.model = model;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}
#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = NO;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.drawMethodView];
    [self.containerView addSubview:self.companyNameView];
    [self.containerView addSubview:self.acountView];
    [self.containerView addSubview:self.accountNameView];
    [self.containerView addSubview:self.contactView];
    [self.containerView addSubview:self.confirBtn];
    [self.containerView addSubview:self.cancelBtn];

    self.moneyLabel.text = self.model.amount.thousandSeparatorAmount;
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(kRealWidth(80));
    }];
    [self.drawMethodView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.moneyLabel.mas_bottom);
    }];
    [self.companyNameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.drawMethodView.mas_bottom);
    }];
    [self.acountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.companyNameView.mas_bottom);
    }];
    [self.accountNameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.acountView.mas_bottom);
    }];
    [self.contactView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.accountNameView.mas_bottom).offset(kRealWidth(30));
        //        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(20));
    }];

    [self.confirBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactView.mas_bottom).offset(kRealWidth(30));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight);
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.cancelBtn.mas_left).offset(-kRealWidth(25));
        make.height.mas_equalTo(kRealWidth(35));
    }];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.confirBtn.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.width.equalTo(self.confirBtn.mas_width);
        make.height.mas_equalTo(kRealWidth(35));
    }];
}
// configInfoViewModel
- (SAInfoViewModel *)getonfigInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = HDAppTheme.TinhNowFont.standard12;
    infoModel.keyColor = HDAppTheme.TinhNowColor.G3;
    infoModel.valueFont = HDAppTheme.TinhNowFont.standard12M;
    infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
    infoModel.lineWidth = 0;
    infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(15), 0, kRealWidth(15), 0);
    return infoModel;
}

- (void)dismissAlert {
    [self dismiss];
    !self.dismissCallBack ?: self.dismissCallBack();
}
#pragma mark -申请提现
- (void)postWithDrawApply {
    [self showloading];
    @HDWeakify(self);
    [self.dto postWithDrawApplyWithModel:self.model success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [HDTips showWithText:TNLocalizedString(@"iX6Ub7No", @"已提交申请")];
        [self dismiss];
        !self.postWithDrawCallBack ?: self.postWithDrawCallBack();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"Z5kClyL2", @"提现金额");
    }
    return _titleLabel;
}
/** @lazy contactView */
- (TNQuestionAndContactView *)contactView {
    if (!_contactView) {
        _contactView = [[TNQuestionAndContactView alloc] init];
    }
    return _contactView;
}
/** @lazy confirBtn */
- (HDUIButton *)confirBtn {
    if (!_confirBtn) {
        _confirBtn = [[HDUIButton alloc] init];
        _confirBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _confirBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [_confirBtn setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        [_confirBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:20];
        };
        [_confirBtn addTarget:self action:@selector(postWithDrawApply) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirBtn;
}
/** @lazy confirBtn */
- (HDUIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[HDUIButton alloc] init];
        _cancelBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _cancelBtn.backgroundColor = HexColor(0xD6DBE8);
        [_cancelBtn setTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:20];
        };
        @HDWeakify(self);
        [_cancelBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismissAlert];
        }];
    }
    return _cancelBtn;
}
/** @lazy moneyLabel */
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [HDAppTheme.TinhNowFont fontMedium:25];
        _moneyLabel.textColor = HexColor(0xFF2323);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

/** @lazy drawMethodView */
- (SAInfoView *)drawMethodView {
    if (!_drawMethodView) {
        SAInfoViewModel *infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = TNLocalizedString(@"cri3B0so", @"提现方式");
        infoModel.valueText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"mCPxonSi", @"第三方支付") : TNLocalizedString(@"3fE8sWJ3", @"银行");
        _drawMethodView = [SAInfoView infoViewWithModel:infoModel];
        _drawMethodView.hd_borderPosition = HDViewBorderPositionTop;
        _drawMethodView.hd_borderLocation = HDViewBorderLocationInside;
        _drawMethodView.hd_borderColor = HexColor(0xD6DBE8);
        _drawMethodView.hd_borderWidth = 0.5;
    }
    return _drawMethodView;
}

/** @lazy companyNameView */
- (SAInfoView *)companyNameView {
    if (!_companyNameView) {
        SAInfoViewModel *infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"bX44DKDk", @"支付公司名称") : TNLocalizedString(@"LKipPAAx", @"银行名称");
        infoModel.valueText = self.model.paymentType;
        _companyNameView = [SAInfoView infoViewWithModel:infoModel];
    }
    return _companyNameView;
}

/** @lazy acountView */
- (SAInfoView *)acountView {
    if (!_acountView) {
        SAInfoViewModel *infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"lcFUhF8n", @"支付账号") : TNLocalizedString(@"3VeQVX4G", @"银行账号");
        infoModel.valueText = self.model.account;
        _acountView = [SAInfoView infoViewWithModel:infoModel];
    }
    return _acountView;
}

/** @lazy drawMethodView */
- (SAInfoView *)accountNameView {
    if (!_accountNameView) {
        SAInfoViewModel *infoModel = [self getonfigInfoViewModel];
        infoModel.keyText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"pBB3MUZp", @"账号名称") : TNLocalizedString(@"mJzP2nCp", @"开户名");
        infoModel.valueText = self.model.accountHolder;
        _accountNameView = [SAInfoView infoViewWithModel:infoModel];
        _accountNameView.hd_borderPosition = HDViewBorderPositionBottom;
        _accountNameView.hd_borderLocation = HDViewBorderLocationInside;
        _accountNameView.hd_borderColor = HexColor(0xD6DBE8);
        _accountNameView.hd_borderWidth = 0.5;
    }
    return _accountNameView;
}
/** @lazy dto */
- (TNWithdrawBindDTO *)dto {
    if (!_dto) {
        _dto = [[TNWithdrawBindDTO alloc] init];
    }
    return _dto;
}
@end
