//
//  Target_YumNow.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HDKitCore/HDMediator.h>

NS_ASSUME_NONNULL_BEGIN

/// 这个类是调度器 HDMediator 自动调度
/// 理论上，一条业务线一个 target 就够了
/// 这是外卖业务线的调度类
@interface _Target (YumNow) : NSObject

@end

NS_ASSUME_NONNULL_END
