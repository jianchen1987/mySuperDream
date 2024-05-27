//
//  TNHomeCategoryModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNHomeCategoryModel : TNModel
/// 名字
@property (nonatomic, copy) NSString *name;
/// 分类id
@property (nonatomic, copy) NSString *categoryId;
/// 分类层级，0为1级分类， 1为2级分类，2为3级分类
@property (nonatomic, assign) NSInteger grade;
/// 排序字段，数值越大越靠前
@property (nonatomic, assign) NSInteger order;
@end

NS_ASSUME_NONNULL_END
