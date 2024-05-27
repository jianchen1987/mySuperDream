#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuionePaySDK : NSObject

/// SDK版本
+ (NSString *)version;

/// 初始化应用ID
/// @param info 在平台注册的ID信息
+ (void)initAppID:(NSString *)info;

/// SDK支付
/// @param orderNo 支付订单号
/// @param scheme 调用支付的app注册在info.plist中的scheme
/// @param failed 无法唤起支付的错误原因信息回调
+ (void)pay:(NSString *)orderNo name:(NSString *)scheme callback:(nullable void (^)(NSString *error))failed;

@end

NS_ASSUME_NONNULL_END
