//
//  TNSellerStoreCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNSellerStoreModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerStoreCell : TNCollectionViewCell
@property (strong, nonatomic) TNSellerStoreModel *model;
@end

NS_ASSUME_NONNULL_END
