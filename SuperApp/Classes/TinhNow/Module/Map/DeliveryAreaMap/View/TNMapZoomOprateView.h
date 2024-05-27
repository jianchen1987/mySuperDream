//
//  TNMapZoomOprateView.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMapZoomOprateView : TNView
/// 放大点击
@property (nonatomic, copy) void (^enlargeClickCallBack)(void);
/// 缩小点击
@property (nonatomic, copy) void (^smallClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
