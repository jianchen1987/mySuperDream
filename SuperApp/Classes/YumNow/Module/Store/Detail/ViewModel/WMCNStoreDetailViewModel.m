//
//  WMCNStoreDetailViewModel.m
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCNStoreDetailViewModel.h"


@implementation WMCNStoreDetailViewModel

- (void)dealHeader {
}

- (void)dealData {
    @HDWeakify(self);
    void (^addStoreClosedDataSource)(void) = ^(void) {
        @HDStrongify(self);
        // 详情分组
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        if (self.isStoreClosed) {
            SANoDataCellModel *noDataModel = SANoDataCellModel.new;
            noDataModel.marginImageToTop = kRealWidth(160);
            noDataModel.image = [UIImage imageNamed:@"placeholder_store_off"];
            noDataModel.descText = self.storeClosedMsg;
            sectionModel.list = @[noDataModel];
        }
        [self.dataSource addObject:sectionModel];
    };

    if (self.isStoreClosed) {
        addStoreClosedDataSource();
    } else {
        // 如果菜单项为空或者所有菜单没有数据，展示空
        if (self.isValidMenuListEmpty) {
            SANoDataCellModel *noDataModel = SANoDataCellModel.new;
            HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
            sectionModel.list = @[noDataModel];
            [self.dataSource addObject:sectionModel];
            self.shopppingCartStoreItem = nil;
            self.payFeeTrialCalRspModel = nil;
        } else {
            for (WMStoreMenuItem *menuItem in self.menuList) {
                //按类目生成各类目模型
                HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
                sectionModel.commonHeaderModel = menuItem;
                [self.dataSource addObject:sectionModel];
            }
            double time = NSDate.date.timeIntervalSince1970;
            [self getFirstMenuGoodDataSuccess:^{
                HDLog(@"🍌首次菜单商品请求完成 %f", NSDate.date.timeIntervalSince1970 - time);
                @HDStrongify(self);
                for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                    WMStoreMenuItem *menuItem = sectionModel.commonHeaderModel;
                    HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
                    headerModel.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
                    headerModel.titleColor = HDAppTheme.WMColor.B3;
                    headerModel.backgroundColor = HDAppTheme.WMColor.bgGray;
                    headerModel.titleNumberOfLines = 0;
                    headerModel.title = menuItem.name;
                    sectionModel.headerModel = headerModel;
                    NSMutableArray *menuList = [NSMutableArray array];
                    NSInteger menuId = [menuItem.menuId integerValue];
                    for (WMStoreGoodsItem *goodItem in self.currentRequestGoods) {
                        if ([goodItem.menuIds containsObject:@(menuId)]) {
                            [menuList addObject:goodItem];
                        }
                        goodItem.storeStatus = self.detailInfoModel.storeStatus;
                        WMShoppingCartStoreItem *storeItem = self.shopppingCartStoreItem;
                        if (!self.hasInitializedOrderPayTrialCalculate && storeItem) {
                            self.shopppingCartStoreItem = storeItem;
                            [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
                            self.hasInitializedOrderPayTrialCalculate = true;
                        }
                        [self updateShoppingCartTotalCount];
                    }
                    sectionModel.list = menuList;
                }
                // 生成滚动到指定 indexPath
                [self setAutoScollerToTargetIndex];
                //设置商品的skCountModel属性
                [self setgoodItemSkuCountModel:self.currentRequestGoods];

                self.refreshFlagFirstGoods = !self.refreshFlagFirstGoods;
            }];
        }
    }
    self.hasGotInitializedData = true;
    self.refreshFlag = !self.refreshFlag;
}
@end
