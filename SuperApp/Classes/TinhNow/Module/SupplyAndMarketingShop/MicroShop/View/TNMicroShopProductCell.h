//
//  TNMicroShopProductCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNSellerProductModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopProductCell : TNCollectionViewCell
@property (nonatomic, assign) BOOL isShowSelected;         ///<  是否展示选择按钮
@property (strong, nonatomic) TNSellerProductModel *model; ///<
/// 删除商品回调
@property (nonatomic, copy) void (^deleteProductCallBack)(TNSellerProductModel *curModel);
/// 改价商品回调
@property (nonatomic, copy) void (^changeProductPriceCallBack)(void);
/// 设置取消商品热卖回调
@property (nonatomic, copy) void (^setProductHotSalesCallBack)(BOOL hotSales);
/// 是否来自搜索页面   搜索的布局有差异
@property (nonatomic, assign) BOOL isFromSearch;
@end

NS_ASSUME_NONNULL_END
