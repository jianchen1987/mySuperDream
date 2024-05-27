//
//  SAWechatPayRequestModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWechatPayRequestModel.h"


@interface SAWechatPayRequestModel ()
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, assign) UInt32 timestamp;
@property (nonatomic, copy) NSString *sign;
@end


@implementation SAWechatPayRequestModel
@end
