//
//  TNMicroShopInfoCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNMicroShopDetailInfoModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopInfoCell : TNCollectionViewCell
///
@property (strong, nonatomic) TNMicroShopDetailInfoModel *model;
@end

NS_ASSUME_NONNULL_END
