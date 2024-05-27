//
//  PNMSWithdrawListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdrawListViewController.h"
#import "PNMSWitdrawDTO.h"
#import "PNMSWithdrawListItemView.h"
#import "PNOperationButton.h"
#import "PNRspModel.h"


@interface PNMSWithdrawListViewController ()
@property (nonatomic, strong) PNMSWithdrawListItemView *toWalletView;
@property (nonatomic, strong) PNMSWithdrawListItemView *toBankView;
@property (nonatomic, strong) PNMSWitdrawDTO *withdrawDTO;
@end


@implementation PNMSWithdrawListViewController

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Withdraw", @"提现");
}

- (void)hd_bindViewModel {
    [self getData];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.toWalletView];
    [self.scrollViewContainer addSubview:self.toBankView];

    ///超管才有权限提现到个人钱包
    if (VipayUser.shareInstance.role == PNMSRoleType_MANAGEMENT) {
        self.toWalletView.hidden = NO;
    } else {
        self.toWalletView.hidden = YES;
    }
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<PNMSWithdrawListItemView *> *visableInfoViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(PNMSWithdrawListItemView *_Nonnull item) {
        return !item.isHidden;
    }];

    PNMSWithdrawListItemView *lastInfoView;
    for (PNMSWithdrawListItemView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom).offset(kRealWidth(12));
            } else {
                make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(12));
                ;
            }
            make.height.equalTo(@(72));
            make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
            make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    [self showloading];

    @HDWeakify(self);
    [self.withdrawDTO getList:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        if ([rspModel.data isKindOfClass:NSArray.class]) {
            NSArray *arr = rspModel.data;
            for (NSDictionary *itemDict in arr) {
                if ([itemDict.allKeys containsObject:@"bizType"]) {
                    NSInteger bizType = [[itemDict objectForKey:@"bizType"] integerValue];
                    if (bizType == 9401) {
                        if ([itemDict.allKeys containsObject:@"status"]) {
                            NSInteger status = [[itemDict objectForKey:@"status"] integerValue];
                            if (status == 10) {
                                self.toBankView.hidden = NO;
                            }
                        }
                    }
                }
            }
        }
        [self.view setNeedsUpdateConstraints];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
- (PNMSWithdrawListItemView *)toWalletView {
    if (!_toWalletView) {
        _toWalletView = [[PNMSWithdrawListItemView alloc] init];
        [_toWalletView setTitlel:PNLocalizedString(@"pn_Withdraw_to_personal_wallet", @"提现到个人钱包") icon:@"icon_withdrawal_wallet"];
        _toWalletView.clickBtnBlock = ^{
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesWithdrawToWalletVC:@{}];
        };
    }
    return _toWalletView;
}

- (PNMSWithdrawListItemView *)toBankView {
    if (!_toBankView) {
        _toBankView = [[PNMSWithdrawListItemView alloc] init];
        _toBankView.hidden = YES;
        [_toBankView setTitlel:PNLocalizedString(@"pn_Withdraw_to_Bank", @"提现到银行") icon:@"icon_withdrawal_bank"];

        _toBankView.clickBtnBlock = ^{
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesWithdrawInputAmountVC:@{}];
        };
    }
    return _toBankView;
}

- (PNMSWitdrawDTO *)withdrawDTO {
    if (!_withdrawDTO) {
        _withdrawDTO = [[PNMSWitdrawDTO alloc] init];
    }
    return _withdrawDTO;
}
@end
