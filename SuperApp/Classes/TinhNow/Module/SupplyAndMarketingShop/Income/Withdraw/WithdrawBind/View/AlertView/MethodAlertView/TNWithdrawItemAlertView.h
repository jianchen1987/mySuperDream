//
//  TNWithdrawItemAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawItemConfig.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawItemAlertView : HDActionAlertView
@property (nonatomic, copy) void (^confirmClickCallBack)(TNWithdrawItemModel *); ///<确认按钮回调

- (instancetype)initAlertViewWithConfig:(TNWithdrawItemConfig *)config;
@end

NS_ASSUME_NONNULL_END
