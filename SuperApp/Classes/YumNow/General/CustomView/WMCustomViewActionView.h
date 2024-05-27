//
//  WMCustomViewActionView.h
//  SuperApp
//
//  Created by wmz on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMNormalAlertView.h"
#import <HDUIKit/HDUIKit.h>

typedef void (^WMCustomConfigBlock)(HDCustomViewActionViewConfig *_Nullable config);
typedef void (^WMAlertConfigBlock)(HDAlertViewConfig *_Nullable config);
NS_ASSUME_NONNULL_BEGIN


@interface WMCustomViewActionView : HDCustomViewActionView
///外卖自定义底部弹窗
+ (instancetype)actionViewWithContentView:(UIView<HDCustomViewActionViewProtocol> *)contentView block:(WMCustomConfigBlock)block;
///外卖普通提示弹窗
+ (HDAlertView *)showTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
                   confirm:(nullable NSString *)confirm
                   handler:(HDAlertViewButtonHandler)handler
                    config:(nullable WMAlertConfigBlock)block;
///外卖普通提示弹窗
+ (WMNormalAlertView *)WMAlertWithConfig:(WMNormalAlertConfig *)config;
///外卖普通提示弹窗
+ (WMNormalAlertView *)WMAlertWithContent:(NSString *)content;
///外卖普通提示弹窗
+ (WMNormalAlertView *)WMAlertWithContent:(NSString *)content handle:(nullable WMAlertViewButtonHandler)handle;
@end

NS_ASSUME_NONNULL_END
