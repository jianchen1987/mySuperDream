//
//  TNTutorialViewController.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDServiceKit/HDServiceKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNTutorialViewController : HDWebViewHostViewController
/// 返回回调
@property (nonatomic, copy) void (^dismissCallBack)(void);
@end

NS_ASSUME_NONNULL_END
