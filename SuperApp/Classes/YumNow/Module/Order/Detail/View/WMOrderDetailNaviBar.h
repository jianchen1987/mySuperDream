//
//  WMOrderDetailNaviBar.h
//  SuperApp
//
//  Created by wmz on 2022/10/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailNaviBar : SAView
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 返回按钮
@property (nonatomic, strong) HDUIButton *backBTN;
/// 刷新按钮
@property (nonatomic, strong) HDUIButton *updateBTN;
/// 联系客服
@property (nonatomic, strong) HDUIButton *contactBTN;

- (void)updateUIWithScrollViewOffsetY:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END
