//
//  TNMoreViewController.m
//  SuperApp
//
//  Created by seeu on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNMoreViewController.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "TNMicroShopDTO.h"
#import "TNMoreTableHeaderView.h"
#import "TNMoreViewModel.h"
#import "WMMenuNavView.h"


@interface TNMoreViewController () <UITableViewDelegate, UITableViewDataSource>
/// tableview
@property (nonatomic, strong) SATableView *tableView;
/// dataSource
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// headView
@property (nonatomic, strong) TNMoreTableHeaderView *headView;
/// viewmodel
@property (nonatomic, strong) TNMoreViewModel *viewModel;
/// 头部背景
@property (nonatomic, strong) UIView *headerViewBgView;
/// 电商卖家DTO
@property (strong, nonatomic) TNMicroShopDTO *microShopDTO;
@end


@implementation TNMoreViewController
- (void)hd_setupViews {
    self.viewModel = TNMoreViewModel.new;
    self.view.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self.view addSubview:self.headerViewBgView];
    [self.view addSubview:self.tableView];
}
- (void)hd_setupNavigation {
    self.hd_navBackgroundColor = HDAppTheme.TinhNowColor.C1;
}

- (void)updateViewConstraints {
    [self.headerViewBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.centerX.width.equalTo(self.headView);
        make.bottom.equalTo(self.headView);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"isSeller" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self->_dataSource = nil;
        if (self.viewModel.isSeller && HDIsStringEmpty([TNGlobalData shared].seller.supplierId)) {
            [self queryTinhnowUserSellerData];
        }
        [self addIsSellerData];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

#pragma mark -电商查询用户卖家信息
- (void)queryTinhnowUserSellerData {
    if (![SAUser hasSignedIn]) {
        return;
    }
    @HDWeakify(self);
    [self.microShopDTO queryMyMicroShopInfoDataSuccess:^(TNSeller *_Nonnull info) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(info.supplierId)) {
            //获取加价策略
            [self.microShopDTO querySellPricePolicyWithSupplierId:info.supplierId success:^(TNMicroShopPricePolicyModel *_Nonnull policyModel) {
                [TNGlobalData shared].seller.pricePolicyModel = policyModel;
            } failure:nil];
        }
    } failure:nil];
}
- (void)hd_getNewData {
    if ([SAUser hasSignedIn]) {
        [self.viewModel getTinhNowUserInfo];
    }
}
//创建分销微店的数据
- (void)addIsSellerData {
    HDTableViewSectionModel *section = [[HDTableViewSectionModel alloc] init];
    SAInfoViewModel *infoModel;
    NSMutableArray<SAInfoViewModel *> *array = [NSMutableArray array];
    if ([SAUser hasSignedIn] && self.viewModel.isSeller) {
        infoModel = SAInfoViewModel.new;
        infoModel.keyText = TNLocalizedString(@"tn_more_my_shop_tips", @"我的微店");
        infoModel.leftImage = [UIImage imageNamed:@"tinhnow-my-shop"];
        infoModel.lineWidth = 0;
        infoModel.associatedObject = @{@"route": @"SuperApp://TinhNow/SupplyAndMarketingShop"};
        [self configInfoViewModel:infoModel];
        [array addObject:infoModel];
    } else {
        /// 卖家申请入口
        infoModel = SAInfoViewModel.new;
        infoModel.keyText = TNLocalizedString(@"Pp4hJo9S", @"卖家申请");
        infoModel.leftImage = [UIImage imageNamed:@"tn_seller_apply"];
        infoModel.lineWidth = 0;
        infoModel.associatedObject = @{@"route": @"SuperApp://TinhNow/SellerApply"};
        [self configInfoViewModel:infoModel];
        [array addObject:infoModel];
    }
    section.list = [NSArray arrayWithArray:array];
    //插入到第一栏
    [self.dataSource insertObject:section atIndex:1];
}
//配置样式数据
- (void)configInfoViewModel:(SAInfoViewModel *)infoViewModel {
    infoViewModel.keyFont = HDAppTheme.font.standard3;
    infoViewModel.keyColor = HDAppTheme.TinhNowColor.G2;
    infoViewModel.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
    infoViewModel.leftImageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(10));
    infoViewModel.contentEdgeInsets = UIEdgeInsetsMake(16, 15, 16, 15);
    infoViewModel.lineEdgeInsets = UIEdgeInsetsMake(0, 46, 0, 14);
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard2Bold;
    model.marginToBottom = kRealWidth(10);
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return section < 0 ? CGFLOAT_MIN : 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAInfoViewModel *model = self.dataSource[indexPath.section].list[indexPath.row];
    SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAInfoViewModel *model = self.dataSource[indexPath.section].list[indexPath.row];
    NSDictionary *params = model.associatedObject;
    if ([SAUser hasSignedIn]) {
        [SAWindowManager openUrl:[params valueForKey:@"route"] withParameters:nil];
    } else {
        NSNumber *noLogin = [params valueForKey:@"noLogin"];
        if ([noLogin boolValue] == YES) {
            [SAWindowManager openUrl:[params valueForKey:@"route"] withParameters:nil];
        } else {
            [SAWindowManager switchWindowToLoginViewController];
        }
    }
}
#pragma mark - nav config
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}
#pragma mark - lazy load
/** @lazy tableView */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.bounces = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.tableHeaderView = self.headView;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:6];

        HDTableViewSectionModel *section = HDTableViewSectionModel.new;
        SAInfoViewModel *infoModel = SAInfoViewModel.new;
        NSMutableArray<SAInfoViewModel *> *array = [[NSMutableArray alloc] initWithCapacity:3];

        /// group 1
        infoModel.keyText = SALocalizedString(@"tn_my_collection", @"My Collection");
        infoModel.leftImage = [UIImage imageNamed:@"tinhnow-ic-more-collection"];

        infoModel.associatedObject = @{@"route": @"SuperApp://TinhNow/myFavorites"};
        //        [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowProductFavorite]
        [self configInfoViewModel:infoModel];
        [array addObject:infoModel];

        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"tn_my_review", @"My Evaluation");
        infoModel.leftImage = [UIImage imageNamed:@"tinhnow-ic-more-evaluation"];
        infoModel.lineWidth = 0;
        infoModel.associatedObject = @{@"route": @"SuperApp://TinhNow/myReviews"};
        [self configInfoViewModel:infoModel];
        [array addObject:infoModel];
        section.list = [NSArray arrayWithArray:array];
        [_dataSource addObject:section];

        /// group 3
        [array removeAllObjects];
        section = HDTableViewSectionModel.new;

        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"tn_receiving_address", @"Receiving Address");
        infoModel.leftImage = [UIImage imageNamed:@"tinhnow-ic-more-receiving"];
        infoModel.lineWidth = 0;
        infoModel.associatedObject = @{@"route": @"SuperApp://SuperApp/revceivingAddressList"};
        [self configInfoViewModel:infoModel];
        [array addObject:infoModel];
        section.list = [NSArray arrayWithArray:array];
        [_dataSource addObject:section];

        /// gourp4
        [array removeAllObjects];
        section = HDTableViewSectionModel.new;

        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"my_coupons", @"我的优惠券");
        infoModel.leftImage = [UIImage imageNamed:@"tinhnow_more_coupon"];
        infoModel.lineWidth = 0;
        infoModel.associatedObject = @{@"route": @"SuperApp://SuperApp/businessCouponList?businessLine=TinhNow&showFilterBar=1&couponState=11"};
        [self configInfoViewModel:infoModel];
        [array addObject:infoModel];
        section.list = [NSArray arrayWithArray:array];
        [_dataSource addObject:section];

        /// gourp5
        [array removeAllObjects];
        section = HDTableViewSectionModel.new;

        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"help_center", @"帮助中心");
        infoModel.leftImage = [UIImage imageNamed:@"tn_more_help_center"];
        infoModel.lineWidth = 0;
        infoModel.associatedObject = @{@"route": [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowHelpCenter], @"noLogin": @(YES)};
        [self configInfoViewModel:infoModel];
        [array addObject:infoModel];
        section.list = [NSArray arrayWithArray:array];
        [_dataSource addObject:section];

        /// gourp6
        [array removeAllObjects];
        section = HDTableViewSectionModel.new;
        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.leftImage = [UIImage imageNamed:@"tn_telegram_k"];
        infoModel.keyText = TNLocalizedString(@"tn_jion_telegram", @"加入Telegram群获取更多优惠");
        infoModel.lineWidth = 0;
        infoModel.enableTapRecognizer = YES;
        [self configInfoViewModel:infoModel];
        infoModel.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveTinhNowTelegramGroupViewController:@{}];
        };
        [array addObject:infoModel];
        section.list = [NSArray arrayWithArray:array];
        [_dataSource addObject:section];
    }
    return _dataSource;
}

/** @lazy headView */
- (TNMoreTableHeaderView *)headView {
    if (!_headView) {
        _headView = [[TNMoreTableHeaderView alloc] initWithViewModel:self.viewModel];
        _headView.myBargainClickCallBack = ^{
            [SAWindowManager openUrl:@"SuperApp://TinhNow/myBargainRecord" withParameters:nil];
        };
        _headView.myJoinGroupClickCallBack = ^{
            if ([SAUser hasSignedIn]) {
                [SAWindowManager openUrl:[[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowMyGroupBuy] withParameters:nil];
            } else {
                [SAWindowManager switchWindowToLoginViewController];
            }
        };
    }
    return _headView;
}
- (UIView *)headerViewBgView {
    if (!_headerViewBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _headerViewBgView = view;
    }
    return _headerViewBgView;
}
/** @lazy microShopDTO */
- (TNMicroShopDTO *)microShopDTO {
    if (!_microShopDTO) {
        _microShopDTO = [[TNMicroShopDTO alloc] init];
    }
    return _microShopDTO;
}
@end
