//
//  GNStoreView.h
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreCellModel.h"
#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreView : GNView

@property (nonatomic, strong) GNStoreCellModel *model;

@end

NS_ASSUME_NONNULL_END
