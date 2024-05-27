//
//  GNTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNEnum.h"
#import "GNMultiLanguageManager.h"
#import "GNTheme.h"
#import "SATableViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNTableViewCell : SATableViewCell <HDSkeletonLayerLayoutProtocol>
/// 线条
@property (nonatomic, strong) UIView *lineView;
/// 添加阴影
- (CAGradientLayer *)addShadom:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
