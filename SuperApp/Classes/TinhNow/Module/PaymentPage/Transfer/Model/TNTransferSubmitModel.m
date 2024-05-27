//
//  TNTransferSubmitModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTransferSubmitModel.h"


@implementation TNTransferSubmitModel
- (NSString *)operatorNo {
    return [SAUser shared].operatorNo;
}
- (NSString *)userName {
    return [SAUser shared].nickName;
}
@end
