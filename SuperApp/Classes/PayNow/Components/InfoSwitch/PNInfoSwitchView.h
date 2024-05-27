//
//  PNInfoSwitchView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInfoSwitchModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInfoSwitchView : PNView
@property (nonatomic, strong) PNInfoSwitchModel *model;

- (void)update;
@end

NS_ASSUME_NONNULL_END
