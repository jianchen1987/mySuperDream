//
//  TNNotReviewHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
@class TNMyNotReviewStoreInfo;
NS_ASSUME_NONNULL_BEGIN


@interface TNNotReviewHeaderView : SATableHeaderFooterView
/// 店铺数据
@property (strong, nonatomic) TNMyNotReviewStoreInfo *storeInfo;
@end

NS_ASSUME_NONNULL_END
