//
//  PNPacketRecordCountSection.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketDetailModel.h"
#import "PNView.h"
#import "SATableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketRecordCountSection : SATableHeaderFooterView
@property (nonatomic, strong) PNPacketDetailModel *model;
@end

NS_ASSUME_NONNULL_END
