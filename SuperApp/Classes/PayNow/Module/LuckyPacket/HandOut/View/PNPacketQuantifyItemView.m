//
//  PNPacketQuantifyItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketQuantifyItemView.h"
#import "PNHandOutViewModel.h"
#import "PNInputItemView.h"


@interface PNPacketQuantifyItemView () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) PNInputItemView *quantifyInputView;
@property (nonatomic, strong) SALabel *rightLabel;
@end


@implementation PNPacketQuantifyItemView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.KVOController hd_observe:self.viewModel keyPath:@"hideKeyBoardFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self endEditing:YES];
        [self.quantifyInputView.textFiled resignFirstResponder];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"clearFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        self.viewModel.model.qty = 0;
        self.quantifyInputView.model.value = @"";
        [self.quantifyInputView update];

        self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
        self.viewModel.calculationRateFlag = !self.viewModel.calculationRateFlag;
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };

    [self addSubview:self.quantifyInputView];
    [self addSubview:self.rightLabel];
}

- (void)updateConstraints {
    [self.quantifyInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.mas_equalTo(self.rightLabel.mas_left);
    }];

    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.centerY);
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
    }];

    [self.rightLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

#pragma mark
- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view {
    self.viewModel.model.qty = [textField.text integerValue];
    self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
    self.viewModel.calculationRateFlag = !self.viewModel.calculationRateFlag;
}

#pragma mark
- (PNInputItemView *)quantifyInputView {
    if (!_quantifyInputView) {
        _quantifyInputView = [[PNInputItemView alloc] init];
        _quantifyInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"pn_packet_quantity", @"红包个数");
        model.placeholder = PNLocalizedString(@"pn_enter_packet_number", @"请输入红包个数");
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueColor = HDAppTheme.PayNowColor.c333333;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(12), kRealWidth(20), kRealWidth(4));
        model.titleFont = HDAppTheme.PayNowFont.standard14M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.firstDigitCanNotEnterZero = YES;
        model.maxInputLength = 7;
        _quantifyInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];

        kb.inputSource = _quantifyInputView.textFiled;
        _quantifyInputView.textFiled.inputView = kb;

        @HDWeakify(self);
        _quantifyInputView.valueChangedBlock = ^(NSString *_Nonnull text) {
            @HDStrongify(self);
            self.viewModel.model.qty = [text integerValue];
            self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
            self.viewModel.calculationRateFlag = !self.viewModel.calculationRateFlag;
        };
    }
    return _quantifyInputView;
}

- (SALabel *)rightLabel {
    if (!_rightLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = PNLocalizedString(@"pn_ge", @"个");
        _rightLabel = label;
    }
    return _rightLabel;
}

@end
