//
//  TNSellerProductCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNSellerProductModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerProductCell : TNCollectionViewCell
///隐藏店铺相关显示
@property (nonatomic, assign) BOOL hiddeStoreInfo;
@property (strong, nonatomic) TNSellerProductModel *model; ///<
///刷新列表
@property (nonatomic, copy) void (^reloadTableViewCallBack)(void);
@end

NS_ASSUME_NONNULL_END
