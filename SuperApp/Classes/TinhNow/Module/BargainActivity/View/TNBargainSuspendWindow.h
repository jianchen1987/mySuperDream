//
//  TNBargainSuspendWindow.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNBargainRootViewController : UIViewController
@end


@interface TNBargainSuspendWindow : UIView
/// 禁用拖动。默认开启手势，即不禁用
@property (nonatomic, assign) BOOL disablePanGesture;
/// 展开
- (void)expand;
/// 收起
- (void)shrink;
/// 展示 在window
- (void)show;
/// 展示在自定义视图
- (void)showInView:(UIView *)inView;

- (CGRect)getIconFrame;

@end

NS_ASSUME_NONNULL_END
