//
//  TNWithdrawConfirmAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
@class TNWithdrawBindRequestModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawConfirmAlertView : HDActionAlertView
@property (nonatomic, copy) void (^dismissCallBack)(void);      ///<
@property (nonatomic, copy) void (^postWithDrawCallBack)(void); ///<发起提现回调
- (instancetype)initWithWithDrawModel:(TNWithdrawBindRequestModel *)model;

@end

NS_ASSUME_NONNULL_END
