//
//  WMFreeDeleviryStoreListView.m
//  SuperApp
//
//  Created by wmz on 2023/2/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMFreeDeleviryStoreListView.h"

@implementation WMFreeDeleviryStoreListView

- (void)wm_getListData {
    @HDWeakify(self);
    CGPoint position = [self getPosition];
    [self.storeDTO getDeliveryFeeStoreListLongitude:@(position.y).stringValue latitude:@(position.x).stringValue pageSize:10 pageNum:self.tableView.pageNum param:self.columnModel.param success:^(WMQueryNearbyStoreRspModel *rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (self.tableView.pageNum == 1) {
            self.dataSource = NSMutableArray.new;
        }
        [self.dataSource addObjectsFromArray:rspModel.list];
        [self.tableView reloadData:!rspModel.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self dismissLoading];
        [self.tableView reloadFail];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
