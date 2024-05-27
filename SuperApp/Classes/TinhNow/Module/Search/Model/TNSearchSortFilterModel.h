//
//  TNSearchSortFilterModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"
#import "TNFilterEnum.h"

NS_ASSUME_NONNULL_BEGIN

//微店搜索视角类型
typedef NS_ENUM(NSInteger, TNMicroShopProductSearchType) {
    TNMicroShopProductSearchTypeNone = 0,   //默认  不搜微店数据
    TNMicroShopProductSearchTypeSeller = 1, //卖家
    TNMicroShopProductSearchTypeUser = 2    //用户
};


@interface TNSearchSortFilterModel : TNCodingModel
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 分类号
@property (nonatomic, copy) NSString *categoryId;
/// 分类名称
@property (nonatomic, copy) NSString *categoryName;
/// 关键词
@property (nonatomic, copy) NSString *keyWord;
///  品牌id
@property (nonatomic, copy) NSString *brandId;
/// 品牌下可选分类号
@property (nonatomic, strong) NSArray *categoryIds;
/// 排序
@property (nonatomic, copy) TNGoodsListSortType sortType;
/// 商品类型
@property (nonatomic, assign) TNProductType productType;
/// 专题id   用于搜索专题列表数据
@property (nonatomic, copy) NSString *specialId;
/// 筛选
@property (nonatomic, strong) NSMutableDictionary<TNSearchFilterOptions, NSObject *> *filter;
/// 是否需要拉取标签数据
@property (nonatomic, assign) BOOL rtnLabel;
/// 热卖商品标签id
@property (nonatomic, copy) NSString *hotLableId;
/// 商品标签id
@property (nonatomic, copy) NSString *labelId;
///供销商ID
@property (nonatomic, copy) NSString *sp;
/// 视角类型(1:卖家,2:用户)
@property (nonatomic, assign) TNMicroShopProductSearchType searchType;
@end

NS_ASSUME_NONNULL_END
