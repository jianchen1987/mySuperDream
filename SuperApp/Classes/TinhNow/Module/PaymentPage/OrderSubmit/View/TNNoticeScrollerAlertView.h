//
//  TNNoticeScrollerView.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  订单提示弹窗

#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNNoticeScrollerAlertView : HDActionAlertView
+ (instancetype)alertViewWithContentText:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
