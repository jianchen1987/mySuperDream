//
//  TNStoreRecommendProductView.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNGoodsModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNStoreRecommendProductView : TNView
///
@property (strong, nonatomic) TNGoodsModel *model;
/// 卖家sp
@property (nonatomic, copy) NSString *sp;
///
@property (nonatomic, assign) CGFloat itemWidth;
@end

NS_ASSUME_NONNULL_END
