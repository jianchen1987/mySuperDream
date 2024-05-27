//
//  TNSubmitReviewModel.m
//  SuperApp
//
//  Created by xixi on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSubmitReviewModel.h"


@implementation TNSubmitReviewItemModel

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSArray *keyArr = dic.allKeys;
    if ([keyArr containsObject:@"name"]) {
        [dic removeObjectForKey:@"name"];
    }
    if ([keyArr containsObject:@"thumbnail"]) {
        [dic removeObjectForKey:@"thumbnail"];
    }
    if ([keyArr containsObject:@"selectedPhotos"]) {
        [dic removeObjectForKey:@"selectedPhotos"];
    }
    return YES;
}

@end


@implementation TNSubmitReviewModel


@end
