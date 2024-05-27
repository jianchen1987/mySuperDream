//
//  TNActivityHotSaleCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityHotSaleCell.h"
#import "TNActivityGoodsView.h"
#import "TNGoodsModel.h"
#import "UIView+UIScreenDisplaying.h"


@implementation TNActivityHotSaleCellModel
- (void)setList:(NSArray<TNGoodsModel *> *)list {
    _list = list;
    for (TNGoodsModel *model in list) {
        if (model.freightSetting || model.isSale) {
            self.hasFreeShippingOrPromotion = YES;
            break;
        }
    }
}
- (TNActivityGoodsDisplayStyle)style {
    if (self.list.count < 3) {
        return TNActivityGoodsDisplayStyleHorizontal;
    }
    return TNActivityGoodsDisplayStyleNormal;
}
- (CGFloat)goodItemWidth {
    CGFloat imageWidth = (kScreenWidth - kRealWidth(15) * 2 - kRealWidth(10) * 2) / 3;
    return imageWidth;
}
- (CGFloat)cellHeight {
    if (HDIsArrayEmpty(self.list)) {
        return 0;
    }
    CGFloat height = 0;
    if (self.list.count <= 2) {
        height += self.goodItemHeight * self.list.count;
    } else {
        //顶部
        height += kRealWidth(10);
        //行数
        NSInteger col = (self.list.count - 1) / 3 + 1;
        height += self.goodItemHeight * col;
        height += kRealWidth(10) * (col - 1);
        //尾部
        height += kRealWidth(10);
    }
    return height;
}
- (CGFloat)goodItemHeight {
    CGFloat height = 0;
    if (self.list.count < 3) { //横向
        height += kRealWidth(120);
    } else {
        //间距  商品图片  两行文字 价格
        height += self.goodItemWidth;
        height += kRealWidth(10);
        height += [self getGoodNameHeight];
        if (self.hasFreeShippingOrPromotion) {
            // 免邮或者促销标签
            height += kRealWidth(8);
            height += kRealWidth(18);
        }
        height += kRealWidth(8);
        height += [self getGoodPriceHeight];
        height += kRealWidth(5);
        height += [self getMarketPriceHeight]; //市场价
        height += kRealWidth(10);
    }
    return height;
}
/// 商品名称高度
- (CGFloat)getGoodNameHeight {
    CGFloat height = 0;
    height += [@"1 \n 2" boundingAllRectWithSize:CGSizeMake(self.goodItemWidth - kRealWidth(10), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0].height;
    return height;
}
/// 售价文本高度
- (CGFloat)getGoodPriceHeight {
    CGFloat height = 0;
    height += [@"1" boundingAllRectWithSize:CGSizeMake(self.goodItemWidth - kRealWidth(10), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12B lineSpacing:0].height;
    return height;
}
/// 市场价文本高度
- (CGFloat)getMarketPriceHeight {
    CGFloat height = 0;
    height += [@"1" boundingAllRectWithSize:CGSizeMake(self.goodItemWidth - kRealWidth(10), MAXFLOAT) font:[HDAppTheme.TinhNowFont fontRegular:10] lineSpacing:0].height;
    return height;
}
@end


@interface TNActivityHotSaleCell ()
@property (strong, nonatomic) NSArray *dataArr;                         ///< 数据源
@property (strong, nonatomic) TNActivityHotSaleCellModel *oldCellModel; ///< 旧的数据源
@property (nonatomic, strong) UIView *backGroundView;
/// 曝光商品数量
@property (strong, nonatomic) NSMutableArray *exposureProductIds;
///
@property (strong, nonatomic) NSMutableArray *itemArray;
///  记录滚动位置
@property (nonatomic, assign) CGFloat lastCollectionOffsetY;
@end


@implementation TNActivityHotSaleCell
- (void)dealloc {
    HDLog(@"TNActivityHotSaleCell  dealloc");
}
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.whiteColor;

    [self.contentView addSubview:self.backGroundView];
    self.exposureProductIds = [NSMutableArray array];
    @HDWeakify(self);
    self.scrollViewDidScrollBlock = ^(UICollectionView *_Nonnull collectionView) {
        @HDStrongify(self);
        if (self.lastCollectionOffsetY == 0 || fabs(collectionView.contentOffset.y - self.lastCollectionOffsetY) > 20) {
            NSArray *cells = collectionView.visibleCells;
            if ([cells containsObject:self] && !HDIsArrayEmpty(self.itemArray) && self.exposureProductIds.count != self.cellModel.list.count) {
                [self.itemArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TNActivityGoodsView *_Nonnull target, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([target isDisplayedInScreen]) {
                        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:target.model.productId];
                        if (![self.exposureProductIds containsObject:target.model.productId]) {
                            [self.exposureProductIds addObject:target.model.productId];
                        }
                        [self.itemArray removeObject:target];
                    }
                }];
            }
            self.lastCollectionOffsetY = collectionView.contentOffset.y;
        }
    };
}

- (void)updateConstraints {
    [self.backGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}

- (void)processExposureProducts {
    UIView *aView = self.superview;
    if ([aView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)aView;
        NSArray *cells = collectionView.visibleCells;
        if ([cells containsObject:self] && self.exposureProductIds.count != self.cellModel.list.count) {
            [self.itemArray enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if ([obj isKindOfClass:[TNActivityGoodsView class]]) {
                    TNActivityGoodsView *target = obj;
                    if ([target isDisplayedInScreen]) {
                        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:target.model.productId];
                        if (![self.exposureProductIds containsObject:target.model.productId]) {
                            [self.exposureProductIds addObject:target.model.productId];
                        }
                    }
                }
            }];
        }
    }
}

#pragma mark - setter
- (void)setCellModel:(TNActivityHotSaleCellModel *)cellModel {
    _cellModel = cellModel;
    if (HDIsObjectNil(self.oldCellModel) || ![self.oldCellModel.list isEqualToArray:cellModel.list]) {
        [self createContainViewWithList:cellModel.list];
        self.oldCellModel = cellModel;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self processExposureProducts];
        });
    }
}
- (void)createContainViewWithList:(NSArray<TNGoodsModel *> *)list {
    [self.backGroundView hd_removeAllSubviews];
    [self.itemArray removeAllObjects];
    if (list.count <= 2) {
        for (int i = 0; i < list.count; i++) {
            TNGoodsModel *model = list[i];
            model.isNeedShowSmallShopCar = model.isOutOfStock ? NO : self.cellModel.isQuicklyAddToCart;
            TNActivityGoodsView *goodView = [[TNActivityGoodsView alloc] init];
            goodView.style = TNActivityGoodsDisplayStyleHorizontal;
            goodView.hasFreeShippingOrPromotion = self.cellModel.hasFreeShippingOrPromotion;
            goodView.model = model;
            goodView.goodItemWidth = self.cellModel.goodItemWidth;
            goodView.goodItemHeight = self.cellModel.goodItemHeight;
            CGFloat x = 0;
            CGFloat y = i == 0 ? 0 : self.cellModel.goodItemHeight;
            goodView.frame = CGRectMake(x, y, kScreenWidth - kRealWidth(30), self.cellModel.goodItemHeight);
            [self.backGroundView addSubview:goodView];
            [self.itemArray addObject:goodView];
        }

    } else {
        CGFloat margin = kRealWidth(10);
        CGFloat height = self.cellModel.goodItemHeight;
        for (int i = 0; i < list.count; i++) {
            TNGoodsModel *model = list[i];
            model.isNeedShowSmallShopCar = model.isOutOfStock ? NO : self.cellModel.isQuicklyAddToCart;
            TNActivityGoodsView *goodView = [[TNActivityGoodsView alloc] init];
            goodView.goodItemWidth = self.cellModel.goodItemWidth;
            goodView.goodItemHeight = self.cellModel.goodItemHeight;
            goodView.hasFreeShippingOrPromotion = self.cellModel.hasFreeShippingOrPromotion;
            goodView.style = TNActivityGoodsDisplayStyleNormal;
            goodView.model = model;
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = (self.cellModel.goodItemWidth + margin) * col;
            CGFloat y = (height + margin) * row;
            goodView.frame = CGRectMake(x, y, self.cellModel.goodItemWidth, height);
            goodView.layer.shadowColor = [UIColor colorWithRed:203 / 255.0 green:212 / 255.0 blue:217 / 255.0 alpha:0.25].CGColor;
            goodView.layer.shadowOffset = CGSizeMake(0, 4);
            goodView.layer.shadowRadius = 6;
            goodView.layer.shadowOpacity = 1;
            goodView.layer.cornerRadius = 8;
            [self.backGroundView addSubview:goodView];
            [self.itemArray addObject:goodView];
        }
    }
}

/** @lazy backGroundView */
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
    }
    return _backGroundView;
}
/** @lazy itemArray */
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
@end
