//
//  PNOpenWalletReqModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNOpenWalletReqModel : PNModel

/// 用户名
@property (nonatomic, strong) NSString *loginName;
/// 用户编号
@property (nonatomic, strong) NSString *userNo;
/// 加密索引
@property (nonatomic, strong) NSString *index;
/// 支付密码
@property (nonatomic, strong) NSString *pwd;
/// 用户照片
@property (nonatomic, strong) NSString *headUrl;
/// 名字
@property (nonatomic, strong) NSString *firstName;
/// 姓氏
@property (nonatomic, strong) NSString *lastName;
/// 性别：男14，女15
@property (nonatomic, assign) NSInteger sex;
/// 出生日期
@property (nonatomic, strong) NSString *birthday;

@end

NS_ASSUME_NONNULL_END
