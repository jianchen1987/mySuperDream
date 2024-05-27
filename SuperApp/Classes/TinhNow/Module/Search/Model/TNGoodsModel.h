//
//  TNGoodsModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNCodingModel.h"
#import "TNImageModel.h"
@class TNProductSkuModel;
@class TNProductSpecificationModel;
@class TNSellerProductModel;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TNGoodsShowCellType) {
    ///单纯显示商品
    TNGoodsShowCellTypeOnlyGoods = 0,
    ///显示商品和店铺
    TNGoodsShowCellTypeGoodsAndStore = 1,
};


@interface TNGoodsModel : TNCodingModel
///// 商品图片
@property (nonatomic, strong) NSArray<TNImageModel *> *productImages;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 门店名
@property (nonatomic, copy) NSString *storeName;
/// 售出数量
@property (nonatomic, strong) NSNumber *sales;
/// 市场价
@property (nonatomic, strong) SAMoneyModel *marketPrice;
/// 商品类型   ES搜索接口直接返回的是 枚举的索引 0 普通商品  1 兑换商品  2 赠品  3 促销活动商品  4 海外购商品
@property (nonatomic, copy) TNGoodsType type;
/// 商品类型  ES 搜索接口通过这个返回
@property (nonatomic, copy) TNGoodsType typeName;
/// 商品价格
@property (nonatomic, strong) SAMoneyModel *price;
/// 商品id
@property (nonatomic, copy) NSString *productId;
///  是否卖光
@property (nonatomic, assign) BOOL isOutOfStock;
/// 商品图片  如果productImages  没有图片数据  可取这里
@property (nonatomic, copy) NSString *thumbnail;
/// 是否是促销商品
@property (nonatomic, assign) BOOL isSale;

/// 商品名称
@property (nonatomic, copy) NSString *productName;
/// 销量格式化展示  < 100 等等
@property (nonatomic, copy) NSString *salesLabel;
/// 是否支持批量
@property (nonatomic, assign) BOOL stagePrice;
/// 店铺类型
@property (nonatomic, assign) TNStoreEnumType storeType;
///  是否热卖
@property (nonatomic, assign) BOOL enabledHotSale;

/** 以下为砍价商品用到字段 */
/// 最大佣金
@property (nonatomic, strong) SAMoneyModel *activityPrice;
/// 商品类型 0 普通 1 助力  2拼团
@property (nonatomic, assign) TNProductType productType;
/// 是否需要新用户
@property (nonatomic, assign) BOOL needNewUser;
/// 活动迎新展示字段
@property (nonatomic, copy) NSString *activityMsg;
/// 库存
@property (nonatomic, assign) NSInteger stock;
/// 活动id
@property (nonatomic, copy) NSString *activityId;
/// 活动库存
@property (nonatomic, assign) NSInteger bargainStock;

/** 以下为cell的配置参数 */
/// 商品显示样式
@property (nonatomic, assign) TNGoodsShowCellType cellType;
/// cell宽度
@property (nonatomic, assign) CGFloat preferredWidth;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// contentEdgeInsets
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
/// 折扣  目前的移动端自己计算
@property (nonatomic, copy) NSString *showDisCount;
/// 售罄本地三语图片地址
@property (nonatomic, copy) NSString *soldOutImageName;
/// 是否显示小购物车
@property (nonatomic, assign) BOOL isNeedShowSmallShopCar;
/// 是否免邮
@property (nonatomic, assign) BOOL freightSetting;
/// 商品名称的富文本
@property (copy, nonatomic) NSMutableAttributedString *productNameAttr;

//转换模型  用于复用 列表页面显示
+ (instancetype)modelWithSellerProductModel:(TNSellerProductModel *)model;
@end

NS_ASSUME_NONNULL_END
