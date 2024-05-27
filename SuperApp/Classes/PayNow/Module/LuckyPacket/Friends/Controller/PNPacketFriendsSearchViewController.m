//
//  PNPacketFriendsSearchViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsSearchViewController.h"
#import "PNPacketFriendsDTO.h"
#import "PNPacketFriendsSearchUserCell.h"
#import "PNPacketWOWNOWUserRspModel.h"
#import "PNTableView.h"


@interface PNPacketFriendsSearchViewController () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableview;
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (nonatomic, strong) PNPacketFriendsDTO *friendsDTO;
@property (nonatomic, strong) NSMutableArray *coolCashUserArray;
@property (nonatomic, copy) void (^selectComplete)(PNPacketCoolCashUserModel *selectUserData);

@end


@implementation PNPacketFriendsSearchViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.selectComplete = [parameters objectForKey:@"callBack"];
    }
    return self;
}

- (void)hd_setupNavigation {
    //    self.hd_navTitleColor = HDAppTheme.PayNowColor.c333333;
    self.hd_backButtonImage = [UIImage imageNamed:@"pn_icon_back_black"];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableview];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchBar becomeFirstResponder];
    });
}

- (void)updateViewConstraints {
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.height.equalTo(@(kRealWidth(50)));
    }];

    [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (void)searchUser:(NSString *)mobile {
    [HDFunctionThrottle throttleWithInterval:0.5 key:@"PNSearchWOWNOWUser" handler:^{
        [self.view showloading];

        @HDWeakify(self);

        [self.friendsDTO searchUserForWOWNOW:mobile pageNo:1 pageSize:20 success:^(PNPacketWOWNOWUserRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            NSArray *wownowUserArray = rspModel.list;

            ///处理数据
            if (wownowUserArray.count > 0) {
                NSString *loginNames = @"";
                for (PNPacketWOWNOWUserInfoModel *itemUserModel in wownowUserArray) {
                    loginNames = [loginNames stringByAppendingFormat:@",%@", itemUserModel.loginName];
                }

                @HDWeakify(self);
                [self.friendsDTO searchUserForCoolCash:loginNames success:^(NSArray<PNPacketFriendsUserModel *> *_Nonnull rspModel) {
                    @HDStrongify(self);
                    [self.view dismissLoading];
                    self.coolCashUserArray = [NSMutableArray arrayWithArray:rspModel];
                    [self.tableview successGetNewDataWithNoMoreData:YES];
                } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self.view dismissLoading];
                }];
            } else {
                @HDStrongify(self);
                [self.view dismissLoading];
                [self.coolCashUserArray removeAllObjects];
                [self.tableview successGetNewDataWithNoMoreData:YES];
            }
        } failure:^(HDNetworkResponse *_Nonnull response) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coolCashUserArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketFriendsSearchUserCell *cell = [PNPacketFriendsSearchUserCell cellWithTableView:tableView];
    cell.model = [self.coolCashUserArray objectAtIndex:indexPath.row];
    if ((self.coolCashUserArray.count - 1) == indexPath.row) {
        cell.line.hidden = YES;
    } else {
        cell.line.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketCoolCashUserModel *model = [self.coolCashUserArray objectAtIndex:indexPath.row];

    if (WJIsStringEmpty(model.surname) && WJIsStringEmpty(model.name)) {
        ///应该只有未开通钱包才是这样
        model.surname = PNLocalizedString(@"pn_not_open_wallet", @"还没开通钱包账户");
        model.name = @"";
    }

    //    if (model.walletOpened) {
    !self.selectComplete ?: self.selectComplete(model);
    [self dismissViewControllerAnimated:YES completion:nil];
    //    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLastCell = ((self.coolCashUserArray.count - 1) == indexPath.row);

    PNPacketFriendsSearchUserCell *userCell = (PNPacketFriendsSearchUserCell *)cell;
    [userCell layoutIfNeeded];

    if (indexPath.row == 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:userCell.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(kRealWidth(10), kRealWidth(10))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = userCell.bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        maskLayer.masksToBounds = YES;
        userCell.bgView.layer.mask = maskLayer;
    } else {
        if (isLastCell) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:userCell.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(kRealWidth(10), kRealWidth(10))];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = userCell.bgView.bounds;
            maskLayer.path = maskPath.CGPath;
            maskLayer.masksToBounds = YES;
            userCell.bgView.layer.mask = maskLayer;
        } else {
            userCell.bgView.layer.mask = nil;
        }
    }
}

#pragma mark
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchUser:searchText];
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    return YES;
}

#pragma mark
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HDSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _searchBar.inputFieldBackgrounColor = HDAppTheme.PayNowColor.cFFFFFF;
        _searchBar.searchImage = [UIImage imageNamed:@"pn_ms_search_black"];
        _searchBar.placeHolder = PNLocalizedString(@"pn_search_input_mobile", @"输入手机号");
    }
    return _searchBar;
}

- (PNTableView *)tableview {
    if (!_tableview) {
        _tableview = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 15.0, *)) {
            _tableview.sectionHeaderTopPadding = 0;
        }
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.needRefreshHeader = NO;
        _tableview.needRefreshFooter = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.showsVerticalScrollIndicator = NO;
    }
    return _tableview;
}

- (PNPacketFriendsDTO *)friendsDTO {
    if (!_friendsDTO) {
        _friendsDTO = [[PNPacketFriendsDTO alloc] init];
    }
    return _friendsDTO;
}

- (NSMutableArray *)coolCashUserArray {
    if (!_coolCashUserArray) {
        _coolCashUserArray = [NSMutableArray array];
    }
    return _coolCashUserArray;
}

@end
