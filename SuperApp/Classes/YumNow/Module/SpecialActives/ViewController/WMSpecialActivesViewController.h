//
//  WMSpecialActivesViewController.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialActivesViewController : SALoginlessViewController <WMViewControllerProtocol>
///需要埋点的活动主题id 传入即埋点
@property (nonatomic, copy) NSString *plateId;

@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
