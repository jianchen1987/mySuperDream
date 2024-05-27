//
//  HDButton.m
//  customer
//
//  Created by 帅呆 on 2018/10/31.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDButton.h"


@interface HDButton () {
    HDButtonStyle _style;
}

@property (nonatomic, strong) UIView *underLine;

@end


@implementation HDButton

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    }
    return _underLine;
}

- (instancetype)initWithFrame:(CGRect)frame type:(HDButtonStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        if (style == HDButtonStyleBorderCycle) {
            self.layer.cornerRadius = frame.size.height / 2.0;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1.0f;
        } else if (style == HDButtonStyleUnderLine) {
            [self addSubview:self.underLine];
        }
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_style == HDButtonStyleBorderCycle) {
        self.layer.borderColor = [self titleColorForState:self.state].CGColor;
    } else if (_style == HDButtonStyleUnderLine) {
        self.underLine.backgroundColor = [self titleColorForState:self.state];
    }
}

@end
