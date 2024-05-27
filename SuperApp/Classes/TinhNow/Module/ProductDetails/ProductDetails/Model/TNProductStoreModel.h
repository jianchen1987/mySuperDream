//
//  TNProductStoreModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductStoreModel : TNModel
/// 店铺id
@property (nonatomic, strong) NSString *storeId;
/// 店铺名称
@property (nonatomic, strong) NSString *name;
/// 店铺电话
@property (nonatomic, strong) NSString *phone;
/// 店铺是否已过期
@property (nonatomic, assign) BOOL hasExpired;
/// 是否启用
@property (nonatomic, assign) BOOL isEnabled;
/// 经度
@property (nonatomic, assign) CLLocationDegrees longitude;
/// 纬度
@property (nonatomic, assign) CLLocationDegrees latitude;
/// 路径
@property (nonatomic, strong) NSString *path;
/// 店铺logo
@property (nonatomic, strong) NSString *logo;
/// 地址
@property (nonatomic, strong) NSString *address;
/// 商品数
@property (nonatomic, assign) NSInteger productCount;
/// 店铺评分
@property (nonatomic, assign) double storeScore;
/// 店铺评价
@property (nonatomic, strong) NSString *storeEvaluate;
/// 店铺类型标签
@property (nonatomic, copy) NSString *storeLabelTxt;
/// 店铺提示文案
@property (nonatomic, copy) NSString *storeTips;
/// 进店逛逛 跳转链接  0：店铺主页; 1： 自定义
@property (nonatomic, assign) NSInteger walkLink;
/// 当店铺设置【进店逛逛】跳转为自定义时，app 路由跳转的地址 当 walkLink 为 1 时不能为空长度不超过 255
@property (nonatomic, copy) NSString *walkLinkApp;
@end

NS_ASSUME_NONNULL_END
