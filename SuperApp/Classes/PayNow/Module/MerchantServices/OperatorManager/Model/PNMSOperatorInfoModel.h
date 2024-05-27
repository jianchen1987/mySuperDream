//
//  PNMSOperatorInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPermissionModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOperatorInfoModel : PNMSPermissionModel
@property (nonatomic, copy) NSString *operatorUserId;
@property (nonatomic, copy) NSString *operatorMobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *accountNo;
@property (nonatomic, copy) NSString *userName;

@end

NS_ASSUME_NONNULL_END
