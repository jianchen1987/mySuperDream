//
//  GNViewController.h
//  SuperApp
//
//  Created by wmz on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNEnum.h"
#import "GNNotificationConst.h"
#import "GNTableView.h"
#import "GNTheme.h"
#import "HDMediator+GroupOn.h"
#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GNViewControllerProtocol <NSObject>

@optional
/// 需要关闭
- (BOOL)needClose;
/// 加载数据
- (void)gn_getNewData;
/// viewDidload加载数据
- (BOOL)gn_firstGetNewData;
@end


@interface GNViewController : SAViewController <GNViewControllerProtocol>

@property (nonatomic, strong) SALabel *nameLB; /// name

@property (nonatomic, strong) HDUIButton *backBtn; /// back
@end

NS_ASSUME_NONNULL_END
