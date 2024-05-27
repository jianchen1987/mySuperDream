//
//  TNSearchSortFilterModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchSortFilterModel.h"


@implementation TNSearchSortFilterModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sortType = TNGoodsListSortTypeDefault; //默认为空
        self.filter = [[NSMutableDictionary alloc] init];
        self.productType = TNProductTypeAll; //默认不传
        self.keyWord = @"";
    }
    return self;
}

@end
