//
//  WMStoreProductModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductModel : WMModel
/// code
@property (nonatomic, copy) NSString *code;
/// 商品 id
@property (nonatomic, copy) NSString *productId;
/// 图片路径
@property (nonatomic, copy) NSString *imagePath;
/// 图片路径
@property (nonatomic, copy) NSArray<NSString *> *imagePaths;
/// 菜单 id
@property (nonatomic, copy) NSString *menuId;
/// 名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 价格
@property (nonatomic, strong) SAMoneyModel *price;
/// 售价
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 当前关键词，用于高亮显示处理
@property (nonatomic, copy) NSString *keyWord;
/// 是否是新店
@property (nonatomic, assign) BOOL isNewStore;

@end

NS_ASSUME_NONNULL_END
