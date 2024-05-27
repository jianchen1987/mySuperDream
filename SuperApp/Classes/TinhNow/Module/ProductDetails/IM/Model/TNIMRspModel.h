//
//  TNIMRspModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNIMRspModel : TNModel

/// 客服名称
@property (nonatomic, strong) NSString *name;
/// 操作员编号
@property (nonatomic, strong) NSString *operatorNo;
/// 当前状态， 0: 不在线 1: 在线
@property (nonatomic, strong) NSString *state;

@end

NS_ASSUME_NONNULL_END
