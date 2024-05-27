//
//  HDCheckStandWechatPayResultResp.h
//  SuperApp
//
//  Created by VanJay on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandPayResultResp.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckStandWechatPayResultResp : HDCheckStandPayResultResp
/** 财付通返回给商家的信息 */
@property (nonatomic, copy) NSString *returnKey;
@end

NS_ASSUME_NONNULL_END
