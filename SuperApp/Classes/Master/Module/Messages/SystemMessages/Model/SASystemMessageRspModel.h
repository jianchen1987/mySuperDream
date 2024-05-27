//
//  SASystemMessageRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "SASystemMessageModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASystemMessageRspModel : SACommonPagingRspModel
/// 列表
@property (nonatomic, copy) NSArray<SASystemMessageModel *> *list;
@end

NS_ASSUME_NONNULL_END
