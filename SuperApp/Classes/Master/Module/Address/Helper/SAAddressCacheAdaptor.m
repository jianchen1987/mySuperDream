//
//  SAAddressCacheAdaptor.m
//  SuperApp
//
//  Created by Chaos on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressCacheAdaptor.h"
#import "SACacheManager.h"
#import "SANotificationConst.h"


@implementation SAAddressCacheAdaptor

+ (void)cacheAddressForClientType:(SAClientType)clientType addressModel:(SAAddressModel *_Nullable)addressModel {

    //首页和外卖共用一个key
    if (clientType == SAClientTypeMaster ) {// 真实经纬度地址
        [SACacheManager.shared setObject:addressModel forKey:kCacheKeyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        //判断手切地址是否存在，没有的情况同步覆盖到手切地址
        SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        if(!currentAddressModel) {
            [SACacheManager.shared setObject:addressModel forKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        }
    }else if (clientType == SAClientTypeYumNow) { //手切地址
        HDLog(@"保存新的外卖地址");
        [SACacheManager.shared setObject:addressModel forKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        // 发送通知
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameUserChangedLocation object:nil userInfo:@{@"clientType": SAClientTypeMaster}];
    }
}

+ (SAAddressModel *)getAddressModelForClientType:(SAClientType)clientType {
    if(clientType == SAClientTypeYumNow) { //返回手切地址
        SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        if(!currentAddressModel) {
            currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        }
        return currentAddressModel;
    }else{
        SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        return currentAddressModel;
    }
}

+ (void)removeYumAddress {
    //移除手切地址
    [SACacheManager.shared removeObjectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
}

@end
