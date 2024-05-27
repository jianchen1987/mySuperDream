//
//  WMWindowIconModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class SAInternationalizationModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAWindowItemModel : WMModel

/// 图片
@property (nonatomic, copy) NSString *bannerUrl;
/// 事件
@property (nonatomic, copy) NSString *jumpLink;
/// 名称
@property (nonatomic, copy) NSString *bannerName;
/// 排序
@property (nonatomic, assign) NSUInteger sort;
/// 广告编号
@property (nonatomic, copy) NSString *bannerNo;
/// 角标
@property (nonatomic, assign) NSUInteger badge;
/// 记录编号
@property (nonatomic, copy) NSString *detailId; ///<

@property (nonatomic, copy) NSString *recordName;              ///< 埋点名称
@property (nonatomic, assign) SAWindowLocation windowLocation; ///< 广告位置
/// index
@property (nonatomic, assign) NSUInteger indexForRecord; ///< 序号

@end

NS_ASSUME_NONNULL_END
