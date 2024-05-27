//
//  PNPacketFriendsView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsView.h"
#import "NSObject+HDKitCore.h"
#import "PNPacketCoolCashUserModel.h"
#import "PNPacketFriendsDTO.h"
#import "PNPacketFriendsSearchViewController.h"
#import "PNPacketFriendsSectionHeaderView.h"
#import "PNPacketFriendsUserInfoCell.h"
#import "PNPacketFriendsUserModel.h"
#import "PNTableView.h"


@interface PNPacketFriendsView () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (nonatomic, strong) HDUIButton *goToSearchBtn;
@property (nonatomic, strong) HDUIButton *closeBtn;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) PNOperationButton *btn;

@property (nonatomic, strong) PNPacketFriendsDTO *friendsDTO;
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;

/// 发红包个数
@property (nonatomic, assign) NSInteger handOutPacketNum;
/// 是否单选
@property (nonatomic, assign) BOOL isSingle;
@end


@implementation PNPacketFriendsView

- (instancetype)initWithFrame:(CGRect)frame handOutPacketNum:(NSInteger)handOutPacketNum {
    self = [super initWithFrame:frame];
    if (self) {
        self.handOutPacketNum = handOutPacketNum;
        self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

        [self setupViews];

        [self getData];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.searchBar];
    [self.containerView addSubview:self.goToSearchBtn];
    [self.containerView addSubview:self.closeBtn];
    [self.containerView addSubview:self.tableView];

    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.btn];

    if (self.handOutPacketNum > 1) {
        self.bottomBgView.hidden = NO;
        self.isSingle = NO;
    } else {
        self.bottomBgView.hidden = YES;
        self.isSingle = YES;
    }
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        if (self.bottomBgView.hidden) {
            make.bottom.mas_equalTo(self.mas_bottom);
        } else {
            make.bottom.mas_equalTo(self.bottomBgView.mas_top);
        }
    }];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kRealWidth(50)));
        make.top.mas_equalTo(self.containerView.mas_top).offset(kRealWidth(20));
        make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
    }];

    [self.goToSearchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchBar);
    }];

    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchBar.mas_right);
        make.right.mas_equalTo(self.containerView.mas_right);
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(kRealWidth(20));
    }];

    if (!self.bottomBgView.hidden) {
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@(kRealWidth(68)));
        }];

        [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomBgView.mas_left).offset(kRealWidth(20));
            make.right.mas_equalTo(self.bottomBgView.mas_right).offset(-kRealWidth(20));
            make.centerY.mas_equalTo(self.bottomBgView.mas_centerY);
        }];
    }

    [self.closeBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

#pragma mark
- (void)getData {
    [self showloading];
    @HDWeakify(self);
    [self.friendsDTO getgetNearTransList:^(NSArray<PNPacketFriendsUserModel *> *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [self processData:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self closeBlock];
    }];
}

- (PNPacketFriendsUserModel *)meUserObject {
    PNPacketFriendsUserModel *meObject = PNPacketFriendsUserModel.new;
    meObject.userNo = VipayUser.shareInstance.userNo;
    meObject.userName = [NSString stringWithFormat:@"%@ %@", VipayUser.shareInstance.lastName, VipayUser.shareInstance.firstName];
    meObject.userPhone = VipayUser.shareInstance.loginName;
    meObject.headUrl = VipayUser.shareInstance.headUrl;

    if (self.handOutPacketNum > 1) {
        meObject.isSelected = YES;
    }

    return meObject;
}

- (void)processData:(NSArray<PNPacketFriendsUserModel *> *)rspModel {
    HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
    [sectionModel hd_bindObjectWeakly:kNearFlag forKey:kFriendsSectionFlag];
    HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
    headerModel.title = PNLocalizedString(@"pn_will_send", @"您可能想发红包的人");
    sectionModel.headerModel = headerModel;

    NSMutableArray *arr = [NSMutableArray arrayWithArray:rspModel];
    //    PNPacketFriendsUserModel *meObject = [self meUserObject];
    //    [arr insertObject:meObject atIndex:0];
    sectionModel.list = arr;

    [self.dataSource addObject:sectionModel];

    //    if (meObject.isSelected) {
    //        [self processSelectData:meObject];
    //    }

    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (void)processSelectData:(PNPacketFriendsUserModel *)model {
    HDTableViewSectionModel * (^createSelectedSectionBlock)(void) = ^() {
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        [sectionModel hd_bindObjectWeakly:kSelectedFlag forKey:kFriendsSectionFlag];
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = PNLocalizedString(@"pn_selected_need_send", @"已选择领取人");
        sectionModel.headerModel = headerModel;

        return sectionModel;
    };

    void (^addOrDeleteBlock)(BOOL, HDTableViewSectionModel *, BOOL) = ^(BOOL isExistSeciton, HDTableViewSectionModel *sectionModel, BOOL isAdd) {
        if (!isAdd) {
            HDLog(@"进行删除操作");
            /// 删除 - 那 sectionModel 肯定是有值
            if (!WJIsObjectNil(sectionModel)) {
                HDLog(@"正常操作删除");
                NSMutableArray *arr = [NSMutableArray arrayWithArray:sectionModel.list];
                [arr removeObject:model];
                sectionModel.list = arr;
                if (sectionModel.list.count <= 0) {
                    HDLog(@"没有已选择的数据了，直接干掉这个secton");
                    [self.dataSource removeObject:sectionModel];
                }
            } else {
                HDLog(@"⚠️ 有bug");
            }
        } else {
            /// 新增
            if (isExistSeciton) {
                HDLog(@"存在section, 进行追加");
                NSMutableArray *arr = [NSMutableArray arrayWithArray:sectionModel.list];

                //                BOOL isExistUserPhone = NO;
                //                for (PNPacketFriendsUserModel *itemModel in sectionModel.list) {
                //                    if ([itemModel.userPhone isEqualToString:model.userPhone]) {
                //                        isExistUserPhone = YES;
                //                        break;
                //                    }
                //                }
                //
                //                if (!isExistUserPhone) {
                [arr addObject:model];
                sectionModel.list = arr;
                //                } else {
                //                    HDLog(@"已经存在相同的userPhone 了");
                //                }
            } else {
                HDLog(@"不存在section, 直接新增");
                HDTableViewSectionModel *newSectionModel = createSelectedSectionBlock();
                newSectionModel.list = @[model];
                [self.dataSource addObject:newSectionModel];
            }
        }
        [self.tableView successGetNewDataWithNoMoreData:NO];

        [self ruleLimit];
    };

    BOOL isAdd = model.isSelected;
    HDTableViewSectionModel *existSectionModel;
    BOOL isExistSeciton = NO;
    for (HDTableViewSectionModel *sectionModel in self.dataSource) {
        NSString *type = [sectionModel hd_getBoundObjectForKey:kFriendsSectionFlag];
        if ([type isEqualToString:kSelectedFlag]) {
            isExistSeciton = YES;
            existSectionModel = sectionModel;
        }
    }

    addOrDeleteBlock(isExistSeciton, existSectionModel, isAdd);
}

- (void)insertSearchSelectUserData:(PNPacketCoolCashUserModel *)selectModel {
    PNPacketFriendsUserModel *userModel = [[PNPacketFriendsUserModel alloc] init];
    userModel.userName = [NSString stringWithFormat:@"%@ %@", selectModel.surname, selectModel.name];
    userModel.userPhone = selectModel.loginName;
    userModel.headUrl = selectModel.headUrl;
    userModel.isSelected = YES;

    if (self.isSingle) {
        [self selectAndCallBack:userModel];
    } else {
        BOOL isExistSameUserPhone = NO;
        if (!WJIsArrayEmpty(self.dataSource)) {
            /// 第一个肯定是
            HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:0];
            if (!WJIsArrayEmpty(sectionModel.list)) {
                for (PNPacketFriendsUserModel *itemModel in sectionModel.list) {
                    if ([itemModel.userPhone isEqualToString:userModel.userPhone] && !itemModel.isSelected && itemModel.otherUser.count == 1) {
                        isExistSameUserPhone = YES;
                        itemModel.isSelected = YES;
                        [self processSelectData:itemModel];
                    }
                }
            }
        }

        if (!isExistSameUserPhone) {
            [self processSelectData:userModel];
        }
    }
}

- (void)ruleLimit {
    if (self.dataSource.count > 1) {
        HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:1];
        if (!WJIsArrayEmpty(sectionModel.list)) {
            self.btn.enabled = YES;
        } else {
            self.btn.enabled = NO;
        }
    } else {
        self.btn.enabled = NO;
    }
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:section];
    return sectionModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketFriendsUserInfoCell *cell = [PNPacketFriendsUserInfoCell cellWithTableView:tableView];

    cell.isSingle = self.isSingle;
    HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:indexPath.section];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kFriendsSectionFlag];
    cell.friendsSectionFlag = type;

    PNPacketFriendsUserModel *userModel = [sectionModel.list objectAtIndex:indexPath.row];
    cell.model = userModel;
    cell.isLastCell = ((sectionModel.list.count - 1) == indexPath.row);

    @HDWeakify(self);
    cell.selectBlock = ^(PNPacketFriendsUserModel *_Nonnull model) {
        @HDStrongify(self);
        [self processSelectData:model];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PNPacketFriendsSectionHeaderView *headerView = [PNPacketFriendsSectionHeaderView headerWithTableView:tableView];
    HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:section];
    headerView.sectionTitle = sectionModel.headerModel.title;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:NSStringFromClass(UITableViewHeaderFooterView.class)];
    footerView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    footerView.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataSource.count >= 2) {
        if (section == 0) {
            return kRealWidth(8);
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSingle) {
        HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:indexPath.section];
        PNPacketFriendsUserModel *userModel = [sectionModel.list objectAtIndex:indexPath.row];
        [self selectAndCallBack:userModel];
    }
}

- (void)selectAndCallBack:(PNPacketFriendsUserModel *)model {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *filterArray = [NSMutableArray array];

    if (![filterArray containsObject:model.userPhone]) {
        [filterArray addObject:model.userPhone];
        [resultArray addObject:model];
    }

    for (PNPacketFriendsUserModel *itemUserModel in model.otherUser) {
        if (![filterArray containsObject:itemUserModel.userPhone]) {
            [filterArray addObject:itemUserModel.userPhone];
            [resultArray addObject:itemUserModel];
        }
    }

    !self.completion ?: self.completion(resultArray);
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    HDTableViewSectionModel *sectionModel = [self.dataSource objectAtIndex:indexPath.section];
//    BOOL isLastCell = ((sectionModel.list.count - 1) == indexPath.row);
//
//    PNPacketFriendsUserInfoCell *userCell = (PNPacketFriendsUserInfoCell *)cell;
//    [userCell layoutIfNeeded];
//
//    if (isLastCell) {
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:userCell.bgView.bounds
//                                                       byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
//                                                             cornerRadii:CGSizeMake(kRealWidth(10), kRealWidth(110))];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = userCell.bgView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        maskLayer.masksToBounds = YES;
//        userCell.contentView.layer.mask = maskLayer;
//    } else {
//        userCell.bgView.layer.mask = nil;
//    }
//}

#pragma mark
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    HDLog(@"%@", searchText);
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    return YES;
}

#pragma mark
- (UIView *)containerView {
    if (!_containerView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _containerView = view;
    }
    return _containerView;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HDSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _searchBar.inputFieldBackgrounColor = HDAppTheme.PayNowColor.cFFFFFF;
        _searchBar.searchImage = [UIImage imageNamed:@"pn_ms_search_black"];
        _searchBar.placeHolder = PNLocalizedString(@"pn_search_input_mobile", @"输入手机号");
        _searchBar.userInteractionEnabled = NO;
    }
    return _searchBar;
}

- (HDUIButton *)goToSearchBtn {
    if (!_goToSearchBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click 跳转了");
            @HDStrongify(self);

            void (^selectCompletion)(PNPacketCoolCashUserModel *) = ^(PNPacketCoolCashUserModel *selectUserData) {
                [self insertSearchSelectUserData:selectUserData];
            };

            PNPacketFriendsSearchViewController *vc = [[PNPacketFriendsSearchViewController alloc] initWithRouteParameters:@{
                @"handOutPacketNum": @(self.handOutPacketNum),
                @"callBack": selectCompletion,
            }];
            SANavigationController *nav = [[SANavigationController alloc] initWithRootViewController:vc];
            [self.viewController presentViewController:nav animated:YES completion:nil];
        }];

        _goToSearchBtn = button;
    }
    return _goToSearchBtn;
}

- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_search_close_black"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, kRealWidth(12), kRealWidth(12));
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");

            !self.closeBlock ?: self.closeBlock();
        }];

        _closeBtn = button;
    }
    return _closeBtn;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = kRealWidth(64);
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = kRealWidth(53);
    }
    return _tableView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bottomBgView = view;
    }
    return _bottomBgView;
}

- (PNOperationButton *)btn {
    if (!_btn) {
        _btn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _btn.enabled = NO;
        [_btn setTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            ///直接取吧

            for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                NSString *type = [sectionModel hd_getBoundObjectForKey:kFriendsSectionFlag];
                if ([type isEqualToString:kSelectedFlag]) {
                    if (!WJIsArrayEmpty(sectionModel.list)) {
                        //过滤一下
                        NSMutableArray *resultArray = [NSMutableArray array];
                        NSMutableArray *filterArray = [NSMutableArray array];
                        for (PNPacketFriendsUserModel *sectionUserModel in sectionModel.list) {
                            if (![filterArray containsObject:sectionUserModel.userPhone]) {
                                [filterArray addObject:sectionUserModel.userPhone];
                                [resultArray addObject:sectionUserModel];
                            }

                            for (PNPacketFriendsUserModel *itemUserModel in sectionUserModel.otherUser) {
                                if (![filterArray containsObject:itemUserModel.userPhone]) {
                                    [filterArray addObject:itemUserModel.userPhone];
                                    [resultArray addObject:itemUserModel];
                                }
                            }
                        }

                        !self.completion ?: self.completion(resultArray);
                    }
                }
            }

            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _btn;
}

- (PNPacketFriendsDTO *)friendsDTO {
    if (!_friendsDTO) {
        _friendsDTO = [[PNPacketFriendsDTO alloc] init];
    }
    return _friendsDTO;
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
