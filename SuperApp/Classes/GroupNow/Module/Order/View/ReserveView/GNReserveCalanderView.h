//
//  GNReserveCalanderView.h
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveRspModel.h"
#import "GNView.h"
#import "NSDate+GNCalanderDate.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class GNReserveCalanderModel;


@interface GNReserveCalanderView : GNView
///营业时间-天
@property (nonatomic, copy) NSArray<NSString *> *businessDay;
///选中model
@property (nonatomic, strong, nullable) GNReserveCalanderModel *selectModel;

@end


@interface GNReserveCalanderCell : SACollectionViewCell
/// label
@property (nonatomic, strong) HDLabel *label;
///背景视图
@property (nonatomic, strong) UIView *bgView;
///圆点
@property (nonatomic, strong) UIView *circleView;

@end


@interface GNReserveCalanderModel : NSObject
/// 显示圆点
@property (nonatomic, assign) BOOL wShowCircle;
/// 圆点颜色
@property (nonatomic, strong) UIColor *wCircleColor;
/// 是当前月份 上个月的数据
@property (nonatomic, assign) BOOL wLastMonth;
/// 是当前月份 下个月的数据
@property (nonatomic, assign) BOOL wNextMonth;
/// 选中
@property (nonatomic, assign) BOOL wSelected;
/// 不可选
@property (nonatomic, assign) BOOL wUnEnable;
/// 是今天
@property (nonatomic, assign) BOOL wToday;
/// 坐标
@property (nonatomic, assign) NSInteger wIndex;
/// 日期
@property (nonatomic, strong) NSDate *wDate;
/// 年
@property (nonatomic, assign) NSInteger wYear;
/// 月
@property (nonatomic, assign) NSInteger wMonth;
/// 日
@property (nonatomic, assign) NSInteger wDay;
/// 周
@property (nonatomic, copy) NSString *wWeek;

@property (nonatomic, assign) BOOL firstModel;

@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, assign) NSTimeInterval dateTime;

@property (nonatomic, assign) BOOL lastModel;
/// 在最大最小范围内
@property (nonatomic, assign) BOOL wInRange;

@end

NS_ASSUME_NONNULL_END
