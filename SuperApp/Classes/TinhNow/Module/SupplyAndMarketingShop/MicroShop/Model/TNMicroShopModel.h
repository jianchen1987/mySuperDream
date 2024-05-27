//
//  TNMicroShopModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopModel : TNModel
@property (nonatomic, copy) NSString *shopName;      ///<店铺名字
@property (nonatomic, copy) NSString *supplierImage; ///<店铺图片
@property (nonatomic, copy) NSString *supplierId;    ///<店铺号
@end

NS_ASSUME_NONNULL_END
