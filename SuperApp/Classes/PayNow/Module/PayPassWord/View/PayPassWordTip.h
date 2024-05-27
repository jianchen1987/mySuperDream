//
//  PayPassWordTip.h
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPassWordTipView.h"
typedef void (^cancelBtnTapBlock)(void);
typedef void (^sureBtnTapBlock)(void);
NS_ASSUME_NONNULL_BEGIN


@interface PayPassWordTip : NSObject
+ (void)showPayPassWordTipViewToView:(UIView *)view
                         IconImgName:(NSString *)iconImgName
                              Detail:(NSString *)detail
                       CancelBtnText:(NSString *)cancelBtnText
                         SureBtnText:(NSString *)sureBtnText
                        SureCallBack:(sureBtnTapBlock)sureCallBack
                      CancelCallBack:(cancelBtnTapBlock)cancelCallBack;
@end

NS_ASSUME_NONNULL_END
