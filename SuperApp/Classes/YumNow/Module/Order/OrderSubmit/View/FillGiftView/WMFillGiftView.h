//
//  WMFillGiftView.h
//  SuperApp
//
//  Created by wmz on 2021/7/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOrderSubmitFullGiftRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMFillGiftView : SAView <HDCustomViewActionViewProtocol>
@property (nonatomic, strong) WMOrderSubmitFullGiftRspModel *model;
/// 点击填写
@property (nonatomic, copy) void (^clickedWriteBlock)(void);
@end

NS_ASSUME_NONNULL_END
