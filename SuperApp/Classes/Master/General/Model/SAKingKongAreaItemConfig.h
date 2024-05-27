//
//  SAKingKongAreaItemConfig.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAHomeDynamicAppState) {
    SAHomeDynamicAppStateKnown = 0,
    SAHomeDynamicAppStateOpen = 10, ///< 上线
    SAHomeDynamicAppStateClose = 11 ///< 下线
};

typedef NS_ENUM(NSUInteger, SAHomeDynamicAppCornerIconStyle) { SAHomeDynamicAppCornerIconStyle1 = 1, SAHomeDynamicAppCornerIconStyle2 = 2, SAHomeDynamicAppCornerIconStyle3 = 3 };

typedef NS_ENUM(NSUInteger, SAHomeDynamicShowType) {
    SAHomeDynamicShowTypeOne = 11, ///< 占两列
    SAHomeDynamicShowTypeTwo = 10, ///< 占一列
};


@interface SAKingKongAreaItemConfig : SAModel
@property (nonatomic, assign) NSTimeInterval cornerIconStartTime;              ///< 角标开始时间
@property (nonatomic, assign) NSTimeInterval cornerIconEndTime;                ///< 角标结束时间
@property (nonatomic, strong) SAInternationalizationModel *name;               ///< 功能名称
@property (nonatomic, strong) SAInternationalizationModel *guideDesc;          ///< 功能引导
@property (nonatomic, copy) NSString *iconURL;                                 ///< 图标url
@property (nonatomic, assign) SAHomeDynamicAppCornerIconStyle cornerIconStyle; ///< 角标样式
@property (nonatomic, copy) NSString *url;                                     ///< 跳转url
@property (nonatomic, copy) NSString *identifier;                              ///< 唯一标识
@property (nonatomic, assign) NSInteger index;                                 ///< 排序序号
@property (nonatomic, assign) SAHomeDynamicAppState cornerIconState;           ///< 角标状态
@property (nonatomic, copy) NSString *cornerIconText;                          ///< 角标文本
@property (nonatomic, assign) NSInteger funcGuideVersion;                      ///< 功能引导版本号
@property (nonatomic, assign) BOOL hasUpdated;                                 ///< 是否更新了
@property (nonatomic, assign) BOOL hasDisplayedNewFunctionGuide;               ///< 是否已经显示过新功能
/// 显示类型
@property (nonatomic, assign) SAHomeDynamicShowType type;
@end

NS_ASSUME_NONNULL_END
