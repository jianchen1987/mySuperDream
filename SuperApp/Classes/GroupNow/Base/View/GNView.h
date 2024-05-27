//
//  GNView.h
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNMultiLanguageManager.h"
#import "GNTheme.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GNViewProtocol <NSObject>

@optional
/// 加载数据
- (void)gn_getNewData;
/// viewDidload加载数据
- (BOOL)gn_firstGetNewData;

@end


@interface GNView : SAView <GNViewProtocol>
/// 线条
@property (nonatomic, strong) UIView *lineView;
/// 底部有间距
@property (nonatomic, assign) BOOL safeBottom;
@end

NS_ASSUME_NONNULL_END
