//
//  SAOrderListFilterDownView.h
//  SuperApp
//
//  Created by Tia on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListFilterDownView : SAView
/// 是否展开
@property (nonatomic, assign, readonly) BOOL showing;
/// 选择时间控件回调
@property (nonatomic, copy) void (^chooseDateBlock)(BOOL isEndDate);
/// 点击确认按钮回调
@property (nonatomic, copy) void (^submitBlock)(SAClientType _Nullable businessline, NSString *_Nullable startDate, NSString *_Nullable endDate);

@property (nonatomic, copy) dispatch_block_t dismissBlock;

- (instancetype)initWithStartOffsetY:(CGFloat)offset;

- (void)showInView:(UIView *)view;

- (void)dismissCompleted:(void (^__nullable)(void))completed;

- (void)updateDate:(NSString *)date isEndDate:(BOOL)isEndDate;

@end

NS_ASSUME_NONNULL_END
