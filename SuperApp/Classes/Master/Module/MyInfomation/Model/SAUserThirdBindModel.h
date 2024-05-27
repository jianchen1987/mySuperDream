//
//  SAUserThirdBindModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUserThirdBindModel : SAModel
/// 第三方绑定用户名
@property (nonatomic, copy) NSString *thirdUserName;
/// 渠道
@property (nonatomic, copy) SAThirdPartyBindChannel channel;
@end

NS_ASSUME_NONNULL_END
