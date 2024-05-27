//
//  WMStoreInfoViewModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMViewModel.h"

@class SAInfoViewModel, WMStoreDetailRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreInfoViewModel : WMViewModel

/// 数据源
@property (nonatomic, strong) WMStoreDetailRspModel *repModel;
/// 商店id
@property (nonatomic, copy) NSString *storeNo;
/// 头像
@property (nonatomic, copy, readonly) NSString *iconUrl;
/// 店名
@property (nonatomic, copy, readonly) NSString *name;
/// 评分
@property (nonatomic, strong, readonly) NSAttributedString *reviewsDesc;
/// discountAndDelievry
@property (nonatomic, copy, readonly) NSAttributedString *discountAndDelievry;
/// 时间
@property (nonatomic, copy, readonly) NSString *distanceAndTimeStr;
/// delivery
@property (nonatomic, copy, readonly) NSString *delivery;
/// 公告
@property (nonatomic, copy, readonly) NSString *notice;
/// 营业时间
@property (nonatomic, copy, readonly) NSString *businessHours;
/// 特色
@property (nonatomic, copy, readonly) NSString *cusines;
/// 图片数组
@property (nonatomic, strong, readonly) NSArray *pictureArray;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 纬度
@property (nonatomic, strong) NSNumber *latitude;
/// 精度
@property (nonatomic, strong) NSNumber *longitude;
/// 支付方式
@property (nonatomic, copy) NSString *payMethod;

/// 配置评分显示
/// @param image 图标
/// @param font font
/// @param color color
- (instancetype)initWithImage:(NSString *)image font:(UIFont *)font textColor:(UIColor *)color startColor:(UIColor *)startColor;

/// 获取门店详情
- (void)getStoreDetialinfo;

- (NSString *)transformDay;
@end

NS_ASSUME_NONNULL_END
