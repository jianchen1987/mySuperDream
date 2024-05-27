//
//  SACMSFloatWindowPluginViewConfig.h
//  SuperApp
//
//  Created by seeu on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSFloatWindowPluginViewConfig : SAModel
///< 图片
@property (nonatomic, copy) NSString *image;
///< 链接
@property (nonatomic, copy) NSString *link;
///< 宽度
@property (nonatomic, assign) CGFloat width;
///< 高度
@property (nonatomic, assign) CGFloat height;
///< 数据源
@property (nonatomic, copy) NSString *dataSource;
@end

NS_ASSUME_NONNULL_END
