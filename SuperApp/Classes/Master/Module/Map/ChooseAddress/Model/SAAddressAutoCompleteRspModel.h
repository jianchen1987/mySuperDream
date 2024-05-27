//
//  SAAddressAutoCompleteRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/3/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddressAutoCompleteItem.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddressAutoCompleteRspModel : SAModel
@property (nonatomic, strong) NSArray<SAAddressAutoCompleteItem *> *results; ///< 模糊查询结果
@property (nonatomic, copy) NSString *status;                                ///< 返回码
@end

NS_ASSUME_NONNULL_END
