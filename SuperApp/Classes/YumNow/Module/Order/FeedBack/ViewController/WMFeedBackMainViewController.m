//
//  WMFeedBackMainViewController.m
//  SuperApp
//
//  Created by wmz on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMFeedBackMainViewController.h"
#import "WMTableView.h"


@interface WMFeedBackMainViewController () <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) WMTableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *dataSource;
/// 历史
@property (nonatomic, strong) HDUIButton *historyBTN;
/// tipLB
@property (nonatomic, strong) HDLabel *tipLB;
/// tipBg
@property (nonatomic, strong) UIView *tipBg;

@end


@implementation WMFeedBackMainViewController

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.WMColor.bgGray;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tipBg];
    [self.tipBg addSubview:self.tipLB];
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"wm_order_feedback_title", @"Order Feedback");
    self.hd_backButtonImage = [UIImage imageNamed:@"yn_home_back"];
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.historyBTN];
    self.historyBTN.hidden = ![self.parameters[@"hasPostSale"] boolValue];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_bindViewModel {
    self.dataSource = NSMutableArray.new;
    [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                         GNCellModel *cellModel = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                         cellModel.title = WMLocalizedString(@"wm_order_feedback_processing_method", @"Expectation Handling Style");
                         cellModel.outInsets = UIEdgeInsetsMake(kRealWidth(12), 0, kRealWidth(12), 0);
                         cellModel.backgroundColor = HDAppTheme.WMColor.bgGray;
                         [sectionModel.rows addObject:cellModel];
                     })];
    self.tipBg.hidden = [self.parameters[@"showChange"] boolValue];
    if ([self.parameters[@"showChange"] boolValue]) {
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             sectionModel.cornerRadios = kRealWidth(8);
                             sectionModel.footerHeight = kRealWidth(12);
                             sectionModel.footerModel.backgroundColor = HDAppTheme.WMColor.bgGray;
                             GNCellModel *model = [GNCellModel createClass:@"WMFeedBackMainCell"];
                             model.title = WMLocalizedString(@"wm_order_feedback_exchange", @"Exchange Food");
                             model.tag = WMOrderFeedBackPostChange;
                             model.image = [UIImage imageNamed:@"yn_order_feedback_food"];
                             model.detail = WMLocalizedString(@"wm_order_feedback_apply_30_minutes", @"Applications are available within 30 minutes of order completion");
                             [sectionModel.rows addObject:model];
                         })];
    }

    [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                         sectionModel.cornerRadios = kRealWidth(8);
                         sectionModel.footerHeight = kRealWidth(12);
                         sectionModel.footerModel.backgroundColor = HDAppTheme.WMColor.bgGray;
                         GNCellModel *model = [GNCellModel createClass:@"WMFeedBackMainCell"];
                         model.title = WMLocalizedString(@"wm_order_feedback_refund", @"Refund");
                         model.tag = WMOrderFeedBackPostRefuse;
                         model.image = [UIImage imageNamed:@"yn_order_feedback_refund"];
                         [sectionModel.rows addObject:model];
                     })];

    [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                         sectionModel.cornerRadios = kRealWidth(8);
                         GNCellModel *model = [GNCellModel createClass:@"WMFeedBackMainCell"];
                         model.title = WMLocalizedString(@"wm_order_feedback_other", @"Other Appeals");
                         model.tag = WMOrderFeedBackPostOther;
                         model.image = [UIImage imageNamed:@"yn_order_feedback_other"];
                         [sectionModel.rows addObject:model];
                     })];
    [self.view setNeedsUpdateConstraints];
    [self.tableView reloadData];
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.dataSource;
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    GNCellModel *model = rowData;
    if ([model isKindOfClass:GNCellModel.class]) {
        [HDMediator.sharedInstance
            navigaveToSubmitFeedBackViewController:@{@"orderNo": self.parameters[@"orderNo"], @"model": model, @"type": model.tag, @"hasPostSale": self.parameters[@"hasPostSale"]}];
    }
}

- (void)updateViewConstraints {
    [self.tipBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipBg.isHidden) {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.mas_equalTo(0);
        }
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipBg.isHidden) {
            make.top.mas_equalTo(kRealWidth(8));
            make.bottom.mas_equalTo(-kRealWidth(8));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
        }
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.tipBg.isHidden) {
            make.top.mas_equalTo(kNavigationBarH);
        } else {
            make.top.equalTo(self.tipBg.mas_bottom);
        }
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_equalTo(0);
    }];

    [super updateViewConstraints];
}

- (HDUIButton *)historyBTN {
    if (!_historyBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [button setTitle:WMLocalizedString(@"wm_order_feedback_history", @"历史记录") forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{@"orderNo": self.parameters[@"orderNo"]}];
        }];
        _historyBTN = button;
    }
    return _historyBTN;
}

- (HDLabel *)tipLB {
    if (!_tipLB) {
        _tipLB = HDLabel.new;
        _tipLB.textColor = HDAppTheme.WMColor.mainRed;
        _tipLB.text = WMLocalizedString(@"wm_order_feedback_can_be_requested", @"");
        _tipLB.textColor = HDAppTheme.WMColor.mainRed;
        _tipLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:_tipLB.text];
        mstr.yy_lineSpacing = kRealWidth(4);
        _tipLB.attributedText = mstr;
    }
    return _tipLB;
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -kiPhoneXSeriesSafeBottomHeight, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.GNdelegate = self;
        _tableView.backgroundColor = HDAppTheme.WMColor.bgGray;
    }
    return _tableView;
}

- (UIView *)tipBg {
    if (!_tipBg) {
        _tipBg = UIView.new;
        _tipBg.backgroundColor = HexColor(0xFFE9EC);
    }
    return _tipBg;
}

@end
