//
//  WalletLimitVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNWalletLimitVC.h"
#import "PNAccountViewModel.h"
#import "PNWalletLimitModel.h"
#import <JJStockView.h>
#import <MJRefresh.h>


@interface PNWalletLimitVC () <StockViewDataSource, StockViewDelegate>
@property (nonatomic, strong) PNAccountViewModel *viewModel;
@property (nonatomic, strong) SALabel *tipLabel;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) JJStockView *stockView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSArray *acountTypeDataSource;
@property (nonatomic, copy) NSDictionary *dataDic;
@end


@implementation PNWalletLimitVC

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.acountTypeDataSource = @[PNLocalizedString(@"Classic_account", @"经典账户"), PNLocalizedString(@"Advanced_account", @"高级账户"), PNLocalizedString(@"Exclusive_account", @"尊享账户")];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.stockView];
    self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Wallet_limit", @"钱包限额");
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self getData];
}

- (void)refreshData {
    [self.stockView.jjStockTableView.mj_header endRefreshing];
    [self getData];
}

- (void)getData {
    [self.viewModel getWalletLimit:^(NSArray<PNWalletLimitModel *> *_Nonnull list) {
        [self.dataSource removeAllObjects];
        self.dataSource = [NSMutableArray arrayWithArray:list];
        [self.stockView.jjStockTableView reloadData];
    }];
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kRealWidth(15));
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(15));
    }];
    [self.stockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kRealWidth(15));
        make.right.equalTo(self.view.mas_right).offset(kRealWidth(-15));
        make.top.equalTo(self.tipLabel.mas_bottom).offset(kRealWidth(15));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight - kRealWidth(15));
    }];

    [super updateViewConstraints];
}

//- (NSString *)getLeftText:(NSInteger)num Currency:(NSString *)currency {
//    switch (num) {
//        case PNLimitTypeDeposit: {
//            return [NSString stringWithFormat:@"%@(%@)", PNLocalizedString(@"Wallet_deposit_limit", @"钱包存款限额"), currency];
//        } break;
//        case PNLimitTypeConsumption: {
//            return [NSString stringWithFormat:@"%@-%@(%@)", PNLocalizedString(@"consumption", @"消费"), PNLocalizedString(@"Single_limit", @"单笔限额"), currency];
//        } break;
//        case PNLimitTypeTransfer: {
//            return [NSString stringWithFormat:@"%@-%@(%@)", PNLocalizedString(@"TRANS_TYPE_TRANSFER", @"转账"), PNLocalizedString(@"Single_limit", @"单笔限额"), currency];
//        } break;
//        case PNLimitTypeTypeSingleDay: {
//            return [NSString stringWithFormat:@"%@(%@)", PNLocalizedString(@"Single_day_limit", @"单日限额"), currency];
//        } break;
//        case PNLimitTypePaymentCode: {
//            return [NSString stringWithFormat:@"%@(%@)", PNLocalizedString(@"paymentCode_limit", @"付款码-单笔限额"), currency];
//        } break;
//        default:
//            break;
//    }
//    return @"";
//}

#pragma mark - Stock DataSource
//左列
- (NSUInteger)countForStockView:(JJStockView *)stockView {
    return self.dataSource.count;
}

//左标题
- (UIView *)titleCellForStockView:(JJStockView *)stockView atRowPath:(NSUInteger)row {
    PNWalletLimitModel *model = self.dataSource[row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50.0f)];
    //    label.text = [self getLeftText:model.bizType Currency:model.currency];
    label.text = model.bizName;
    label.textColor = HDAppTheme.PayNowColor.c343B4D;
    label.numberOfLines = 0;
    label.font = [HDAppTheme.font boldForSize:13];
    label.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//内容
- (UIView *)contentCellForStockView:(JJStockView *)stockView atRowPath:(NSUInteger)row {
    PNWalletLimitModel *model = self.dataSource[row];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100 * self.acountTypeDataSource.count + 10, 50.0f)];
    bg.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < self.self.acountTypeDataSource.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * 100, 0, 100, 50.0f)];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.font boldForSize:12];
        if (i == 2) {
            label.text = model.enjoyLevel;
        } else if (i == 1) {
            label.text = model.seniorLevel;
        } else {
            label.text = model.classicsLevel;
        }
        label.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:label];
    }
    return bg;
}

#pragma mark - Stock Delegate

- (CGFloat)heightForCell:(JJStockView *)stockView atRowPath:(NSUInteger)row {
    return 50.0f;
}

//左上角单元格
- (UIView *)headRegularTitle:(JJStockView *)stockView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50.0f)];
    label.text = PNLocalizedString(@"Limit_type", @"限额类型");
    label.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
    label.textColor = HDAppTheme.PayNowColor.c343B4D;
    label.numberOfLines = 0;
    label.font = [HDAppTheme.font boldForSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//上标题
- (UIView *)headTitle:(JJStockView *)stockView {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100 * self.acountTypeDataSource.count + 10, 50.0f)];
    bg.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
    for (int i = 0; i < self.acountTypeDataSource.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * 100, 0, 100, 50.0f)];
        label.text = self.acountTypeDataSource[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.font boldForSize:13];
        [bg addSubview:label];
    }
    return bg;
}

- (CGFloat)heightForHeadTitle:(JJStockView *)stockView {
    return 50.0f;
}

- (void)didSelect:(JJStockView *)stockView atRowPath:(NSUInteger)row {
    NSLog(@"DidSelect Row:%ld", row);
}

#pragma mark - Button Action

- (void)buttonAction:(UIButton *)sender {
    NSLog(@"Button Row:%ld", sender.tag);
}

#pragma mark - Get

- (JJStockView *)stockView {
    if (_stockView != nil) {
        return _stockView;
    }
    _stockView = [JJStockView new];
    if (@available(iOS 15.0, *)) {
        _stockView.jjStockTableView.sectionHeaderTopPadding = 0;
    }
    _stockView.backgroundColor = [UIColor clearColor];
    _stockView.dataSource = self;
    _stockView.delegate = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _stockView.jjStockTableView.mj_header = header;

    [header setTitle:PNLocalizedString(@"PN_MJ_STATE_DOWN_NORMAL", @"下拉刷新") forState:MJRefreshStateIdle];
    [header setTitle:PNLocalizedString(@"PN_MJ_STATE_DOWN_PULLING", @"放开刷新") forState:MJRefreshStatePulling];
    [header setTitle:PNLocalizedString(@"PN_MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];

    return _stockView;
}

- (SALabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = SALabel.new;
        _tipLabel.font = [HDAppTheme.font forSize:13];
        _tipLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _tipLabel.text = PNLocalizedString(@"Different_account_levels_have_different_limits", @"");
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNAccountViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = [[PNAccountViewModel alloc] init]; });
}
@end
