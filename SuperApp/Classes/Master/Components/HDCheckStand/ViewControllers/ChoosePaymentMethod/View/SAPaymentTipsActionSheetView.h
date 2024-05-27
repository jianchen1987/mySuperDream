//
//  SAPaymentTipsActionSheetView.h
//  SuperApp
//
//  Created by Tia on 2023/4/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAPaymentTipsActionSheetView : HDActionAlertView
/// 标题
@property (nonatomic, copy) NSString *title;
/// 文本介绍
@property (nonatomic, copy) NSString *detailText;
/// 继续付款回调
@property (nonatomic, copy) dispatch_block_t submitBlock;

@end

NS_ASSUME_NONNULL_END
