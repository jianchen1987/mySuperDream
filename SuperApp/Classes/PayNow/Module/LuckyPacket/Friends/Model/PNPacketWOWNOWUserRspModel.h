//
//  PNPacketWOWNOWUserRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SACommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketWOWNOWUserInfoModel : PNModel
/// 操作员号
@property (nonatomic, copy) NSString *operatorNo;
/// 登录手机号
@property (nonatomic, copy) NSString *loginName;
/// 昵称
@property (nonatomic, copy) NSString *nickname;
/// 注册时间
@property (nonatomic, copy) NSString *createTime;
@end


@interface PNPacketWOWNOWUserRspModel : SACommonPagingRspModel
@property (nonatomic, strong) NSArray<PNPacketWOWNOWUserInfoModel *> *list;
@end

NS_ASSUME_NONNULL_END
