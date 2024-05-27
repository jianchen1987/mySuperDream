//
//  PNMSStoreManagerViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreManagerViewModel.h"
#import "PNMSOperatorDTO.h"
#import "PNMSStoreManagerDTO.h"
#import "PNMSStoreOperatorRspModel.h"
#import "PNPhotoManager.h"
#import "PNRspModel.h"
#import "PNUploadImageDTO.h"


@interface PNMSStoreManagerViewModel ()
@property (nonatomic, strong) PNMSStoreManagerDTO *storeDTO;
@property (nonatomic, strong) PNUploadImageDTO *uploadDTO;
@property (nonatomic, strong) PNMSOperatorDTO *operatorDTO;
@end


@implementation PNMSStoreManagerViewModel

- (void)getNewData:(BOOL)isNeedShowLoading {
    if (isNeedShowLoading) {
        [self.view showloading];
    }

    @HDWeakify(self);
    [self.storeDTO getStoreListData:^(NSArray<PNMSStoreInfoModel *> *_Nonnull rspArray) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.dataSource = [NSMutableArray arrayWithArray:rspArray];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

- (void)getStoreInfo {
    [self.view showloading];

    @HDWeakify(self);
    [self.storeDTO getStoreDetailWithStoreNo:self.storeNo success:^(PNMSStoreInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.storeInfoModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)saveOrUpdateStore {
    [self.view showloading];

    NSMutableDictionary *dict = [self.storeInfoModel yy_modelToJSONObject];
    [dict removeObjectForKey:@"permissionList"];
    [dict removeObjectForKey:@"walletPrower"];
    [dict removeObjectForKey:@"withdraowPower"];
    [dict removeObjectForKey:@"collectionPower"];
    [dict removeObjectForKey:@"storePower"];
    [dict removeObjectForKey:@"receiverCodePower"];
    [dict removeObjectForKey:@"storeDataQueryPower"];

    //这里将storeImages转换一下
    NSString *storeImagesStr = [self.storeInfoModel.storeImages componentsJoinedByString:@","];
    [dict setValue:storeImagesStr forKey:@"storeImages"];

    //    if (![self.storeInfoModel.storePhone hasPrefix:@"8550"]) {
    //        NSString *phoneStr = [NSString stringWithFormat:@"8550%@", self.storeInfoModel.storePhone];
    //        [dict setValue:phoneStr forKey:@"storePhone"];
    //    }

    /// 新增的时候给赋值 来源
    if (WJIsStringEmpty(self.storeInfoModel.storeId)) {
        [dict setObject:@"WOWNOW" forKey:@"applySource"];
    }

    @HDWeakify(self);
    [self.storeDTO saveOrUpdateStore:dict success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self.view.viewController.navigationController popViewControllerAnimated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)uploadImages:(NSArray<UIImage *> *)images completion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
    [self.uploadDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            [hud hideAnimated:YES];
        });
        !completion ?: completion(imageURLArray);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [hud hideAnimated:YES];
    }];
}

- (void)getStoreOperatorList:(void (^)(PNMSStoreOperatorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.view showloading];

    @HDWeakify(self);
    [self.storeDTO getOperatorListWithStoreNo:self.storeNo currentPage:self.currentPage success:^(PNMSStoreOperatorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

- (void)getStoreOperatorDetail {
    [self.view showloading];
    @HDWeakify(self);
    [self.storeDTO getStoreOperatorDetail:self.storeOperatorId success:^(PNMSStoreOperatorInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.storeOperatorInfoModel = rspModel;
        self.isSuccess = YES;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)saveOrUpdateStoreOperator {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    //    NSString *permissionListStr = [self.storeOperatorInfoModel.permissionList componentsJoinedByString:@","];
    [dict setValue:self.storeOperatorInfoModel.storeDataQueryPower ? @(PNMSPermissionType_STORE_DATA_QUERY) : @"" forKey:@"permissionList"];
    [dict setValue:self.storeOperatorInfoModel.accountNo forKey:@"accountNo"];

    NSString *operatorMobile = self.storeOperatorInfoModel.operatorMobile;
    if (![operatorMobile hasPrefix:@"855"]) {
        operatorMobile = [NSString stringWithFormat:@"8550%@", operatorMobile];
    }
    [dict setValue:operatorMobile forKey:@"operatorMobile"];
    [dict setValue:self.storeOperatorInfoModel.storeNo forKey:@"storeNo"];
    [dict setValue:@(self.storeOperatorInfoModel.role) forKey:@"role"];
    [dict setValue:self.storeOperatorInfoModel.storeOperatorId forKey:@"id"];

    [self.view showloading];
    @HDWeakify(self);
    [self.storeDTO saveOrUpdateStoreOperator:dict success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self.view.viewController.navigationController popViewControllerAnimated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 反查信息
- (void)getCoolCashAccountName {
    [self.view showloading];

    @HDWeakify(self);
    [self.storeDTO getCCAmountWithMobile:self.storeOperatorInfoModel.operatorMobile success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        HDLog(@"%@", rspModel.data);
        if ([rspModel.data isKindOfClass:NSDictionary.class]) {
            NSString *firstName = [rspModel.data objectForKey:@"firstName"] ?: @"";
            NSString *lastName = [rspModel.data objectForKey:@"lastName"] ?: @"";
            self.storeOperatorInfoModel.userName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
            self.storeOperatorInfoModel.accountNo = [rspModel.data objectForKey:@"accountNo"] ?: @"";
            self.isSuccess = YES;
        }
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.storeOperatorInfoModel.userName = @"";
        self.storeOperatorInfoModel.accountNo = @"";
    }];
}

/// 解除绑定
- (void)unBindStoreOperator:(NSString *)operatorMobile success:(void (^)(void))successBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.operatorDTO unBindOperator:operatorMobile success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNMSStoreManagerDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = [[PNMSStoreManagerDTO alloc] init];
    }
    return _storeDTO;
}

- (PNUploadImageDTO *)uploadDTO {
    if (!_uploadDTO) {
        _uploadDTO = [[PNUploadImageDTO alloc] init];
    }
    return _uploadDTO;
}

- (PNMSOperatorDTO *)operatorDTO {
    if (!_operatorDTO) {
        _operatorDTO = [[PNMSOperatorDTO alloc] init];
    }
    return _operatorDTO;
}
@end
