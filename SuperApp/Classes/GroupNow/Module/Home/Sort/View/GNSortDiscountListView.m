//
//  GNSortDiscountListView.m
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNSortDiscountListView.h"
#import "HDMediator+GroupOn.h"


@implementation GNSortDiscountListView

- (void)gn_getNewData {
    @HDWeakify(self);
    [self.viewModel getClassificatioProductDataCode:self.classificationCode parentCode:self.parentCode pageNum:self.tableView.pageNum
                                         completion:^(GNProductPagingRspModel *_Nonnull rspModel, BOOL error) {
                                             @HDStrongify(self);
                                             if (!error) {
                                                 if (self.tableView.pageNum > 1) {
                                                     [self.sectionModel.rows addObjectsFromArray:rspModel.list ?: @[]];
                                                 } else {
                                                     self.sectionModel.rows = [NSMutableArray arrayWithArray:rspModel.list ?: @[]];
                                                 }
                                             }
                                             self.tableView.GNdelegate = self;
                                             !error ? [self.tableView reloadData:!rspModel.hasNextPage] : [self.tableView reloadFail];
                                         }];
}

- (Class)classOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return NSClassFromString(@"GNArticleDetailProductCell");
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    GNProductModel *model = (GNProductModel *)rowData;
    [HDMediator.sharedInstance navigaveToGNStoreProductViewController:@{
        @"storeNo": model.storeNo,
        @"productCode": model.codeId,
    }];
}

@end
