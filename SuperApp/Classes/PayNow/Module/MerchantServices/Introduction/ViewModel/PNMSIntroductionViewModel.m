//
//  PNMSIntroductionViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSIntroductionViewModel.h"
#import "PNUserDTO.h"


@interface PNMSIntroductionViewModel ()
@property (nonatomic, strong) PNUserDTO *userDTO;
@end


@implementation PNMSIntroductionViewModel

- (void)getUserInfo {
    [self.userDTO getPayNowUserInfoSuccess:^(HDUserInfoRspModel *_Nonnull rspModel) {

    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

#pragma mark
- (PNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[PNUserDTO alloc] init];
    }
    return _userDTO;
}
@end
