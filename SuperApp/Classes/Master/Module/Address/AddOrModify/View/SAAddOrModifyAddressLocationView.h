//
//  SAAddOrModifyAddressLocationView.h
//  SuperApp
//
//  Created by Chaos on 2021/3/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressModel;


@interface SAAddOrModifyAddressLocationView : SAView

/// 定位地址
@property (nonatomic, strong) SAAddressModel *addressModel;
/// 点击回调
@property (nonatomic, copy) void (^chooseLocationAddress)(SAAddressModel *addressModel);

@end

NS_ASSUME_NONNULL_END
