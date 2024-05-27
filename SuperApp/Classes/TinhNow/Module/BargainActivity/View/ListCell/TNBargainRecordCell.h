//
//  TNBargainRecordCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNBargainRecordModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainRecordCellModel : NSObject

@end


@interface TNBargainRecordCell : SATableViewCell <HDSkeletonLayerLayoutProtocol>
/// 助力记录数据源
@property (strong, nonatomic) TNBargainRecordModel *model;
/// 点击订单详情回调
@property (nonatomic, copy) void (^orderDetailClickCallBack)(void);
/// 是否需要隐藏 分割线
@property (nonatomic, assign) BOOL hiddeBottomLine;
@end

NS_ASSUME_NONNULL_END
