//
//  SACouponFilterDownView.h
//  SuperApp
//
//  Created by Tia on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAOptionModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACouponFilterSectionModel : NSObject
/// section名称
@property (nonatomic, strong) SAInternationalizationModel *title;
/// 选项数组
@property (nonatomic, strong) NSArray *option;

@end


@interface SACouponFilterOptionModel : SAOptionModel
/// 文本宽度
@property (nonatomic) NSInteger width;
/// 排序 10-默认 11-新到 12-快过期 13-面额由大到小 14-面额由小到大
@property (nonatomic) NSInteger orderBy;
/// 券类别 9-全部 10-平台券 11-门店券
@property (nonatomic) NSInteger sceneType;
/// YumNow-外卖, TinhNow-电商, PhoneTopUp-话费充值 GameChannel-游戏频道, HotelChannel-酒店频道
@property (nonatomic, copy) SAClientType businessLine;

@end


@interface SACouponFilterModel : NSObject

@property (nonatomic, strong) SACouponFilterSectionModel *availableRange;

@property (nonatomic, strong) SACouponFilterSectionModel *couponType;

@property (nonatomic, strong) SACouponFilterSectionModel *sort;

@end


@interface SACouponFilterDownView : SAView

/// 是否展开
@property (nonatomic, assign, readonly) BOOL showing;

- (instancetype)initWithStartOffsetY:(CGFloat)offset;

- (void)show;

- (void)dismissCompleted:(void (^__nullable)(void))completed;

/// 点击确认按钮回调
@property (nonatomic, copy) void (^submitBlock)(NSInteger sceneType, SAClientType businessLine, NSInteger orderBy);

@end

NS_ASSUME_NONNULL_END
