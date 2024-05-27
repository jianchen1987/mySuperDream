//
//  PNMSPreBindView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPreBindView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNInputItemView.h"
#import "PNMSBindViewModel.h"
#import "PNMSStepView.h"


@interface PNMSPreBindView () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNMSStepView *stepView;
@property (nonatomic, strong) PNInputItemView *merchantIDInputView;
@property (nonatomic, strong) HDUIButton *nextBtn;
@property (nonatomic, strong) PNMSBindViewModel *viewModel;
@end


@implementation PNMSPreBindView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.stepView];
    [self.scrollViewContainer addSubview:self.merchantIDInfoView];
    [self.scrollViewContainer addSubview:self.nextBtn];

    //    self.merchantIDInputView.model.value = @"BM040012";
    //    [self.merchantIDInputView update];
    //    [self ruleLimit];
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

    [self.merchantIDInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.stepView.mas_bottom).offset(kRealWidth(8));
        make.height.equalTo(@(kRealWidth(52)));
    }];

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(24));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-24));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(-(kRealWidth(24) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateConstraints];
}

#pragma mark
#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)pn_textFieldShouldEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
    return YES;
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
}

#pragma mark
- (void)ruleLimit {
    NSString *idStr = self.merchantIDInputView.inputText;
    if (WJIsStringNotEmpty(idStr) && idStr.length >= 8) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

#pragma mark
- (PNInputItemView *)merchantIDInfoView {
    if (!_merchantIDInputView) {
        _merchantIDInputView = [[PNInputItemView alloc] init];
        _merchantIDInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.bottomLineHeight = 0;
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        NSString *hightStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, PNLocalizedString(@"ms_input_merchant_id", @"输入商户ID")];
        model.attributedTitle = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B
                                                            highLightColor:HDAppTheme.PayNowColor.mainThemeColor];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;

        _merchantIDInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _merchantIDInputView.textFiled;
        _merchantIDInputView.textFiled.inputView = kb;
    }
    return _merchantIDInputView;
}

- (PNMSStepView *)stepView {
    if (!_stepView) {
        _stepView = [[PNMSStepView alloc] init];
        _stepView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        [_stepView layoutIfNeeded];

        NSMutableArray<PNMSStepItemModel *> *list = [NSMutableArray arrayWithCapacity:3];
        PNMSStepItemModel *model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_1_hight"];
        model.titleStr = PNLocalizedString(@"ms_input_merchant_id", @"输入商户ID");
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, 0, 0);
        model.titleFont = HDAppTheme.PayNowFont.standard12M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_2_nor"];
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

        [_stepView setModelList:list step:0];
    }
    return _stepView;
}

- (HDUIButton *)nextBtn {
    if (!_nextBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        [button setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:0];
        button.enabled = NO;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [self.viewModel getMerchantInfoWithMerchantNo:self.merchantIDInputView.inputText];
        }];

        _nextBtn = button;
    }
    return _nextBtn;
}

@end
