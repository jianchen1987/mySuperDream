//
//  TNSpecificationSelectAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecificationSelectAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import "TNProductBatchToggleView.h"
#import "TNProductChooseTipsView.h"
#import "TNSingleSpecificationContentView.h"
#import "TNWholesaleSpecificationContentView.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry/Masonry.h>


@interface TNSpecificationSelectAlertView ()
/// 购物提示
@property (nonatomic, strong) TNProductChooseTipsView *tipsView;
/// 顶部关闭视图
@property (strong, nonatomic) UIView *topView;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 切换菜单视图
@property (strong, nonatomic) TNProductBatchToggleView *tabView;
/// 单买视图
@property (strong, nonatomic) TNSingleSpecificationContentView *singleContentView;
/// 批量视图
@property (strong, nonatomic) TNWholesaleSpecificationContentView *batchContentView;
/// 规格模型
@property (strong, nonatomic) TNSkuSpecModel *specModel;
/// 按钮显示类型
@property (nonatomic, assign) TNProductBuyType buyType;
/// 弹窗类型
@property (nonatomic, assign) TNSpecificationType specType;
/// 单买还是批量  混合展示的时候需要
@property (nonatomic, copy) TNSalesType salesType;
///
@property (nonatomic, assign) CGFloat singleContentHeight;
///
@property (nonatomic, assign) CGFloat batchContentHeight;
@end


@implementation TNSpecificationSelectAlertView
- (instancetype)initWithSpecType:(TNSpecificationType)specType specModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType {
    if (self = [super init]) {
        self.specModel = model;
        self.buyType = buyType;
        self.specType = specType;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        //进入规格页埋点
        [TNEventTrackingInstance trackEvent:@"spec" properties:@{@"productId": model.productId}];
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.tipsView];
    [self.containerView addSubview:self.topView];
    [self.topView addSubview:self.closeBTN];
    if (HDIsStringNotEmpty(self.specModel.purchaseTips)) {
        self.tipsView.hidden = NO;
        [self.tipsView setText:self.specModel.purchaseTips];
    }
    if (self.specType == TNSpecificationTypeSingle) {
        //单买
        self.salesType = TNSalesTypeSingle;
        self.tabView.hidden = YES;
        [self.containerView addSubview:self.singleContentView];
        [self initSingleView];
    } else if (self.specType == TNSpecificationTypeBatch) {
        //批量
        self.salesType = TNSalesTypeBatch;
        self.tabView.hidden = YES;
        [self.containerView addSubview:self.batchContentView];
        [self initBatchView];
    } else if (self.specType == TNSpecificationTypeMix) {
        //单买批量一起
        self.tabView.hidden = NO;
        [self.containerView addSubview:self.tabView];
        [self.containerView addSubview:self.singleContentView];
        self.salesType = TNSalesTypeSingle; //默认单买
        [self initSingleView];
        //        [self initBatchView];
    }
}
- (void)initSingleView {
    @HDWeakify(self);
    self.singleContentView.clickCloseCallBack = ^{
        @HDStrongify(self);
        [self dismiss];
    };
    self.singleContentView.addToCartBlock = ^(TNItemModel *_Nonnull itemModel) {
        @HDStrongify(self);
        @HDWeakify(self);
        [self dismissCompletion:^{
            @HDStrongify(self);
            if (self.buyType == TNProductBuyTypeBuyNow) {
                !self.buyNowCallBack ?: self.buyNowCallBack(itemModel, self.salesType);
            } else if (self.buyType == TNProductBuyTypeAddCart) {
                !self.addToCartCallBack ?: self.addToCartCallBack(itemModel, self.salesType);
            }
        }];
    };
}
- (void)initBatchView {
    [self.containerView addSubview:self.batchContentView];
    @HDWeakify(self);
    self.batchContentView.clickCloseCallBack = ^{
        @HDStrongify(self);
        [self dismiss];
    };
    self.batchContentView.buyNowOraddToCartCallBack = ^(TNItemModel *_Nonnull item) {
        @HDStrongify(self);
        @HDWeakify(self);
        [self dismissCompletion:^{
            @HDStrongify(self);
            if (self.buyType == TNProductBuyTypeBuyNow) {
                !self.buyNowCallBack ?: self.buyNowCallBack(item, self.salesType);
            } else if (self.buyType == TNProductBuyTypeAddCart) {
                !self.addToCartCallBack ?: self.addToCartCallBack(item, self.salesType);
            }
        }];
    };
}
- (void)layoutContainerViewSubViews {
    if (!self.tipsView.isHidden) {
        [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left);
            make.top.equalTo(self.containerView.mas_top);
            make.right.equalTo(self.containerView.mas_right);
            make.height.mas_equalTo(kRealWidth(35));
        }];
    }
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        if (!self.tipsView.isHidden) {
            make.top.mas_equalTo(self.tipsView.mas_bottom);
        } else {
            make.top.mas_equalTo(self.containerView.mas_top);
        }
        make.height.mas_equalTo(kRealWidth(30));
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    if (self.specType == TNSpecificationTypeSingle) {
        //单买
        [self.singleContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
        }];
    } else if (self.specType == TNSpecificationTypeBatch) {
        //批量
        [self.batchContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
        }];
    } else if (self.specType == TNSpecificationTypeMix) {
        //单买批量一起
        [self.tabView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(kRealWidth(40));
        }];
        if ([self.salesType isEqualToString:TNSalesTypeSingle]) {
            [self.singleContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.containerView);
                make.top.equalTo(self.tabView.mas_bottom);
                make.bottom.equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
            }];
        }
        if ([self.salesType isEqualToString:TNSalesTypeBatch]) {
            [self.batchContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.containerView);
                make.top.equalTo(self.tabView.mas_bottom);
                make.bottom.equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
            }];
        }
    }
}
#pragma mark -切换 单买 批量菜单
- (void)changeSpecificationStyle:(TNSalesType)salesType {
    self.salesType = salesType;
    if ([salesType isEqualToString:TNSalesTypeSingle]) {
        [self.batchContentView removeFromSuperview];
        if (![self.containerView.subviews containsObject:self.singleContentView]) {
            [self.containerView addSubview:self.singleContentView];
            [self initSingleView];
        }
    } else if ([salesType isEqualToString:TNSalesTypeBatch]) {
        [self.singleContentView removeFromSuperview];
        if (![self.containerView.subviews containsObject:self.batchContentView]) {
            [self.containerView addSubview:self.batchContentView];
            [self initBatchView];
        }
    }
    [self layoutContainerViewSubViews];
}
/** @lazy contentView */
- (TNWholesaleSpecificationContentView *)batchContentView {
    if (!_batchContentView) {
        _batchContentView = [[TNWholesaleSpecificationContentView alloc] initWithSpecModel:self.specModel buyType:self.buyType];
    }
    return _batchContentView;
}
/** @lazy singleContentView */
- (TNSingleSpecificationContentView *)singleContentView {
    if (!_singleContentView) {
        _singleContentView = [[TNSingleSpecificationContentView alloc] initWithProductModel:self.specModel buyType:self.buyType];
    }
    return _singleContentView;
}
- (TNProductChooseTipsView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[TNProductChooseTipsView alloc] init];
        _tipsView.userSetHeight = YES;
        _tipsView.hidden = YES;
    }
    return _tipsView;
}
/** @lazy tabView */
- (TNProductBatchToggleView *)tabView {
    if (!_tabView) {
        _tabView = [[TNProductBatchToggleView alloc] init];
        TNProductBatchToggleCellModel *model = [[TNProductBatchToggleCellModel alloc] init];
        model.salesType = TNSalesTypeSingle;
        model.hiddenQuestionBtn = YES;
        @HDWeakify(self);
        model.toggleCallBack = ^(TNSalesType _Nonnull salesType) {
            @HDStrongify(self);
            [self changeSpecificationStyle:salesType];
        };
        _tabView.model = model;
    }
    return _tabView;
}
/** @lazy topView */
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
@end
