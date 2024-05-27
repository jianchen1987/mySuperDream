//
//  WMOrderDetailViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailViewController : SAViewController <WMViewControllerProtocol>
/// 订单号
@property (nonatomic, copy, readonly) NSString *orderNo;
@end

NS_ASSUME_NONNULL_END
