//
//  PNMSCollectionViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCollectionModel.h"
#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSCollectionViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) NSString *merchantNo;

@property (nonatomic, strong) PNMSCollectionModel *model;

- (void)getNewData;
@end

NS_ASSUME_NONNULL_END
