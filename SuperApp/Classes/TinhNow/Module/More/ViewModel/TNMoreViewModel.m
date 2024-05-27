//
//  TNMoreViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNMoreViewModel.h"
#import "TNGetTinhNowUserDiffRspModel.h"
#import "TNGlobalData.h"
#import "TNUserDTO.h"


@interface TNMoreViewModel ()
/// userDTO
@property (nonatomic, strong) TNUserDTO *userDTO;

@end


@implementation TNMoreViewModel

- (NSString *)headUrlStr {
    return SAUser.shared.headURL;
}

- (NSString *)nickName {
    return SAUser.shared.nickName;
}

#pragma mark - public methods
- (void)getTinhNowUserInfo {
    @HDWeakify(self);
    [self.userDTO getTinhNowUserIsSellerSuccess:^(TNGetTinhNowUserDiffRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.isSeller = rspModel.supplierFlag;
        if (!self.isSeller && HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId)) {
            [TNGlobalData shared].seller = nil;
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
    //    [self.userDTO getTinhNowUserDifferenceWithUserNo:SAUser.shared.operatorNo
    //                                             success:^(TNGetTinhNowUserDiffRspModel *_Nonnull rspModel) {
    //                                                 @HDStrongify(self);
    //                                                 self.isDistributor = rspModel.distributor;
    //                                             }
    //                                             failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){
    //
    //                                             }];
}

#pragma mark - lazy load
/** @lazy userDTO */
- (TNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[TNUserDTO alloc] init];
    }
    return _userDTO;
}

@end
