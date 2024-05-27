//
//  GNFilterView.h
//  SuperApp
//
//  Created by wmz on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNFilterModel.h"
#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNFilterView : GNView
/// 起始坐标Y
@property (nonatomic, assign) CGFloat startOffsetY;
/// viewWillAppear
@property (nonatomic, copy) void (^viewWillAppear)(UIView *view);
/// viewWillDisappear
@property (nonatomic, copy) void (^viewWillDisappear)(UIView *view);

- (instancetype)initWithFrame:(CGRect)frame filterModel:(GNFilterModel *)filterModel startOffsetY:(CGFloat)offset;

- (void)hideAllSlideDownView;

- (void)resetAll;
@end

NS_ASSUME_NONNULL_END
