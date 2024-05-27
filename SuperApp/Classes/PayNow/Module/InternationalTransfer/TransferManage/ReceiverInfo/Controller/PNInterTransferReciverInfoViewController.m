//
//  PNInterTransferReciverInfoViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferReciverInfoViewController.h"
#import "PNInterTransferReciverDTO.h"
#import "PNInterTransferReciverInfoCell.h"
#import "PNTableView.h"


@interface PNInterTransferReciverInfoViewController () <UITableViewDelegate, UITableViewDataSource, HDSearchBarDelegate>
/// 列表视图
@property (strong, nonatomic) PNTableView *tableView;
/// 原始数据源
@property (strong, nonatomic) NSArray *originaldataArr;
///
@property (strong, nonatomic) HDSearchBar *searchBar;
/// 增加按钮
@property (strong, nonatomic) PNOperationButton *addBtn;
///
@property (strong, nonatomic) PNInterTransferReciverDTO *reciverDto;
/// 是否是来选择收款人的
@property (nonatomic, assign) BOOL isChooseReciver;
///  选中回调
@property (nonatomic, copy) void (^callBack)(PNInterTransferReciverModel *model);
///  展示数据源
@property (strong, nonatomic) NSMutableArray *showDataArr;

/// json数据源  用于筛选
@property (strong, nonatomic) NSArray *jsonDictArray;

@property (nonatomic, assign) PNInterTransferThunesChannel channel;

@property (nonatomic, assign) BOOL isMore;

@end


@implementation PNInterTransferReciverInfoViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSNumber *chooseReciver = [parameters objectForKey:@"chooseReciver"];
        self.isChooseReciver = [chooseReciver boolValue];
        self.callBack = [parameters objectForKey:@"callBack"];
        self.channel = [[parameters objectForKey:@"channel"] integerValue];
        self.isMore = [[parameters objectForKey:@"more"] boolValue];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"mKw25x8s", @"收款人信息");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView getNewData];
}

- (void)getNewData {
    self.searchBar.text = @"";
    @HDWeakify(self);
    [self.reciverDto queryAllReciverListWithChannel:self.channel success:^(NSArray<PNInterTransferReciverModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self.showDataArr removeAllObjects];
        self.originaldataArr = list;
        if (!HDIsArrayEmpty(self.originaldataArr)) {
            self.jsonDictArray = [list yy_modelToJSONObject];
            [self.showDataArr addObjectsFromArray:self.originaldataArr];
        }
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.tableView failGetNewData];
    }];
}

#pragma mark -去编辑页面
- (void)extracted:(void (^)(void))callBack model:(PNInterTransferReciverModel *)model {
    [HDMediator.sharedInstance navigaveToInternationalTransferAddOrUpdateReciverInfoVC:@{
        @"callBack": callBack,
        @"reciverModel": model,
        @"channel": @(self.channel),
    }];
}

- (void)gotoEditVC:(PNInterTransferReciverModel *)model {
    @HDWeakify(self);
    void (^callBack)(void) = ^{
        @HDStrongify(self);
        [self.tableView.mj_header beginRefreshing];
    };

    [self extracted:callBack model:model];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (self.isMore) {
            make.top.mas_equalTo(self.view);
        } else {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        }
    }];

    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(12));
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(20));
        make.bottom.equalTo(self.view.mas_bottom).offset(kiPhoneXSeriesSafeBottomHeight > 0 ? -kiPhoneXSeriesSafeBottomHeight : -kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(48));
    }];

    [super updateViewConstraints];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNInterTransferReciverInfoCell *cell = [PNInterTransferReciverInfoCell cellWithTableView:tableView];
    PNInterTransferReciverModel *reciverModel = self.showDataArr[indexPath.row];
    cell.model = reciverModel;
    @HDWeakify(self);
    cell.editClickCallBack = ^{
        @HDStrongify(self);
        [self gotoEditVC:reciverModel];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PNInterTransferReciverModel *reciverModel = self.showDataArr[indexPath.row];
    if (self.isChooseReciver) {
        !self.callBack ?: self.callBack(reciverModel);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self gotoEditVC:reciverModel];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.searchBar.textField.isEditing) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark -HDSearchBar delegate
- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (HDIsArrayEmpty(self.originaldataArr)) {
        return;
    }

    if (HDIsStringNotEmpty(searchText)) {
        NSString *key = fixedKeywordWithOriginalKeyword(searchText);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS %@ || msisdn CONTAINS %@", key, key];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.jsonDictArray filteredArrayUsingPredicate:predicate]];
        [self processShowData:[NSArray yy_modelArrayWithClass:[PNInterTransferReciverModel class] json:array]];
    } else {
        [self processShowData:self.originaldataArr];
    }
}

- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar {
    [self processShowData:self.originaldataArr];
    return YES;
}

///根据数组 处理要展示的数据源
- (void)processShowData:(NSArray *)array {
    [self.showDataArr removeAllObjects];
    [self.showDataArr addObjectsFromArray:array];
    [self.tableView successGetNewDataWithNoMoreData:YES];
}

NS_INLINE NSString *fixedKeywordWithOriginalKeyword(NSString *originalKeyword) {
    // 去除两端空格
    NSString *keyWord = [originalKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [keyWord copy];
}

#pragma mark - lazy load
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = kRealWidth(40);
        _searchBar.placeholderColor = HDAppTheme.PayNowColor.c999999;
        _searchBar.textColor = HDAppTheme.PayNowColor.c333333;
        _searchBar.textFont = [HDAppTheme.PayNowFont fontMedium:14];
        _searchBar.placeHolder = PNLocalizedString(@"BTzO3MA1", @"客户名字/电话");
        _searchBar.inputFieldBackgrounColor = HDAppTheme.PayNowColor.backgroundColor;
        _searchBar.marginToSide = kRealWidth(12);
        _searchBar.size = CGSizeMake(kScreenWidth, kRealWidth(60));
    }
    return _searchBar;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self getNewData];
        };
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;
    }
    return _tableView;
}

/** @lazy oprateBtn */
- (PNOperationButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_addBtn setTitle:PNLocalizedString(@"epWpMMBj", @"新增收款人信息") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_addBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self gotoEditVC:nil];
        }];
    }
    return _addBtn;
}

//* @lazy showDataArr
- (NSMutableArray *)showDataArr {
    if (!_showDataArr) {
        _showDataArr = [NSMutableArray array];
    }
    return _showDataArr;
}

/** @lazy reciverDto */
- (PNInterTransferReciverDTO *)reciverDto {
    if (!_reciverDto) {
        _reciverDto = [[PNInterTransferReciverDTO alloc] init];
    }
    return _reciverDto;
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
