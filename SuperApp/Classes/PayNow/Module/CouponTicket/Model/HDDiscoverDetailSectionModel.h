//
//  HDDiscoverDetailSectionModel.h
//  customer
//
//  Created by VanJay on 2019/4/17.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"
@class HDDiscoverDetailTableViewSectionHeaderModel;

NS_ASSUME_NONNULL_BEGIN


@interface HDDiscoverDetailSectionModel : SAModel
@property (nonatomic, strong) HDDiscoverDetailTableViewSectionHeaderModel *headerModel; ///< 标题配置
@property (nonatomic, copy) NSArray *list;                                              ///< 对应 section 列表
@property (nonatomic, copy) NSString *relatedCellClass;                                 ///< 对应的 cell Class 名
@property (nonatomic, copy) NSString *relatedHeaderClass;                               ///< 对应的 header Class 名
@property (nonatomic, copy) NSString *relatedFoorderClass;                              ///< 对应的 header Class 名

@end

NS_ASSUME_NONNULL_END
