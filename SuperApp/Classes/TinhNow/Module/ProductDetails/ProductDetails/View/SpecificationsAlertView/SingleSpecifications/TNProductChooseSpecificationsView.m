//
//  TNProductChooseSpecificationsView.m
//  SuperApp
//
//  Created by seeu on 2020/7/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductChooseSpecificationsView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAModifyShoppingCountView.h"
#import "SAOperationButton.h"
#import "SATableView.h"
#import "TNItemModel.h"
#import "TNProductChooseTipsView.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductInfoView.h"
#import "TNProductSpecPropertieModel.h"
#import "TNSingleSpecificationContentView.h"
#import "TNSkuSpecModel.h"
#import "TNSkuSpecView.h"
#define kMarginTitleToTop kRealWidth(20.0f)


@interface TNProductChooseSpecificationsView ()
///// model
@property (nonatomic, strong) TNSkuSpecModel *productModel;
///// 按钮显示类型
@property (nonatomic, assign) TNProductBuyType buyType;
///
@property (strong, nonatomic) TNSingleSpecificationContentView *contentView;
@end


@implementation TNProductChooseSpecificationsView

- (instancetype)initWithProductModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType {
    self = [super init];
    if (self) {
        self.buyType = buyType;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.productModel = model;
        //        [self dataInit];
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
    [self.containerView addSubview:self.contentView];
    @HDWeakify(self);
    self.contentView.clickCloseCallBack = ^{
        @HDStrongify(self);
        [self dismiss];
    };
    self.contentView.addToCartBlock = ^(TNItemModel *_Nonnull itemModel) {
        @HDStrongify(self);
        [self dismissCompletion:^{
            !self.addToCartBlock ?: self.addToCartBlock(itemModel);
        }];
    };
}
- (void)layoutContainerViewSubViews {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
    }];
}
- (TNSingleSpecificationContentView *)contentView {
    if (!_contentView) {
        _contentView = [[TNSingleSpecificationContentView alloc] initWithProductModel:self.productModel buyType:self.buyType];
    }
    return _contentView;
}
@end
