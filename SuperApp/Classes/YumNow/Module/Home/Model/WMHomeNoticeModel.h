//
//  WMHomeNoticeModel.h
//  SuperApp
//
//  Created by wmz on 2022/4/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMMessageCode.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHomeNoticeModel : WMModel
/// id
@property (nonatomic, assign) NSInteger id;
/// homeNoticeNo
@property (nonatomic, copy) NSString *homeNoticeNo;
///内容
@property (nonatomic, copy) NSString *content;
///优先级
@property (nonatomic, assign) NSInteger priority;
///是否全天显示
@property (nonatomic, assign) BOOL showHour;
///频率显示
@property (nonatomic, assign) BOOL daily;
///手动关闭
@property (nonatomic, assign) BOOL handClose;
///开始时间
@property (nonatomic, copy) NSString *launchFrom;
///结束时间
@property (nonatomic, copy) NSString *launchTo;
///开始时间
@property (nonatomic, copy) NSString *startTime;
///结束时间
@property (nonatomic, copy) NSString *endTime;
///频率 F001 每天推送一次 F002用户每次下拉首页时显示 F003 用户每次进入首页显示
@property (nonatomic, copy) NSString *frequency;
///通知类型 HNT001 配送量 HNT002 营销类
@property (nonatomic, copy) NSString *homeNoticeType;
/// custom 展示的时间戳
@property (nonatomic, assign) NSTimeInterval showTime;

@end

NS_ASSUME_NONNULL_END
