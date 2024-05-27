//
//  PNApartmentListView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentListView.h"
#import "PNApartmentDTO.h"
#import "PNApartmentListCell.h"
#import "PNNotifyView.h"
#import "PNOperationButton.h"
#import "PNTableView.h"


@interface PNApartmentListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNNotifyView *notifyView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDUIButton *moreSelectBtn;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) PNOperationButton *nextBtn;
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, assign) PNApartmentListCellType cellType;

@property (nonatomic, strong) PNApartmentDTO *apartmentDTO;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray<PNApartmentListItemModel *> *dataSource;
@property (nonatomic, copy) PNCurrencyType currency;

@end


@implementation PNApartmentListView

- (void)getNewData {
    self.currentPage = 1;
    [self.tableView getNewData];
}

- (void)hd_setupViews {
    self.cellType = PNApartmentListCellType_Default;
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self addSubview:self.topBgView];
    [self.topBgView addSubview:self.titleLabel];
    [self.topBgView addSubview:self.moreSelectBtn];

    [self addSubview:self.tableView];
    [self addSubview:self.notifyView];

    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.nextBtn];

    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeApartment];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }
}

- (void)updateConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.mas_equalTo(self.viewController.hd_navigationBar.mas_bottom);
        }];
    }

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        if (!self.notifyView.hidden) {
            make.top.equalTo(self.notifyView.mas_bottom);
        } else {
            make.top.equalTo(self);
        }
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.topBgView.mas_top).mas_equalTo(kRealWidth(20));
        make.bottom.mas_equalTo(self.topBgView.mas_bottom).offset(-kRealWidth(12));
        make.right.mas_equalTo(self.moreSelectBtn.mas_left).offset(-kRealWidth(12));
    }];

    [self.moreSelectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topBgView.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];

    if (!self.bottomBgView.hidden) {
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
        }];

        [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomBgView.mas_top).offset(kRealWidth(8));
            make.left.mas_equalTo(self.bottomBgView.mas_left).offset(kRealWidth(20));
            make.right.mas_equalTo(self.bottomBgView.mas_right).offset(-kRealWidth(20));
            make.bottom.mas_equalTo(self.bottomBgView.mas_bottom).offset(-(kRealWidth(8) + kiPhoneXSeriesSafeBottomHeight));
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (!self.topBgView.hidden) {
            make.top.mas_equalTo(self.topBgView.mas_bottom);
        } else {
            if (!self.notifyView.hidden) {
                make.top.mas_equalTo(self.notifyView.mas_bottom);
            } else {
                make.top.mas_equalTo(self.mas_top);
            }
        }

        if (!self.bottomBgView.hidden) {
            make.bottom.mas_equalTo(self.bottomBgView.mas_top);
        } else {
            make.bottom.mas_equalTo(self.mas_bottom);
        }
    }];

    [super updateConstraints];
}

#pragma mark
- (void)getData {
    @HDWeakify(self);
    [self.apartmentDTO getApartmentListData:@"" endTime:@"" currentPage:self.currentPage status:@[@(PNApartmentPaymentStatus_TO_PAID)] success:^(PNApartmentListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSArray<PNApartmentListItemModel *> *list = rspModel.list;
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
            if (list.count) {
                self.dataSource = [NSMutableArray arrayWithArray:list];
            }
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            if (list.count) {
                [self.dataSource addObjectsFromArray:list];
            }
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }

        if (WJIsArrayEmpty(self.dataSource)) {
            self.topBgView.hidden = YES;
        } else {
            self.topBgView.hidden = NO;
        }

        [self rultLimit];
        [self setNeedsUpdateConstraints];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.currentPage == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
    }];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNApartmentListCell *cell = [PNApartmentListCell cellWithTableView:tableView];
    cell.cellType = self.cellType;
    cell.currency = self.currency;
    cell.model = [self.dataSource objectAtIndex:indexPath.row];

    @HDWeakify(self);
    cell.selectBtnBlock = ^(PNApartmentListItemModel *_Nonnull model) {
        @HDStrongify(self);
        if (self.cellType == PNApartmentListCellType_MoreSelect) {
            if (!model.isSelected) {
                if (![self checkIsExistSelectData]) {
                    self.currency = @"";
                }
            } else {
                self.currency = model.currency;
            }
            [self rultLimit];
            [self.tableView successGetNewDataWithNoMoreData:NO];
        } else {
            [HDMediator.sharedInstance navigaveToPayNowApartmentComfirmVC:@{
                @"dataSource": @[model],
            }];
        }
    };
    return cell;
}

#pragma mark
- (BOOL)checkIsExistSelectData {
    BOOL isExistSelect = NO;
    for (PNApartmentListItemModel *itemModel in self.dataSource) {
        if (itemModel.isSelected) {
            isExistSelect = YES;
            break;
        }
    }

    return isExistSelect;
}

- (void)resetSelected {
    for (PNApartmentListItemModel *itemModel in self.dataSource) {
        itemModel.isSelected = NO;
    }
    [self rultLimit];
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (void)rultLimit {
    NSInteger count = 0;
    for (PNApartmentListItemModel *itemModel in self.dataSource) {
        if (itemModel.isSelected) {
            count++;
        }
    }

    if (count > 0) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder_2";
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.currentPage = 1;
            self.currency = @"";
            [self getData];
        };

        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.currentPage++;
            [self getData];
        };
    }
    return _tableView;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

        _topBgView = view;
    }
    return _topBgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.text = PNLocalizedString(@"pn_select_bill_no", @"请选择账单缴费");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDUIButton *)moreSelectBtn {
    if (!_moreSelectBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_select_2", @"选择") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.layer.cornerRadius = kRealWidth(10);
        button.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        button.layer.borderWidth = PixelOne;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            btn.selected = !btn.selected;

            if (btn.selected) {
                self.cellType = PNApartmentListCellType_MoreSelect;
                self.bottomBgView.hidden = NO;
                [btn setTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") forState:UIControlStateSelected];
                [self resetSelected];
                self.currency = @"";
            } else {
                self.cellType = PNApartmentListCellType_Default;
                self.bottomBgView.hidden = YES;
                [btn setTitle:PNLocalizedString(@"pn_select_2", @"选择") forState:UIControlStateNormal];
            }

            [self setNeedsUpdateConstraints];
            [self.tableView successGetNewDataWithNoMoreData:YES];
        }];

        _moreSelectBtn = button;
    }
    return _moreSelectBtn;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0600].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, -4);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 8;
        view.hidden = YES;
        _bottomBgView = view;
    }
    return _bottomBgView;
}

- (PNOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _nextBtn.enabled = NO;
        [_nextBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_nextBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);

            //找出已经选择的
            NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
            for (PNApartmentListItemModel *itemModel in self.dataSource) {
                if (itemModel.isSelected) {
                    [resultArray addObject:itemModel];
                }
            }

            [HDMediator.sharedInstance navigaveToPayNowApartmentComfirmVC:@{
                @"dataSource": resultArray,
            }];
        }];
    }
    return _nextBtn;
}

- (PNApartmentDTO *)apartmentDTO {
    if (!_apartmentDTO) {
        _apartmentDTO = [[PNApartmentDTO alloc] init];
    }
    return _apartmentDTO;
}

- (NSMutableArray<PNApartmentListItemModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end
