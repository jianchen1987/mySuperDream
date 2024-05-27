//
//  TNTextFeildAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNTextFeildAlertView : HDActionAlertView
/// 输入 回调
@property (nonatomic, copy) void (^enterValueCallBack)(NSString *valueText);

/// 初始化一个输入弹窗
/// - Parameters:
///   - title: 标题
///   - valueText: 值
///   - placeHold: 占位值
- (instancetype)initAlertWithTitle:(NSString *)title valueText:(NSString *)valueText placeHold:(NSString *)placeHold;
@end

NS_ASSUME_NONNULL_END
