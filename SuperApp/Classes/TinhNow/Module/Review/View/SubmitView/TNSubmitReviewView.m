//
//  TNSubmitReviewView.m
//  SuperApp
//
//  Created by xixi on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSubmitReviewView.h"
#import "TNReviewViewModel.h"
#import "SATableView.h"
#import "TNSubmitReviewCell.h"
#import "TNSubmitReviewFooterView.h"
#import <HDUIKit/HDAnnouncementView.h>


@interface TNSubmitReviewView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TNReviewViewModel *viewModel;
///
@property (nonatomic, strong) HDUIButton *postBtn;
///
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;
///
@property (nonatomic, strong) SATableView *tableView;

@property (nonatomic, strong) TNSubmitReviewFooterView *footerView;
/// 公告视图
@property (nonatomic, strong) HDAnnouncementView *announcementView;

@end


@implementation TNSubmitReviewView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.announcementView];
    [self addSubview:self.tableView];
    [self addSubview:self.postBtn];
    if (iPhoneXSeries) {
        [self addSubview:self.iphoneXSeriousSafeAreaFillView];
    }
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.viewModel.dataModel.itemList.count > 0) {
            self.tableView.hidden = NO;
            self.postBtn.hidden = NO;
            if (iPhoneXSeries) {
                self.iphoneXSeriousSafeAreaFillView.hidden = NO;
            }
            self.viewModel.dataModel.orderNo = self.orderNo;
            self.footerView.model = self.viewModel.dataModel;
            [self.tableView successGetNewDataWithNoMoreData:YES];
        } else {
            [self.tableView failGetNewData];
        }
        [self setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"noticeRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.viewModel.noticeContent)) {
            HDAnnouncementViewConfig *config = HDAnnouncementViewConfig.new;
            config.backgroundColor = HDAppTheme.color.sa_C1;
            config.textFont = HDAppTheme.font.sa_standard12M;
            config.textColor = UIColor.whiteColor;
            config.text = self.viewModel.noticeContent;
            config.contentInsets = UIEdgeInsetsMake(10, 15, 10, 15);
            config.trailingBuffer = 60.0f;
            self.announcementView.config = config;
            self.announcementView.hidden = NO;

            [self setNeedsUpdateConstraints];
        }
    }];
}

- (void)updateConstraints {
    if (!self.iphoneXSeriousSafeAreaFillView.hidden) {
        [self.iphoneXSeriousSafeAreaFillView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.equalTo(@(kiPhoneXSeriesSafeBottomHeight));
            make.right.mas_equalTo(self.mas_right);
        }];
    }

    [self.postBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.equalTo(@(kRealWidth(50.f)));
        if (self.iphoneXSeriousSafeAreaFillView.hidden) {
            make.bottom.mas_equalTo(self.mas_bottom);
        } else {
            make.bottom.mas_equalTo(self.iphoneXSeriousSafeAreaFillView.mas_top);
        }
    }];


    if (!self.announcementView.isHidden) {
        [self.announcementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.viewController.hd_navigationBar.mas_bottom);
            make.right.equalTo(self);
            make.height.mas_equalTo(35);
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        if (!self.announcementView.hidden) {
            make.top.equalTo(self.announcementView.mas_bottom);
        } else {
            make.top.equalTo(self.viewController.hd_navigationBar.mas_bottom);
        }
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.postBtn.mas_top);
    }];

    [super updateConstraints];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataModel.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNSubmitReviewCell *cell = [TNSubmitReviewCell cellWithTableView:tableView];
    NSArray *arr = self.viewModel.dataModel.itemList;
    cell.model = [arr objectAtIndex:indexPath.row];

    @HDWeakify(self);
    cell.reloadHander = ^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:NO];
    };

    cell.frame = tableView.bounds;
    [cell layoutIfNeeded];

    return cell;
}

- (void)postAction {
    [self.viewModel postReviewAction];
}

#pragma mark -
- (HDUIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setTitle:TNLocalizedString(@"tn_button_submit", @"提交") forState:UIControlStateNormal];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:0];
        _postBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15.f];
        _postBtn.backgroundColor = HDAppTheme.TinhNowColor.cFF8824;
        _postBtn.adjustsButtonWhenHighlighted = false;
        _postBtn.hidden = YES;
        @HDWeakify(self);
        [_postBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self postAction];
        }];
    }
    return _postBtn;
}

- (UIView *)iphoneXSeriousSafeAreaFillView {
    if (!_iphoneXSeriousSafeAreaFillView) {
        _iphoneXSeriousSafeAreaFillView = [[UIView alloc] init];
        _iphoneXSeriousSafeAreaFillView.backgroundColor = self.postBtn.backgroundColor;
        _iphoneXSeriousSafeAreaFillView.hidden = YES;
    }
    return _iphoneXSeriousSafeAreaFillView;
}


- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = HexColor(0xF5F7FA);
        _tableView.hidden = YES;


        @HDWeakify(self);
        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow-ic-home-placeholder";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        placeHolderModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self.viewModel getOrderDetailWithOrderNo:self.orderNo];
        };
        _tableView.placeholderViewModel = placeHolderModel;

        [self.footerView layoutIfNeeded];
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (TNSubmitReviewFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[TNSubmitReviewFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.hd_width, 100.f)];

        CGFloat height = [_footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        _footerView.height = height;
    }
    return _footerView;
}

- (HDAnnouncementView *)announcementView {
    if (!_announcementView) {
        _announcementView = [[HDAnnouncementView alloc] initWithFrame:CGRectZero];
        _announcementView.hidden = YES;
    }
    return _announcementView;
}

@end
