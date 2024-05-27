//
//  TNSellerProductModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerProductModel : TNModel
@property (nonatomic, copy) NSString *productId;         ///<商品ID
@property (nonatomic, copy) NSString *sn;                ///<商品编号
@property (nonatomic, copy) TNGoodsType productType;     ///<商品枚举字符串
@property (nonatomic, copy) NSString *thumbnail;         ///<商品图片
@property (nonatomic, copy) NSString *productName;       ///<商品名称
@property (nonatomic, copy) NSString *storeName;         ///<店铺名称
@property (nonatomic, copy) NSString *logo;              ///<店铺图片
@property (nonatomic, copy) NSNumber *sales;             ///<销量
@property (strong, nonatomic) SAMoneyModel *price;       ///<销售价
@property (strong, nonatomic) SAMoneyModel *bulkPrice;   ///<批发价
@property (strong, nonatomic) SAMoneyModel *profit;      ///<收益
@property (nonatomic, strong) SAMoneyModel *marketPrice; ///<  市场价
@property (nonatomic, assign) BOOL sale;                 ///< 是否加入销售
@property (nonatomic, copy) NSString *categoryId;        ///<商品所在三级分类id
@property (nonatomic, assign) BOOL freightSetting;       ///< 是否免邮
@property (nonatomic, copy) NSString *showDisCount;      ///< 折扣  目前的移动端自己计算
@property (nonatomic, assign) BOOL promotion;            //是否促销
@property (nonatomic, copy) NSString *storeId;           //店铺id
@property (nonatomic, copy) NSString *storeNo;           //店铺id
@property (nonatomic, assign) BOOL isSelected;           ///< 绑定属性 自用
@property (nonatomic, copy) TNGoodsType typeName;        ///<商品枚举字符串
@property (nonatomic, assign) BOOL stagePrice;           ///< 阶梯价
@property (nonatomic, copy) NSString *salesLabel;        /// 销量格式化展示  < 100 等等
/// 店铺类型
@property (nonatomic, assign) TNStoreEnumType storeType;
///  是否热卖
@property (nonatomic, assign) BOOL enabledHotSale;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;          //选品列表
@property (nonatomic, assign) CGFloat microShopCellHeight; //微店列表
///
@property (nonatomic, assign) CGFloat microShopContentStackHeight; ///微店列表 容器高度
@end

NS_ASSUME_NONNULL_END
