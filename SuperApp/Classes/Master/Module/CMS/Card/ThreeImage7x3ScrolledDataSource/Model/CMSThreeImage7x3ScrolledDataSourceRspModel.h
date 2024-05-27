//
//  CMSThreeImage7x3ScrolledDataSourceRspModel.h
//  SuperApp
//
//  Created by Chaos on 2021/7/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CMSThreeImage7x3ItemConfig;


@interface CMSThreeImage7x3ScrolledDataSourceRspModel : SARspModel

/// 标题
@property (nonatomic, copy) NSString *title;
/// 副标题
@property (nonatomic, copy) NSString *subTitle;
/// 副标题链接
@property (nonatomic, copy) NSString *subTitleLink;
/// 节点
@property (nonatomic, strong) NSArray<CMSThreeImage7x3ItemConfig *> *nodes;

@end

NS_ASSUME_NONNULL_END
