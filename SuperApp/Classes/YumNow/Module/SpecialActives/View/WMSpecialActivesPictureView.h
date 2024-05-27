//
//  WMSpecialActivesPictureView.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMSpecialActivesViewModel.h"

typedef NS_ENUM(NSInteger, WMRadianDirection) {
    WMRadianDirectionBottom = 0,
    WMRadianDirectionTop = 1,
    WMRadianDirectionLeft = 2,
    WMRadianDirectionRight = 3,
};

NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialActivesPictureView : SAView

@property (nonatomic, copy) void (^frameBlock)(CGFloat realHeight);
/// vimodel
@property (nonatomic, strong) WMSpecialActivesViewModel *viewModel;
/// 圆弧方向, 默认在下方
@property (nonatomic) WMRadianDirection direction;
/// 圆弧高/宽, 可为负值。 正值凸, 负值凹
@property (nonatomic) CGFloat radian;
///时间
@property (nonatomic, copy) NSString *buinessTime;
@end

NS_ASSUME_NONNULL_END
