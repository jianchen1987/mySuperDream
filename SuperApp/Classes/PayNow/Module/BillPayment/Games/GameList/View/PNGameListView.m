//
//  PNGamePaymentView.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameListView.h"
#import "PNGameDetailViewController.h"
#import "PNGameListCell.h"
#import "PNGameListViewModel.h"
#import "PNTableView.h"


@interface PNGameListView () <UITableViewDelegate, UITableViewDataSource>
///
@property (strong, nonatomic) PNGameListViewModel *viewModel;
///
@property (strong, nonatomic) UIImageView *headerImageView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 描述
@property (strong, nonatomic) UILabel *desLabel;
///
@property (strong, nonatomic) UIView *bgView;
///
@property (strong, nonatomic) PNTableView *tableView;

@end


@implementation PNGameListView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.headerImageView];
    [self.headerImageView addSubview:self.titleLabel];
    [self.headerImageView addSubview:self.desLabel];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.tableView];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.viewModel getNewData];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsObjectNil(self.viewModel.rspModel)) {
            [self updateInfoData];
            [self.tableView successGetNewDataWithNoMoreData:NO];
        } else {
            [self.tableView failGetNewData];
        }
    }];
}
- (void)updateInfoData {
    self.titleLabel.text = self.viewModel.rspModel.titleInfo.title;
    self.desLabel.text = self.viewModel.rspModel.titleInfo.desc;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.headerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(144));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.headerImageView.mas_top).offset(kRealHeight(20));
        make.right.equalTo(self.headerImageView.mas_right).offset(-kRealWidth(70));
    }];
    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealHeight(4));
        make.right.equalTo(self.headerImageView.mas_right).offset(-kRealWidth(70));
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(-kRealWidth(12));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [super updateConstraints];
}
#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.rspModel.categories.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kRealHeight(12);
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRealHeight(8);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGameListCell *cell = [PNGameListCell cellWithTableView:tableView];
    PNGameCategoryModel *model = self.viewModel.rspModel.categories[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGameCategoryModel *model = self.viewModel.rspModel.categories[indexPath.section];
    PNGameDetailViewController *vc = [[PNGameDetailViewController alloc] initWithRouteParameters:@{@"categoryId": model.gameId}];
    [SAWindowManager navigateToViewController:vc];
}
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.estimatedRowHeight = kRealHeight(80);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.needShowErrorView = YES;
        _tableView.backgroundColor = HexColor(0xF3F4FA);

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;
    }
    return _tableView;
}
/** @lazy headerImageView */
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pn_game_banner"]];
    }
    return _headerImageView;
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HexColor(0xF3F4FA);
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:16];
        };
    }
    return _bgView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.PayNowFont fontSemibold:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
/** @lazy desLabel */
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = HDAppTheme.PayNowFont.standard12;
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}
@end
