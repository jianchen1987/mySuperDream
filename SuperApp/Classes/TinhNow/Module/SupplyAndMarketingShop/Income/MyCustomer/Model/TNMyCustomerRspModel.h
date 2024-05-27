//
//  TNMyCustomerRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNPagingRspModel.h"

@class TNMyCustomerModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNMyCustomerRspModel : TNPagingRspModel

@property (strong, nonatomic) NSArray<TNMyCustomerModel *> *list;

@end


@interface TNMyCustomerModel : TNModel

/// 用户头像
@property (nonatomic, strong) NSString *imgUrl;

/// 昵称
@property (nonatomic, strong) NSString *nickname;

/// 手机号
@property (nonatomic, strong) NSString *mobile;

/// 下单绑定时间
@property (nonatomic, strong) NSString *bindTime;

@end

NS_ASSUME_NONNULL_END
