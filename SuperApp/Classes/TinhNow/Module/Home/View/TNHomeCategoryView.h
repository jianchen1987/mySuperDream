//
//  TNHomeCategoryView.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNGoodsModel;


@interface TNHomeCategoryView : TNView <HDCategoryListContentViewDelegate>
/// 数据源
@property (nonatomic, strong, readonly) NSMutableArray<TNGoodsModel *> *dataSource;
/// 初始化
/// @param categoryId 必传分类id
- (instancetype)initWithCategoryId:(NSString *)categoryId;
@end

NS_ASSUME_NONNULL_END
