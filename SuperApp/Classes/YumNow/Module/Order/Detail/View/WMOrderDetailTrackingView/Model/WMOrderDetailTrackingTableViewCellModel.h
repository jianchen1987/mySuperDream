//
//  WMOrderDetailTrackingTableViewCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WMOrderDetailTrackingStatus) {
    WMOrderDetailTrackingStatusCompleted = 0, ///< 已完成
    WMOrderDetailTrackingStatusProcessing,    ///< 进行中
    WMOrderDetailTrackingStatusExpected       ///< 将来
};


@interface WMOrderDetailTrackingTableViewCellModel : WMModel

/// 显示上面线
@property (nonatomic, assign) BOOL showUpLine;
/// 显示下面线
@property (nonatomic, assign) BOOL showDownLine;
/// 下一个节点
@property (nonatomic, assign) BOOL hightNode;
/// 状态
@property (nonatomic, assign) WMOrderDetailTrackingStatus status;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 描述
@property (nonatomic, copy) NSString *desc;

+ (instancetype)modelWithStatus:(WMOrderDetailTrackingStatus)status title:(NSString *)title desc:(NSString *)desc;
@end

NS_ASSUME_NONNULL_END
