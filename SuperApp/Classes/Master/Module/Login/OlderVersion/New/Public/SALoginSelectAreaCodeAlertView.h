//
//  SASlectAreaCodeAlertView.h
//  SuperApp
//
//  Created by Tia on 2022/9/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

@class SACountryModel;

NS_ASSUME_NONNULL_BEGIN


@interface SALoginSelectAreaCodeAlertView : HDActionAlertView
/// 选择了 item 回调
@property (nonatomic, copy) void (^selectedItemHandler)(SACountryModel *model);

@end

NS_ASSUME_NONNULL_END
