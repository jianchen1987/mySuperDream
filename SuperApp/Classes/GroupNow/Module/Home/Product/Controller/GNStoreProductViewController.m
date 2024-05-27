//
//  GNStoreProductViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreProductViewController.h"
#import "GNAlertUntils.h"
#import "GNGroupFootView.h"
#import "GNStoreDetailHeadCell.h"
#import "GNStringUntils.h"


@interface GNStoreProductViewController () <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) GNTableView *tableView;
/// label
@property (nonatomic, strong) HDLabel *tipLB;
/// footView
@property (nonatomic, strong) GNGroupFootView *footView;

@end


@implementation GNStoreProductViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadUI];
}

- (void)loadUI {
    @HDWeakify(self) if (!self.tableView.refresh) {
        [self.viewModel getProductDetailStoreNo:self.productNo completion:^{
            @HDStrongify(self)[self getCommentList];
            self.footView.hidden = NO;
            [self.view setNeedsUpdateConstraints];
            self.footView.productModel = self.viewModel.productModel;
            if (self.viewModel.productModel) {
                NSString *tip = nil;
                if ([self.viewModel.productModel.productStatus.codeId isEqualToString:GNProductStatusDown]) {
                    tip = GNLocalizedString(@"gn_product_down", @"产品已经下架啦");
                } else {
                    if (!self.viewModel.productModel.isTermOfValidity) {
                        tip = GNLocalizedString(@"gn_not_within", @"产品不在有效期内");
                    } else {
                        if (self.viewModel.productModel.isSoldOut) {
                            tip = GNLocalizedString(@"gn_product_sold_out", @"产品已售罄");
                        }
                    }
                }
                self.tipLB.text = tip;
                self.tipLB.hidden = !tip;
            } else {
                self.tipLB.hidden = YES;
            }
            if (self.viewModel.productModel) {
                self.tableView.GNdelegate = self;
                [self.tableView reloadData];
            }
        }];
    }
    else {
        self.footView.hidden = NO;
        [self.view setNeedsUpdateConstraints];
        self.footView.productModel = self.viewModel.productModel;
    }
}

/// 获取评论
- (void)getCommentList {
    @HDWeakify(self);
    [self.viewModel getStoreReviewStoreNo:self.storeNo productCode:self.productNo pageNum:self.tableView.pageNum completion:^(GNCommentPagingRspModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        if (!error) {
            if (!rspModel.total) {
                if (self.tableView.needRefreshFooter)
                    self.tableView.needRefreshFooter = NO;
            } else {
                if (!self.tableView.needRefreshFooter)
                    self.tableView.needRefreshFooter = YES;
            }
            [self.tableView reloadData:!rspModel.hasNextPage];
        }
    }];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    self.view.backgroundColor = HDAppTheme.color.gn_mainBgColor;
}

- (void)updateViewConstraints {
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.footView.isHidden) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        if (!self.footView.isHidden) {
            make.bottom.equalTo(self.footView.mas_top);
        } else {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];

    [super updateViewConstraints];
}

- (void)hd_setupViews {
    @HDWeakify(self);
    [self.view addSubview:self.footView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tipLB];
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self getCommentList];
    };
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [self.parentViewController respondEvent:event];
    /// 全文
    if ([event.key isEqualToString:@"reloadAction"]) {
        [self.tableView reloadData];
    }
    ///导航
    else if ([event.key isEqualToString:@"navigationAction"]) {
        [GNAlertUntils navigation:self.viewModel.productModel.storeName.desc lat:self.viewModel.productModel.geoPointDTO.lat.doubleValue lon:self.viewModel.productModel.geoPointDTO.lon.doubleValue];
    }
    ///跳转地图
    else if ([event.key isEqualToString:@"mapAction"]) {
        [HDMediator.sharedInstance navigaveToGNStoreMapViewController:@{@"storeNo": self.storeNo}];
    }
}

#pragma mark GNTableViewProtocol
- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.dataSource;
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.topSop = YES;
        _tableView.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return (id)[GNStoreDetailHeadCell cellWithTableView:tableview];
            } else {
                return [GNTableViewCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [GNStoreDetailHeadCell skeletonViewHeight];
            } else {
                return [GNTableViewCell skeletonViewHeight];
            }
        }];
        _tableView.provider.numberOfRowsInSection = 10;
        _tableView.delegate = self.tableView.provider;
        _tableView.dataSource = self.tableView.provider;
        _tableView.needRefreshFooter = YES;
    }
    return _tableView;
}

- (GNStoreProductViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNStoreProductViewModel.new; });
}

- (HDLabel *)tipLB {
    if (!_tipLB) {
        _tipLB = HDLabel.new;
        _tipLB.textColor = HDAppTheme.color.gn_whiteColor;
        _tipLB.font = HDAppTheme.font.gn_14;
        _tipLB.backgroundColor = HDAppTheme.color.gn_333Color;
        _tipLB.hidden = YES;
        _tipLB.alpha = 0.4;
        _tipLB.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLB;
}

- (BOOL)needClose {
    return YES;
}

- (GNGroupFootView *)footView {
    if (!_footView) {
        _footView = GNGroupFootView.new;
        _footView.hidden = YES;
    }
    return _footView;
}

@end
