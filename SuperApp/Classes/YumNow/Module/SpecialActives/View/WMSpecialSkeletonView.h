//
//  WMSpecialSkeletonView.h
//  SuperApp
//
//  Created by wmz on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMSpecialActivesViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialSkeletonView : SAView
/// viewModel
@property (nonatomic, strong) WMSpecialActivesViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
