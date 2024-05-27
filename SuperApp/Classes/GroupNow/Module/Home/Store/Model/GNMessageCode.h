//
//  GNMessageCode.h
//  SuperApp
//
//  Created by wmz on 2021/6/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNMessageCode : GNModel

/// message
@property (nonatomic, copy) NSString *message;
/// codeId
@property (nonatomic, copy) NSString *codeId;

@end


@interface GeoPointDTO : GNModel
/// lon
@property (nonatomic, copy) NSString *lon;
/// lat
@property (nonatomic, copy) NSString *lat;

@end

NS_ASSUME_NONNULL_END
