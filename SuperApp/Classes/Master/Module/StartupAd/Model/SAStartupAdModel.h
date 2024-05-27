//
//  SAStartupAdModel.h
//  SuperApp
//
//  Created by Chaos on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAStartupAdModel : SAModel

/// id
@property (nonatomic, copy) NSString *adNo;
/// 类型
@property (nonatomic, copy) SAStartupAdType mediaType;
/// 图片或视频链接
@property (nonatomic, copy) NSString *url;
/// 跳转链接
@property (nonatomic, copy) NSString *jumpLink;
/// 排序
@property (nonatomic, assign) NSInteger sort;
/// 生效时间
@property (nonatomic, assign) NSTimeInterval adEffectiveTime;
/// 到期时间
@property (nonatomic, assign) NSTimeInterval adExpirationTime;
/// 展示时间（默认5s）
@property (nonatomic, assign) NSUInteger adPlayTime;
/// 投放时间类型：10-每天任意时间、11-每天固定时间段
@property (nonatomic, assign) NSInteger timeType;
/// 投放开始时间段（HH:mm）
@property (nonatomic, copy) NSString *startTimeSlot;
/// 投放结束时间段（HH:mm）
@property (nonatomic, copy) NSString *endTimeSlot;

#pragma mark - 绑定属性
/// 已下载好的图片存储路径（使用时需自己拼接Document目录）
@property (nonatomic, copy) NSString *_Nullable imagePath;
/// 已下载好的视频存储路径（使用时需自己拼接Document目录）
@property (nonatomic, copy) NSString *_Nullable videoPath;
/// 当前广告是否符合展示条件
@property (nonatomic, assign, readonly) BOOL isEligible;
/// 指引文案
@property (nonatomic, copy) NSString *adGuide;
/// 跳转方式：button-按钮触发、shake-摇一摇触发
@property (nonatomic, copy) NSString *jumpType;

@end

NS_ASSUME_NONNULL_END
