//
//  TNSingleSelectedAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSingleSelectedAlertConfig.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNSingleSelectedAlertView : HDActionAlertView
- (instancetype)initWithConfig:(TNSingleSelectedAlertConfig *)config;
/// 选中回调
@property (nonatomic, copy) void (^selectedItemCallBack)(TNSingleSelectedItem *item);
@end

NS_ASSUME_NONNULL_END
