//
//  TNBargainViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressModel.h"
#import "TNBargainDetailModel.h"
#import "TNBargainGoodModel.h"
#import "TNBargainPageConfig.h"
#import "TNBargainPeopleRecordRspModel.h"
#import "TNBargainRecordModel.h"
#import "TNBargainRuleModel.h"
#import "TNBargainSuccessModel.h"
#import "TNCreateBargainTaskModel.h"
#import "TNHomeCategoryModel.h"
#import "TNProductDetailsRspModel.h"
#import "TNSpeciaActivityDetailModel.h"
#import "TNViewModel.h"
#import "TNCheckRegionModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainViewModel : TNViewModel

/// 正在进行中的任务
@property (strong, nonatomic) NSArray<TNBargainRecordModel *> *records;
/// 广告图
@property (nonatomic, copy) NSString *banner;

/// 是否显示展示 正在进行中的任务 加载更多
@property (nonatomic, assign) BOOL isShowExtendOngoingTask;
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否还有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;
/// 分类数据
@property (strong, nonatomic) NSMutableArray<TNHomeCategoryModel *> *categoryArr;
/// 砍价列表数据源  根据id 对应数据
@property (strong, nonatomic) NSMutableDictionary<NSString *, TNBargainPageConfig *> *goodsDic;

//选取规格的数据
/// 选择的地址数据
@property (nonatomic, strong) SAShoppingAddressModel *__nullable addressModel;
/// 商品规格模型
@property (strong, nonatomic) TNProductDetailsRspModel *__nullable skuModel;
/// 商品规格里面的商品数据
@property (strong, nonatomic) TNBargainGoodModel *__nullable goodModel;
/// 选中的sku
@property (strong, nonatomic) TNProductSkuModel *__nullable selectedSku;
/// 我的助力列表相关
@property (strong, nonatomic) NSMutableArray<TNBargainRecordModel *> *myRecords;
/// 助力详情数据
@property (strong, nonatomic) TNBargainDetailModel *detailModel;
/// 邀人攻略
@property (strong, nonatomic) TNBargainRuleModel *ruleModel;
/// 助力详情  助力记录数据源
@property (strong, nonatomic) TNBargainPeopleRecordRspModel *recordRspModel;
/// 请求失败回调
@property (nonatomic, copy) void (^queryFailureCallBack)(void);

///砍价专题配置数据
@property (nonatomic, strong) TNSpeciaActivityDetailModel *configModel;
/// 获取最新的砍价首页推荐和banner图数据
- (void)getBargainListIndexNewDataCompletion:(void (^)(BOOL isSuccess))completion;
/// 获取砍价列表推荐更多数据
- (void)loadBargainListIndexMoreDataCompletion:(void (^)(BOOL isSuccess))completion;
///获取正在进行中的列表数据
- (void)getUnderwayTaskDataCompletion:(void (^)(void))completion;
///获取商品规格和收货地址
- (void)getGoodSkuSpecAndAdressByActivityId:(NSString *)activityId completion:(void (^)(void))completion;
///清除选规格的数据源
- (void)clearChooseGoodSpecData;
///创建助力任务
- (void)createBargainTaskWithModel:(TNCreateBargainTaskModel *)taskModel completion:(void (^)(NSString *taskId))completion failure:(CMNetworkFailureBlock)failureBlock;
///获取最新的我的助力记录数据
- (void)getMyRecordNewData;
///获取更多的助力记录
- (void)loadMyRecordMoreData;
///获取助力详情  pageType  1-助力详情,2-帮助好友助力页面
- (void)getBargainDetailDataWithTaskId:(NSString *)taskId pageType:(NSInteger)pageType;
///获取助力成功的任务列表  展示用
- (void)getSucessTaskListCompletion:(void (^)(NSArray<TNBargainSuccessModel *> *sucessTaskList))completion;
/// 创建助力任务的参数模型
- (TNCreateBargainTaskModel *)createBargainTaskModel;
/// 开启详情任务的定时器
- (void)startBargainDetailTimer;
/// 关闭详情任务的定时器
- (void)cancelBargainDetailTimer;
/// 帮砍一刀
- (void)helpBargainCompletion:(void (^)(BOOL isSuccess))completion;
/// 获取砍价分类数据
- (void)getBargainCategoryDataByScene:(TNProductCategoryScene)scene souceId:(NSString *)sourceId completion:(void (^)(void))completion;
/// 获取砍价列表
- (void)getCategoryBargainListByCategoryModel:(TNHomeCategoryModel *)model completion:(void (^)(BOOL isSuccess))completion;
/// 检查是否在配送范围内
- (void)checkRegion:(void (^)(TNCheckRegionModel *))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 获取砍价专题配置数据  banner  标题  分享url
- (void)getBargainActivityConfigDataByActivityId:(NSString *)activityId successBlock:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 获取砍价专题列表数据
- (void)getCategoryBargainActivityListByActivityId:(NSString *)activityId categoryModel:(TNHomeCategoryModel *)model completion:(void (^)(BOOL isSuccess))completion;
@end
NS_ASSUME_NONNULL_END
