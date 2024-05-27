//
//  TNBargainRecordModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainRecordModel.h"


@implementation TNBargainRecordModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"taskId": @"id", @"status": @"taskStatus"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bargainDetailList": [TNBargainPeopleModel class]};
}
- (NSTimeInterval)expiredTimeOut {
    if (_expiredTimeOut <= 0) {
        return _expiredTimeMillis / 1000;
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
@end


@implementation TNBargainRecordListRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageSize": @"size", @"pageNum": @"current"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"records": [TNBargainRecordModel class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.pageNum >= self.pages) {
        self.hasNextPage = NO;
    } else {
        self.hasNextPage = YES;
    }

    return YES;
}

@end
