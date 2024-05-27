//
//  PNMSPermissionModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPermissionModel.h"


@implementation PNMSPermissionModel

- (void)setPermissionList:(NSMutableArray *)permissionList {
    if ([permissionList containsObject:@(PNMSPermissionType_WALLET_BALANCE_QUERY)]) {
        self.walletPrower = YES;
    } else {
        self.walletPrower = NO;
    }

    if ([permissionList containsObject:@(PNMSPermissionType_WALLET_WITHDRAWAL)]) {
        self.withdraowPower = YES;
    } else {
        self.withdraowPower = NO;
    }

    if ([permissionList containsObject:@(PNMSPermissionType_COLLECTION_DATA_QUERY)]) {
        self.collectionPower = YES;
    } else {
        self.collectionPower = NO;
    }

    if ([permissionList containsObject:@(PNMSPermissionType_STORE_MANAGEMENT)]) {
        self.storePower = YES;
    } else {
        self.storePower = NO;
    }

    if ([permissionList containsObject:@(PNMSPermissionType_MERCHANT_CODE_QUERY)]) {
        self.receiverCodePower = YES;
    } else {
        self.receiverCodePower = NO;
    }

    if ([permissionList containsObject:@(PNMSPermissionType_STORE_DATA_QUERY)]) {
        self.storeDataQueryPower = YES;
    } else {
        self.storeDataQueryPower = NO;
    }
}

- (NSMutableArray *)permissionList {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.walletPrower) {
        [arr addObject:@(PNMSPermissionType_WALLET_BALANCE_QUERY)];
    }

    if (self.withdraowPower) {
        [arr addObject:@(PNMSPermissionType_WALLET_WITHDRAWAL)];
    }

    if (self.collectionPower) {
        [arr addObject:@(PNMSPermissionType_COLLECTION_DATA_QUERY)];
    }

    if (self.storePower) {
        [arr addObject:@(PNMSPermissionType_STORE_MANAGEMENT)];
    }

    if (self.receiverCodePower) {
        [arr addObject:@(PNMSPermissionType_MERCHANT_CODE_QUERY)];
    }

    if (self.storeDataQueryPower) {
        [arr addObject:@(PNMSPermissionType_STORE_DATA_QUERY)];
    }

    return arr;
}

@end
