//
//  PNCityPickerViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCityPickerViewController.h"

#define kPickerViewHeight (kScreenWidth * (217 / 375.0))


@interface PNCityPickerViewController ()
/// 阴影
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) PNCityPickerView *pickerView;

@end


@implementation PNCityPickerViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.pickerView];

    self.pickerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };

    self.shadowView.alpha = 0;

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

- (PNCityPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[PNCityPickerView alloc] initWithFrame:CGRectMake(0, self.view.height - 250, self.view.width, 250)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self.delegate;
        @HDWeakify(self);
        _pickerView.clickedCancelBlock = ^{
            @HDStrongify(self);
            [self clickedShadowViewHandler];
        };
    }
    return _pickerView;
}

@end
