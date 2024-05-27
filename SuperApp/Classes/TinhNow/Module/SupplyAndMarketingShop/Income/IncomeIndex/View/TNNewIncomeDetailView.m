//
//  TNNewIncomeDetailView.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeDetailView.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "TNNewIncomeDetailViewModel.h"
#import "TNQuestionAndContactView.h"


@interface TNNewIncomeDetailView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SATableView *tableView;
@property (strong, nonatomic) HDLabel *moneyLabel;                   ///< 金额
@property (strong, nonatomic) UIView *footerView;                    ///<  底部联系视图
@property (strong, nonatomic) TNNewIncomeDetailViewModel *viewModel; ///<
@end


@implementation TNNewIncomeDetailView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.moneyLabel;
    self.moneyLabel.size = CGSizeMake(kScreenWidth, kRealWidth(100));
}
- (void)setUpFootView {
    self.footerView = [[UIView alloc] init];
    self.footerView.size = CGSizeMake(kScreenWidth, kRealWidth(130));
    self.tableView.tableFooterView = self.footerView;
    TNQuestionAndContactView *contactView = [[TNQuestionAndContactView alloc] init];
    [self.footerView addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.footerView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
    }];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.viewModel getDatailData];
    @HDWeakify(self);
    self.viewModel.incomeDetailGetDataFaild = ^{
        @HDStrongify(self);
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
        [self.tableView failGetNewData];
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.viewModel.detailModel.actualIncome.cent)) {
            if ([self.viewModel.detailModel.actualIncome.cent integerValue] > 0) {
                self.moneyLabel.text = [NSString stringWithFormat:@"%@ %@", @"+", self.viewModel.detailModel.actualIncome.thousandSeparatorAmount];
            } else {
                self.moneyLabel.text = self.viewModel.detailModel.actualIncome.thousandSeparatorAmount;
            }
        }
        [self setUpFootView];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark -delgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
    SAInfoViewModel *model = self.viewModel.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.needShowErrorView = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
/** @lazy viewModel */
- (TNNewIncomeDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNNewIncomeDetailViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy moneyLabel */
- (HDLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[HDLabel alloc] init];
        _moneyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _moneyLabel.font = [HDAppTheme.TinhNowFont fontSemibold:30];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.numberOfLines = 2;
        _moneyLabel.text = @"--";
        _moneyLabel.hd_borderPosition = HDViewBorderPositionBottom;
        _moneyLabel.hd_borderWidth = 0.5;
        _moneyLabel.hd_borderColor = HexColor(0xE4E5EA);
    }
    return _moneyLabel;
}

@end
