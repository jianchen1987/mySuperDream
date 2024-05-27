//
//  TNBargainPageConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/2/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNBargainGoodModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainPageConfig : TNModel
/// 是否还有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
/// 商品数据源
@property (strong, nonatomic) NSMutableArray<TNBargainGoodModel *> *goods;
@end

NS_ASSUME_NONNULL_END
