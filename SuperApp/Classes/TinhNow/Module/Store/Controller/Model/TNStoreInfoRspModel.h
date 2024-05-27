//
//  TNStoreInfoRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNActionImageModel;
@class SAInternationalizationModel;

typedef NS_ENUM(NSInteger, TNStoreViewShowType) {
    TNStoreViewShowTypeNormal = 0,      //默认普通的店铺页面
    TNStoreViewShowTypeSellerToAdd = 1, //卖家来选品的店铺页面
    TNStoreViewShowTypeMicroShop = 2,   //用户进入卖家的店铺  微店
};


@interface TNStoreInfoRspModel : TNRspModel

/// 门店no
@property (nonatomic, copy) NSString *storeNo;
/// 门店电话
@property (nonatomic, copy) NSString *phone;
/// 最后修改时间
@property (nonatomic, assign) NSTimeInterval lastModifiedDate;
/// 是否过期
@property (nonatomic, assign) BOOL hasExpired;
/// 创建日期
@property (nonatomic, assign) NSTimeInterval createDate;
/// logo
@property (nonatomic, copy) NSString *logo;
/// 店铺类型（GENERAL 普通，SELF 自营）
@property (nonatomic, copy) TNStoreType storeType;
/// 路径
@property (nonatomic, copy) NSString *path;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 店名
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 是否开启
@property (nonatomic, assign) BOOL isEnable;
/// 是否收藏
@property (nonatomic, assign) BOOL collectFlag;
/// 广告图片
@property (nonatomic, strong) NSArray<TNActionImageModel *> *adImages;
/// 营业开始时间
@property (nonatomic, copy) NSString *businessStartDate;
/// 营业结束时间
@property (nonatomic, copy) NSString *businessEndDate;
/// 门头照
@property (copy, nonatomic) NSString *images;
/// 是否有商家实景数据
@property (nonatomic, assign) BOOL hasStoreLive;
/// 是否显示店铺提示弹窗
@property (nonatomic, assign) BOOL showStoreTips;
/// 店铺提示文案
@property (nonatomic, strong) SAInternationalizationModel *storeTipsLocal;
/// 是否展示购物车
@property (nonatomic, assign) BOOL isQuicklyAddToCart;
/// storeInfo cell高度
@property (nonatomic, assign) CGFloat cellHeight;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;

/// TNStoreIntroductionView 高度
@property (nonatomic, assign) CGFloat storeIntroductionViewHeight;
/*
 * 店铺展示的类型   根据 isFromProductCenter  和 sp 一起来判断   如果都有值  就是TNStoreViewShowTypeSellerToAdd
 * isFromProductCenter  和 sp  都没有值 TNStoreViewShowTypeNormal
 * isFromProductCenter 为false  和 sp 有值  TNStoreViewShowTypeUserToSeller
 */
@property (nonatomic, assign) TNStoreViewShowType storeViewShowType;

/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;
@end

NS_ASSUME_NONNULL_END
