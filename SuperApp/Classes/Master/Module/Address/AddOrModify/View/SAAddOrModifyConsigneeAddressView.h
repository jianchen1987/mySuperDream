//
//  SAAddOrModifyConsigneeAddressView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyConsigneeAddressView : SAAddOrModifyAddressBaseView
/// 详细地址
@property (nonatomic, copy) NSString *consigneeAddress;
/// 详情地址
@property (nonatomic, strong, readonly) HDTextView *addressDetailTV;
@end

NS_ASSUME_NONNULL_END
