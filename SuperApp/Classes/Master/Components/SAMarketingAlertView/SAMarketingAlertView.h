//
//  SAMarketingAlertView.h
//  SuperApp
//
//  Created by seeu on 2020/11/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 弹窗展示逻辑
typedef NS_ENUM(NSUInteger, SAMarketingAlertShowType) {
    SAMarketingAlertShowTypeOnce = 0,       ///< 只展示一次
    SAMarketingAlertShowTypeOnceInDay = 10, ///< 每天展示一次
    SAMarketingAlertShowTypeAlways = 11,    ///< 一直展示
};

// 图片展示顺序
typedef NS_ENUM(NSUInteger, SAMarketingAlertPicRule) {
    SAMarketingAlertPicRuleRandomness = 10, ///< 随机
    SAMarketingAlertPicRuleOrdered = 11     ///< 按顺序
};

// 弹窗展示时间段
typedef NS_ENUM(NSUInteger, SAMarketingAlertShowTime) {
    SAMarketingAlertShowTimeAllDay = 10,   ///< 任意时间段
    SAMarketingAlertShowTimeFixedTime = 11 ///< 固定时间段
};

@class SAMarketingAlertViewConfig;

@interface SAMarketingAlertItem : SACodingModel
///< 图片地址
@property (nonatomic, copy) NSString *popImage;
///< 跳转地址
@property (nonatomic, copy) NSString *jumpLink;
///< 关联对象
@property (nonatomic, strong) SAMarketingAlertViewConfig *associatedObj;
@end


@interface SAMarketingAlertViewConfig : SACodingModel
@property (nonatomic, copy) NSString *activityId;                    /// 活动id
@property (nonatomic, copy) NSString *popName;                       ///< 弹窗名称
@property (nonatomic, copy) NSString *type;                          ///< 类型 10本地图片  11 网络图片
@property (nonatomic, strong) SAInternationalizationModel *imageUrl; ///< 图片地址
@property (nonatomic, copy) NSString *location;                      ///< 位置 10 首页
@property (nonatomic, strong) SAInternationalizationModel *action;   ///< 跳转路由
@property (nonatomic, copy) NSString *termType;                      ///< 终端类型iOS Android
@property (nonatomic, copy) NSString *version;                       ///< 版本号
@property (nonatomic, assign) NSUInteger closeAfterSec;              ///< 多少秒自动关闭,0 不关闭
//@property (nonatomic, assign) SAMarketingAlertShowType showType;      ///< 展示逻辑
@property (nonatomic, strong) Class showInClass; ///< 弹窗展示Class
///< 结束时间 （ms）
@property (nonatomic, assign) NSUInteger endTime;

///< 英文广告数组
@property (nonatomic, strong) NSArray<SAMarketingAlertItem *> *enImageAndLinkInfos;
@property (nonatomic, strong) NSArray<SAMarketingAlertItem *> *zhImageAndLinkInfos;
@property (nonatomic, strong) NSArray<SAMarketingAlertItem *> *kmImageAndLinkInfos;
///< 图片显示规则
@property (nonatomic, assign) SAMarketingAlertPicRule picShowRule;
///< 展示时间规则
@property (nonatomic, assign) SAMarketingAlertShowTime popTimeType;
///< 显示时间段——开始时间
@property (nonatomic, copy) NSString *popStartTime;
///< 显示时间段——结束时间
@property (nonatomic, copy) NSString *popEndTime;
/// 展示次数
@property (nonatomic, assign) NSInteger showCount;

/// 11=【所有用户】打开APP (已登录状态) 12=【新用户】首次注册登录APP 13=【指定用户群】打开APP (已登录状态) 18=【未注册设备】打开APP（未登录状态） 19=【所有用户】打开APP（未登录状态）
@property (nonatomic, assign) NSInteger openOcacasion;

// 是否可用
- (BOOL)isValidWithLocation:(NSString *)location;
- (BOOL)save;
@end


@interface SAMarketingAlertView : HDActionAlertView

/// 点击图片前回调
@property (nonatomic, copy) void (^willJumpTo)(NSString *adId, NSString *adTitle, NSString *imageUrl, NSString *link);
/// 点击关闭前回调
@property (nonatomic, copy) void (^willClose)(NSString *adId, NSString *adTitle, NSString *imageUrl, NSString *link);

+ (instancetype)alertViewWithConfigs:(NSArray<SAMarketingAlertViewConfig *> *)configs;

@end

NS_ASSUME_NONNULL_END
