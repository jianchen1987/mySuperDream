//
//  TNScrollContentRspModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNScrollContentModel;


@interface TNScrollContentRspModel : TNRspModel
/// 数据源
@property (nonatomic, copy) NSArray<TNScrollContentModel *> *list;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
