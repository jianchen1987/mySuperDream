//
//  WMOrderDetailContainerView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailContainerView : SAView <HDSkeletonLayerLayoutProtocol>
/// 骨架占位 View 高度
+ (CGFloat)skeletonViewHeight;
@end

NS_ASSUME_NONNULL_END
