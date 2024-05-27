//
//  PNMSPermissionModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSPermissionModel : PNModel

@property (nonatomic, assign) BOOL walletPrower;
@property (nonatomic, assign) BOOL withdraowPower;
@property (nonatomic, assign) BOOL collectionPower;
@property (nonatomic, assign) BOOL storePower;
@property (nonatomic, assign) BOOL receiverCodePower;
@property (nonatomic, assign) BOOL storeDataQueryPower;

/// 权限
@property (nonatomic, strong) NSMutableArray *permissionList;

@end

NS_ASSUME_NONNULL_END
