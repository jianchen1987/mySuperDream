//
//  SAView.h
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+PayNow.h"
#import "HDMediator+TinhNow.h"
#import "HDMediator+YumNow.h"
#import "NSArray+SASudokuMasonry.h"
#import "PNMultiLanguageManager.h"
#import "SAAppTheme.h"
#import "SALabel.h"
#import "SAMultiLanguageRespond.h"
#import "SANavigationController.h"
#import "SANotificationConst.h"
#import "SAOperationButton.h"
#import "SAViewProtocol.h"
#import "SAWindowManager.h"
#import "TNMultiLanguageManager.h"
#import "UIView+NAT.h"
#import "WMAppTheme.h"
#import "WMMultiLanguageManager.h"
#import "WMViewModel.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <HDVendorKit/HDWebImageManager.h>
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAView : UIView <SAViewProtocol, SAMultiLanguageRespond>
/// KVO
@property (nonatomic, strong, readonly) FBKVOController *KVOController;
/// 手势识别器
@property (nonatomic, strong, readonly) UITapGestureRecognizer *hd_tapRecognizer;
/// 滚动容器
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
/// 撑大 UIScrollView 的 UIView
@property (nonatomic, strong, readonly) UIView *scrollViewContainer;
@end

NS_ASSUME_NONNULL_END
