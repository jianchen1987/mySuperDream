//
//  PNPacketWishesItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketWishesItemView.h"
#import "PNHandOutViewModel.h"
#import "PNInputItemView.h"


@interface PNPacketWishesItemView () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) PNInputItemView *wishesInputView;
@end


@implementation PNPacketWishesItemView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.viewModel.model.remarks = PNLocalizedString(@"pn_wish_default", @"恭喜发财，红包拿来");
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.KVOController hd_observe:self.viewModel keyPath:@"hideKeyBoardFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self endEditing:YES];
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(8)];
    };

    [self addSubview:self.wishesInputView];
}

- (void)updateConstraints {
    [self.wishesInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view {
    self.viewModel.model.remarks = textField.text;
}

#pragma mark

- (PNInputItemView *)wishesInputView {
    if (!_wishesInputView) {
        _wishesInputView = [[PNInputItemView alloc] init];
        _wishesInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"pn_Wishes_title", @"祝福语");
        model.placeholder = self.viewModel.model.remarks;
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueColor = HDAppTheme.PayNowColor.c333333;
        model.maxInputLength = 60;
        model.keyboardType = UIKeyboardTypeDefault;
        model.fixWhenInputSpace = YES;
        model.isUppercaseString = YES;
        model.canInputMoreSpace = NO;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(12), kRealWidth(20), kRealWidth(12));
        model.titleFont = HDAppTheme.PayNowFont.standard14M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;

        _wishesInputView.model = model;

        //        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        //        theme.enterpriseText = @"";
        //        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        //        kb.inputSource = _wishesInputView.textFiled;
        //        _wishesInputView.textFiled.inputView = kb;
    }
    return _wishesInputView;
}
@end
