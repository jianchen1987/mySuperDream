//
//  HDCommonPagingRspModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"


@implementation HDCommonPagingRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isFirstPage": @[@"isFirstPage", @"firstPage"], @"isLastPage": @[@"isLastPage", @"lastPage"]};
}

- (BOOL)pn_hasNetPage {
    if (self.pages > self.pageNum) {
        return YES;
    } else {
        return NO;
    }
}
@end
