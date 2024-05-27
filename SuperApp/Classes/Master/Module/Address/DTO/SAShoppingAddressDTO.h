//
//  SAShoppingAddressDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressModel.h"
#import "SAViewModel.h"

@class WMStoreModel;
@class SACheckMobileValidRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAShoppingAddressDTO : SAViewModel

/// 获取地址列表
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getShoppingAddressListSuccess:(void (^)(NSArray<SAShoppingAddressModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 新增地址
/// @param model 模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addAddressWithModel:(SAShoppingAddressModel *)model
                    smsCode:(NSString *)smsCode
                    success:(void (^)(SAShoppingAddressModel *rspModel))successBlock
                    failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 修改地址
/// @param model 模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)modifyAddressWithModel:(SAShoppingAddressModel *)model smsCode:(NSString *)smsCode success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取默认地址
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getDefaultAddressSuccess:(void (^)(SAShoppingAddressModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 删除地址
/// @param addressNo 地址编号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)removeAddressWithAddressNo:(NSString *)addressNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取用户收货地址
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getUserAccessableShoppingAddressWithStoreNo:(NSString *)storeNo success:(void (^)(NSArray<SAShoppingAddressModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 搜索页获取用户收货地址
/// @param lat 经度
/// @param lon 纬度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSearchAddressListWithLog:(double)lat lat:(double)lon Success:(void (^)(NSArray<SAShoppingAddressModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 检测收货人手机号是否需要短信校验
/// @param mobile 手机号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)checkConsigneeMobileIsValidWithMobile:(NSString *)mobile success:(void (^)(SACheckMobileValidRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
