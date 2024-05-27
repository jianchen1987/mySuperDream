//
//  SAHasMessageBTNViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAHasMessageBTNViewController.h"
#import "SAMessageDTO.h"


@interface SAHasMessageBTNViewController ()
/// DTO
@property (nonatomic, strong) SAMessageDTO *messageDTO;
@end


@implementation SAHasMessageBTNViewController

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 2;
}

//- (void)hd_getNewData {
//    // 未登录不处理
//    if (!SAUser.hasSignedIn) return;
//
//    [self.messageDTO
//        getUnreadStationMessageCountWithClientType:self.clientType
//                                           success:nil
//                                           failure:nil];
//}

#pragma mark - lazy load
- (SAMessageDTO *)messageDTO {
    return _messageDTO ?: ({ _messageDTO = SAMessageDTO.new; });
}
@end
