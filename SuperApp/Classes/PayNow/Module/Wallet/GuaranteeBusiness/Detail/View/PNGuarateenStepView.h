//
//  PNGuarateenStepView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenStepView : PNView

- (void)refreshView:(NSArray *)dataSource flowStep:(NSInteger)flowStep;
@end

NS_ASSUME_NONNULL_END
