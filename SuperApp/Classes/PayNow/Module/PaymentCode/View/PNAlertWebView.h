//
//  PNAlertWebView.h
//  SuperApp
//
//  Created by xixi on 2022/5/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RightBtnClickBlock)(void);


@interface PNAlertWebView : HDActionAlertView

@property (nonatomic, copy) RightBtnClickBlock rightBtnClickBlock;

/// 初始化
/// @param url 加载的url
/// @param title 显示顶部的标题
- (instancetype)initAlertWithURL:(NSString *)url title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
