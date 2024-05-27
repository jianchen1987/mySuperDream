//
//  GNSortStoreListView.m
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNSortStoreListView.h"


@implementation GNSortStoreListView

- (void)hd_setupViews {
    [super hd_setupViews];
}

- (void)pageViewDidAppear {
}

- (void)gn_getNewData {
    @HDWeakify(self);
    [self.viewModel getClassificationStoreDataCode:self.classificationCode parentCode:self.parentCode pageNum:self.tableView.pageNum
                                        completion:^(GNStorePagingRspModel *_Nonnull rspModel, BOOL error) {
                                            @HDStrongify(self);
                                            self.tableView.GNdelegate = self;
                                            if (!error) {
                                                if (self.tableView.pageNum > 1) {
                                                    [self.sectionModel.rows addObjectsFromArray:rspModel.list ?: @[]];
                                                } else {
                                                    self.sectionModel.rows = [NSMutableArray arrayWithArray:rspModel.list ?: @[]];
                                                }
                                            }
                                            !error ? [self.tableView reloadData:!rspModel.hasNextPage] : [self.tableView reloadFail];
                                        }];
}

@end
