//
//  PNMSGetSMSCodeView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^InputChangeBlock)(NSString *inputValue);
typedef void (^ClickSendSMSCodeBlock)(void);


@interface PNMSGetSMSCodeView : PNView

@property (nonatomic, copy) ClickSendSMSCodeBlock clickSendSMSCodeBlock;
@property (nonatomic, copy) InputChangeBlock inputChangeBlock;

/// 开始倒计时
- (void)startCountDown;
@end

NS_ASSUME_NONNULL_END
