//
//  TNStoreRecommendWapperView.h
//  SuperApp
//
//  Created by 张杰 on 2023/2/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNGoodsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNStoreRecommendWapperView : TNView
/// 商品数据源
@property (strong, nonatomic) NSArray<TNGoodsModel *> *goodArr;
/// 卖家sp
@property (nonatomic, copy) NSString *sp;
@end

NS_ASSUME_NONNULL_END
