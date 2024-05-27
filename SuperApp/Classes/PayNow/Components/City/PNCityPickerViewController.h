//
//  PNCityPickerViewController.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SANonePresentAnimationViewController.h"
#import "PNCityPickerView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCityPickerViewController : SANonePresentAnimationViewController
/// 代理
@property (nonatomic, weak) id<PNCityPickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
