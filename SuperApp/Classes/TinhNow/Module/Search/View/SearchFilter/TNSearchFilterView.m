//
//  TNSearchFilterView.m
//  SuperApp
//
//  Created by seeu on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchFilterView.h"
#import "SAOperationButton.h"
#import "TNFilterEnum.h"


@interface TNSearchFilterView ()
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *filterBackgroundContainer;
/// filterContainer
@property (nonatomic, strong) UIView *filterContainer;
/// cancelButton
@property (nonatomic, strong) SAOperationButton *cancelButton;
/// confirmButton
@property (nonatomic, strong) SAOperationButton *confirmButton;
///
@property (nonatomic, strong) NSMutableArray<UIView<TNFilterOptionProtocol> *> *filters;

/// filterContainerHeight
@property (nonatomic, assign) CGFloat filterContainerHeight;
/// 相对view
@property (nonatomic, strong) UIView *behindView;

@end


@implementation TNSearchFilterView

- (instancetype)initWithView:(UIView *)behindView {
    /// 弹窗直接加到keyWindow
    self.behindView = behindView;
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame))];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.filterContainerEdgeInsets = UIEdgeInsetsMake(15, 15, 20, 15);
    }
    return self;
}

- (void)hd_setupViews {
    CGRect startRect = [self.behindView convertRect:self.behindView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat startY = startRect.origin.y + CGRectGetHeight(startRect);
    self.shadowBackgroundView.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - startY);
    self.filterBackgroundContainer.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    //    self.filterContainer.frame = CGRectMake(self.filterContainerEdgeInsets.left, self.filterContainerEdgeInsets.top, CGRectGetWidth(self.frame) - self.filterContainerEdgeInsets.left -
    //    self.filterContainerEdgeInsets.right, CGFLOAT_MIN);
    self.filterContainer.hidden = YES;
    self.cancelButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2.0, CGFLOAT_MIN);
    self.confirmButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 2.0, 0, CGRectGetWidth(self.frame) / 2.0, CGFLOAT_MIN);

    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.filterBackgroundContainer];
    [self.filterBackgroundContainer addSubview:self.filterContainer];
    [self.filterBackgroundContainer addSubview:self.cancelButton];
    [self.filterBackgroundContainer addSubview:self.confirmButton];
    //点击背景回收弹出视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroudTap:)];
    [self addGestureRecognizer:tap];
}

- (void)updateConstraints {
    CGRect startRect = [self.behindView convertRect:self.behindView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat startY = startRect.origin.y + CGRectGetHeight(startRect);

    [self.shadowBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(CGRectGetHeight(self.frame) - startY);
    }];
    [self.filterBackgroundContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.shadowBackgroundView);
    }];

    [self.filterContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.filterBackgroundContainer.mas_left).offset(self.filterContainerEdgeInsets.left);
        make.right.equalTo(self.filterBackgroundContainer.mas_right).offset(-self.filterContainerEdgeInsets.right);
        make.top.equalTo(self.filterBackgroundContainer.mas_top).offset(self.filterContainerEdgeInsets.top);
    }];

    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.filterBackgroundContainer.mas_left);
        make.top.equalTo(self.filterContainer.mas_bottom).offset(self.filterContainerEdgeInsets.bottom);
        make.bottom.equalTo(self.filterBackgroundContainer.mas_bottom);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(CGRectGetWidth(self.frame) / 2.0);
    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.filterBackgroundContainer.mas_right);
        make.top.equalTo(self.filterContainer.mas_bottom).offset(self.filterContainerEdgeInsets.bottom);
        make.bottom.equalTo(self.filterBackgroundContainer.mas_bottom);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(CGRectGetWidth(self.frame) / 2.0);
    }];

    UIView *topView = nil;
    for (UIView *view in self.filters) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.filterContainer);
            if (topView) {
                make.top.equalTo(topView.mas_bottom);
            } else {
                make.top.equalTo(self.filterContainer.mas_top);
            }
        }];
        topView = view;
    }

    if (!topView) {
        [topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.filterContainer.mas_bottom);
        }];
    }

    [self updateBackgroundContainerConstraints];
    [super updateConstraints];
}
#pragma mark - private methods
- (void)updateBackgroundContainerConstraints {
    CGFloat filtersHight = 0;
    for (UIView<TNFilterOptionProtocol> *view in self.filters) {
        CGFloat viewHeight = [view TN_layoutWithWidth:CGRectGetWidth(self.frame)];
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.showing) {
                make.height.mas_equalTo(viewHeight);
            } else {
                make.height.mas_equalTo(0);
            }
        }];

        filtersHight += viewHeight;
    }

    [self.filterBackgroundContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.showing) {
            make.height.mas_equalTo(filtersHight + self.filterContainerEdgeInsets.top + self.filterContainerEdgeInsets.bottom + 40);
        } else {
            make.height.mas_equalTo(0);
        }
    }];

    [self.filterContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.showing) {
            make.height.mas_equalTo(filtersHight);
        } else {
            make.height.mas_equalTo(0);
        }
    }];

    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.showing) {
            make.height.mas_equalTo(40);
        } else {
            make.height.mas_equalTo(0);
        }
    }];

    [self.confirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.showing) {
            make.height.mas_equalTo(40);
        } else {
            make.height.mas_equalTo(0);
        }
    }];
}
- (CGFloat)filterContainerHeight {
    CGFloat filtersHight = 0;
    for (UIView<TNFilterOptionProtocol> *view in self.filters) {
        CGFloat viewHeight = [view TN_layoutWithWidth:CGRectGetWidth(self.frame)];
        filtersHight += viewHeight;
    }
    return filtersHight + self.filterContainerEdgeInsets.top + self.filterContainerEdgeInsets.bottom + 40;
}
#pragma mark - public methods
- (void)addFilter:(UIView<TNFilterOptionProtocol> *)filter {
    [self.filters addObject:filter];
    [self.filterContainer addSubview:filter];
    filter.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self setNeedsUpdateConstraints];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.showing = YES;
    self.filterContainer.hidden = NO;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self updateBackgroundContainerConstraints];
        self.shadowBackgroundView.alpha = 0.5;
        [self layoutIfNeeded];
    } completion:^(BOOL finished){

    }];
}

- (void)dismiss {
    self.showing = NO;
    [self updateBackgroundContainerConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowBackgroundView.alpha = 0;
        self.filterContainer.hidden = YES;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - private methods
- (void)confirm {
    NSMutableDictionary<TNSearchFilterOptions, NSObject *> *filter = [[NSMutableDictionary alloc] init];
    for (UIView<TNFilterOptionProtocol> *view in self.filters) {
        [filter addEntriesFromDictionary:[view TN_currentOptions]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(TNSearchFilterView:confirmWithFilterOptions:)]) {
        [self.delegate TNSearchFilterView:self confirmWithFilterOptions:filter];
    }
}
- (void)cancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TNSearchFilterView:clickedOnCancelButton:)]) {
        [self.delegate TNSearchFilterView:self clickedOnCancelButton:self.cancelButton];
    }
}
- (void)reset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TNSearchFilterView:clickedOnResetButton:)]) {
        [self.delegate TNSearchFilterView:self clickedOnResetButton:self.cancelButton];
    }
}

- (void)backGroudTap:(UIGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    if (![self.filterBackgroundContainer.layer.presentationLayer hitTest:touchPoint]) { //筛选区域之外的位置  点击全部收回弹窗
        [self cancel];
    }
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
- (UIView *)filterBackgroundContainer {
    if (!_filterBackgroundContainer) {
        _filterBackgroundContainer = [[UIView alloc] init];
        _filterBackgroundContainer.backgroundColor = UIColor.whiteColor;
    }
    return _filterBackgroundContainer;
}
/** @lazy filtercontainer */
- (UIView *)filterContainer {
    if (!_filterContainer) {
        _filterContainer = [[UIView alloc] init];
    }
    return _filterContainer;
}
/** @lazy cancelbutton */
- (SAOperationButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_cancelButton setTitle:TNLocalizedString(@"UFrIdr2o", @"重置") forState:UIControlStateNormal];
        _cancelButton.cornerRadius = 0;
        [_cancelButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.G5];
        [_cancelButton setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        [_cancelButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
/** @lazy confirmbutton */
- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmButton setTitle:TNLocalizedString(@"tn_button_confirm_title", @"Confirm") forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        _confirmButton.cornerRadius = 0;
        [_confirmButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
    }
    return _confirmButton;
}
/** @lazy filters */
- (NSMutableArray<UIView<TNFilterOptionProtocol> *> *)filters {
    if (!_filters) {
        _filters = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _filters;
}
@end
