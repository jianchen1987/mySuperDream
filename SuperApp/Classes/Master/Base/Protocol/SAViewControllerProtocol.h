//
//  SAViewControllerProtocol.h
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SAViewControllerShowType) { SAViewControllerShowTypePush = 0, SAViewControllerShowTypePresent };

@protocol SAViewModelProtocol;

@protocol SAViewControllerProtocol <NSObject>

@required

/// 展示类型
- (SAViewControllerShowType)showType;

/// 是否允许被连续 push，默认为否
- (BOOL)allowContinuousBePushed;

/// 是否需要登录，默认 YES
- (BOOL)needLogin;

/// 是否需要设置支付密码，默认为 false，如果此值返回 true，则 needLogin 必须返回 true，否则 SAWindowManager 可能工作不正确
/// 原因：需要支付密码支撑的页面必须要求登录
- (BOOL)needCheckPayPwd;

@optional
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel;
- (void)hd_setupViews;
- (void)hd_bindViewModel;
- (void)hd_getNewData;
- (void)hd_addKeyboardHandler;
- (void)hd_setupNavigation;

/// 重新获取数据最小间隔，默认 10 秒（设为-2则不会再次获取）
@property (nonatomic, assign) NSTimeInterval miniumGetNewDataDuration;

@end

@protocol SAViewControllerRoutableProtocol <NSObject>
@required
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters;
@end
