//
//  HDPaymentCodeZoomInShowView.h
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAView.h"

typedef NS_ENUM(NSInteger, HDPaymentCodeZoomInShowViewType) {
    HDPaymentCodeZoomInShowViewTypeBarCode = 0, ///< 条形码
    HDPaymentCodeZoomInShowViewTypeQRCode       ///< 二维码
};

NS_ASSUME_NONNULL_BEGIN


@interface HDPaymentCodeZoomInShowView : SAView
@property (nonatomic, copy) void (^dismissCompletionHandler)(void);
@property (nonatomic, assign, readonly) BOOL isShowing;

- (instancetype)initWithType:(HDPaymentCodeZoomInShowViewType)type codeImageView:(UIImageView *)codeImageView contentStr:(NSString *)contentStr;
- (void)showCompletion:(void (^__nullable)(void))completion;
- (void)dismiss;

- (void)updateCodeImage:(UIImage *)image contentStr:(NSString *)contentStr type:(HDPaymentCodeZoomInShowViewType)type;
@end

NS_ASSUME_NONNULL_END
