//
//  PNInterTransferRelationModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferRelationModel : PNModel
/// 关系
@property (nonatomic, copy) NSString *relationType;
/// 关系code
@property (nonatomic, copy) NSString *relationCode;
@end

NS_ASSUME_NONNULL_END
