//
//  PNBillSupplierListView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillSupplierListView.h"
#import "HDSearchBar.h"
#import "PNBillSupplierInfoModel.h"
#import "PNBillSupplierItemCell.h"
#import "PNBillSupplierListViewModel.h"
#import "PNTableView.h"
#import "PNToQueryModel.h"


@interface PNBillSupplierListView () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (nonatomic, strong) PNBillSupplierListViewModel *viewModel;
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, strong) NSString *keyWord;
@end


@implementation PNBillSupplierListView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.viewModel getBillerSupplierList];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}

- (void)hd_setupViews {
    [self addSubview:self.searchBar];
    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(kRealWidth(5));
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [super updateConstraints];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.showDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBillSupplierItemCell *cell = [PNBillSupplierItemCell cellWithTableView:tableView];
    PNBillSupplierInfoModel *model = [self.viewModel.showDataSourceArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBillSupplierInfoModel *model = [self.viewModel.showDataSourceArray objectAtIndex:indexPath.row];
    PNToQueryModel *toModel = [[PNToQueryModel alloc] init];
    toModel.customerCode = @"";
    toModel.paymentCategory = self.viewModel.paymentCategory;
    toModel.payTo = [NSString stringWithFormat:@"%@-%@", model.payeeMerNo, model.payeeMerName];
    toModel.apiCredential = model.apiCredential;
    toModel.billerCode = model.payeeMerNo;
    NSDictionary *dict = [toModel yy_modelToJSONObject];
    [HDMediator.sharedInstance navigaveToPayNowQueryWaterPaymentVC:dict];
}

#pragma mark
#pragma mark - HDSearchBarDelegate
NS_INLINE NSString *fixedKeywordWithOriginalKeyword(NSString *originalKeyword) {
    // 去除两端空格
    NSString *keyWord = [originalKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [keyWord copy];
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:true animated:true];
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchListForKeyWord:searchText];
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    [self searchListForKeyWord:textField.text];
    return YES;
}

#pragma mark
- (void)searchListForKeyWord:(NSString *)key {
    HDLog(@"search: %@", key);
    NSString *keyStr = fixedKeywordWithOriginalKeyword(key).uppercaseString;
    if (WJIsStringEmpty(keyStr)) {
        self.viewModel.showDataSourceArray = [self.viewModel.dataSourceArray mutableCopy];
        [self.tableView successGetNewDataWithNoMoreData:NO];
    } else {
        [self.viewModel.showDataSourceArray removeAllObjects];
        /// 过滤
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"payeeMerName_search CONTAINS %@ || payeeMerNo CONTAINS %@", keyStr, keyStr];
        self.viewModel.showDataSourceArray = [NSMutableArray arrayWithArray:[self.viewModel.dataSourceArray filteredArrayUsingPredicate:predicate]];

        if (self.viewModel.showDataSourceArray.count > 0) {
            [self.tableView successGetNewDataWithNoMoreData:NO];
        } else {
            self.tableView.placeholderViewModel.title = [NSString stringWithFormat:PNLocalizedString(@"supplier_no_search_result", @"没有关于\"ac\"的搜索结果"), keyStr];
            [self.tableView failGetNewData];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = 35;
        _searchBar.showBottomShadow = false;
        [_searchBar setRightButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消")];
        _searchBar.placeHolder = PNLocalizedString(@"search_for_biller", @"搜索供应商");
        _searchBar.placeholderColor = HDAppTheme.PayNowColor.placeholderColor;
        _searchBar.inputFieldBackgrounColor = HDAppTheme.PayNowColor.cF6F6F6;
        [_searchBar setLeftButtonImage:UIImage.new];
    }
    return _searchBar;
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
        _tableView.rowHeight = UITableViewAutomaticDimension;

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;
    }
    return _tableView;
}

@end
