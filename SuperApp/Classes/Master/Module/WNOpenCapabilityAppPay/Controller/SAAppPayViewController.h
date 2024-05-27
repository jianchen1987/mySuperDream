//
//  SAAppPayViewController.h
//  SuperApp
//
//  Created by seeu on 2021/11/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppPayReqModel : SACodingModel

@property (nonatomic, copy) NSString *appId;  ///< 调用方appId
@property (nonatomic, strong) NSString *body; ///< 密文

@end


@interface SAAppPayViewController : SAViewController

- (void)payWithReqModel:(SAAppPayReqModel *)model;

@end

NS_ASSUME_NONNULL_END
