//
//  WMMineView.m
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMineView.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "SAWindowItemModel.h"
#import "WMMineAdvertisementCell.h"
#import "WMMineAdvertisementModel.h"
#import "WMMineHeaderView.h"
#import "WMMineTicketInfoTableViewCell.h"
#import "WMMineViewModel.h"
#import <HDUIKit/HDTableHeaderFootView.h>
#import <HDUIKit/HDTableViewSectionModel.h>


@interface WMMineView () <UITableViewDelegate, UITableViewDataSource>
/// 头部
@property (nonatomic, strong) WMMineHeaderView *headerView;
/// 头部背景
@property (nonatomic, strong) UIView *headerViewBgView;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// VM
@property (nonatomic, strong) WMMineViewModel *viewModel;
@end


@implementation WMMineView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.G5;

    [self addSubview:self.headerViewBgView];
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;

    self.headerView.hd_frameWillChangeBlock = ^CGRect(__kindof UIView *_Nonnull view, CGRect followingFrame) {
        CGRect frame = followingFrame;
        frame.origin = CGPointZero;
        return frame;
    };

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        @HDWeakify(self);
        [self.viewModel getCouponInfoAndUserInfoCompletion:^{
            @HDStrongify(self);
            [self.tableView.mj_header endRefreshing];
            [self.tableView successGetNewDataWithNoMoreData:true];
        }];
    };
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)getNewData {
    [self.tableView getNewData];
}

- (void)hd_languageDidChanged {
    [self.viewModel handleLanguageDidChanged];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewAndTableHeaderView)(void) = ^void(void) {
        @HDStrongify(self);
        self.dataSource = self.viewModel.dataSource;
        [self.tableView successGetNewDataWithNoMoreData:true];

        if (SAUser.hasSignedIn) {
            // 优先用 SAGetUserInfoRspModel
            if (!HDIsObjectNil(self.viewModel.userInfoRspModel)) {
                [self.headerView setNickName:self.viewModel.userInfoRspModel.nickName];
                [self.headerView setHeadImageWithUrl:self.viewModel.userInfoRspModel.headURL];
            } else {
                [self.headerView setNickName:self.viewModel.user.nickName];
                [self.headerView setHeadImageWithUrl:self.viewModel.user.headURL];
            }
        } else {
            [self.headerView setNickName:WMLocalizedString(@"please_sign_in", @"请登录")];
            [self.headerView setHeadImageWithUrl:nil];
        }
    };

    reloadTableViewAndTableHeaderView();

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.viewModel clearDataSource];
        reloadTableViewAndTableHeaderView();
    }];
    [self.KVOController hd_observe:self.viewModel keyPath:@"userInfoRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        SAGetUserInfoRspModel *userInfo = change[NSKeyValueChangeNewKey];
        @HDStrongify(self);
        [self.headerView setNickName:userInfo.nickName];
        [self.headerView setHeadImageWithUrl:userInfo.headURL];
    }];
}

- (void)updateConstraints {
    [self.headerViewBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.width.equalTo(self.headerView);
        make.bottom.equalTo(self.headerView);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = self.headerView.height - scrollView.contentOffset.y;
    height = height >= 0 ? height : 0;
    self.headerViewBgView.frame = CGRectMake(0, 0, self.headerViewBgView.width, height);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;

    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];

    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        trueModel.lineWidth = indexPath.row < sectionModel.list.count - 1 ? PixelOne : 0;
        cell.model = trueModel;
        cell.clipsToBounds = true;
        return cell;
    } else if ([model isKindOfClass:SACouponInfoRspModel.class]) {
        WMMineTicketInfoTableViewCell *cell = [WMMineTicketInfoTableViewCell cellWithTableView:tableView];
        SACouponInfoRspModel *trueModel = (SACouponInfoRspModel *)model;
        [cell configCellWithModel:trueModel];
        cell.clipsToBounds = true;
        return cell;
    } else if ([model isKindOfClass:WMMineAdvertisementModel.class]) {
        WMMineAdvertisementCell *cell = [WMMineAdvertisementCell cellWithTableView:tableView];
        cell.model = model;

        return cell;
    }

    return UITableViewCell.new;
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

    return section == 0 ? 30 : 15;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.section].list[indexPath.row];

    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        if (trueModel.eventHandler) {
            trueModel.eventHandler();
        } else if (trueModel.clickedValueButtonHandler) {
            trueModel.clickedValueButtonHandler();
        } else {
            NSString *routePath = trueModel.associatedObject[@"routeURL"];
            [HDMediator.sharedInstance performActionWithURL:routePath];
        }
    } else if ([model isKindOfClass:SACouponInfoRspModel.class]) {
        [HDMediator.sharedInstance navigaveToMyCouponsViewController:@{@"businessLine": SAClientTypeYumNow}];
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;

        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_tableView.mj_header;
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.textColor = [UIColor whiteColor];
        header.backgroundColor = UIColor.clearColor;
        header.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _tableView;
}

- (WMMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = WMMineHeaderView.new;
        _headerView.tapEventHandler = ^{
            if (!SAUser.hasSignedIn) {
                [SAWindowManager switchWindowToLoginViewController];
            }
        };
    }
    return _headerView;
}

- (UIView *)headerViewBgView {
    if (!_headerViewBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.color.mainColor;
        _headerViewBgView = view;
    }
    return _headerViewBgView;
}
@end
