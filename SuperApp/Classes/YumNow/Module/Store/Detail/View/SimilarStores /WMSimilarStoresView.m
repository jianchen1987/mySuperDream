//
//  WMSimilarStoresView.m
//  SuperApp
//
//  Created by wmz on 2022/7/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSimilarStoresView.h"
#import "WMTableView.h"
#import "WMStoreSearchResultTableViewCell.h"
#import "WMStoreDetailDTO.h"
#import "WMSearchStoreRspModel.h"


@interface WMSimilarStoresView () <GNTableViewProtocol>
/// tableview
@property (nonatomic, strong) WMTableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// DTO
@property (nonatomic, strong) WMStoreDetailDTO *DTO;

@end


@implementation WMSimilarStoresView

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    @HDWeakify(self) self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self)[self getData];
    };
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (void)setStoreNo:(NSString *)storeNo {
    _storeNo = storeNo;
    [self getData];
}

- (void)getData {
    @HDWeakify(self)[self.DTO getSimilarStoreListWithStoreNo:self.storeNo pageNum:self.tableView.pageNum success:^(WMSearchStoreRspModel *_Nonnull rspModel) {
        @HDStrongify(self) self.tableView.GNdelegate = self;
        if (self.tableView.pageNum == 1) {
            self.dataSource = [NSMutableArray arrayWithArray:rspModel.list];
        } else {
            [self.dataSource addObjectsFromArray:rspModel.list];
        }
        [self.tableView reloadData:!rspModel.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) self.tableView.GNdelegate = self;
        [self.tableView reloadFail];
    }];
}

- (Class)classOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return WMStoreSearchResultTableViewCell.class;
}

- (BOOL)xibOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return self.dataSource;
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    WMStoreListItemModel *model = (id)rowData;
    if (self.clickedConfirmBlock && [model isKindOfClass:WMStoreListItemModel.class]) {
        self.clickedConfirmBlock(model);
    }
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.needRefreshFooter = YES;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMStoreSearchResultTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [WMStoreSearchResultTableViewCell skeletonViewHeight];
        }];
        _tableView.provider.numberOfRowsInSection = 10;
        _tableView.delegate = self.tableView.provider;
        _tableView.dataSource = self.tableView.provider;
    }
    return _tableView;
}

- (WMStoreDetailDTO *)DTO {
    if (!_DTO) {
        _DTO = WMStoreDetailDTO.new;
    }
    return _DTO;
}

@end
