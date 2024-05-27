//
//  GNStoreTimeView.h
//  SuperApp
//
//  Created by wmz on 2021/11/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreDetailModel.h"
#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreTimeView : GNView <HDCustomViewActionViewProtocol>
@property (nonatomic, strong) GNStoreDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
