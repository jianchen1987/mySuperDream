//
//  SALoginByPasswordRightView.h
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SALoginByPasswordRightView : SAView
/// 点击眼睛按钮
@property (nonatomic, copy) void (^showPlainPwdButtonClickedHandler)(UIButton *);

- (CGSize)layoutImmediately;

@end

NS_ASSUME_NONNULL_END
