//
//  PNMSMapAddressViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSMapAddressViewModel.h"
#import "PNMSMapAddressDTO.h"


@interface PNMSMapAddressViewModel ()
@property (nonatomic, strong) PNMSMapAddressDTO *mapAddressDTO;
@end


@implementation PNMSMapAddressViewModel

- (void)getProvinces {
    [self.view showloading];

    @HDWeakify(self);
    [self.mapAddressDTO getProvinces:^(NSArray<PNMSMapAddressViewModel *> *_Nonnull rspArray) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.provincesArray = [NSArray arrayWithArray:rspArray];
        self.provincesRefreshFlag = !self.provincesRefreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNMSMapAddressDTO *)mapAddressDTO {
    if (!_mapAddressDTO) {
        _mapAddressDTO = [[PNMSMapAddressDTO alloc] init];
    }
    return _mapAddressDTO;
}
@end
