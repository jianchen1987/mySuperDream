//
//  GNArticleDetailViewController.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDetailViewController.h"
#import "GNArticleViewModel.h"
#import "GNNaviView.h"
#import "GNStoreDetailHeadCell.h"


@interface GNArticleDetailViewController () <GNTableViewProtocol>
/// viewModel
@property (nonatomic, strong) GNArticleViewModel *viewModel;
/// tableView
@property (nonatomic, strong) GNTableView *tableView;
/// 导航栏
@property (nonatomic, strong) GNNaviView *naviView;

@end


@implementation GNArticleDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.articleCode = parameters[@"id"];
    }
    return self;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviView];
    @HDWeakify(self);
    self.tableView.tappedRefreshBtnHandler = self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self gn_getNewData];
    };
}

- (void)updateViewConstraints {
    [self.naviView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationBarH);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [super updateViewConstraints];
}

- (void)gn_getNewData {
    @HDWeakify(self)[self.viewModel getAritcleDetailWithCode:self.articleCode completion:^(GNArticleModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self) self.tableView.GNdelegate = self;
        !error ? [self.tableView reloadData:NO] : [self.tableView reloadFail];
    }];
}

#pragma mark respondEvent
- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///返回
    if ([event.key isEqualToString:@"dissmiss"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    ///刷新cell
    else if ([event.key isEqualToString:@"reloadAction"]) {
        [self.tableView updateCell:nil];
    }
}

#pragma mark GNTableViewProtocol
- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    if ([rowData conformsToProtocol:@protocol(GNRowModelProtocol)]) {
        ///跳转门店
        if ([rowData.businessData isKindOfClass:GNStoreCellModel.class]) {
            GNStoreCellModel *businessData = rowData.businessData;
            [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": businessData.storeNo}];
        }
        ///跳转商品
        else if ([rowData.businessData isKindOfClass:GNProductModel.class]) {
            GNProductModel *businessData = rowData.businessData;
            [HDMediator.sharedInstance navigaveToGNStoreProductViewController:@{
                @"storeNo": businessData.storeNo,
                @"productCode": businessData.codeId,
            }];
        }
        ///其他类型
        else if ([rowData.businessData isKindOfClass:GNArticleModel.class]) {
            GNArticleModel *businessData = rowData.businessData;
            //专题页
            if ([businessData.boundType.codeId isEqualToString:GNHomeArticleBindTopic]) {
                [HDMediator.sharedInstance navigaveToGNTopicViewController:@{@"activityNo": businessData.boundContent}];
            } else {
                ///其他链接
                if (businessData.boundContent && [SAWindowManager canOpenURL:businessData.boundContent]) {
                    [SAWindowManager openUrl:businessData.boundContent withParameters:@{}];
                }
            }
        }
    }
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.detailDataSource;
}

- (GNArticleViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNArticleViewModel.new; });
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kiPhoneXSeriesSafeBottomHeight, 0);
        _tableView.provider.numberOfRowsInSection = 4;
        _tableView.delegate = self.tableView.provider;
        _tableView.dataSource = self.tableView.provider;
        _tableView.needRefreshHeader = YES;
        _tableView.needShowErrorView = YES;
        _tableView.needRefreshBTN = YES;
    }
    return _tableView;
}

- (GNNaviView *)naviView {
    if (!_naviView) {
        _naviView = GNNaviView.new;
        _naviView.rightBTN.hidden = true;
        _naviView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [_naviView.leftBTN setImage:[UIImage imageNamed:@"gn_nav_back_yuan"] forState:UIControlStateNormal];
    }
    return _naviView;
}

- (BOOL)needLogin {
    return false;
}

@end
