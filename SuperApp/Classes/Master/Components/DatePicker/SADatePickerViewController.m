//
//  SADatePickerViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SADatePickerViewController.h"
#import "SADatePickerView.h"

#define kPickerViewHeight (kScreenWidth * (217 / 375.0))


@interface SADatePickerViewController ()
/// 阴影
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) SADatePickerView *pickerView;
@end


@implementation SADatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.pickerView];

    self.pickerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };

    self.shadowView.alpha = 0;

    NSDate *now = [NSDate new];
    if (self.maxDate && [now compare:self.maxDate] == NSOrderedDescending) {
        [self.pickerView setCurrentDate:self.maxDate];
    } else if (self.minDate && [now compare:self.minDate] == NSOrderedAscending) {
        [self.pickerView setCurrentDate:self.minDate];
    } else {
        [self.pickerView setCurrentDate:[NSDate new]];
    }

    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kPickerViewHeight);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.shadowView.alpha == 0) {
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, self.pickerView.bounds.size.height);
        [UIView animateWithDuration:0.25 animations:^{
            self.shadowView.alpha = 1;
            self.pickerView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - event response
- (void)clickedShadowViewHandler {
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
        self.pickerView.transform = CGAffineTransformMakeTranslation(0, self.pickerView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self dismissAnimated:YES completion:nil];
    }];
}

#pragma mark - public methods
- (void)setCurrentDate:(NSDate *)date {
    [self.pickerView setCurrentDate:date];
}

/// 设置标题
- (void)setTitleText:(NSString *)text {
    [self.pickerView setTitleText:text];
}

#pragma mark - lazy load

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedShadowViewHandler)];
        _shadowView.backgroundColor = HDColor(0, 0, 0, 0.4);
        [_shadowView addGestureRecognizer:recognizer];
    }
    return _shadowView;
}

- (SADatePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[SADatePickerView alloc] initWithFrame:CGRectMake(0, self.view.height - 250, self.view.width, 250) style:self.datePickStyle];
        _pickerView.delegate = self.delegate;
        _pickerView.minDate = self.minDate;
        _pickerView.maxDate = self.maxDate;
        _pickerView.backgroundColor = [UIColor whiteColor];
        @HDWeakify(self);
        _pickerView.clickedCancelBlock = ^{
            @HDStrongify(self);
            [self clickedShadowViewHandler];
        };
    }
    return _pickerView;
}
@end
