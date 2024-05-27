//
//  PNMSCollectionViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCollectionViewModel.h"
#import "PNMSCollectionDTO.h"


@interface PNMSCollectionViewModel ()
@property (nonatomic, strong) PNMSCollectionDTO *collectionDTO;
@end


@implementation PNMSCollectionViewModel
- (void)getNewData {
    [self.view showloading];
    @HDWeakify(self);
    [self.collectionDTO getMSDayCountWithMerchantNo:self.merchantNo success:^(PNMSCollectionModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.model = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

#pragma mark
- (PNMSCollectionDTO *)collectionDTO {
    if (!_collectionDTO) {
        _collectionDTO = [[PNMSCollectionDTO alloc] init];
    }
    return _collectionDTO;
}
@end
