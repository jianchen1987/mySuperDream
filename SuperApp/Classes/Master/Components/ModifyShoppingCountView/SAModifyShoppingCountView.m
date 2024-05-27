//
//  SAModifyShoppingCountView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModifyShoppingCountView.h"
#import <HDKitCore/HDFunctionThrottle.h>


@interface SAModifyShoppingCountView ()
/// 当前数量
@property (nonatomic, assign) NSUInteger count;
/// 减
@property (nonatomic, strong) HDUIButton *minusBTN;
/// 加
@property (nonatomic, strong) HDUIButton *plusBTN;
/// 数量
@property (nonatomic, strong) SALabel *countLB;
/// 上一次触发回调时的数量
@property (nonatomic, assign) NSUInteger oldCount;
@end


@implementation SAModifyShoppingCountView

- (void)hd_setupViews {
    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [self addSubview:self.minusBTN];
    [self addSubview:self.countLB];
    [self addSubview:self.plusBTN];

    self.blockTime = 0.3;
    self.step = 1;
    self.minCount = 0;
    self.firstStepCount = 1;
    self.oldCount = self.firstStepCount;
    self.maxCount = NSUIntegerMax;
    [self _updateCount:self.minCount];
}

- (void)updateConstraints {
    [self.minusBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.bottom.equalTo(self);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self);
    }];
    // 计算 99 宽度，如果没超过 99，都用 99 的宽度，否则用实际宽度
    const CGFloat number99Witdth = [@"99" boundingAllRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:self.countLB.font].width;
    [self.countLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBTN.mas_right);
        make.right.equalTo(self.plusBTN.mas_left);
        if (self.count <= 99) {
            make.width.mas_equalTo(number99Witdth);
        } else {
            make.width.mas_equalTo([self.countLB.text boundingAllRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:self.countLB.font].width);
        }
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self);
    }];
    [self.plusBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self);
    }];
    [super updateConstraints];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect newBounds = CGRectInset(self.bounds, -10, -5);
    if (CGRectContainsPoint(newBounds, point)) {
        if (point.x >= self.bounds.size.width * 0.5) {
            return self.plusBTN;
        }
        return self.minusBTN;
    } else {
        return nil;
    }
    return self;
}

#pragma mark - private methods
- (void)_setCount:(NSUInteger)count type:(SAModifyShoppingCountViewOperationType)type {
    [self _updateCount:count];

    //    !self.changedCountHandler ?: self.changedCountHandler(type, self.count);

    [HDFunctionThrottle throttleWithInterval:self.blockTime key:@"com.yumnow.function.modifyShoppingCountView" handler:^{
        BOOL shouldInvoke = false;
        if (type == SAModifyShoppingCountViewOperationTypePlus) {
            shouldInvoke = count > self.oldCount;
            self.oldCount = count;
        } else {
            shouldInvoke = self.oldCount > count;
            self.oldCount = count;
        }
        if (shouldInvoke) {
            !self.changedCountHandler ?: self.changedCountHandler(type, self.count);
        }
    }];
}
- (void)_updateCount:(NSUInteger)count {
    self.count = count;
    self.countLB.text = [NSString stringWithFormat:@"%zd", count];

    [self enableOrDisablePlusButton:count < self.maxCount];
    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)updateCount:(NSUInteger)count {
    if (count < 0)
        return;
    self.oldCount = count;
    [self _updateCount:count];
}

- (void)enableOrDisableButton:(BOOL)yor {
    self.plusBTN.enabled = yor;
    self.minusBTN.enabled = yor;
}

- (void)enableOrDisablePlusButton:(BOOL)yor {
    self.plusBTN.enabled = yor;
}

- (void)enableOrDisableMinusButton:(BOOL)yor {
    self.minusBTN.enabled = yor;
}

#pragma mark - event response
- (void)minusBTNClickedHander {
    !self.clickedMinusBTNHandler ?: self.clickedMinusBTNHandler();

    if (self.disableMinusLogic)
        return;

    NSUInteger tmpCount;
    if (self.count >= self.step) {
        tmpCount = self.count - self.step;
    } else {
        tmpCount = self.minCount;
    }
    // 判断是否小于第一步步进值
    if (tmpCount != self.minCount && tmpCount < self.firstStepCount) {
        tmpCount = self.minCount;
    }
    if (self.countShouldChange ? self.countShouldChange(SAModifyShoppingCountViewOperationTypeMinus, tmpCount) : YES) {
        [self _setCount:tmpCount type:SAModifyShoppingCountViewOperationTypeMinus];
    }
}

- (void)plusBTNClickedHander {
    !self.clickedPlusBTNHandler ?: self.clickedPlusBTNHandler();

    if (self.disablePlusLogic)
        return;

    NSUInteger step = self.step;
    // 如果是初始值，判断第一次步进值
    if (self.count == self.minCount) {
        step = self.firstStepCount;
    }

    if (self.count >= self.maxCount) {
        !self.maxCountLimtedHandler ?: self.maxCountLimtedHandler(self.maxCount);
        return;
    }
    NSUInteger tmpCount;
    if (self.count + step <= self.maxCount) {
        tmpCount = self.count + step;
    } else {
        tmpCount = self.maxCount;
    }

    if (self.countShouldChange ? self.countShouldChange(SAModifyShoppingCountViewOperationTypePlus, tmpCount) : YES) {
        [self _setCount:tmpCount type:SAModifyShoppingCountViewOperationTypePlus];
    }
}

#pragma mark - setter
- (void)setMinusIcon:(NSString *)minusIcon {
    _minusIcon = minusIcon;

    [self.minusBTN setImage:[UIImage imageNamed:minusIcon] forState:UIControlStateNormal];
}

- (void)setPlusIcon:(NSString *)plusIcon {
    _plusIcon = plusIcon;
    [self.plusBTN setImage:[UIImage imageNamed:plusIcon] forState:UIControlStateNormal];
}

- (void)setCustomCountLB:(void (^)(SALabel *_Nonnull))customCountLB {
    _customCountLB = customCountLB;
    if (customCountLB) {
        customCountLB(self.countLB);
    }
}

#pragma mark - lazy load
- (HDUIButton *)minusBTN {
    if (!_minusBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"shopping_minus"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"shopping_minus_disable"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTarget:self action:@selector(minusBTNClickedHander) forControlEvents:UIControlEventTouchUpInside];
        _minusBTN = button;
    }
    return _minusBTN;
}

- (SALabel *)countLB {
    if (!_countLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        [label setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _countLB = label;
    }
    return _countLB;
}

- (HDUIButton *)plusBTN {
    if (!_plusBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"goods_add_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"shopping_add_disabled"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTarget:self action:@selector(plusBTNClickedHander) forControlEvents:UIControlEventTouchUpInside];
        _plusBTN = button;
    }
    return _plusBTN;
}
@end
