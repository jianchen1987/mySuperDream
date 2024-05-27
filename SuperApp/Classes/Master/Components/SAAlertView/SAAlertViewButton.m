//
//  SAAlertViewButton.m
//  SuperApp
//
//  Created by Tia on 2022/9/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAlertViewButton.h"
#import "SAAppTheme.h"
#import "UIColor+HDKitCore.h"


@implementation SAAlertViewButton

+ (instancetype)buttonWithTitle:(NSString *)title type:(SAAlertViewButtonType)type handler:(SAAlertViewButtonHandler)handler {
    return [[self alloc] initWithTitle:title type:type handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title type:(SAAlertViewButtonType)type handler:(SAAlertViewButtonHandler)handler {
    if (self = [super init]) {
        self.type = type;
        self.handler = handler;

        self.titleLabel.numberOfLines = 2;
        [self setTitle:title forState:UIControlStateNormal];

        [self setProperties];
    }
    return self;
}

#pragma mark - life cycle
- (void)commonInit {
    [self addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = HDAppTheme.color.sa_C1;

    [self setProperties];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setProperties {
    self.titleLabel.font = HDAppTheme.font.standard3Bold;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    if (_type == SAAlertViewButtonTypeDefault) {
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else if (_type == SAAlertViewButtonTypeCustom) {
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else if (_type == SAAlertViewButtonTypeCancel) {
        [self setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        self.backgroundColor = [UIColor hd_colorWithHexString:@"#FEF0F2"];
    }
}
#pragma mark - event response
- (void)tappedButton {
    !self.handler ?: self.handler(self.alertView, self);
}

#pragma mark - getters and setters
- (void)setType:(SAAlertViewButtonType)type {
    _type = type;

    [self setProperties];
}

@end
