//
//  PNApartmentRecordListView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNApartmentRecordListView : PNView

@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NSMutableArray *statusArray;

- (void)getNewData;
@end

NS_ASSUME_NONNULL_END
