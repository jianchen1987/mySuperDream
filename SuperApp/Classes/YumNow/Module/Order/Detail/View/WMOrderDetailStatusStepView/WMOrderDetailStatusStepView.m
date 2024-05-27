//
//  WMOrderDetailStatusStepView.m
//  SuperApp
//
//  Created by Chaos-Joey on 8/31/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderDetailStatusStepView.h"
#import "LOTAnimationView.h"


@interface WMOrderDetailStatusStepView () <CAAnimationDelegate>
/// orderIV
@property (nonatomic, strong) UIImageView *orderIV;
/// cookIV
@property (nonatomic, strong) UIImageView *cookIV;
/// deIV
@property (nonatomic, strong) UIImageView *deIV;
/// finishIV
@property (nonatomic, strong) UIImageView *finishIV;
/// stepOneView
@property (nonatomic, strong) UIView *stepOneView;
/// stepTwoView
@property (nonatomic, strong) UIView *stepTwoView;
/// stepThreeView
@property (nonatomic, strong) UIView *stepThreeView;
/// shapeLayer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) LOTAnimationView *animation;

@end


@implementation WMOrderDetailStatusStepView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bg3;
    [self addSubview:self.orderIV];
    [self addSubview:self.cookIV];
    [self addSubview:self.deIV];
    [self addSubview:self.finishIV];
    [self addSubview:self.stepOneView];
    [self addSubview:self.stepTwoView];
    [self addSubview:self.stepThreeView];
}

- (void)updateConstraints {
    [self.orderIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];

    [self.stepOneView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(4));
        make.left.equalTo(self.orderIV.mas_right).offset(kRealWidth(7));
    }];

    [self.cookIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepOneView.mas_right).offset(kRealWidth(7));
        make.centerY.mas_equalTo(0);
    }];

    [self.stepTwoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.stepOneView);
        make.left.equalTo(self.cookIV.mas_right).offset(kRealWidth(7));
        make.width.mas_equalTo(kRealWidth(93));
    }];

    [self.deIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepTwoView.mas_right).offset(kRealWidth(7));
        make.centerY.mas_equalTo(0);
    }];

    [self.stepThreeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.stepTwoView);
        make.left.equalTo(self.deIV.mas_right).offset(kRealWidth(7));
    }];

    [self.finishIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.equalTo(self.stepThreeView.mas_right).offset(kRealWidth(8));
        make.centerY.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (void)setStep:(int)step {
    UIColor *selectColor = HDAppTheme.WMColor.mainRed;
    UIColor *unSelectColor = HexColor(0xECECEC);
    self.orderIV.hidden = self.cookIV.hidden = self.deIV.hidden = self.finishIV.hidden = self.stepOneView.hidden = self.stepTwoView.hidden = self.stepThreeView.hidden = YES;
    if (self.animation) {
        [self.animation stop];
        [self.animation removeFromSuperview];
        self.animation = nil;
    }
    if (step == 1) {
        self.animation = [LOTAnimationView animationNamed:@"order_detail_one"];
    } else if (step == 2) {
        self.animation = [LOTAnimationView animationNamed:@"order_detail_two"];
    } else if (step == 3) {
        self.animation = [LOTAnimationView animationNamed:@"order_detail_three"];
    } else if (step == 4) {
        self.orderIV.hidden = self.cookIV.hidden = self.deIV.hidden = self.finishIV.hidden = self.stepOneView.hidden = self.stepTwoView.hidden = self.stepThreeView.hidden = NO;
        self.orderIV.image = [UIImage imageNamed:@"yn_order_detail_step_order_sel"];
        self.stepOneView.layer.backgroundColor = self.stepTwoView.layer.backgroundColor = self.stepThreeView.layer.backgroundColor = selectColor.CGColor;
        self.cookIV.tintColor = self.finishIV.tintColor = self.deIV.tintColor = selectColor;
    } else if (step == 0) {
        self.orderIV.hidden = self.cookIV.hidden = self.deIV.hidden = self.finishIV.hidden = self.stepOneView.hidden = self.stepTwoView.hidden = self.stepThreeView.hidden = NO;
        self.orderIV.image = [UIImage imageNamed:@"yn_order_detail_step_order"];
        self.stepOneView.layer.backgroundColor = self.stepTwoView.layer.backgroundColor = self.stepThreeView.layer.backgroundColor = unSelectColor.CGColor;
        self.cookIV.tintColor = self.deIV.tintColor = self.finishIV.tintColor = unSelectColor;
    }
    if (self.animation) {
        self.animation.loopAnimation = YES;
        [self addSubview:self.animation];
        [self.animation mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.animation playWithCompletion:^(BOOL animationFinished){
        }];
    }
}

- (UIImageView *)orderIV {
    if (!_orderIV) {
        _orderIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_order_detail_step_order"]];
    }
    return _orderIV;
}

- (UIImageView *)cookIV {
    if (!_cookIV) {
        _cookIV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"yn_order_detail_step_cook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    return _cookIV;
}

- (UIImageView *)deIV {
    if (!_deIV) {
        _deIV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"yn_order_detail_step_deliver"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    return _deIV;
}

- (UIImageView *)finishIV {
    if (!_finishIV) {
        _finishIV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"yn_order_detail_step_finish"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    return _finishIV;
}

- (UIView *)stepOneView {
    if (!_stepOneView) {
        _stepOneView = UIView.new;
        _stepOneView.layer.cornerRadius = kRealWidth(2);
    }
    return _stepOneView;
}

- (UIView *)stepTwoView {
    if (!_stepTwoView) {
        _stepTwoView = UIView.new;
        _stepTwoView.layer.cornerRadius = kRealWidth(2);
    }
    return _stepTwoView;
}

- (UIView *)stepThreeView {
    if (!_stepThreeView) {
        _stepThreeView = UIView.new;
        _stepThreeView.layer.cornerRadius = kRealWidth(2);
    }
    return _stepThreeView;
}
@end
