//
//  PNMSBindModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBindModel : PNModel
///
@property (nonatomic, copy) NSString *merchantNo;
///
@property (nonatomic, copy) NSString *merchantName;
///
@property (nonatomic, copy) NSString *bindingMobile;
@end

NS_ASSUME_NONNULL_END
