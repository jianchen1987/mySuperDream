//
//  WMNearbyStoreTagsFilterTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class WMNearbyStoreTagsModel;


@interface WMNearbyStoreTagsFilterTableViewCellModel : NSObject
/// 单元格高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 标签
@property (nonatomic, strong) NSArray<WMNearbyStoreTagsModel *> *dataSource;
@end


@interface WMNearbyStoreTagsFilterTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) WMNearbyStoreTagsFilterTableViewCellModel *model;
/// 选择标签回调
@property (nonatomic, copy) void (^tagAddedHandler)(WMNearbyStoreTagsModel *tag);
/// 删除标签回调
@property (nonatomic, copy) void (^tagDeletedHandler)(WMNearbyStoreTagsModel *tag);
@end

NS_ASSUME_NONNULL_END
