//
//  TNSellerStoreModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSellerStoreModel : TNModel
@property (nonatomic, copy) NSString *storeNo;         ///<店铺ID
@property (nonatomic, copy) NSString *storeName;       ///<店铺ID
@property (nonatomic, copy) TNStoreType storeTypeName; ///<店铺枚举字符串
@property (nonatomic, copy) NSString *logo;            ///<店铺图片
@property (nonatomic, copy) NSString *productNum;      ///<商品数量
@property (nonatomic, copy) NSString *storeType;       ///<店铺枚举  数字

@end

NS_ASSUME_NONNULL_END
