//
//  WMNewFreeDeleviryStoreListView.m
//  SuperApp
//
//  Created by Tia on 2023/7/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewFreeDeleviryStoreListView.h"


@implementation WMNewFreeDeleviryStoreListView

- (void)wm_getListData {
    @HDWeakify(self);
    CGPoint position = [self getPosition];
    [self.storeDTO getDeliveryFeeStoreListLongitude:@(position.y).stringValue latitude:@(position.x).stringValue pageSize:10 pageNum:self.tableView.pageNum param:self.columnModel.param
        success:^(WMQueryNearbyStoreRspModel *rspModel) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([model isKindOfClass:WMStoreModel.class]) {
        WMStoreModel *trueModel = (WMStoreModel *)model;
        NSMutableDictionary *params = NSMutableDictionary.dictionary;
        params[@"storeNo"] = trueModel.storeNo;
        params[@"storeName"] = trueModel.storeName.desc;
        params[@"funnel"] = @"首页";
        ///付费商家点击
        if (trueModel.payFlag) {
            [LKDataRecord.shared traceEvent:@"sortClickStore" name:@"sortClickStore" parameters:@{@"plateId": trueModel.uuid, @"storeNo": trueModel.storeNo} SPM:nil];
            params[@"payFlag"] = trueModel.uuid;
        }
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"NEARBY"} SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
        ///普通门店点击 3.0.16.0
        [LKDataRecord.shared traceEvent:@"merchantClick" name:@"merchantClick"
                             parameters:@{@"type": @"merchantClick", @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000], @"iocntype": self.iocntype}
                                    SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];

        if (self.columnModel.param) {
            //新列表商品埋点、新店开业、免配送费
            NSMutableDictionary *params = @{@"storeNo": trueModel.storeNo, @"exposureSort": @(indexPath.row).stringValue, @"plateId": WMManage.shareInstance.plateId}.mutableCopy;

            [params addEntriesFromDictionary:self.columnModel.param];
            //品牌商家
            if ([params[@"type"] isEqualToString:@"brand"]) {
                params[@"type"] = @"brandList";
            }
            //免配送费
            if ([params[@"type"] isEqualToString:@"deliveryFee"]) {
                params[@"type"] = @"freeDeliveryFee";
            }

            [LKDataRecord.shared traceEvent:@"takeawayStoreClick" name:@"takeawayStoreClick" parameters:params SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreModel.class]) {
        WMStoreModel *itemModel = model;
        ///付费曝光
        [tableView recordExposureCountWithModel:model indexPath:indexPath position:1];
        ///普通门店曝光
        [tableView recordNormalStoreExposureCountWithModel:model indexPath:indexPath iocntype:self.iocntype];

        //新列表埋点、新店开业、免配送费
        if (self.columnModel.param) {
            NSMutableDictionary *params = @{
                @"exposureSort": @(indexPath.row).stringValue,
                @"storeNo": itemModel.storeNo,
                @"plateId": WMManage.shareInstance.plateId,
            }
                                              .mutableCopy;
            [params addEntriesFromDictionary:self.columnModel.param];
            [params addEntriesFromDictionary:self.columnModel.param];

            //品牌商家
            if ([params[@"type"] isEqualToString:@"brand"]) {
                params[@"type"] = @"brandList";
            }
            //免配送费
            if ([params[@"type"] isEqualToString:@"deliveryFee"]) {
                params[@"type"] = @"freeDeliveryFee";
            }

            [tableView recordStoreExposureCountWithValue:itemModel.storeNo key:itemModel.mShowTime indexPath:indexPath info:params eventName:@"takeawayStoreExposure"];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
