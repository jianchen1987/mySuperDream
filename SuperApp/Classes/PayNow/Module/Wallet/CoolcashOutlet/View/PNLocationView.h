//
//  PNLocationView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ButtonClickBlock)(void);


@interface PNLocationView : PNView
@property (nonatomic, copy) ButtonClickBlock buttonClickBlock;
@end

NS_ASSUME_NONNULL_END
