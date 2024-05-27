//
//  PNInputItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInputItemCell.h"


@interface PNInputItemCell () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNInputItemView *inputView;
@end


@implementation PNInputItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.inputView];
}

- (void)updateConstraints {
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - getters and setters
- (void)setModel:(PNInputItemModel *)model {
    _model = model;

    if (self.model.useWOWNOWKeyboard) {
        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:self.model.wownowKeyBoardType theme:theme];

        kb.inputSource = _inputView.textFiled;
        self.inputView.textFiled.inputView = kb;
    } else {
        self.inputView.textFiled.inputView = nil;
    }

    self.inputView.model = model;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (BOOL)pn_textFieldShouldEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self handleBlock];
    return YES;
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self handleBlock];
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(nonnull PNInputItemView *)view {
    [self handleBlock];
}

- (BOOL)pn_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string view:(nonnull PNInputItemView *)view {
    [self handleBlock];
    return YES;
}

- (BOOL)pn_textFieldShouldClear:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self handleBlock];
    return YES;
}

- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self handleBlock];
    return YES;
}

- (void)handleBlock {
    !self.inputChangeBlock ?: self.inputChangeBlock(self.inputView.inputText);
}

#pragma mark - lazy load
- (PNInputItemView *)inputView {
    if (!_inputView) {
        _inputView = [[PNInputItemView alloc] init];
        _inputView.delegate = self;

        if (self.model.useWOWNOWKeyboard) {
            HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
            theme.enterpriseText = @"";
            HDKeyBoard *kb = [HDKeyBoard keyboardWithType:self.model.wownowKeyBoardType theme:theme];

            kb.inputSource = _inputView.textFiled;
            _inputView.textFiled.inputView = kb;
        }
    }
    return _inputView;
}

@end
