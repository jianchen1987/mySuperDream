//
//  TNSingleSpecificationContentView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSingleSpecificationContentView.h"
#import "SAModifyShoppingCountView.h"
#import "SAOperationButton.h"
#import "TNItemModel.h"
#import "TNProductChooseTipsView.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductInfoView.h"
#import "TNProductSpecPropertieModel.h"
#import "TNSkuSpecModel.h"
#import "TNSkuSpecView.h"


@interface TNSingleSpecificationContentView ()
/// model
@property (nonatomic, strong) TNSkuSpecModel *productModel;
/// 商品视图
@property (strong, nonatomic) TNProductInfoView *productInfoView;
/// 规格列表
@property (strong, nonatomic) TNSkuSpecView *skuSpecView;
/// 添加购物车按钮
@property (nonatomic, strong) SAOperationButton *addToCartBTN;
/// 当前选中的SKU
@property (nonatomic, strong) TNProductSkuModel *curSelectedSkuModel;
/// 按钮显示类型
@property (nonatomic, assign) TNProductBuyType buyType;
@end


@implementation TNSingleSpecificationContentView
- (instancetype)initWithProductModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType {
    self.buyType = buyType;
    id json = [model yy_modelToJSONObject];
    self.productModel = [TNSkuSpecModel yy_modelWithJSON:json];
    return [super init];
}
- (void)hd_setupViews {
    [self addSubview:self.productInfoView];
    [self addSubview:self.skuSpecView];
    [self addSubview:self.addToCartBTN];
    [self.productInfoView updateProductInfoByThumbImageUrl:self.productModel.thumbnail largeImageUrl:self.productModel.skuLargeImg price:self.productModel.priceRange stock:nil selectedSpec:nil
                                                    weight:self.productModel.showWight];
    self.skuSpecView.model = self.productModel;
    NSString *btnTitle = @"";
    if (self.buyType == TNProductBuyTypeBuyNow) {
        btnTitle = TNLocalizedString(@"tn_buynow", @"立即购买");
    } else if (self.buyType == TNProductBuyTypeAddCart) {
        btnTitle = TNLocalizedString(@"tn_add_cart", @"Add to Cart");
    }
    [self.addToCartBTN setTitle:btnTitle forState:UIControlStateNormal];
}
- (void)updateConstraints {
    [self.productInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top);
    }];

    [self.skuSpecView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.productInfoView.mas_bottom);
    }];

    [self.addToCartBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.skuSpecView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self updateSkuSpecViewLayout];
    [self.productInfoView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.skuSpecView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}
- (void)updateSkuSpecViewLayout {
    CGFloat skuSpecViewHeight = self.skuSpecView.collectionViewHeight;
    if (skuSpecViewHeight > kScreenHeight * 0.5) {
        skuSpecViewHeight = kScreenHeight * 0.5;
    }
    [self.skuSpecView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(skuSpecViewHeight);
    }];
}
#pragma mark - event response
- (void)clickedCloseBTNHandler {
    !self.clickCloseCallBack ?: self.clickCloseCallBack();
}

- (void)clickedAddToCartBTNHandler {
    TNItemModel *item = TNItemModel.new;
    item.storeNo = self.productModel.storeNo;
    item.goodsId = self.productModel.productId;
    item.goodName = self.productModel.productName;
    item.shareCode = self.productModel.shareCode;
    item.sp = self.productModel.sp;
    item.salesType = TNSalesTypeSingle;
    TNItemSkuModel *skuModel = [[TNItemSkuModel alloc] init];
    skuModel.goodsSkuId = self.curSelectedSkuModel.skuId;
    skuModel.addDelta = [NSNumber numberWithInteger:self.skuSpecView.selectedCount];
    skuModel.salePrice = self.curSelectedSkuModel.price;
    skuModel.properties = [self getProperties];
    skuModel.thumbnail = HDIsStringNotEmpty(self.curSelectedSkuModel.thumbnail) ? self.curSelectedSkuModel.thumbnail : self.productModel.thumbnail;
    skuModel.weight = self.curSelectedSkuModel.weight;
    item.skuList = @[skuModel];
    !self.addToCartBlock ?: self.addToCartBlock(item);
}

#pragma mark - private methods
// 获取选中的SKU 的属性值集合
- (NSString *)getProperties {
    __block NSString *skuProperties = @"";
    [self.curSelectedSkuModel.specValueKeyArray enumerateObjectsUsingBlock:^(NSString *_Nonnull itemObj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.productModel.specs enumerateObjectsUsingBlock:^(TNProductSpecificationModel *_Nonnull specObj, NSUInteger specIdx, BOOL *_Nonnull stop) {
            [specObj.specValues enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *_Nonnull subObj, NSUInteger subIdx, BOOL *_Nonnull stop) {
                if ([subObj.propId isEqualToString:itemObj]) {
                    if (specIdx == 0) {
                        skuProperties = [skuProperties stringByAppendingFormat:@"%@", subObj.propValue];
                    } else {
                        skuProperties = [skuProperties stringByAppendingFormat:@",%@", subObj.propValue];
                    }

                    *stop = YES;
                }
            }];
        }];
    }];
    return skuProperties;
}
- (CGFloat)containerViewWidth {
    return kScreenWidth;
}

- (void)fixedButtonState {
    [self.productInfoView updateProductInfoByThumbImageUrl:HDIsStringNotEmpty(self.curSelectedSkuModel.thumbnail) ? self.curSelectedSkuModel.thumbnail : self.productModel.thumbnail
                                             largeImageUrl:HDIsStringNotEmpty(self.curSelectedSkuModel.skuLargeImg) ? self.curSelectedSkuModel.skuLargeImg : self.productModel.skuLargeImg
                                                     price:self.curSelectedSkuModel.price.thousandSeparatorAmount
                                                     stock:self.curSelectedSkuModel.stock
                                              selectedSpec:[self getProperties]
                                                    weight:self.curSelectedSkuModel.showWight];
    if (self.curSelectedSkuModel.stock.integerValue != 0 && self.curSelectedSkuModel.stock.integerValue >= self.skuSpecView.selectedCount) {
        [self.addToCartBTN setEnabled:YES];
    } else {
        [self.addToCartBTN setEnabled:NO];
    }
    //刷新约束
    [self updateSkuSpecViewLayout];
}

#pragma mark - lazy load


- (SAOperationButton *)addToCartBTN {
    if (!_addToCartBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.cornerRadius = 0;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 30, 10, 30);
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
        [button addTarget:self action:@selector(clickedAddToCartBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        [button setEnabled:NO];
        _addToCartBTN = button;
    }
    return _addToCartBTN;
}

- (TNSkuSpecView *)skuSpecView {
    if (!_skuSpecView) {
        //设置默认选择数据
        _skuSpecView = [[TNSkuSpecView alloc] init];
        @HDWeakify(self);
        _skuSpecView.selectedSkuCallBack = ^(NSSet<NSIndexPath *> *_Nonnull selecedIndexSet, TNProductSkuModel *_Nonnull skuModel) {
            @HDStrongify(self);
            if (self.productModel.isSupplier) { //是卖家的话  购买商品 取批发价
                skuModel.price = skuModel.bulkPrice;
            }
            self.curSelectedSkuModel = skuModel;
            if (!self.curSelectedSkuModel) {
                [self.addToCartBTN setEnabled:NO];
                if (selecedIndexSet.count > 0) {
                    __block NSString *skuProperties = @"";
                    [selecedIndexSet enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, BOOL *_Nonnull stop) {
                        [self.productModel.specs enumerateObjectsUsingBlock:^(TNProductSpecificationModel *_Nonnull specObj, NSUInteger specIdx, BOOL *_Nonnull stop) {
                            if (specIdx == obj.section) {
                                [specObj.specValues enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *_Nonnull subObj, NSUInteger subIdx, BOOL *_Nonnull stop) {
                                    if (subIdx == obj.row) {
                                        if (HDIsStringEmpty(skuProperties)) {
                                            skuProperties = [skuProperties stringByAppendingFormat:@"%@", subObj.propValue];
                                        } else {
                                            skuProperties = [skuProperties stringByAppendingFormat:@",%@", subObj.propValue];
                                        }
                                        *stop = YES;
                                    }
                                }];
                                *stop = YES;
                            }
                        }];
                    }];
                    [self.productInfoView updateProductInfoByStock:nil selectedSpec:skuProperties];
                } else {
                    [self.productInfoView updateProductInfoByStock:nil selectedSpec:nil];
                }
                [self updateSkuSpecViewLayout];
                return;
            }
            [self fixedButtonState];
        };


        _skuSpecView.collectionViewHeightCallBack = ^{
            @HDStrongify(self);
            [self updateSkuSpecViewLayout];
        };
        _skuSpecView.willShowKeyboardModifyCountCallBack = ^(CGRect keyboardRect) {
            @HDStrongify(self);
            CGFloat maxHeight = keyboardRect.size.height + self.productInfoView.height + 70;
            CGFloat maxY = kScreenHeight - maxHeight;
            if (self.frame.origin.y > maxY) {
                self.transform = CGAffineTransformTranslate(self.transform, 0, -(self.frame.origin.y - maxY));
            }
        };
        _skuSpecView.willHiddenKeyboardModifyCountCallBack = ^{
            @HDStrongify(self);
            self.transform = CGAffineTransformIdentity;
        };
    }
    return _skuSpecView;
}
/** @lazy productInfoView */
- (TNProductInfoView *)productInfoView {
    if (!_productInfoView) {
        _productInfoView = [[TNProductInfoView alloc] init];
        @HDWeakify(self);
        _productInfoView.closeClickCallBack = ^{
            @HDStrongify(self);
            !self.clickCloseCallBack ?: self.clickCloseCallBack();
        };
    }
    return _productInfoView;
}
@end
