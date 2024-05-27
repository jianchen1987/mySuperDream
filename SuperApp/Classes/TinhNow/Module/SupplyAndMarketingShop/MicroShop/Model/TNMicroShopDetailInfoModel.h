//
//  TNMicroShopDetailInfoModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNSeller;
NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopDetailInfoModel : TNModel
/// 卖家ID
@property (nonatomic, copy) NSString *supplierId;
/// 卖家店铺图片
@property (nonatomic, copy) NSString *supplierImage;
/// 卖家code
@property (nonatomic, copy) NSString *sp;
/// 名称
@property (nonatomic, copy) NSString *nickName;
/// 是否优质卖家
@property (nonatomic, assign) BOOL isHonor;
/// 是否已收藏
@property (nonatomic, assign) BOOL collectFlag;

+ (instancetype)modelWithSellerModel:(TNSeller *)sellerModel;
@end

NS_ASSUME_NONNULL_END
