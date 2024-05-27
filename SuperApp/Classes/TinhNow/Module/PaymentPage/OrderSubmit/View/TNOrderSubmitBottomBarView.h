//
//  TNOrderSubmitBottomBarView.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderSubmitBottomBarView : TNView
/// 下单按钮点击回调
@property (nonatomic, copy) void (^confirmButtonClickedHandler)(void);
/// 打开关闭按钮
- (void)setSubmitBtnEnable:(BOOL)enable;
@end

NS_ASSUME_NONNULL_END
