//
//  TNCarouselViewWrapperCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCarouselViewWrapperCellModel.h"


@implementation TNCarouselViewWrapperCellModel
+ (instancetype)modelWithType:(TNCarouselViewWrapperCellType)type list:(NSArray<SAWindowItemModel *> *)list {
    TNCarouselViewWrapperCellModel *model = TNCarouselViewWrapperCellModel.new;
    model.type = type;
    model.list = list;
    model.cellHeight = 150.0f;
    model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return model;
}
@end
