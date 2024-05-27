//
//  WMSpecialSkeletonView.m
//  SuperApp
//
//  Created by wmz on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSpecialSkeletonView.h"
#import "HDSkeletonLayerDataSourceProvider.h"
#import "WMStoreSkeletonCell.h"
#import "WMTableView.h"


@interface WMSpecialSkeletonView () <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) WMTableView *tableView;
///骨架
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;

@end


@implementation WMSpecialSkeletonView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    @HDWeakify(self)[self.KVOController hd_observe:self.viewModel keyPath:@"type" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if ([self.viewModel.type isEqualToString:@"noData"]) {
            self.tableView.GNdelegate = self;
            [self.tableView reloadData:NO];
        } else if ([self.viewModel.type isEqualToString:@"error"]) {
            self.tableView.GNdelegate = self;
            [self.tableView reloadFail];
        } else {
            self.tableView.dataSource = self.tableView.provider;
            self.tableView.delegate = self.tableView.provider;
            [self.tableView reloadData];
        }
    }];
}

- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return @[];
}

- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarH);
    }];
    [super updateConstraints];
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self.tableView.provider;
        _tableView.delegate = self.tableView.provider;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
    }
    return _tableView;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMStoreSkeletonCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [WMStoreSkeletonCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 20;
    }
    return _provider;
}

@end
