//
//  PNNeedInputInviteCodeRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNNeedInputInviteCodeRspModel : PNModel
/**
 status = true &&  inviteCode == '' => 需要弹窗
 status = true &&  inviteCode == 'abc' =>不需要弹窗，但是需要显示 邀请码
 status = false 不需要弹窗 不需要显示邀请码
 */

/// true 需要显示字段  false  不需要
@property (nonatomic, assign) BOOL status;
/// 失败原因
@property (nonatomic, copy) NSString *failMsg;
/// 绑定过的邀请码（为空时需要用户填写）
@property (nonatomic, copy) NSString *inviteCode;
@end

NS_ASSUME_NONNULL_END
