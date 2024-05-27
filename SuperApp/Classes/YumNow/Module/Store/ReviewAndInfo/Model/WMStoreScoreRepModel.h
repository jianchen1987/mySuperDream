//
//  WMStoreScoreModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreScoreRepModel : WMRspModel

/// 评分
@property (nonatomic, assign) double score;
/// storeNo
@property (nonatomic, copy) NSString *storeNo;
/// 好评率
@property (nonatomic, assign) double rate;
/// 评论总数
@property (nonatomic, assign) NSInteger num;

@end

NS_ASSUME_NONNULL_END
