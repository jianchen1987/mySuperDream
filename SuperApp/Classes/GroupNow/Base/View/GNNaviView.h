//
//  GNNaviView.h
//  SuperApp
//
//  Created by wmz on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNNaviView : GNView
/// 左
@property (nonatomic, strong) HDUIButton *leftBTN;
/// 右
@property (nonatomic, strong) HDUIButton *rightBTN;
/// bg
@property (nonatomic, strong) UIView *bgIV;
///标题
@property (nonatomic, strong) HDLabel *titleLB;

@end

NS_ASSUME_NONNULL_END
