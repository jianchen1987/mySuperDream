//
//  PNCityPickerView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNCityPickerView;


NS_ASSUME_NONNULL_BEGIN


@protocol PNCityPickerViewDelegate <NSObject>

@optional
/// 点击确定选中的 省市
- (void)cityPickerView:(PNCityPickerView *)pickView didSelectprovince:(NSString *)province city:(NSString *)city;
@end


@interface PNCityPickerView : PNView
/// 代理
@property (nonatomic, weak) id<PNCityPickerViewDelegate> delegate;

/// 点击了取消
@property (nonatomic, copy) void (^clickedCancelBlock)(void);
@end

NS_ASSUME_NONNULL_END
