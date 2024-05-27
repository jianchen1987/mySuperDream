//
//  PNIDVerifyView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNIDVerifyView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNIDVerifyViewModel.h"
#import "PNInputItemView.h"
#import "PNOperationButton.h"


@interface PNIDVerifyView () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNIDVerifyViewModel *viewMode;
@property (nonatomic, strong) PNInputItemView *firstNameInfoView;
@property (nonatomic, strong) PNInputItemView *lastNameInfoView;
@property (nonatomic, strong) PNInputItemView *legalTypeInfoView;
@property (nonatomic, strong) PNInputItemView *legalNumberInfoView;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) PNOperationButton *confirmButton;

@end


@implementation PNIDVerifyView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewMode = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewMode hd_bindView:self];

    [self.KVOController hd_observe:self.viewMode keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (WJIsStringNotEmpty(self.viewMode.cardTypeRspModel.message) && self.viewMode.userLevel != PNUserLevelNormal) {
            [self appendInputNumber];
        }
    }];

    if (self.viewMode.userLevel != PNUserLevelNormal) {
        [self.viewMode getCardType];
    }
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.lastNameInfoView];
    [self.scrollViewContainer addSubview:self.firstNameInfoView];

    self.bottomBgView.hidden = NO;
    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.confirmButton];
}

- (void)appendInputNumber {
    [self.scrollViewContainer addSubview:self.legalTypeInfoView];
    self.legalTypeInfoView.model.value = self.viewMode.cardTypeRspModel.message;
    [self.legalTypeInfoView update];
    [self.scrollViewContainer addSubview:self.legalNumberInfoView];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        if (!self.bottomBgView.hidden) {
            make.bottom.mas_equalTo(self.bottomBgView.mas_top);
        } else {
            make.bottom.mas_equalTo(self.mas_bottom);
        }
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<UIView *> *visableViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView;
    for (UIView *view in visableViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViewContainer);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            if (view == visableViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }

            if ([view isKindOfClass:PNInputItemView.class]) {
                make.height.equalTo(@(kRealWidth(50)));
            }
        }];
        lastView = view;
    }

    if (!self.bottomBgView.hidden) {
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
        }];

        [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.bottomBgView.mas_width).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
            make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
            make.centerX.mas_equalTo(self.bottomBgView.mas_centerX);
            make.top.mas_equalTo(self.bottomBgView.mas_top).offset(kRealWidth(10));
            make.bottom.mas_equalTo(self.bottomBgView.mas_bottom).offset((iPhoneXSeries ? -(kiPhoneXSeriesSafeBottomHeight + kRealWidth(15)) : -kRealWidth(15)));
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)ruleLimit {
    if (WJIsStringNotEmpty(self.firstNameInfoView.model.value) && WJIsStringNotEmpty(self.lastNameInfoView.model.value)) {
        if (self.viewMode.userLevel != PNUserLevelNormal) {
            if (WJIsStringNotEmpty(self.legalNumberInfoView.model.value)) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        } else {
            self.confirmButton.enabled = YES;
        }
    } else {
        self.confirmButton.enabled = NO;
    }
}

#pragma mark
#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [textField resignFirstResponder];
    return YES;
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view {
    [self ruleLimit];
}

#pragma mark
- (void)verifyAction {
    ///姓
    NSString *lastName = self.lastNameInfoView.model.value.uppercaseString;
    ///名
    NSString *firstName = self.firstNameInfoView.model.value.uppercaseString;
    ///证件号
    NSString *cardNum = self.legalNumberInfoView.model.value;

    [self.viewMode verifyCustomerInfo:lastName firstName:firstName cardNum:cardNum];
}

#pragma mark
- (PNInputItemView *)lastNameInfoView {
    if (!_lastNameInfoView) {
        _lastNameInfoView = [[PNInputItemView alloc] init];
        _lastNameInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        NSString *higStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, PNLocalizedString(@"familyName", @"姓")];
        model.attributedTitle = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard15M
                                                            highLightColor:HDAppTheme.PayNowColor.mainThemeColor];
        model.placeholder = PNLocalizedString(@"set_familyName", @"请输入姓");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        model.isUppercaseString = YES;
        model.canInputMoreSpace = NO;
        _lastNameInfoView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _lastNameInfoView.textFiled;
        _lastNameInfoView.textFiled.inputView = kb;
    }
    return _lastNameInfoView;
}

- (PNInputItemView *)firstNameInfoView {
    if (!_firstNameInfoView) {
        _firstNameInfoView = [[PNInputItemView alloc] init];
        _firstNameInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        NSString *higStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, PNLocalizedString(@"givenName", @"名字")];
        model.attributedTitle = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard15M
                                                            highLightColor:HDAppTheme.PayNowColor.mainThemeColor];
        model.placeholder = PNLocalizedString(@"set_givenName", @"请输入名");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        model.isUppercaseString = YES;
        model.canInputMoreSpace = NO;
        _firstNameInfoView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _firstNameInfoView.textFiled;
        _firstNameInfoView.textFiled.inputView = kb;
    }
    return _firstNameInfoView;
}

- (PNInputItemView *)legalTypeInfoView {
    if (!_legalTypeInfoView) {
        _legalTypeInfoView = [[PNInputItemView alloc] init];
        _legalTypeInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"Legal_type", @"证件类型");
        model.enabled = NO;
        _legalTypeInfoView.model = model;
    }
    return _legalTypeInfoView;
}

- (PNInputItemView *)legalNumberInfoView {
    if (!_legalNumberInfoView) {
        _legalNumberInfoView = [[PNInputItemView alloc] init];
        _legalNumberInfoView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        NSString *higStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, PNLocalizedString(@"Legal_number", @"证件号")];
        model.attributedTitle = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard15M
                                                            highLightColor:HDAppTheme.PayNowColor.mainThemeColor];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        _legalNumberInfoView.model = model;
    }
    return _legalNumberInfoView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        _bottomBgView = view;
    }
    return _bottomBgView;
}

- (PNOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:0];
        _confirmButton.enabled = NO;

        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self verifyAction];
        }];
    }
    return _confirmButton;
}

@end
