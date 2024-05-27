//
//  GNTabbar.h
//  SuperApp
//
//  Created by wmz on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATabBar.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNTabbar : SATabBar
///线条
@property (nonatomic, strong) UIView *line;
///底部毛玻璃
@property (nonatomic, strong) UIImageView *backView;
///上一个选中
@property (nonatomic, assign) NSInteger lastSelectIndex;
@end

NS_ASSUME_NONNULL_END
