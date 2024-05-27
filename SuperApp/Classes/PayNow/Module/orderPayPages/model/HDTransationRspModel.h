//
//  HDTransationRspModel.h
//  customer
//
//  Created by 帅呆 on 2018/12/24.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDTransationData.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDTransationRspModel : NSObject

@property (nonatomic, copy) NSString *rspCd;
@property (nonatomic, copy) NSString *rspInf;
@property (nonatomic, strong) HDTransationData *data;

//+ (NSDictionary *)modelCustomPropertyMapper;

@end

NS_ASSUME_NONNULL_END
