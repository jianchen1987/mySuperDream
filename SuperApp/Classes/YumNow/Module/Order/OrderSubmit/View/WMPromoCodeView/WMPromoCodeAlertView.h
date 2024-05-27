//
//  WMPromoCodeAlertView.h
//  SuperApp
//
//  Created by wmz on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMPromoCodeAlertView : SAView <HDCustomViewActionViewProtocol>
/// 选中回调
@property (nonatomic, copy) void (^clickedConfirmBlock)(NSString *_Nullable inputStr);

@property (nonatomic, copy) NSString *promoCode;
@end

NS_ASSUME_NONNULL_END
