//
//  PNTimePickerViewController.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTimePickerView.h"
#import "SANonePresentAnimationViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNTimePickerViewController : SANonePresentAnimationViewController
/// 代理
@property (nonatomic, weak) id<PNTimePickerViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
