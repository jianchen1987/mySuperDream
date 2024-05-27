//
//  SARecoderView.h
//  SuperApp
//
//  Created by Tia on 2022/8/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SARecorderView : HDActionAlertView

/// 初始化
/// @param title 弹框标题
/// @param subTitle 弹窗副标题
/// @param second 最大录制秒数，最大60秒，建议设置2-60秒之间
/// @param completion 录制回调
- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
         limitMaxRecordSecond:(NSInteger)second
                   completion:(nullable void (^)(BOOL finish, NSString *_Nullable filePath, NSInteger second))completion;

@end

NS_ASSUME_NONNULL_END
