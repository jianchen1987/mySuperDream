//
//  SAViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+YumNow.h"
#import "SAGeneralUtil.h"
#import "SAMultiLanguageManager.h"
#import "SARspModel.h"
#import "SAUser.h"
#import "SAViewModelProtocol.h"
#import "UIView+NAT.h"
#import <Foundation/Foundation.h>
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAViewModel : NSObject <SAViewModelProtocol>

#pragma mark - 埋点相关
///< 来源
@property (nonatomic, copy) NSString *source;
///< 关联ID
@property (nonatomic, copy) NSString *associatedId;

@end

NS_ASSUME_NONNULL_END
