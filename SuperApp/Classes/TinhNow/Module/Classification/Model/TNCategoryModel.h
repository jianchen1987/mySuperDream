//
//  TNCategoryModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 更多按钮 标识
static NSString *const kCategotyMoreItemName = @"TNCategotyMoreItemName";
/// 主题会场 标识
static NSString *const kCategotyThemeVenueItemName = @"TNCategotyThemeVenueItemName";
/// 推荐 标识
static NSString *const kCategotyRecommondItemName = @"TNCategotyRecommondItemName";

@class SAInternationalizationModel;


@interface TNCategoryModel : TNCodingModel
/// 分类ID
@property (nonatomic, copy) NSString *menuId;
/// name
@property (nonatomic, strong) SAInternationalizationModel *menuName;
/// 分类父ID
@property (nonatomic, copy) NSString *parentId;
/// 图片 商铺用的这个字段
@property (nonatomic, copy) NSString *icon;
/// order
@property (nonatomic, copy) NSString *order;
/// 级别
@property (nonatomic, copy) NSString *grade;
/// 子集
@property (nonatomic, strong) NSArray<TNCategoryModel *> *children;
///  名称 如果menuName没值  就取用这个  又是因为其它分类没有国际化字段
@property (nonatomic, strong) NSString *name;
/// 图片 其它分类用的这个字段  懵逼
@property (nonatomic, copy) NSString *logo;
/// 如果是品牌相关的数据  就会带有分类聚合数组  用来筛选品牌列表数据
@property (nonatomic, strong) NSArray<NSString *> *productCategoryIds;
/// 绑定属性  是否点击选中
@property (nonatomic, assign) BOOL isSelected;
/// 绑定属性  临时记录是否已点击选中
@property (nonatomic, assign) BOOL tempIsSelected;
/// 分类设置本地图片   优先级最高 未选中图片
@property (strong, nonatomic) UIImage *unSelectLogoImage;
/// 分类设置本地图片   优先级最高  选中图片
@property (strong, nonatomic) UIImage *selectLogoImage;
/// 图片宽高  默认是50
@property (nonatomic, assign) CGFloat imageWidth;
/// 类目高度  图片 + 文字
@property (nonatomic, assign) CGFloat itemHeight;

/// 商品分类高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 商品分类宽度
@property (nonatomic, assign) CGFloat cellWidth;

///  是否有选中的二级目录
@property (nonatomic, assign) BOOL hasSelectedSecondCategory;
@end

NS_ASSUME_NONNULL_END
