//
//  WMTipAlertView.h
//  SuperApp
//
//  Created by wmz on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMTipAlertView : SAView <HDCustomViewActionViewProtocol>
@property (nonatomic, copy) NSString *tip;
@end

NS_ASSUME_NONNULL_END
