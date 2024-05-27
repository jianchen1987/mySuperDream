#import <Foundation/Foundation.h>
#import <HDKitCore/HDMediator.h>

NS_ASSUME_NONNULL_BEGIN

/// 这个类是调度器 HDMediator 自动调度
/// 理论上，一条业务线一个 target 就够了
/// 这是支付业务线的调度类
@interface _Target (PayNow) : NSObject


@end

NS_ASSUME_NONNULL_END
