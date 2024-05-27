//
//  TNAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//  弹窗  继承自HDAlertView  多一个右上角的退出按钮

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNAlertView : HDAlertView
///  右上角关闭按钮点击回调
@property (nonatomic, copy) void (^closeBtnClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
