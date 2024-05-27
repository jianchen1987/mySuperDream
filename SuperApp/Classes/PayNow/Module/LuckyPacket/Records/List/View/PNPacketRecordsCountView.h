//
//  PNPacketRecordsCountView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordRspModel.h"
#import "PNView.h"

typedef void (^SelectYearBlock)(NSString *year);

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketRecordsCountView : PNView
@property (nonatomic, copy) NSString *viewType;
@property (nonatomic, strong) PNPacketRecordRspModel *model;

@property (nonatomic, copy) SelectYearBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
