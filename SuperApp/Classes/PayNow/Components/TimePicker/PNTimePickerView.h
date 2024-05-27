//
//  PNTimePickerView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNTimePickerView;

NS_ASSUME_NONNULL_BEGIN

@protocol PNTimePickerViewDelegate <NSObject>

@optional
/// 点击确定选中的 省市
- (void)cityPickerView:(PNTimePickerView *)pickView didSelectHour:(NSString *)hour minute:(NSString *)minute;
@end


@interface PNTimePickerView : PNView
/// 代理
@property (nonatomic, weak) id<PNTimePickerViewDelegate> delegate;

/// 点击了取消
@property (nonatomic, copy) void (^clickedCancelBlock)(void);
@end

NS_ASSUME_NONNULL_END
