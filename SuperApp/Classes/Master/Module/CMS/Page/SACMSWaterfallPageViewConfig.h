//
//  SACMSWaterfailPageViewConfig.h
//  SuperApp
//
//  Created by seeu on 2022/2/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSWaterfallPageViewConfig : SAModel
///< 分类标题数据源
@property (nonatomic, copy) NSString *categoryDataSource;
///< 分类标题选中颜色
@property (nonatomic, copy) NSString *categoryColor;
///< 分类标题字体
@property (nonatomic, assign) NSUInteger categoryFont;
///< 分类标题默认颜色
@property (nonatomic, copy) NSString *categoryDefaultColor;
///< 分类标题选中颜色
@property (nonatomic, copy) NSString *categoryBottomLineColor;
///< 瀑布流数据源
@property (nonatomic, copy) NSString *waterfallDataSource;
///< 瀑布流单元样式
@property (nonatomic, assign) NSUInteger waterfallCellType;
///< 瀑布流默认参数
@property (nonatomic, copy) NSString *waterfallDefaultParams;

@end

NS_ASSUME_NONNULL_END
