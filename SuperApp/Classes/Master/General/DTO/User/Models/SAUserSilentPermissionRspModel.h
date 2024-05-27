//
//  SAUserSilentPermissionRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/9/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUserSilentPermissionRspModel : SARspModel
@property (nonatomic, copy) NSString *accessToken; ///<
@property (nonatomic, copy) NSString *openId;      ///<
@property (nonatomic, copy) NSString *redirectUrl; ///<
@end

NS_ASSUME_NONNULL_END
