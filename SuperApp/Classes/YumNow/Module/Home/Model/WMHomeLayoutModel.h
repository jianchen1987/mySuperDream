//
//  WMHomeLayoutModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMHomeLayoutCongigModel;


@interface WMHomeLayoutModel : WMModel
///标识
@property (nonatomic, strong) WMHomeLayoutType identity;
///排序
@property (nonatomic, assign) NSInteger sort;
///对应class
@property (nonatomic, strong) Class cellClass;
///请求URL
@property (nonatomic, copy) NSString *URL;
///请求参数
@property (nonatomic, strong) NSDictionary *param;
///响应model
@property (nonatomic, copy) NSString *responseClass;
///配置
@property (nonatomic, strong) NSDictionary *config;
///数据源model
@property (nonatomic, strong) id dataSource;
///埋点事件
@property (nonatomic, copy) NSDictionary *event;
/// UIConfig
@property (nonatomic, strong) WMHomeLayoutCongigModel *layoutConfig;
///骨架
@property (nonatomic, assign, getter=isShake) BOOL shake;

#pragma mark - 埋点相关参数
///< 出现时间
@property (nonatomic, assign) NSTimeInterval willDisplayTime;

@end


@interface WMHomeLayoutCongigModel : WMModel
///外边距
@property (nonatomic, assign) UIEdgeInsets outSets;
///内边距
@property (nonatomic, assign) UIEdgeInsets inSets;
/// collectionView的内边距
@property (nonatomic, assign) UIEdgeInsets contenInset;
@end

NS_ASSUME_NONNULL_END
