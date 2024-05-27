//
//  TNProductChooseTipsView.h
//  SuperApp
//
//  Created by xixi on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductChooseTipsView : SAView
/// 设置内容
- (void)setText:(NSString *)text;
/// 外部设置高度
@property (nonatomic, assign) BOOL userSetHeight;
/// 点击回调
@property (nonatomic, copy) void (^tappedHandler)(void);

@end

NS_ASSUME_NONNULL_END
