//
//  SAAddOrModifyAddressPhoneView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyAddressPhoneView : SAAddOrModifyAddressBaseView
/// 号码
@property (nonatomic, strong, readonly) HDUITextField *phoneNumberTF;
/// 手机号
@property (nonatomic, copy) NSString *mobile;

/// 手机号编辑回调
@property (nonatomic, copy) void (^phoneNoDidChanged)(NSString *phoneNo);
/// 结束编辑回调
@property (nonatomic, copy) void (^phoneNoDidEndEditing)(NSString *phoneNo);

@end

NS_ASSUME_NONNULL_END
