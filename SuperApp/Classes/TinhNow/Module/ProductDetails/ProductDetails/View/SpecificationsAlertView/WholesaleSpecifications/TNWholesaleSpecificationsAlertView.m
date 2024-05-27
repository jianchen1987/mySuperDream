//
//  TNWholesaleSpecificationsAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNWholesaleSpecificationsAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import "TNWholesaleSpecificationContentView.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry/Masonry.h>


@interface TNWholesaleSpecificationsAlertView ()
///
@property (strong, nonatomic) TNWholesaleSpecificationContentView *contentView;
///// 规格模型
@property (strong, nonatomic) TNSkuSpecModel *specModel;
///// 按钮显示类型
@property (nonatomic, assign) TNProductBuyType buyType;
@end


@implementation TNWholesaleSpecificationsAlertView
- (instancetype)initWithSpecModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType {
    if (self = [super init]) {
        self.specModel = model;
        self.buyType = buyType;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
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
    self.contentView.buyNowOraddToCartCallBack = ^(TNItemModel *_Nonnull item) {
        @HDStrongify(self);
        @HDWeakify(self);
        [self dismissCompletion:^{
            @HDStrongify(self);
            if (self.buyType == TNProductBuyTypeBuyNow) {
                !self.buyNowCallBack ?: self.buyNowCallBack(item);
            } else if (self.buyType == TNProductBuyTypeAddCart) {
                !self.addToCartCallBack ?: self.addToCartCallBack(item);
            }
        }];
    };
}
- (void)layoutContainerViewSubViews {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
    }];
}

/** @lazy contentView */
- (TNWholesaleSpecificationContentView *)contentView {
    if (!_contentView) {
        _contentView = [[TNWholesaleSpecificationContentView alloc] initWithSpecModel:self.specModel buyType:self.buyType];
    }
    return _contentView;
}
@end
