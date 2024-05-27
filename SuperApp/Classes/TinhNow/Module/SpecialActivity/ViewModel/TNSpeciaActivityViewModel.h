//
//  TNSpeciaActivityViewModel.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNActivityCardRspModel.h"
#import "TNCategoryModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNRedZoneActivityModel.h"
#import "TNSpeciaActivityDetailModel.h"
#import "TNViewModel.h"
@class SAShoppingAddressModel;

NS_ASSUME_NONNULL_BEGIN

#define kSpecialLeftCategoryWidth kRealWidth(75) //左边分类宽度


@interface TNSpeciaActivityViewModel : TNViewModel
/// 商品专题id
@property (nonatomic, copy) NSString *_Nullable activityId;
/// 分类数据
@property (strong, nonatomic) NSMutableArray<TNCategoryModel *> *categoryArr;
/// 分类以及广告数据刷新标记
@property (nonatomic, assign) BOOL adsAndCategoryRefrehFlag;
/// 砍价专题配置数据
@property (nonatomic, strong) TNSpeciaActivityDetailModel *_Nullable configModel;
/// 广告位数据
@property (strong, nonatomic) TNActivityCardRspModel *activityCardRspModel;
/// 收货地址
@property (strong, nonatomic) SAShoppingAddressModel *addressModel;
/// 红区专题模型
@property (strong, nonatomic) TNRedZoneActivityModel *_Nullable redZoneModel;
/// 专题展示样式（1：样式1, 2：样式2）
@property (nonatomic, assign) TNSpecialStyleType styleType;
/// 漏斗埋点用
@property (nonatomic, copy) NSString *funnel;
/// 专题埋点前缀
@property (nonatomic, copy) NSString *speciaTrackPrefixName;
/// 专题埋点样式参数
@property (nonatomic, copy) NSString *specialTrackStyleParamete;

/// 显示横向商品样式
@property (nonatomic, assign) BOOL showHorizontalStyle;
/// 推荐 目录下所有推荐热销数据源
@property (strong, nonatomic) NSArray<TNGoodsModel *> *recommedHotSalesProductsArr;
/// 推荐 目录下所有推荐数据源
@property (strong, nonatomic) NSArray<TNGoodsModel *> *recommedProductsArr;
/// 记录是否还有下一页   用于切换两个专题样式公用数据的显示
@property (nonatomic, assign) BOOL hasNextPage;
/// 商品列表高度  有tab的时候要特别处理
@property (nonatomic, assign) CGFloat kProductsListViewHeight;
/// 热销标签数组
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *recommendHotTagsArr;
/// 普通列表标签数组
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *recommendNormalTagsArr;

/// 商品专题失效回调
@property (nonatomic, copy) void (^activityFailureCallBack)(void);
/// 网络失败回调
@property (nonatomic, copy) void (^networkFailCallBack)(void);

/// 获取红区专题的专题id专题
- (void)getRedZoneSpecialActivityIdSuccessBlock:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 获取专题配置数据
- (void)getSpecialActivityConfigDataSuccessBlock:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 获取广告以及分类数据
- (void)requestAdsAndCategoryDataCompletion:(void (^)(void))completion;

/// 重置分类选中状态
- (void)resetCategoryDataSelectedState;
///清空缓存数据
- (void)clearCacheData;
/// 通过标签数组获取标签占据的高度
- (CGFloat)getSpecialTagsHeightByTagsArr:(NSArray<TNGoodsTagModel *> *)tagsArr;
/// 获取一个默认 全部 标签按钮
- (TNGoodsTagModel *)getDefaultTagModel;
/// 处理标签选中  以及挪位置  并返回处理后的数组
- (NSArray<TNGoodsTagModel *> *)processSelectedTagByTagId:(NSString *)tagId inTagArr:(NSArray<TNGoodsTagModel *> *)tagsArr;
@end

NS_ASSUME_NONNULL_END
