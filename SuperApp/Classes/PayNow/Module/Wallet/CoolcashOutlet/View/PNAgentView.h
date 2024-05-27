//
//  PNAgentView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNAgentInfoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickTapHiddenBlock)(void);


@interface PNAgentView : PNView

@property (nonatomic, strong) PNAgentInfoModel *model;

@property (nonatomic, copy) ClickTapHiddenBlock clickTapHiddenBlock;

- (void)showInView:(UIView *)superview;

- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
