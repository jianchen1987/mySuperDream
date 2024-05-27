//
//  TNSmallShopCarButton.m
//  SuperApp
//
//  Created by 张杰 on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSmallShopCarButton.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "TNGoodInfoModel.h"
#import "TNGoodsDTO.h"
#import "TNGoodsModel.h"
#import "TNProductBuyTipsView.h"
#import "TNShoppingCar.h"
#import "TNSkuSpecModel.h"
#import "TNSpecificationSelectAlertView.h"
#import "UIView+NAT.h"
#import <HDKitCore/HDCommonDefines.h>
#import <Masonry/Masonry.h>


@interface TNSmallShopCarButton ()
/// 加购按钮
@property (strong, nonatomic) HDUIButton *addCartBtn;
///
@property (strong, nonatomic) TNGoodsDTO *goodDTO;
@end


@implementation TNSmallShopCarButton
- (instancetype)init {
    self = [super init];
    if (self) {
        [self hd_setupViews];
    }
    return self;
}
- (void)hd_setupViews {
    [self addSubview:self.addCartBtn];
    [self.addCartBtn sizeToFit];
    [self.addCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)setGoodModel:(TNGoodsModel *)goodModel {
    _goodModel = goodModel;
}
//加入购物车
- (void)addShopCartClick {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    [KeyWindow showloading];
    @HDWeakify(self);
    [self.goodDTO queryGoodSkuDataWithProductId:self.goodModel.productId success:^(TNGoodInfoModel *_Nonnull rspModel) {
        [KeyWindow dismissLoading];
        @HDStrongify(self);
        if (rspModel.showPurchaseTipsStore) {
            [self showStoreBuyTipsView:rspModel];
        } else {
            [self showSkuSpecAlertView:rspModel];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [KeyWindow dismissLoading];
    }];
}
#pragma mark -展示店铺购买提示视图
- (void)showStoreBuyTipsView:(TNGoodInfoModel *)goodInfoModel {
    TNProductBuyTipsView *tipsView = [[TNProductBuyTipsView alloc] initTipsType:TNProductBuyTypeAddCart storeNo:goodInfoModel.storeNo storePhone:goodInfoModel.storePhone
                                                                           tips:goodInfoModel.purchaseTipsStore
                                                                          title:self.goodModel.productName
                                                                        content:self.goodModel.price.thousandSeparatorAmount
                                                                          image:self.goodModel.thumbnail];
    @HDWeakify(self);
    tipsView.doneClickCallBack = ^{
        @HDStrongify(self);
        [self showSkuSpecAlertView:goodInfoModel];
    };
    [tipsView show];
}
#pragma mark -展示规格选择视图
- (void)showSkuSpecAlertView:(TNGoodInfoModel *)goodInfoModel {
    TNSpecificationType type = TNSpecificationTypeSingle;
    if (!HDIsObjectNil(goodInfoModel.batchPriceInfo) && goodInfoModel.batchPriceInfo.enabledStagePrice) {
        type = TNSpecificationTypeMix;
    }
    TNSpecificationSelectAlertView *specView = [[TNSpecificationSelectAlertView alloc] initWithSpecType:type specModel:[TNSkuSpecModel modelWithGoodModel:goodInfoModel]
                                                                                                buyType:TNProductBuyTypeAddCart];
    @HDWeakify(self);
    specView.addToCartCallBack = ^(TNItemModel *_Nonnull item, TNSalesType _Nonnull salesType) {
        @HDStrongify(self);
        //判断限购商品
        if (!goodInfoModel.canBuy) {
            [NAT showAlertWithMessage:[NSString stringWithFormat:TNLocalizedString(@"tn_limit_goods_tips", @"商品限购%ld件，把机会留给其他人吧"), goodInfoModel.maxLimit]
                          buttonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                              [alertView dismiss];
                          }];
            return;
        }

        !self.addShopCartTrackEventCallBack ?: self.addShopCartTrackEventCallBack(self.goodModel.productId, item);
        //        [self addToCartWithItem:item];
    };
    [specView show];
}
//- (void)addToCartWithItem:(TNItemModel *)itemModel {
//    [KeyWindow showloading];
//    @HDWeakify(self);
//    [[TNShoppingCar share] addItemToShoppingCarWithItem:itemModel
//        success:^(TNAddItemToShoppingCarRspModel *_Nonnull rspModel) {
//            @HDStrongify(self);
//            [KeyWindow dismissLoading];
//
//
//            [TNTool startAddProductToCartAnimationWithImage:self.goodModel.thumbnail startPoint:self.animationStartPoint endPoint:[TNShoppingCartEntryWindow.sharedInstance getCartButtonConvertPoint]
//            inView:[UIApplication sharedApplication].keyWindow completion:^{
//                [HDTips showWithText:TNLocalizedString(@"tn_add_cart_success", @"添加购物车成功") inView:KeyWindow hideAfterDelay:3];
//            }];
//
//        }
//        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
//            [KeyWindow dismissLoading];
//            [HDTips showWithText:TNLocalizedString(@"tn_add_cart_fail", @"添加购物车失败") inView:KeyWindow hideAfterDelay:3];
//        }];
//}
//- (TNSkuSpecModel *)getSkuModel:(TNGoodInfoModel *)goodInfoModel {
//    TNSkuSpecModel *skuModel = [[TNSkuSpecModel alloc] init];
//    skuModel.skus = goodInfoModel.skus;
//    skuModel.specs = goodInfoModel.specs;
//    skuModel.productId = goodInfoModel.productId;
//    skuModel.priceRange = [goodInfoModel getPriceRange];
//    skuModel.maxStock = [goodInfoModel getMaxStock];
//    skuModel.storeNo = goodInfoModel.storeNo;
//    skuModel.purchaseTips = goodInfoModel.purchaseTips;
//    skuModel.productName = self.goodModel.productName;
//    skuModel.thumbnail = self.goodModel.thumbnail;
//    skuModel.skuLargeImg = self.goodModel.thumbnail;
//    skuModel.goodsLimitBuy = goodInfoModel.goodsLimitBuy;
//    skuModel.maxLimit = goodInfoModel.maxLimit;
//    skuModel.minLimit = 1;
//    if (goodInfoModel.skus.count == 1) {
//        TNProductSkuModel *first = goodInfoModel.skus.firstObject;
//        if (HDIsStringNotEmpty(first.showWight)) {
//            skuModel.showWight = first.showWight;
//        }
//    }
//    return skuModel;
//}
/** @lazy addCartBtn */
- (HDUIButton *)addCartBtn {
    if (!_addCartBtn) {
        _addCartBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_addCartBtn setImage:[UIImage imageNamed:@"tn_add_shopcar"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_addCartBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self addShopCartClick];
        }];
    }
    return _addCartBtn;
}
/** @lazy goodDTO */
- (TNGoodsDTO *)goodDTO {
    if (!_goodDTO) {
        _goodDTO = [[TNGoodsDTO alloc] init];
    }
    return _goodDTO;
}
@end
