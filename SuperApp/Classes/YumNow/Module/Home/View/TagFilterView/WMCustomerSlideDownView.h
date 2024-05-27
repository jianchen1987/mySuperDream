//
//  WMCustomerSlideDownView.h
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCustomerSlideDownView : SAView

- (instancetype)initWithStartOffsetY:(CGFloat)offset customerView:(UIView<HDCustomViewActionViewProtocol> *)customerView;

- (void)show;
- (void)dismissCompleted:(void (^__nullable)(void))completed;
@property (nonatomic, assign) CGFloat cornerRadios;
/// willAppear
@property (nonatomic, copy) void (^slideDownViewWillAppear)(WMCustomerSlideDownView *slideDownView);
/// willDisappler
@property (nonatomic, copy) void (^slideDownViewWillDisappear)(WMCustomerSlideDownView *slideDownView);
@end

NS_ASSUME_NONNULL_END
