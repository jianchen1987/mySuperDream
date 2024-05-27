//
//  WMModifyAddressDTO.h
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "WMModifyAddressListModel.h"
#import "WMModifyAddressSubmitOrderModel.h"
#import "WMModifyFeeModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMModifyAddressDTO : SAViewModel
- (void)getOrderUpdateAddressWithAddressNo:(NSString *)addressNo
                                   orderNo:(NSString *)orderNo
                                   success:(void (^_Nullable)(WMModifyFeeModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)createOrderUpdateAddressWithAddressNo:(NSString *)addressNo
                                      orderNo:(NSString *)orderNo
                                     distance:(NSInteger)distance
                                         time:(NSInteger)time
                                          fee:(SAMoneyModel *)fee
                                      success:(void (^_Nullable)(WMModifyAddressSubmitOrderModel *rspModel))successBlock
                                      failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)getListOrderUpdateAddressWithOrderNo:(NSString *)orderNo
                                     success:(void (^_Nullable)(NSArray<WMModifyAddressListModel *> *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)cancelOrderUpdateAddressWithOrderNo:(NSString *)orderNo success:(CMNetworkSuccessVoidBlock _Nullable)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
