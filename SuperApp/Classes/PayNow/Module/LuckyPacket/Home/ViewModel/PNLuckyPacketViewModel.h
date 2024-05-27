//
//  PNLuckyPacketViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNLuckyPacketViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

- (void)getNewData;
@end

NS_ASSUME_NONNULL_END
