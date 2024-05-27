//
//  HDReflushTokenRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/16.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"


@interface HDReflushTokenRspModel : HDJsonRspModel

@property (nonatomic, copy) NSString *sessionKey;
@property (nonatomic, copy) NSString *mobileToken;
@property (nonatomic, copy) NSString *userNo; //刷新时有
@property (nonatomic, copy) NSString *loginName;
@end
