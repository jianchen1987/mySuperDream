//
//  PNLuckyPacketViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLuckyPacketViewModel.h"
#import "PNPacketMessageDTO.h"
#import "PNPacketMessageListRspModel.h"
#import "VipayUser.h"


@interface PNLuckyPacketViewModel ()
@property (nonatomic, strong) PNPacketMessageDTO *messageDTO;

@end


@implementation PNLuckyPacketViewModel

- (void)getNewData {
    NSDictionary *dict = @{
        @"orderType": @(1),
        @"pageSize": @(6),
        @"pageNum": @(1),
    };
    [self.messageDTO packetMessageList:dict success:^(PNPacketMessageListRspModel *_Nonnull rspModel) {
        self.dataSourceArray = [NSMutableArray arrayWithArray:rspModel.list];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

#pragma mark
- (PNPacketMessageDTO *)messageDTO {
    if (!_messageDTO) {
        _messageDTO = [[PNPacketMessageDTO alloc] init];
    }
    return _messageDTO;
}
@end
