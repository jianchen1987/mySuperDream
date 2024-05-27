//
//  PNMSReceiveCodeViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSReceiveCodeViewModel.h"
#import "PNMSReceiveCodeDTO.h"
#import "PNMSReceiveCodeRspModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@interface PNMSReceiveCodeViewModel ()
@property (nonatomic, strong) PNMSReceiveCodeDTO *receiveCodeDto;

@property (nonatomic, strong) dispatch_source_t timer;
@end


@implementation PNMSReceiveCodeViewModel

- (void)startTimerToGetQRCode {
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0);
        @HDWeakify(self);
        dispatch_source_set_event_handler(timer, ^{
            @HDStrongify(self);
            if (!WJIsObjectNil(self.qrCodeRspModel) && WJIsStringNotEmpty(self.qrCodeRspModel.qrData)) {
                HDLog(@"开始检查");
                [self checkQRData];
            } else {
                [self genQRCode];
            }
        });
        self.timer = timer;
        dispatch_resume(self.timer);
    }
}

- (void)cancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        HDLog(@"定时器取消");
    }
}

/// 获取收款码
- (void)genQRCode {
    [self.view showloading];
    @HDWeakify(self);

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params setValue:[PNCommonUtils yuanTofen:self.amount] forKey:@"amt"];
    [params setValue:self.currency forKey:@"currency"];
    [params setValue:self.currency forKey:@"cy"];
    [params setValue:self.storeOperatorInfoModel.merchantNo forKey:@"merchantNo"];
    [params setValue:self.storeOperatorInfoModel.merchantNo forKey:@"tenantId"];

    if (self.type == PNMSReceiveCodeType_Store || self.type == PNMSReceiveCodeType_StoreOperator) {
        [params setValue:self.storeOperatorInfoModel.storeNo forKey:@"storeNo"];
        [params setValue:self.storeOperatorInfoModel.storeName forKey:@"storeName"];

        if (self.type == PNMSReceiveCodeType_StoreOperator) {
            [params setValue:self.storeOperatorInfoModel.operatorName forKey:@"operaName"];
            [params setValue:self.storeOperatorInfoModel.operatorMobile forKey:@"operaLoginName"];
        }
    }

    [self.receiveCodeDto genQRCode:params success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        self.qrCodeRspModel = [PNMSReceiveCodeRspModel yy_modelWithJSON:rspModel.data];
        self.qrCodeRspModel.currency = self.currency;
        self.qrCodeRspModel.amount = self.amount;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)checkQRData {
    [self.receiveCodeDto checkQRData:self.qrCodeRspModel.qrData success:^(BOOL rspValue) {
        if (rspValue) {
            HDLog(@"qrdata 无效，重新生成");
            [self genQRCode];
        } else {
            HDLog(@"qrdata 有效");
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

#pragma mark
- (PNMSReceiveCodeDTO *)receiveCodeDto {
    if (!_receiveCodeDto) {
        _receiveCodeDto = [[PNMSReceiveCodeDTO alloc] init];
    }
    return _receiveCodeDto;
}

@end
