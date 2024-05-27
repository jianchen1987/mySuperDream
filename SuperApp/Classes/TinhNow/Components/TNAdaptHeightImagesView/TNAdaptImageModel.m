//
//  TNAdaptPicModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNAdaptImageModel.h"


@implementation TNAdaptImageModel
+ (NSArray<TNAdaptImageModel *> *)getAdaptImageModelsByImagesStrs:(NSArray<NSString *> *)list {
    if (HDIsArrayEmpty(list)) {
        return @[];
    }
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *imgStr in list) {
        if (HDIsStringNotEmpty(imgStr)) {
            TNAdaptImageModel *model = [[TNAdaptImageModel alloc] init];
            model.imgUrl = imgStr;
            model.imageHeight = 0;
            [images addObject:model];
        }
    }
    return images;
}

@end
