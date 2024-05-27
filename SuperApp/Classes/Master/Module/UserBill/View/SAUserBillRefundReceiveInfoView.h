//
//  SAUserBillRefundReceiveInfoView.h
//  SuperApp
//
//  Created by seeu on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import <HDUIkit/HDCustomViewActionView.h>

NS_ASSUME_NONNULL_BEGIN

@class SAUserBillRefundReceiveAccountModel;


@interface SAUserBillRefundReceiveInfoView : SAView <HDCustomViewActionViewProtocol>

///< model
@property (nonatomic, strong) SAUserBillRefundReceiveAccountModel *model;

@end

NS_ASSUME_NONNULL_END
