//
//  PNMSStoreManagerViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreInfoModel.h"
#import "PNMSStoreOperatorInfoModel.h"
#import "PNViewModel.h"

@class PNMSStoreOperatorRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreManagerViewModel : PNViewModel
@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *storeNo;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storeOperatorId;
///
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL canEidt;

@property (nonatomic, strong) PNMSStoreInfoModel *storeInfoModel;
@property (nonatomic, strong) PNMSStoreOperatorInfoModel *storeOperatorInfoModel;

@property (nonatomic, assign) BOOL isSuccess;

- (void)getNewData:(BOOL)isNeedShowLoading;

- (void)getStoreInfo;

- (void)saveOrUpdateStore;

- (void)uploadImages:(NSArray<UIImage *> *)images completion:(void (^)(NSArray<NSString *> *imgUrlArray))completion;

- (void)getStoreOperatorList:(void (^)(PNMSStoreOperatorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

- (void)getStoreOperatorDetail;

- (void)saveOrUpdateStoreOperator;
/// 反查信息
- (void)getCoolCashAccountName;

/// 解除绑定
- (void)unBindStoreOperator:(NSString *)operatorMobile success:(void (^)(void))successBlock;
@end

NS_ASSUME_NONNULL_END
