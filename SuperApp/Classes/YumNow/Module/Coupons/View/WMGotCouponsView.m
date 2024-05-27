//
//  WMGotCouponsView.m
//  SuperApp
//
//  Created by wmz on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMGotCouponsView.h"
#import "WMCouponsDTO.h"
#import "WMCouponsTableViewCell.h"
#import "WMManage.h"
#import "WMSearchStoreRspModel.h"
#import "WMStoreSearchResultTableViewCell.h"
#import "WMTableView.h"


@interface WMGotCouponsView () <GNTableViewProtocol>
/// tableview
@property (nonatomic, strong) WMTableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// DTO
@property (nonatomic, strong) WMCouponsDTO *DTO;

@end


@implementation WMGotCouponsView

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    self.tableView.frame = self.bounds;
}

- (void)layoutyImmediately {
    CGRect rect = self.frame;
    [self.tableView layoutIfNeeded];
    rect.size.height = MIN(kScreenHeight * 0.8, self.tableView.contentSize.height);
    self.frame = rect;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        if (self.tableView.contentSize.height > (kScreenHeight * 0.8 - kiPhoneXSeriesSafeBottomHeight)) {
            make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    ///手工领券
    if ([event.key isEqualToString:@"giveCouponAction"]) {
        WMStoreCouponDetailModel *model = event.info[@"data"];
        if ([model isKindOfClass:WMStoreCouponDetailModel.class]) {
            if (!SAUser.hasSignedIn) {
                if (self.hideBlock) {
                    self.hideBlock(YES);
                }
                [SAWindowManager switchWindowToLoginViewController];
                return;
            }
            @HDWeakify(self)
                ///已领取
                if ((model.isReceived && (model.isOver || model.isStockOut)) || model.showUse) {
                if (self.clickedConfirmBlock) {
                    self.clickedConfirmBlock(model);
                }
            }
            else {
                [self showloading];
                WMCouponActivityContentModel *sectionModel = self.rspModel.activityContents[event.indexPath.section];
                [self.DTO giveCouponWithActivityNo:sectionModel.activityNo couponNo:model.couponNo storeJoinNo:sectionModel.storeJoinNo storeNo:self.storeNo
                    success:^(WMOneClickItemResultModel *_Nonnull rspModel) {
                        @HDStrongify(self)[self dismissLoading];
                        if (rspModel.isSuccess) {
                            [NAT showToastWithTitle:nil content:WMLocalizedString(@"wm_receive_successful", @"领取成功，快去使用吧！") type:HDTopToastTypeSuccess];
                            model.showUse = YES;
                            [self.tableView reloadData];
                        } else {
                            [NAT showToastWithTitle:nil content:WMManage.shareInstance.giveCouponErrorInfo[rspModel.errorCode] type:HDTopToastTypeInfo];
                        }
                    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                        @HDStrongify(self)[self dismissLoading];
                    }];
            }
        }
    }
}

- (void)setRspModel:(WMCouponActivityModel *)rspModel {
    _rspModel = rspModel;
    self.tableView.GNdelegate = self;
    self.dataSource = NSMutableArray.new;
    int i = 0;
    for (WMCouponActivityContentModel *model in rspModel.activityContents) {
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             GNCellModel *cellModel = GNCellModel.new;
                             cellModel.cellClass = WMCouponsTitleTableViewCell.class;
                             cellModel.title = model.title;
                             if (i == 0) {
                                 cellModel.outInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(12), kRealWidth(12));
                             } else {
                                 cellModel.outInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(12), kRealWidth(12), kRealWidth(12));
                             }
                             [sectionModel.rows addObject:cellModel];
                             for (WMStoreCouponDetailModel *couponModel in model.coupons) {
                                 cellModel = GNCellModel.new;
                                 cellModel.cellClass = WMCouponsTableViewCell.class;
                                 cellModel.businessData = couponModel;
                                 [sectionModel.rows addObject:cellModel];
                             }
                         })];
        i++;
    }
    [self.tableView reloadData:YES];
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.dataSource;
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
    }
    return _tableView;
}

- (WMCouponsDTO *)DTO {
    if (!_DTO) {
        _DTO = WMCouponsDTO.new;
    }
    return _DTO;
}

@end
