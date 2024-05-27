//
//  WMCustomerSlideDownView.m
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCustomerSlideDownView.h"


@interface WMCustomerSlideDownView ()
/// 相对视图
@property (nonatomic, assign) CGFloat startY;
/// 自定义视图
@property (nonatomic, strong) UIView<HDCustomViewActionViewProtocol> *customerView;

/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *containerView;
/// 是否展开
@property (atomic, assign) BOOL showing;
/// 自定义视图高度
@property (nonatomic, assign) CGFloat customerHeight;

@end


@implementation WMCustomerSlideDownView

- (instancetype)initWithStartOffsetY:(CGFloat)offset customerView:(UIView<HDCustomViewActionViewProtocol> *)customerView {
    self.startY = offset;
    self.customerView = customerView;
    [self.containerView hd_removeAllSubviews];
    self.customerHeight = CGRectGetHeight(self.customerView.frame);
    self.customerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:self.customerView];
    // 强制刷新获取初始化数据
    [self.customerView setNeedsLayout];
    [self.customerView layoutIfNeeded];

    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

    return self;
}

- (void)hd_setupViews {
    self.shadowBackgroundView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.startY);
    self.containerView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.containerView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.shadowBackgroundView addGestureRecognizer:tap];

    @HDWeakify(self);
    if( [self.customerView isKindOfClass:NSClassFromString(@"WMNearbyFilterBarContentView")]) {
        [self.KVOController hd_observe:self.customerView keyPath:@"frame" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            [self updateConstraints];
        }];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.cornerRadios) {
        self.containerView.clipsToBounds = YES;
        self.containerView.layer.cornerRadius = self.cornerRadios;
        self.containerView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
}

- (void)updateConstraints {
    [self updateContainerConstraints];
    [super updateConstraints];
}

- (void)updateContainerConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.startY);
        if (self.showing) {
            if( [self.customerView isKindOfClass:NSClassFromString(@"WMNearbyFilterBarContentView")]) {
                make.height.mas_equalTo(CGRectGetHeight(self.customerView.frame));
            }else{
                make.height.mas_equalTo(self.customerHeight);
            }
        } else {
            make.height.mas_equalTo(0);
        }
    }];

    if([self.customerView isKindOfClass:NSClassFromString(@"WMNearbyFilterBarContentView")]) {
        [self.customerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(CGRectGetHeight(self.customerView.frame));
        }];
    }else{
        [self.customerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerView);
        }];
    }
}

#pragma mark - private methods

#pragma mark - public methods
- (void)show {
    !self.slideDownViewWillAppear ?: self.slideDownViewWillAppear(self);

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.showing = YES;
    [self.containerView setNeedsUpdateConstraints];
    self.shadowBackgroundView.alpha = 0.7;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.shadowBackgroundView.alpha = 0.7;
        [self updateContainerConstraints];
    } completion:^(BOOL finished){
    }];
}

- (void)dismiss {
    [self dismissCompleted:nil];
}

- (void)dismissCompleted:(void (^__nullable)(void))completed {
    !self.slideDownViewWillDisappear ?: self.slideDownViewWillDisappear(self);
    self.showing = NO;
    [self.containerView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.1 animations:^{
        self.shadowBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self updateContainerConstraints];
        if (completed) {
            completed();
        }
    }];
}

#pragma mark - override system methods
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.showing) { // 展开
        if (!CGRectContainsPoint(self.containerView.frame, point)) {
            dispatch_async(dispatch_get_main_queue(), ^{ //点击非内容页面，隐藏view
                [self dismiss];
            });
        }
        return CGRectContainsPoint(self.containerView.frame, point) || CGRectContainsPoint(self.shadowBackgroundView.frame, point);
    }
    // 收起
    return [super pointInside:point withEvent:event];
}

#pragma mark - lazy load
/** @lazy shadowbackgroundView */
- (UIView *)shadowBackgroundView {
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = UIColor.blackColor;
        _shadowBackgroundView.alpha = 0;
        _shadowBackgroundView.userInteractionEnabled = YES;
    }
    return _shadowBackgroundView;
}

/** @lazy filterbackgroundcontainer */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MIN)];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

@end
