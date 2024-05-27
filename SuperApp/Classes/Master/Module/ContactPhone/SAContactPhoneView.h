//
//  SAContactPhoneView.h
//  SuperApp
//
//  Created by Chaos on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAContactPhoneView : SAView <HDCustomViewActionViewProtocol>

/// 拨打号码
@property (nonatomic, copy) void (^clickedPhoneNumberBlock)(NSString *phoneNumber);

@end

NS_ASSUME_NONNULL_END
