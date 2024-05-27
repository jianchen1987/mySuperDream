//
//  TNProductDetailsRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNImageModel.h"
#import "TNProductActivityModel.h"
#import "TNProductBatchPriceInfoModel.h"
#import "TNProductDetailPublicImg.h"
#import "TNProductOriginalModel.h"
#import "TNProductSaleRegionModel.h"
#import "TNProductServiceModel.h"
#import "TNProductSkuModel.h"
#import "TNProductSpecificationModel.h"
#import "TNProductStoreModel.h"
#import "TNPromotionModel.h"
#import "TNRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailsRspModel : TNRspModel

/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 商品编号
@property (nonatomic, copy) NSString *sn;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 副标题
@property (nonatomic, copy) NSString *caption;
/// 类型
@property (nonatomic, copy) TNGoodsType type;
/// 销售价
@property (nonatomic, strong) SAMoneyModel *price;
/// 成本价
@property (nonatomic, strong) SAMoneyModel *cost;
/// 市场价
@property (nonatomic, strong) SAMoneyModel *marketPrice;
/// 最大佣金
@property (nonatomic, strong) SAMoneyModel *maxCommission;
/// 单位
@property (nonatomic, copy) NSString *unit;
/// 介绍
@property (nonatomic, copy) NSString *introduction;
/// 店铺名
@property (nonatomic, copy) NSString *storeName;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 销量
@property (nonatomic, strong) NSNumber *sales;
/// 商品图片
@property (nonatomic, strong) NSArray<TNImageModel *> *productImages;
/// 收藏标识
@property (nonatomic, assign) BOOL collectFlag;
/// 店铺电话
@property (nonatomic, copy) NSString *storePhone;
/// 分享链接
@property (nonatomic, copy) NSString *shareUrl;
/// skus
@property (nonatomic, strong) NSArray<TNProductSkuModel *> *skus;
/// specs
@property (nonatomic, strong) NSArray<TNProductSpecificationModel *> *specs;
/// 运费说明
@property (nonatomic, copy) NSString *freight;
/// 服务列表
@property (nonatomic, strong) NSArray<NSString *> *service;
/// 服务保障列表
@property (nonatomic, strong) NSArray<TNProductServiceModel *> *servicesGuaranteeList;
/// 运费价格 如果是0  就是包邮 显示freightMessage字段
@property (nonatomic, copy) NSString *freightPrice;
/// 运费文案 显示
@property (nonatomic, copy) NSString *freightMessage;
/// 运费货币单位
@property (nonatomic, strong) NSString *freightCurrency;
/// 营销活动列表
@property (nonatomic, strong) NSArray<TNPromotionModel *> *promotionList;
/// 是否是限购商品
@property (nonatomic, assign) BOOL goodsLimitBuy;
/// 是否可以购买限购商品
@property (nonatomic, assign) BOOL isBuyLimitGood;
/// 最小限购数量
@property (nonatomic, assign) NSInteger minLimit;
/// 最大限购数量
@property (nonatomic, assign) NSInteger maxLimit;
/// 销量格式化展示  < 100 等等
@property (nonatomic, copy) NSString *salesLabel;
/// 自定义字段
/// 折扣  目前的移动端自己计算 超过20%  则有值
@property (nonatomic, copy) NSString *showDisCount;
/// 分销客分享code 用于统计佣金   未有单独的字段返回   需在分享链接里面截取
@property (nonatomic, copy) NSString *shareCode;
/// 店铺信息
@property (nonatomic, strong) TNProductStoreModel *storeProductInfo;
/// 全网公告
@property (nonatomic, strong) NSString *announcement;
/// 购物提示
@property (nonatomic, strong) NSString *purchaseTips;
/// 发货至
@property (nonatomic, strong) TNProductSaleRegionModel *storeRegion;
/// 原始商品信息
@property (nonatomic, strong) TNProductOriginalModel *productSource;
/// 活动信息（砍价，拼团）
@property (nonatomic, strong) NSArray<TNProductActivityModel *> *productActivityList;
/// 商品标签文本  例如  海外购
@property (nonatomic, copy) NSString *labelTxt;
/// 出发地
@property (nonatomic, copy) NSString *departTxt;
/// 国际物流
@property (nonatomic, copy) NSString *interShippingTxt;
/// 目的地
@property (nonatomic, copy) NSString *arriveTxt;
/// 是否显示店铺提示弹窗
@property (nonatomic, assign) BOOL showStoreTips;
/// 视频列表
@property (strong, nonatomic) NSArray<NSString *> *videoList;
/// 海外购运费
@property (nonatomic, copy) NSString *overseaFreightPrice;
/// 是否开启了免邮 1 免邮 0 到付
@property (nonatomic, assign) BOOL freightSetting;
/// 是否可以查看配送区域地图
@property (nonatomic, assign) BOOL canOpenMap;
/// 公共详情图片
@property (strong, nonatomic) TNProductDetailPublicImg *productDetailPublicImgDTO;
/// 供销码
@property (nonatomic, copy) NSString *sp;
/// 店铺类型
@property (nonatomic, copy) TNStoreType storeType;
///是否是卖家
@property (nonatomic, assign) BOOL isSupplier;
///是否已经加入销售
@property (nonatomic, assign) BOOL isJoinSales;
///收益
@property (strong, nonatomic) SAMoneyModel *revenue;
///卖家ID
@property (nonatomic, copy) NSString *supplierId;
///批发价
@property (strong, nonatomic) SAMoneyModel *tradePrice;
///
@property (nonatomic, copy) NSString *productCategoryId;
/// 微店荣耀标识  是否优质卖家
@property (nonatomic, assign) BOOL isHonor;
///阶梯价信息
@property (strong, nonatomic) TNProductBatchPriceInfoModel *batchPriceInfo;
/// 汇率文案
@property (nonatomic, copy) NSString *khrExchangeRate;
/**---------- 砍价  特有的字段 ---------- */
/// 默认最低价（从SKU 里面筛选出来）
@property (nonatomic, strong) SAMoneyModel *lowestPrice;
/// 砍价商品id
@property (nonatomic, strong) NSString *_id;
/// 新客提示语
@property (nonatomic, strong) NSString *registNewTips;
/// 新客提示语 - 带参数变量
@property (nonatomic, strong) NSString *clientNumberMsg;
/// 活动activityId的状态  状态 1:未开始;2:进行中;3:暂停中;4:已结束  ENUM('INIT', 'DOING', 'PAUSED', 'FINISHED', 'SETTLEMENT')
@property (nonatomic, strong) NSString *status;
/// 活动activityId 剩余库存
@property (nonatomic, assign) NSInteger stockNumber;

- (NSString *)getPriceRange;
- (NSNumber *)getMaxStock;
- (TNProductSkuModel *)getSkuModelWithKey:(NSString *)key;
- (BOOL)checkSkuSoldOutWithKey:(NSString *)key;
///设置默认规格数据的sku
- (void)setSpecDefaultSku;
@end

NS_ASSUME_NONNULL_END
