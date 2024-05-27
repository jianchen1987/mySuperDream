//
//  TNProductBaseInfoCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNEnum.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductBaseInfoCellModel : NSObject
/// 产品名称
@property (nonatomic, copy) NSString *productName;
/// 是否收藏
@property (nonatomic, assign) BOOL isCollected;
/// 销量格式化展示  < 100 等等
@property (nonatomic, copy) NSString *salesLabel;
/// 商品类型
@property (nonatomic, copy) TNGoodsType type;
/// 全网公告
@property (nonatomic, strong) NSString *announcement;
/// 微店荣耀标识  是否优质卖家
@property (nonatomic, assign) BOOL isHonor;
/// 是否支持混批
@property (nonatomic, assign) BOOL mixWholeSale;
/// 店铺类型
@property (nonatomic, copy) TNStoreType storeType;
///是否已经加入销售
@property (nonatomic, assign) BOOL isJoinSales;
/// 详情显示样式
@property (nonatomic, assign) TNProductDetailViewType detailViewStyle;
/// 收藏点击回调
@property (nonatomic, copy) void (^favoriteClickCallBack)(BOOL isCollected);
/// 加入或者取消销售回调
@property (nonatomic, copy) void (^addOrCancelSalesClickCallBack)(BOOL isAdd);
@end


@interface TNProductBaseInfoCell : SATableViewCell
///
@property (strong, nonatomic) TNProductBaseInfoCellModel *model;
/// 普通分享点击
@property (nonatomic, copy) void (^shareClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
