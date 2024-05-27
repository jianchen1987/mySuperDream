//
//  SAAddOrModifyAddressIsDefaultView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyAddressIsDefaultViewModel : NSObject
@end


@interface SAAddOrModifyAddressIsDefaultView : SAAddOrModifyAddressBaseView
/// 是否默认
@property (nonatomic, strong, readonly) UISwitch *isDefaultAddressSwitch;
/// 是否默认地址
@property (nonatomic, assign) BOOL isDefault;
@end

NS_ASSUME_NONNULL_END
