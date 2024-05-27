//
//  TNBargainDetailModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainDetailModel.h"


@implementation TNHelpBargainModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"bargainDetailList": [TNBargainPeopleModel class],
        @"couponList": [TNCouponModel class],
    };
}
@end


@implementation TNBargainUserModel

@end


@implementation TNBargainDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"taskId": @"id", @"status": @"taskStatus", @"registNewTips": @"newClientMsg", @"downLoadAppTips": @"downloadMsg"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"bargainDetailList": [TNBargainPeopleModel class],
        @"couponList": [TNCouponModel class],
    };
}

- (NSTimeInterval)expiredTimeOut {
    if (_expiredTimeOut <= 0) {
        NSTimeInterval timeout = _expiredTimeMillis / 1000;
        return timeout;
    }
    return _expiredTimeOut;
}
- (void)setUserMsg:(NSString *)userMsg {
    _userMsg = userMsg;
    if (HDIsStringNotEmpty(userMsg)) {
        self.attrMsg = [[NSAttributedString alloc] initWithData:[userMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                             documentAttributes:nil
                                                          error:nil];
    }
}
- (void)setHelpCopywritingV2:(NSString *)helpCopywritingV2 {
    _helpCopywritingV2 = helpCopywritingV2;
    if (HDIsStringNotEmpty(helpCopywritingV2)) {
        if ([helpCopywritingV2 containsString:@"<span"]) {
            //是HTML标签
            self.attrhelpCopywritingV2 = [[NSAttributedString alloc] initWithData:[helpCopywritingV2 dataUsingEncoding:NSUnicodeStringEncoding]
                                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                               documentAttributes:nil
                                                                            error:nil];
        }
    }
}
- (NSString *)showBargainSuccessMsg {
    NSString *showStr = self.helpCopywritingV2;
    if (!HDIsObjectNil(self.userMsgPrice)) {
        showStr = [showStr stringByAppendingFormat:@"-%@", self.userMsgPrice.thousandSeparatorAmount];
    }
    return showStr;
}
@end


@implementation TNCouponModel

@end
