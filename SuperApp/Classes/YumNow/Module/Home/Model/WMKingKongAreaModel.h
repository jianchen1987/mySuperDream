//
//  WMKingKongAreaModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMKingKongAreaModel : WMRspModel
/// link类型
@property (nonatomic, copy) NSString *linkType;
/// id
@property (nonatomic, assign) NSInteger id;
///图标
@property (nonatomic, copy) NSString *icon;
/// name
@property (nonatomic, copy) NSString *name;
/// link
@property (nonatomic, copy) NSString *link;
///排序
@property (nonatomic, assign) NSInteger sort;

/// 是否大图
@property (nonatomic, assign) BOOL needBig;

@end

NS_ASSUME_NONNULL_END
