//
//  SAMineView.m
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMineView.h"
#import "LKDataRecord.h"
#import "SACMSCardTableViewCell.h"
#import "SACMSCardView.h"
#import "SAInfoTableViewCell.h"
#import "SAMineHeaderView.h"
#import "SAMineTicketInfoTableViewCell.h"
#import "SAMineViewModel.h"
#import "SATableView.h"
#import <HDUIKit/HDTableHeaderFootView.h>
#import <HDUIKit/HDTableViewSectionModel.h>

//#define kHeaderViewBgViewHeight (iPhoneXSeries ? 166 : 142)


@interface SAMineView () <UITableViewDelegate, UITableViewDataSource>
/// 头部
@property (nonatomic, strong) SAMineHeaderView *headerView;
/// 头部背景
@property (nonatomic, strong) UIImageView *headerViewBgView;
@property (nonatomic, strong) UIView *container;            ///< 容器
@property (nonatomic, strong) UIImageView *containerBgView; ///< 容器背景
/// 列表
@property (nonatomic, strong) SATableView *tableView;
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// VM
@property (nonatomic, strong) SAMineViewModel *viewModel;
/// 语言切换
@property (nonatomic, assign) BOOL isChangeLanguage;
@property (nonatomic, assign) UIEdgeInsets edgeInst; ///< 内边距

///< 浮动窗口
@property (nonatomic, strong) SACMSFloatWindowPluginView *floatWindow;

@end


@implementation SAMineView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.edgeInst = UIEdgeInsetsMake(0, 0, 0, 0);

    [self addSubview:self.headerViewBgView];
    [self addSubview:self.headerView];
    [self addSubview:self.container];
    [self.container addSubview:self.containerBgView];
    [self.container addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };

    [self.tableView registerEndScrollinghandler:^{
        @HDStrongify(self);
        if (!self.tableView.isScrolling && !HDIsObjectNil(self.floatWindow)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //停止滚动的时候  展开购物车
                [self.floatWindow expand];
            });
        }
    } withKey:@"CMSPluginFloatWindow"];
}

- (void)getNewData {
    @HDWeakify(self);
    [self.viewModel getNewData:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:true];
    }];
}

- (void)hd_languageDidChanged {
    if (self.isChangeLanguage) {
        [self getNewData];
    }
    self.isChangeLanguage = true;
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewAndTableHeaderView)(void) = ^void(void) {
        @HDStrongify(self);
        self.dataSource = self.viewModel.dataSource;
        [self.tableView successGetNewDataWithNoMoreData:true];

        if (SAUser.hasSignedIn) {
            if (!HDIsObjectNil(self.viewModel.userInfoRspModel)) {
                [self.headerView updateInfoWithModel:self.viewModel.userInfoRspModel];
            } else {
                // 请求还没回来，先用缓存数据
                [self.headerView updateInfoWithNickName:SAUser.shared.nickName headUrl:SAUser.shared.headURL pointBalance:SAUser.shared.pointBalance];
            }
        } else {
            [self.headerView updateInfoWithModel:nil];
        }
    };

    reloadTableViewAndTableHeaderView();

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        reloadTableViewAndTableHeaderView();
    }];
    [self.KVOController hd_observe:self.viewModel keyPath:@"userInfoRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        SAGetUserInfoRspModel *userInfo = change[NSKeyValueChangeNewKey];
        @HDStrongify(self);
        [self.headerView updateInfoWithModel:userInfo];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"signinActivityEntranceUrl" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        NSString *url = change[NSKeyValueChangeNewKey];
        [self.headerView updateSigninEntrance:url];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"contentInsets" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!UIEdgeInsetsEqualToEdgeInsets(self.edgeInst, self.viewModel.contentInsets)) {
            self.edgeInst = self.viewModel.contentInsets;
            [self setNeedsUpdateConstraints];
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"bgColor" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.viewModel.bgColor) {
            self.container.backgroundColor = self.viewModel.bgColor;
        } else {
            self.container.backgroundColor = HDAppTheme.color.G5;
        }
        [self setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"bgImageUrl" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.viewModel.bgImageUrl)) {
            [HDWebImageManager setImageWithURL:self.viewModel.bgImageUrl placeholderImage:nil imageView:self.containerBgView];
        } else {
            self.containerBgView.image = nil;
        }
        [self setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"plugins" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(self.viewModel.plugins)) {
            [self generatePlugins:self.viewModel.plugins];
        } else {
            if (self.floatWindow) {
                [self.floatWindow removeFromSuperview];
                self.floatWindow = nil;
            }
        }
    }];
}

- (void)updateConstraints {
    CGFloat headerViewBgViewHeight = kNavigationBarH + kRealWidth(55) + kRealWidth(15) * 2 - kRealWidth(7);

    [self.headerViewBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(headerViewBgViewHeight);
    }];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerViewBgView);
    }];

    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerViewBgView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];

    [self.containerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.edgeInst);
    }];
    [super updateConstraints];
}

#pragma mark - private methods
- (void)generatePlugins:(NSArray<SACMSPluginViewConfig *> *)plugins {
    NSArray<SACMSPluginViewConfig *> *floatWindowPluginFilter = [plugins hd_filterWithBlock:^BOOL(SACMSPluginViewConfig *_Nonnull item) {
        return [item.modleLable isEqualToString:CMSPluginIdentifyFloatWindow];
    }];

    if (floatWindowPluginFilter.count) {
        if (self.floatWindow && [self.floatWindow.config isEqual:floatWindowPluginFilter.firstObject]) {
            //            HDLog(@"浮动窗口已经存在，且配置相等，不再重新创建");
        } else {
            if (!self.floatWindow) {
                self.floatWindow = [[SACMSFloatWindowPluginView alloc] initWithConfig:floatWindowPluginFilter.firstObject];
                [self addSubview:self.floatWindow];
                [self bringSubviewToFront:self.floatWindow];
            } else {
                self.floatWindow.config = floatWindowPluginFilter.firstObject;
            }

            self.floatWindow.clickedHander = ^(SACMSPluginViewConfig *_Nonnull config) {
                [LKDataRecord.shared traceClickEvent:HDIsStringNotEmpty(config.pluginName) ? config.pluginName : @"" parameters:@{} SPM:[LKSPM SPMWithPage:@"" area:@"" node:@""]];
            };
        }
    } else {
        if (self.floatWindow) {
            [self.floatWindow removeFromSuperview];
            self.floatWindow = nil;
        }
    }
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
        SAMineTicketInfoTableViewCell *cell = [SAMineTicketInfoTableViewCell cellWithTableView:tableView];
        SACouponInfoRspModel *trueModel = (SACouponInfoRspModel *)model;
        [cell configCellWithModel:trueModel];
        cell.clipsToBounds = true;
        return cell;
    } else if ([model isKindOfClass:SACMSCardTableViewCellModel.class]) {
        SACMSCardTableViewCellModel *trueModel = (SACMSCardTableViewCellModel *)model;
        SACMSCardTableViewCell *cell = [SACMSCardTableViewCell cellWithTableView:tableView];
        cell.model = trueModel;
        @HDWeakify(self);
        trueModel.cardView.refreshCard = ^(SACMSCardView *_Nonnull card) {
            @HDStrongify(self);
            [self.tableView successGetNewDataWithNoMoreData:YES];
        };
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return nil;
    if (section <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard2Bold;
    model.backgroundColor = HDAppTheme.color.G5;
    model.marginToBottom = kRealWidth(10);
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return section <= 0 ? CGFLOAT_MIN : 15;
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
        [HDMediator.sharedInstance navigaveToMyCouponsViewController:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //监听视频卡片出现播放视频
    if ([cell isKindOfClass:SACMSCardTableViewCell.class]) {
        [(SACMSCardTableViewCell *)cell startPlayer];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //监听视频卡片消失暂停视频
    if ([cell isKindOfClass:SACMSCardTableViewCell.class]) {
        [(SACMSCardTableViewCell *)cell stopPlayer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.isScrolling = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    scrollView.isScrolling = false;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!HDIsObjectNil(self.floatWindow)) {
        [self.floatWindow shrink];
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

- (SAMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = SAMineHeaderView.new;
        _headerView.tapEventHandler = ^{
            if (SAUser.hasSignedIn) {
                [HDMediator.sharedInstance navigaveToMyInfomationController:nil];
            } else {
                [SAWindowManager switchWindowToLoginViewController];
            }
        };
    }
    return _headerView;
}

- (UIImageView *)headerViewBgView {
    if (!_headerViewBgView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 166)];
        imageView.image = [UIImage imageNamed:@"mine_header_bg"];
        _headerViewBgView = imageView;
    }
    return _headerViewBgView;
}

- (UIView *)container {
    if (!_container) {
        _container = UIView.new;
        _container.backgroundColor = HDAppTheme.color.G5;
    }
    return _container;
}

- (UIImageView *)containerBgView {
    if (!_containerBgView) {
        _containerBgView = UIImageView.new;
    }
    return _containerBgView;
}

@end
