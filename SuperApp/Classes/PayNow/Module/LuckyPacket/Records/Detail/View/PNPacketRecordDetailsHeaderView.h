//
//  PNPacketRecordDetailsHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketDetailModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketRecordDetailsHeaderView : PNView
@property (nonatomic, strong) PNPacketDetailModel *model;
@property (nonatomic, copy) NSString *viewType;
@end

NS_ASSUME_NONNULL_END
