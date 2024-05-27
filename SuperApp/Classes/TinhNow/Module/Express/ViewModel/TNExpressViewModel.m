//
//  TNExpressViewModel.m
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressViewModel.h"
#import "TNExpressDTO.h"


@interface TNExpressViewModel ()
//
@property (nonatomic, strong) TNExpressDTO *expressDTO;

///
@property (nonatomic, assign) BOOL refreshFlag;
@end


@implementation TNExpressViewModel

- (void)getNewDataWithOrderNo:(NSString *)orderNo {
    @HDWeakify(self);
    [self.view showloading];
    [self.expressDTO getExpressDetailsWithOrderNo:orderNo success:^(TNExpressDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.rspModel = rspModel;
        if (!HDIsArrayEmpty(rspModel.expressOrder)) {
            self.expModel = rspModel.expressOrder.firstObject;
            if ([self.expModel.deliveryCorpCode isEqualToString:TNDeliveryCorpCodeYumnow]) {
                [self getExpressRiderData:self.expModel.trackingNo];
            } else { //不是外卖的直接去刷新数据
                self.refreshFlag = !self.refreshFlag;
            }
        } else {
            self.refreshFlag = !self.refreshFlag;
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        HDLog(@"error:%@", error);
        if (self.networkFailCallBack) {
            self.networkFailCallBack();
        }
    }];
}
///请求外卖骑手数据
- (void)getExpressRiderData:(NSString *)trackingNo {
    [self.view showloading];
    [self.expressDTO getExpressRiderDataWithTrackingNo:trackingNo success:^(TNExpressRiderModel *_Nonnull rspModel) {
        [self.view dismissLoading];
        self.riderModel = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self.view dismissLoading];
    }];
}
- (TNExpressDTO *)expressDTO {
    if (!_expressDTO) {
        _expressDTO = [[TNExpressDTO alloc] init];
    }
    return _expressDTO;
}
@end
