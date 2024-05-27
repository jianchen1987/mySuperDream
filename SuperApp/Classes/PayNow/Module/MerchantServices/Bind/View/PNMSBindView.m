//
//  PNMSBindView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBindView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNInputItemView.h"
#import "PNMSBindViewModel.h"
#import "PNMSGetSMSCodeView.h"
#import "PNMSStepView.h"
#import "SAInfoView.h"


@interface PNMSBindView ()
@property (nonatomic, strong) PNMSStepView *stepView;
@property (nonatomic, strong) SAInfoView *merchantIDInfoView;
@property (nonatomic, strong) SAInfoView *merchantNameInfoView;
@property (nonatomic, strong) SAInfoView *bindNumberInfoView;
@property (nonatomic, strong) PNMSGetSMSCodeView *getSMSCodeView;
@property (nonatomic, strong) HDUIButton *submitBtn;

@property (nonatomic, strong) PNMSBindViewModel *viewModel;
@property (nonatomic, strong) NSString *smsCode;
@end


@implementation PNMSBindView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.stepView];
    [self.scrollViewContainer addSubview:self.merchantIDInfoView];
    [self.scrollViewContainer addSubview:self.merchantNameInfoView];
    [self.scrollViewContainer addSubview:self.bindNumberInfoView];
    [self.scrollViewContainer addSubview:self.getSMSCodeView];
    [self.scrollViewContainer addSubview:self.submitBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.scrollViewContainer.mas_top);
    }];

    [self.merchantIDInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.stepView.mas_bottom).offset(kRealWidth(8));
        make.height.equalTo(@(52));
    }];

    [self.merchantNameInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.merchantIDInfoView.mas_bottom);
        make.height.equalTo(@(52));
    }];

    [self.bindNumberInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.merchantNameInfoView.mas_bottom);
        make.height.equalTo(@(52));
    }];

    [self.getSMSCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.bindNumberInfoView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(24));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-24));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(-(kRealWidth(24) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateConstraints];
}

- (void)sendSMS {
    [self.viewModel sendSMSCodeWithMerchantNo:self.viewModel.model.merchantNo success:^{
        [self.getSMSCodeView startCountDown];
    }];
}

#pragma mark
- (PNMSStepView *)stepView {
    if (!_stepView) {
        _stepView = [[PNMSStepView alloc] init];
        _stepView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        [_stepView layoutIfNeeded];

        NSMutableArray<PNMSStepItemModel *> *list = [NSMutableArray arrayWithCapacity:3];
        PNMSStepItemModel *model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_1_hight_pre"];
        model.titleStr = PNLocalizedString(@"ms_input_merchant_id", @"输入商户ID");
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, 0, 0);
        model.titleFont = HDAppTheme.PayNowFont.standard12M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_2_hight"];
        model.titleStr = PNLocalizedString(@"ms_verify_merchant_info", @"验证商户信息");
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, 0, 0);
        model.titleFont = HDAppTheme.PayNowFont.standard12M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_3_nor"];
        model.titleStr = PNLocalizedString(@"ms_bind_success_tips", @"关联成功");
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, 0, 0);
        model.titleFont = HDAppTheme.PayNowFont.standard12M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        [list addObject:model];

        [_stepView setModelList:list step:1];
    }
    return _stepView;
}

- (SAInfoView *)merchantIDInfoView {
    if (!_merchantIDInfoView) {
        SAInfoView *view = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        NSString *hightStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, PNLocalizedString(@"ms_merchant_id", @"商户ID")];
        model.attrKey = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                           norFont:HDAppTheme.PayNowFont.standard14B
                                                          norColor:HDAppTheme.PayNowColor.c333333];
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueColor = HDAppTheme.PayNowColor.c333333;
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        model.valueText = self.viewModel.model.merchantNo;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));

        view.model = model;
        _merchantIDInfoView = view;
    }
    return _merchantIDInfoView;
}

- (SAInfoView *)merchantNameInfoView {
    if (!_merchantNameInfoView) {
        SAInfoView *view = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        NSString *hightStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, PNLocalizedString(@"ms_merchant_name", @"商户名称")];
        model.attrKey = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                           norFont:HDAppTheme.PayNowFont.standard14B
                                                          norColor:HDAppTheme.PayNowColor.c333333];
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueColor = HDAppTheme.PayNowColor.c333333;
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        model.valueText = self.viewModel.model.merchantName;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));

        view.model = model;
        _merchantNameInfoView = view;
    }
    return _merchantNameInfoView;
}

- (SAInfoView *)bindNumberInfoView {
    if (!_bindNumberInfoView) {
        SAInfoView *view = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        NSString *hightStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, PNLocalizedString(@"ms_bind_phone_number", @"绑定手机号")];
        model.attrKey = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                           norFont:HDAppTheme.PayNowFont.standard14B
                                                          norColor:HDAppTheme.PayNowColor.c333333];
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueColor = HDAppTheme.PayNowColor.c333333;
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        model.valueText = self.viewModel.model.bindingMobile;
        model.lineWidth = 0;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));

        view.model = model;
        _bindNumberInfoView = view;
    }
    return _bindNumberInfoView;
}

- (PNMSGetSMSCodeView *)getSMSCodeView {
    if (!_getSMSCodeView) {
        _getSMSCodeView = [[PNMSGetSMSCodeView alloc] init];

        @HDWeakify(self);
        _getSMSCodeView.clickSendSMSCodeBlock = ^{
            @HDStrongify(self);
            [self sendSMS];
        };

        _getSMSCodeView.inputChangeBlock = ^(NSString *_Nonnull inputValue) {
            @HDStrongify(self);
            self.smsCode = inputValue;
            if (WJIsStringNotEmpty(inputValue)) {
                self.submitBtn.enabled = YES;
            } else {
                self.submitBtn.enabled = NO;
            }
        };
    }
    return _getSMSCodeView;
}

- (HDUIButton *)submitBtn {
    if (!_submitBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        button.enabled = NO;
        [button setTitle:PNLocalizedString(@"ms_submit_apply", @"提交申请") forState:0];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [self.viewModel verifyAndBindWithMerchantNo:self.viewModel.model.merchantNo smsCode:self.smsCode];
        }];

        _submitBtn = button;
    }
    return _submitBtn;
}
@end
