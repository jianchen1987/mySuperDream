//
//  PNGesturePasswordViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGesturePasswordViewController.h"
#import "PNGesturePasswordView.h"


@interface PNGesturePasswordViewController ()
@property (nonatomic, strong) SALabel *infoLabel;
@property (nonatomic, strong) PNGesturePasswordView *gesturePasswordView;
@end


@implementation PNGesturePasswordViewController

- (void)hd_setupViews {
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.gesturePasswordView];
}

- (void)updateViewConstraints {
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(24));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (SALabel *)infoLabel {
    if (!_infoLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.numberOfLines = 0;
        label.text = @"请设置";
        _infoLabel = label;
    }
    return _infoLabel;
}

- (PNGesturePasswordView *)gesturePasswordView {
    if (!_gesturePasswordView) {
        @HDWeakify(self);
        PNGesturePasswordView *gesturePasswordView = [[PNGesturePasswordView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_WIDTH) viewType:PNGesturePasswordViewTypeReset];

        [gesturePasswordView resultCallback:^(PNGesturePasswordResultStatus status, NSString *_Nonnull currentSelectPassword) {
            HDLog(@"%@", currentSelectPassword);
            @HDStrongify(self);
            if (status == PNGesturePasswordResult_SetFirst) {
                self.infoLabel.text = @"请重新输入刚才设置的手势密码";
            } else if (status == PNGesturePasswordResult_SetFirstSuccess) {
                self.infoLabel.text = @"设置成功";
            } else if (status == PNGesturePasswordResult_SetFirstFail) {
                self.infoLabel.text = @"请重新输入刚才设置的手势密码, 要跟第一次的相同";
            } else if (status == PNGesturePasswordResult_LessThan) {
                self.infoLabel.text = @"请至少连接4个点";
                [self shakeAnimationForView:self.infoLabel];
            } else if (status == PNGesturePasswordResult_TwoSameTime) {
                self.infoLabel.text = @"校验成功 - 进入页面";
            } else if (status == PNGesturePasswordResult_TwoDifferentTimes) {
                self.infoLabel.text = @"校验失败 与上一次输入不一致，请重新设置";
                [self shakeAnimationForView:self.infoLabel];
            } else if (status == PNGesturePasswordResult_PassVerificationOldPassword) {
                self.infoLabel.text = @"校验旧密码 通过";
            } else if (status == PNGesturePasswordResult_FailVerificationOldPassword) {
                self.infoLabel.text = @"校验旧密码 失败";
                [self shakeAnimationForView:self.infoLabel];
            }
        }];

        _gesturePasswordView = gesturePasswordView;
    }
    return _gesturePasswordView;
}

- (void)shakeAnimationForView:(UIView *)view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];

    [viewLayer addAnimation:animation forKey:nil];
}
@end
