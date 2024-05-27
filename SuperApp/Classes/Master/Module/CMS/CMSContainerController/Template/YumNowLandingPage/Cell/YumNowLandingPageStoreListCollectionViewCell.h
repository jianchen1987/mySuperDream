//
//  YumNowLandingPageStoreListCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2023/12/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "SAYumNowLandingPageCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@class YumNowLandingPageStoreListCollectionViewCellModel;
@class SAAddressModel;

@interface YumNowLandingPageStoreListCollectionViewCell : SACollectionViewCell
/// 筛选框要出来了，上层做对应处理
@property(nonatomic, copy) void (^filterViewWillAppear)(UIView *filterView);
/// 点击回调
@property(nonatomic, copy) void (^clickOnCategoryHandler)(SAYumNowLandingPageCategoryModel *selectedModel);
///< model
@property (nonatomic, strong) YumNowLandingPageStoreListCollectionViewCellModel *model;
@end

@interface YumNowLandingPageStoreListCollectionViewCellModel : NSObject
///< 分类颜色
@property (nonatomic, copy) NSString *categoryColor;
///< 分类默认颜色
@property (nonatomic, copy) NSString *categoryDefaultColor;
///< 下划线颜色
@property (nonatomic, copy) NSString *categoryBottomLineColor;
///< 字体大象
@property (nonatomic, assign) NSUInteger categoryFont;
///< 数据地址
@property (nonatomic, copy) NSString *dataSourcePath;
///< 默认请求参数
@property (nonatomic, copy) NSString *defaultParams;
///< 当前地址
@property (nonatomic, strong) SAAddressModel *address;
///< 展示样式
@property (nonatomic, assign) YumNowLandingPageCategoryStyle showLabel;
///< 是否展示筛选
@property (nonatomic, assign) BOOL sortFilter;
///< 门店卡片展示样式
@property (nonatomic, copy) YumNowLandingPageStoreCardStyle storeLogoShowType;
///< 数据
@property (nonatomic, strong) NSArray<SAYumNowLandingPageCategoryModel *> *categoryModels;



@end

NS_ASSUME_NONNULL_END
