//
//  TNPhoneActionAlertView.m
//  SuperApp
//
//  Created by xixi on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPhoneActionAlertView.h"


@interface TNPhoneActionAlertView ()
///
@property (nonatomic, strong) UIView *contentView;
@end


@implementation TNPhoneActionAlertView

- (instancetype)initWithContentView:(UIView<HDCustomViewActionViewProtocol> *)contentView {
    if (self = [super init]) {
        _contentView = contentView;

        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.allowTapBackgroundDismiss = YES;
    }
    return self;
}


/** 布局containerview的位置,就是那个看得到的视图 */
- (void)layoutContainerView {
    CGFloat containerHeight = CGRectGetHeight(_contentView.frame);
    CGFloat top = kScreenHeight - containerHeight;
    self.containerView.frame = CGRectMake(0, top, kScreenWidth, containerHeight);
}

/** 设置containerview的属性,比如圆角 */
- (void)setupContainerViewAttributes {
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 10.f;
}

/** 给containerview添加子视图 */
- (void)setupContainerSubViews {
    [self.containerView addSubview:self.contentView];
}

/** 设置子视图的frame */
- (void)layoutContainerViewSubViews {
}

@end
