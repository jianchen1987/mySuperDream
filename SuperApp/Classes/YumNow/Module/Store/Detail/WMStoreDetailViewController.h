//
//  WMStoreDetailViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAHasMessageBTNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreDetailViewController : SAHasMessageBTNViewController <WMViewControllerProtocol>
/// 门店号
@property (nonatomic, copy, readonly) NSString *storeNo;
@end

NS_ASSUME_NONNULL_END
