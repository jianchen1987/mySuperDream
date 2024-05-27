//
//  SAWindowManager.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import <UIKit/UIKit.h>

@class SATabBarItemConfig;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HDAfterSignedInToDoEventBlock)(void);

/// 用户登录完成之后需要做的事，用于覆盖自动操作，value 类型为 HDAfterSignedInToDoEventBlock
FOUNDATION_EXPORT NSString *const kSAAfterSignedInToDoEventBlockParamKey;
/// 在由未登录转为已登录时，是否需要禁止跳转到之前欲跳转的界面，默认会自动跳转， value 类型为 BOOL
FOUNDATION_EXPORT NSString *const kSAShouldForbidAutoPerformBeforeSignedInActionParamKey;


@interface SAWindowManager : NSObject

/// 当前根控制器
+ (UIViewController *)rootViewController;

/// 切换到主界面
+ (void)switchWindowToMainTabBarController;

/// 切换到主界面
/// @param completion 动作完成
+ (void)switchWindowToMainTabBarControllerCompletion:(void (^_Nullable)(void))completion;

/// 切换到登录界面
+ (void)switchWindowToLoginViewController;
/// 直接切换到密码登录页面
+ (void)switchWindowToLoginByPasswordViewController;

/// 切换到登录页，并在登录成功后执行回调
/// @param event 登录成功回调
+ (void)switchWindowToLoginViewControllerWithLoginToDoEvent:(void (^_Nullable)(void))event;

/// 切换到登录界面，并执行completion
/// completion会在登录页present时同步执行，需自行处理好延迟问题，在转场动画发生时，拿到的VisiableViewControler并不一定是你想要的
/// @param completion 动作完成
+ (void)switchWindowToLoginViewControllerCompletion:(void (^_Nullable)(void))completion;

/// 切换到登录界面后，再 push 某界面,在登录控制器的Nav push
/// completion会在登录页present时同步执行，需自行处理好延迟问题，在转场动画发生时，拿到的VisiableViewControler并不一定是你想要的
/// @param viewController 要 push 的控制器实例
/// @param completion 动作完成
+ (void)switchWindowToLoginViewControllerToViewController:(UIViewController *_Nullable)viewController completion:(void (^)(void))completion;

/// 从 UITabBarController 当前选中的界面获取指定 class 类型的实例
/// @param tabBarVC UITabBarController 实例
/// @param vcClass 目标控制器 Class
+ (UIViewController *)getControllerInstanceFromTabBarSelectedIndex:(UITabBarController *)tabBarVC forVC:(Class)vcClass;

/**
 导航到指定控制器实例，做了登录前后的处理

 @param viewController 控制器实例
 */
+ (void)navigateToViewController:(UIViewController *)viewController;

/// 导航到指定的控制器实例，并移除队列中指定的类
/// @param viewController 目标控制器
/// @param className 该移除的类名
+ (void)navigateToViewController:(UIViewController *)viewController removeSpecClass:(NSString *_Nullable)className;
/**
 导航到指定控制器类

 @param class 控制器类
 */
+ (void)navigateToViewControllerClass:(Class)class;

/**
 导航到指定控制器类

 @param class 控制器类
 @param parameters 初始化参数
 */
+ (void)navigateToViewControllerClass:(Class)class parameters:(NSDictionary *_Nullable)parameters;

/**
 导航到指定控制器实例

 @param viewController 控制器实例
 @param parameters 传递给控制器实例的参数
 */
+ (void)navigateToViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters;

/// 导航到指定控制器实例，当前导航栏堆栈没有业务线首页就加入业务线首页
/// @param viewController 控制器实例
/// @param parameters 传递给控制器实例的参数
/// @param businessLine 业务线
+ (void)navigateToViewController:(UIViewController *)viewController
                      parameters:(NSDictionary *)parameters
             addBusinessHomePage:(SAClientType)businessLine API_DEPRECATED("内部不再处理业务线首页逻辑，遵循原生交互后进先出", ios(7.0, 10.0));

/**
 present 指定控制器类

 @param class 控制器类
 @param needNavCWrapper 是否需要导航控制器包装
 */
+ (void)presentViewControllerClass:(Class)class needNavCWrapper:(BOOL)needNavCWrapper;

/**
 present指定控制器类

 @param class 控制器类
 @param parameters 初始化参数
 @param needNavCWrapper 是否需要导航控制器包装
 */
+ (void)presentViewControllerClass:(Class)class parameters:(NSDictionary *_Nullable)parameters needNavCWrapper:(BOOL)needNavCWrapper;

/**
present 指定控制器实例（默认有导航栏包装）

@param viewController 控制器实例
@param parameters 传递给控制器实例的参数
*/
+ (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *_Nullable)parameters;

/**
 present指定控制器实例

 @param viewController 控制器实例
 @param parameters 传递给控制器实例的参数
 @param needNavCWrapper 是否需要导航控制器包装
 */
+ (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *_Nullable)parameters needNavCWrapper:(BOOL)needNavCWrapper;

+ (void)navigateToBusinessLineHomePageWithClass:(Class)class;

/**
 打开路由

 @param url 路由地址
 @param parameters 参数（参数也可在url中，此处可传 nil）
 @return 是否成功打开
 */
+ (BOOL)openUrl:(NSString *)url withParameters:(NSDictionary<NSString *, id> *_Nullable)parameters;

/// 是否可以打开路由
/// @param url 路由
+ (BOOL)canOpenURL:(NSString *)url;

/// 当前可见的控制器
+ (UIViewController *)visibleViewController;

/// 活动 window
+ (UIWindow *)keyWindow;

/// 跳转到绑定手机页面
/// @param text 提示文言
/// @param bindSuccessBlock 绑定成功后的回调
/// @param cancelBindBlock 取消绑定的回调
+ (void)navigateToSetPhoneViewControllerWithText:(NSString *)text bindSuccessBlock:(nullable dispatch_block_t)bindSuccessBlock cancelBindBlock:(nullable dispatch_block_t)cancelBindBlock;


@end

NS_ASSUME_NONNULL_END
