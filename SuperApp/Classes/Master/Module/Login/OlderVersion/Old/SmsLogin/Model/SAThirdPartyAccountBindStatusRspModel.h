//
//  SAThirdPartyAccountBindStatusRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAThirdPartyAccountBindStatusRspModel : SARspModel
/// 是否已绑定
@property (nonatomic, assign) BOOL isBind;
@end

NS_ASSUME_NONNULL_END
