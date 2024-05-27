//
//  WMOrderDetailContactPhoneView.h
//  SuperApp
//
//  Created by Chaos on 2021/2/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailContactPhoneView : SAView <HDCustomViewActionViewProtocol>

/// 电话号码数组，可以为NSString数组或者SAContactPhoneModel数组
@property (nonatomic, strong) NSArray *phoneList;
/// 拨打号码
@property (nonatomic, copy) void (^clickedPhoneNumberBlock)(NSString *phoneNumber);

@end

NS_ASSUME_NONNULL_END
