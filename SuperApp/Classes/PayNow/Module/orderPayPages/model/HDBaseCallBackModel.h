//
//  HDBaseCallBackModel.h
//  customer
//
//  Created by 帅呆 on 2018/12/24.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDTransationRspModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDBaseCallBackModel : NSObject

@property (nonatomic, copy) NSString *resultStatus;
@property (nonatomic, strong) HDTransationRspModel *result;

@end

NS_ASSUME_NONNULL_END
