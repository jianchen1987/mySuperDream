//
//  PNGamePaymentViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameListViewModel.h"
#import "PNGameListDTO.h"


@interface PNGameListViewModel ()
///
@property (strong, nonatomic) PNGameListDTO *gameDTO;
@end


@implementation PNGameListViewModel
- (void)getNewData {
    [self.view showloading];
    @HDWeakify(self);
    [self.gameDTO queryGameListSuccess:^(PNGameRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.rspModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}
/** @lazy gameDTO */
- (PNGameListDTO *)gameDTO {
    if (!_gameDTO) {
        _gameDTO = [[PNGameListDTO alloc] init];
    }
    return _gameDTO;
}
@end
