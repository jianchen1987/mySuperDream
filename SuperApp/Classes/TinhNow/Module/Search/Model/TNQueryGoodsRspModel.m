//
//  TNSearchGoodsRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNQueryGoodsRspModel.h"
#import "TNBargainGoodModel.h"
#import "TNGoodsModel.h"
#import <HDKitCore/HDKitCore.h>


@implementation TNQueryGoodsRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageNum": @"pageNumber", @"pages": @"totalPages"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNGoodsModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.pageNum >= self.pages) {
        self.hasNextPage = NO;
    } else {
        self.hasNextPage = YES;
    }

    return YES;
}
+ (NSArray<TNBargainGoodModel *> *)modelArrayWithGoodModelList:(NSArray<TNGoodsModel *> *)list {
    NSArray<TNBargainGoodModel *> *arr = [list mapObjectsUsingBlock:^id _Nonnull(TNGoodsModel *_Nonnull obj, NSUInteger idx) {
        TNBargainGoodModel *model = [TNBargainGoodModel modelWithProductModel:obj];
        return model;
    }];
    return arr;
}
@end


@implementation TNESAggsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productLabel": [TNGoodsTagModel class]};
}

@end
