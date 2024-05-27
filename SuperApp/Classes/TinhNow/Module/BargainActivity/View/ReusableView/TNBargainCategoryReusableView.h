//
//  TNBargainActivityHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//  砍价分类头部

#import "TNHomeCategoryModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainCategoryReusableView : UICollectionReusableView
/// 数据源
@property (nonatomic, copy) NSArray<TNHomeCategoryModel *> *list;
/// 点击类别回调
@property (nonatomic, copy) void (^categoryClickCallBack)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
