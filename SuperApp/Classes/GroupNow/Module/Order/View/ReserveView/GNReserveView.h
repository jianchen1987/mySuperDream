//
//  GNReserveView.h
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveRspModel.h"
#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNReserveView : GNView
@property (nonatomic, copy) void (^callback)(GNReserveRspModel *_Nullable rspModel);
@end

NS_ASSUME_NONNULL_END
