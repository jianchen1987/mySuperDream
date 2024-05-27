//
//  SAAddOrModifyAddressView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"
#import "SAAddressModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyAddressView : SAAddOrModifyAddressBaseView
/// 地址
@property (nonatomic, strong) SAAddressModel *addressModel;
@end

NS_ASSUME_NONNULL_END
