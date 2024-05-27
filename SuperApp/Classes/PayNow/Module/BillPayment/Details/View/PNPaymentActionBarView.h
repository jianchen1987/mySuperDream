//
//  PNPaymentActionBar.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

/// 关闭 按钮回调
typedef void (^ClickCloseActionBlock)(void);


@interface PNPaymentActionBarView : PNView
@property (nonatomic, copy) ClickCloseActionBlock clickCloseActionBlock;
@end

NS_ASSUME_NONNULL_END
