//
//  SAStartupAdSkipView.m
//  SuperApp
//
//  Created by Chaos on 2021/4/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAStartupAdSkipView.h"


@interface SAStartupAdSkipView ()

/// 定时器
@property (nonatomic, strong) dispatch_source_t timer;
/// 倒计时数字
@property (nonatomic, strong) SALabel *numberLB;
/// 线
@property (nonatomic, strong) UIView *lineView;
/// skip
@property (nonatomic, strong) SALabel *skipLB;

@end


@implementation SAStartupAdSkipView

- (void)hd_setupViews {
    self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewHandler)]];
    [self addSubview:self.numberLB];
    [self addSubview:self.lineView];
    [self addSubview:self.skipLB];

    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        view.layer.cornerRadius = CGRectGetHeight(precedingFrame) * 0.5;
    };

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.numberLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.right.equalTo(self.lineView.mas_left);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(26));
        make.right.equalTo(self).offset(-kRealWidth(39));
        make.centerY.equalTo(self);
        make.top.equalTo(self).offset(1);
        make.width.mas_equalTo(1);
    }];
    [self.skipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right);
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - event response
NSInteger _timerCount;
- (void)clickViewHandler {
    [self stopTimer];
    !self.skipBlock ?: self.skipBlock(true, self.shownTime);
}

#pragma mark - 定时器
- (void)startTimer {
    if (!self.timer) {
        _timerCount = self.skipTime;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), 1.0 * NSEC_PER_SEC, 0);
        @HDWeakify(self);
        dispatch_source_set_event_handler(timer, ^{
            @HDStrongify(self);
            if (_timerCount <= 1) {
                [self stopTimer];
                dispatch_async(dispatch_get_main_queue(), ^{
                    !self.skipBlock ?: self.skipBlock(false, self.skipTime);
                });
            } else {
                _timerCount -= 1;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.numberLB.text = [NSString stringWithFormat:@"%zd", _timerCount];
                });
            }
        });
        self.timer = timer;
        dispatch_resume(self.timer);
    }
}

- (void)stopTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - setter
- (void)setSkipTime:(NSUInteger)skipTime {
    _skipTime = skipTime;
    self.numberLB.text = [NSString stringWithFormat:@"%lu", skipTime];
}

#pragma mark - getter
- (NSUInteger)shownTime {
    return self.skipTime - _timerCount + 1;
}

#pragma mark - lazy load
- (SALabel *)numberLB {
    if (!_numberLB) {
        SALabel *label = SALabel.new;
        label.textColor = HexColor(0x0072FF);
        label.font = HDAppTheme.font.standard3Bold;
        label.textAlignment = NSTextAlignmentCenter;
        _numberLB = label;
    }
    return _numberLB;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HexColor(0x969696);
    }
    return _lineView;
}

- (SALabel *)skipLB {
    if (!_skipLB) {
        SALabel *label = SALabel.new;
        label.text = @"Skip";
        label.textColor = HexColor(0x0072FF);
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        _skipLB = label;
    }
    return _skipLB;
}

@end
