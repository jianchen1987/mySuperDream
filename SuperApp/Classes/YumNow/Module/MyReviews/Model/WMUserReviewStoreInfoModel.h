//
//  WMUserReviewStoreInfoModel.h
//  SuperApp
//
//  Created by VanJay on 2020/7/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMUserReviewStoreInfoModel : WMModel
/// 经营范围
@property (nonatomic, copy) NSArray<NSString *> *businessScopes;
/// logo
@property (nonatomic, copy) NSString *logo;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
@end


@interface WMUserReviewStoreInfoStoresModel : WMModel
/// 所有的评论
@property (nonatomic, copy) NSArray<WMUserReviewStoreInfoModel *> *res;
@end

NS_ASSUME_NONNULL_END
