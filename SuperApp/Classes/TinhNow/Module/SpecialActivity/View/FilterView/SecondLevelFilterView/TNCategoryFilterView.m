//
//  TNCategoryFilterView.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryFilterView.h"
#import "TNCategoryChooseView.h"
#import "TNCategoryModel.h"


@interface TNCategoryFilterView ()
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *filterBackgroundContainer;
/// 分类选择视图
@property (strong, nonatomic) TNCategoryChooseView *filterContainer;
/// cancelButton
@property (nonatomic, strong) SAOperationButton *cancelButton;
/// confirmButton
@property (nonatomic, strong) SAOperationButton *confirmButton;
/// 相对view
@property (nonatomic, strong) UIView *behindView;
/// 数据源
@property (strong, nonatomic) NSArray<TNCategoryModel *> *categoryArr;
@end


@implementation TNCategoryFilterView
- (void)dealloc {
    HDLog(@"TNCategoryFilterView  释放");
}
- (instancetype)initWithView:(UIView *)behindView categoryArr:(nonnull NSArray *)categoryArr {
    /// 弹窗直接加到keyWindow
    self.behindView = behindView;
    self.categoryArr = categoryArr;
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame))];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}
- (void)hd_setupViews {
    CGRect startRect = [self.behindView convertRect:self.behindView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGFloat startY = startRect.origin.y + CGRectGetHeight(startRect);
    self.shadowBackgroundView.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - startY);
    self.filterBackgroundContainer.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    self.filterContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    self.cancelButton.frame = CGRectMake(0, self.filterContainer.bottom, CGRectGetWidth(self.frame) / 2.0, CGFLOAT_MIN);
    self.confirmButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 2.0, self.filterContainer.bottom, CGRectGetWidth(self.frame) / 2.0, CGFLOAT_MIN);

    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.filterBackgroundContainer];
    [self.filterBackgroundContainer addSubview:self.filterContainer];
    [self.filterBackgroundContainer addSubview:self.cancelButton];
    [self.filterBackgroundContainer addSubview:self.confirmButton];

    //赋值
    self.filterContainer.categoryArr = self.categoryArr;
    //点击背景回收弹出视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroudTap:)];
    [self addGestureRecognizer:tap];
}
#pragma mark - 点击背景回收
- (void)backGroudTap:(UIGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    if (![self.filterBackgroundContainer.layer.presentationLayer hitTest:touchPoint]) { //筛选区域之外的位置  点击全部收回弹窗
        [self dismiss];
    }
}
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.isShowing = YES;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.filterBackgroundContainer.height = 245;
        self.filterContainer.height = 200;
        self.cancelButton.top = self.confirmButton.top = self.filterContainer.bottom;
        self.cancelButton.height = 45;
        self.confirmButton.height = 45;
        self.shadowBackgroundView.alpha = 0.8;
        [self layoutIfNeeded];
    } completion:^(BOOL finished){

    }];
}
- (void)dismiss {
    self.isShowing = NO;
    //每次都清理掉临时选中
    [self clearAll];
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBackgroundContainer.height = 0;
        self.filterContainer.height = 0;
        self.cancelButton.height = 0;
        self.confirmButton.height = 0;
        self.cancelButton.top = self.confirmButton.top = self.filterContainer.bottom;
        self.shadowBackgroundView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissCallBack) {
            self.dismissCallBack();
        }
    }];
}
#pragma mark - 重置
- (void)reset {
    if ([self checkCategoryHasSearched]) {
        //重置后 如果之前的二级分类有搜索过 就刷新当前一级分类的数据
        NSInteger index = 0;
        NSInteger targetIndex = 0;
        NSString *categoryId;
        for (TNCategoryModel *leftModel in self.categoryArr) {
            if (leftModel.isSelected) {
                targetIndex = index;
                categoryId = leftModel.menuId;
                break;
            }
            index++;
        }
        if (self.selectedCallBack) {
            self.selectedCallBack(targetIndex, categoryId);
        }
    }
    [self.filterContainer reset];
    self.confirmButton.enabled = YES; //可以点击
}
#pragma mark - 确定
- (void)confirm {
    if ([self checkHasSelectd] && [self checkHasNewSelected]) {
        NSMutableArray *selectedArr = [NSMutableArray array];
        NSInteger index = 0;
        NSInteger targetIndex = 0;
        for (TNCategoryModel *leftModel in self.categoryArr) {
            leftModel.isSelected = leftModel.tempIsSelected; //将选中的赋值
            if (leftModel.isSelected) {
                targetIndex = index;
                BOOL hasSelected = NO;
                for (TNCategoryModel *rightModel in leftModel.children) {
                    rightModel.isSelected = rightModel.tempIsSelected;
                    if (rightModel.isSelected) {
                        [selectedArr addObject:rightModel.menuId];
                        hasSelected = YES;
                    }
                }
                if (hasSelected == NO) {
                    [selectedArr addObject:leftModel.menuId];
                }
            }
            index++;
        }
        if (self.selectedCallBack) {
            self.selectedCallBack(targetIndex, [selectedArr componentsJoinedByString:@","]);
        }
    }
    [self dismiss];
}
#pragma mark - 验证筛选是否新选了
- (BOOL)checkHasNewSelected {
    for (TNCategoryModel *leftModel in self.categoryArr) {
        if (leftModel.isSelected != leftModel.tempIsSelected) {
            //如果选中的和原有选中不同 必然是新选的
            return YES;
        } else {
            //判断右边
            for (TNCategoryModel *rightModel in leftModel.children) {
                if (rightModel.isSelected != rightModel.tempIsSelected) {
                    return YES;
                }
            }
        }
    }
    return NO;
}
#pragma mark - 验证当前是否有选择的分类
- (BOOL)checkHasSelectd {
    for (TNCategoryModel *leftModel in self.categoryArr) {
        if (leftModel.tempIsSelected) {
            return YES;
        } else {
            //判断右边
            for (TNCategoryModel *rightModel in leftModel.children) {
                if (rightModel.tempIsSelected) {
                    return YES;
                }
            }
        }
    }
    return NO;
}
#pragma mark - 验证当前弹窗里面选中的二级分类 是否有搜索过
- (BOOL)checkCategoryHasSearched {
    for (TNCategoryModel *leftModel in self.categoryArr) {
        if (leftModel.isSelected) {
            //只有原本的二级分类有值  就代表已经搜索过
            for (TNCategoryModel *rightModel in leftModel.children) {
                if (rightModel.isSelected) {
                    return YES;
                }
            }
            break;
        }
    }
    return NO;
}
#pragma mark - 清除所有选中
- (void)clearAll {
    [self.categoryArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.tempIsSelected = NO;
        [obj.children enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
            subObj.tempIsSelected = NO;
        }];
    }];
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
- (TNCategoryChooseView *)filterContainer {
    if (!_filterContainer) {
        _filterContainer = [[TNCategoryChooseView alloc] init];
        @HDWeakify(self);
        _filterContainer.checkCanConfirm = ^(BOOL canConfirm) {
            @HDStrongify(self);
            self.confirmButton.enabled = canConfirm;
        };
    }
    return _filterContainer;
}
/** @lazy cancelbutton */
- (SAOperationButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_cancelButton setTitle:TNLocalizedString(@"UFrIdr2o", @"重置") forState:UIControlStateNormal];
        _cancelButton.cornerRadius = 0;
        [_cancelButton applyPropertiesWithBackgroundColor:HexColor(0xD6DBE8)];
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
        [_confirmButton setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        _confirmButton.cornerRadius = 0;
        [_confirmButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
    }
    return _confirmButton;
}
@end
