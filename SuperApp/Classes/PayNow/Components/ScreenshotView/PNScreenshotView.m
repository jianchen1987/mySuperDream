//
//  PNScreenshotView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNScreenshotView.h"


@interface PNScreenshotView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *bgView;

@end


@implementation PNScreenshotView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = self.bounds;
    self.bgView.frame = self.bounds;
}

- (void)setupUI {
    [self addSubview:self.textField];
    self.textField.subviews.firstObject.userInteractionEnabled = YES;
    [self.textField.subviews.firstObject addSubview:self.bgView];
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    if (self.textField != view) {
        [self.bgView addSubview:view];
    }
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.secureTextEntry = YES;
        _textField.delegate = self;
    }

    return _textField;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }

    return _bgView;
}

#pragma mark
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

@end
