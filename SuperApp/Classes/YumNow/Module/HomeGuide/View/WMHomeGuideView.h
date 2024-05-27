//
//  WMHomeGuideView.h
//  SuperApp
//
//  Created by wmz on 2021/11/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHomeGuideView : SAView
/// show
@property (nonatomic, assign, getter=isShow) BOOL show;
///更新状态
- (void)updateStatus;
///显示
- (void)show;
///隐藏
- (void)dissmiss;
@end

NS_ASSUME_NONNULL_END
