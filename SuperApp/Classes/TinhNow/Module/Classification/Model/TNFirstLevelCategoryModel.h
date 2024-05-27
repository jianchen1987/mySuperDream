//
//  TNFirstLevelCategoryModel.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNSecondLevelCategoryModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNFirstLevelCategoryModel : TNModel
/// 广告图地址
@property (nonatomic, copy) NSString *advImgUrl;
/// 广告图 H5跳转连接
@property (nonatomic, copy) NSString *advH5Url;
/// 未选中图标地址
@property (nonatomic, copy) NSString *uncheckimgUrl;
/// 选中图标地址
@property (nonatomic, copy) NSString *selectedimgUrl;
/// 分类id
@property (nonatomic, copy) NSString *categoryId;
/// 备注
@property (nonatomic, copy) NSString *memo;
/// 层级
@property (nonatomic, copy) NSString *grade;
/// APP跳转连接
@property (nonatomic, copy) NSString *advAppUrl;
/// 分类名字
@property (nonatomic, copy) NSString *name;
/// 二级l分类数据源
@property (nonatomic, strong) NSArray<TNSecondLevelCategoryModel *> *children;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
