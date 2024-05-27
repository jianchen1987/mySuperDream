//
//  SAAddressAutoCompleteItem.h
//  SuperApp
//
//  Created by seeu on 2021/3/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddressAutoCompleteItem : SAModel
@property (nonatomic, copy) NSString *name;    ///< 描述
@property (nonatomic, copy) NSString *placeId; ///< 地点编号
@end

NS_ASSUME_NONNULL_END
