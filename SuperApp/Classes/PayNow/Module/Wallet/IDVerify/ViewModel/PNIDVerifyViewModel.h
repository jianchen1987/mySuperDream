//
//  PNIDVerifyViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGetCardTypeRspModel.h"
#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNIDVerifyViewModel : PNViewModel
@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, strong) PNGetCardTypeRspModel *cardTypeRspModel;
@property (nonatomic, assign) PNUserLevel userLevel;

/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL needSetting, BOOL isSuccess);

- (void)getCardType;

///校验信息
- (void)verifyCustomerInfo:(NSString *)lastName firstName:(NSString *)firstName cardNum:(NSString *)cardNum;
@end

NS_ASSUME_NONNULL_END
