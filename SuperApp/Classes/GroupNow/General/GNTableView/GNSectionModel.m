//
//  GNSectionModel.m
//  SuperApp
//
//  Created by wGN on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSectionModel.h"


@implementation GNSectionModel

GNSectionModel *addSection(GNSectionModelBlock block) {
    return [GNSectionModel addSection:block];
}

+ (GNSectionModel *)addSection:(nullable GNSectionModelBlock)block {
    GNSectionModel *sectionModel = [[GNSectionModel alloc] init];
    if (block) {
        block(sectionModel);
    }
    return sectionModel;
}

- (instancetype)init {
    if (self = [super init]) {
        self.headerClass = GNTableHeaderFootView.class;
        self.footerClass = GNTableHeaderFootView.class;
        self.headerHeight = 0.01;
        self.footerHeight = 0.01;
        self.headerModel = GNTableHeaderFootViewModel.new;
        self.footerModel = GNTableHeaderFootViewModel.new;
        self.headerModel.backgroundColor = UIColor.whiteColor;
        self.footerModel.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (NSMutableArray<id<GNRowModelProtocol>> *)rows {
    if (!_rows) {
        _rows = [NSMutableArray new];
    }
    return _rows;
}
@end
