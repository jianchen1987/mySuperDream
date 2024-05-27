//
//  TNStoreFavoritesModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopFavoritesModel : TNModel
/// 是否优质卖家
@property (nonatomic, assign) BOOL isHonor;
/// 微店名称
@property (nonatomic, copy) NSString *nickName;
/// 微店图片
@property (nonatomic, copy) NSString *supplierImage;
/// 微店id
@property (nonatomic, copy) NSString *supplierId;
@end


@interface TNStoreFavoritesModel : TNModel
/// 店铺ID
@property (nonatomic, copy) NSString *storeId;
/// 店铺名称
@property (nonatomic, copy) NSString *name;
/// 店铺类型
@property (nonatomic, copy) TNStoreType type;
/// 店铺logo图
@property (nonatomic, copy) NSString *logo;
/// 店铺收藏id
@property (nonatomic, copy) NSString *storeFavoriteId;
///
@property (strong, nonatomic) TNMicroShopFavoritesModel *supplierFavoriteRespDto;
/// 是否是微店
@property (nonatomic, assign) BOOL isMicroShop;
@end

NS_ASSUME_NONNULL_END
