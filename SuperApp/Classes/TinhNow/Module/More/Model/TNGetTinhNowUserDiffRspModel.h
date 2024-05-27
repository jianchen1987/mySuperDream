//
//  TNGetTinhNowUserDiffRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNGetTinhNowUserDiffRspModel : TNRspModel
/// 是否分销员
@property (nonatomic, assign) BOOL distributor;
/// 是否是卖家
@property (nonatomic, assign) BOOL supplierFlag;
@end

NS_ASSUME_NONNULL_END
