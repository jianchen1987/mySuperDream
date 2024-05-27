//
//  TNShoppingCarItemModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SAMoneyModel;
@class TNShoppingCarBatchGoodsModel;


@interface TNShoppingCarItemModel : TNCodingModel
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// sku名称
@property (nonatomic, copy) NSString *goodsSkuName;
/// 商品名称
@property (nonatomic, copy) NSString *goodsName;
/// 商品展示号
@property (nonatomic, copy) NSString *itemDisplayNo;
/// 更新时间
@property (nonatomic, assign) NSTimeInterval updateTime;
/// 图片
@property (nonatomic, copy) NSString *picture;
/// 数量
@property (nonatomic, strong) NSNumber *quantity;
/// skuid
@property (nonatomic, copy) NSString *goodsSkuId;
/// 商品金额
///
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 分享码
@property (nonatomic, copy) NSString *shareCode;
/// 商品可用库存
@property (nonatomic, copy) NSString *availableStock;
/// 属性
@property (nonatomic, copy) NSString *property ;
/// 商品状态
@property (nonatomic, assign) TNStoreItemState goodsState;
/// 商品类型
@property (nonatomic, copy) TNGoodsType productType;
/// 是否开启了免邮 1 免邮 0 到付
@property (nonatomic, assign) BOOL freightSetting;
/// 重量  返回的是 克  需转换成千克
@property (strong, nonatomic) NSNumber *weight;
/// 重量显示带单位
@property (nonatomic, copy) NSString *showWight;
/// 供销码  卖家专有
@property (nonatomic, copy) NSString *sp;

#pragma mark - 绑定属性
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
///  临时选中  批量购物车要用到
@property (nonatomic, assign) BOOL tempSelected;
/// 记录选中状态是否已经被自动设置过
@property (nonatomic, assign) BOOL hasSetSelectedState;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;
/// sku所属的商品模型  方便UI展示处理
@property (strong, nonatomic) TNShoppingCarBatchGoodsModel *goodModel;
/// 绑定属性  是否有下架  失效等  在试算接口会替换
@property (nonatomic, copy) NSString *invalidMsg;
@end

NS_ASSUME_NONNULL_END
