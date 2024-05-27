//
//  HDUserRegisterRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/2.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"


@interface HDUserRegisterRspModel : HDJsonRspModel
@property (nonatomic, copy) NSString *customerNo;
@property (nonatomic, copy) NSString *userNo;
@property (nonatomic, copy) NSString *sessionKey;
@property (nonatomic, copy) NSString *mobileToken;

@property (nonatomic, copy) NSString *accountNo;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) BOOL tradePwdExist;
@property (nonatomic, assign) BOOL loginPwdExist;

@property (nonatomic, assign) PNUserLevel accountLevel;
@property (nonatomic, assign) PNAuthenStatus authStatus;
@property (nonatomic, assign) BOOL regStatus; ///< 是否注册,true 是

@end
