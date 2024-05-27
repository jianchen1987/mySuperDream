//
//  TNTermsAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  海外购协议 查看更多弹窗

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNTermsAlertView : HDActionAlertView
+ (instancetype)alertViewWithContentText:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
