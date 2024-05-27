//
//  HDCheckStandInputPwdViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandBaseViewController.h"
#import "HDCheckStandPaymentDetailTitleModel.h"

@class HDCheckStandOrderSubmitParamsRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckStandInputPwdViewController : HDCheckStandBaseViewController
- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters;
- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters title:(NSString *)title tipStr:(NSString *)tipStr;
@property (nonatomic, strong) HDCheckStandOrderSubmitParamsRspModel *model; ///< 模型
//@property (nonatomic, assign) HDTransType tradeType;                         ///< 交易类型
@end

NS_ASSUME_NONNULL_END
