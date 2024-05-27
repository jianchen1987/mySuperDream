//
//  WMFeedBackHistoryViewController.m
//  SuperApp
//
//  Created by wmz on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMFeedBackHistoryViewController.h"
#import "WMFeedBackHistoryItemView.h"
#import "WMOrderFeedBackDTO.h"


@interface WMFeedBackHistoryViewController ()
/// DTO
@property (nonatomic, strong) WMOrderFeedBackDTO *DTO;

@end


@implementation WMFeedBackHistoryViewController

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"wm_order_feedback_detail", @"Order Feedback");
    self.hd_backButtonImage = [UIImage imageNamed:@"yn_home_back"];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.orderNo = self.parameters[@"orderNo"];
    self.view.backgroundColor = HDAppTheme.WMColor.bgGray;
    self.scrollView.contentInset = UIEdgeInsetsMake(kRealWidth(12), 0, kiPhoneXSeriesSafeBottomHeight ?: kRealWidth(12), 0);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
}

- (void)hd_getNewData {
    @HDWeakify(self)[self.view showloading];
    [self.DTO requestPostSaleListByOrderWithNO:self.orderNo success:^(NSArray<WMOrderFeedBackDetailModel *> *_Nonnull rspModel) {
        @HDStrongify(self)[self.view dismissLoading];
        [self.scrollViewContainer hd_removeAllSubviews];
        for (WMOrderFeedBackDetailModel *model in rspModel) {
            WMFeedBackHistoryItemView *itemView = WMFeedBackHistoryItemView.new;
            itemView.model = model;
            [self.scrollViewContainer addSubview:itemView];
        }
        [self.view setNeedsUpdateConstraints];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self.view dismissLoading];
    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(self.scrollView);
    }];

    WMFeedBackHistoryItemView *lastView;
    for (WMFeedBackHistoryItemView *infoView in self.scrollViewContainer.subviews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(12));
            } else {
                make.top.mas_equalTo(0);
            }
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
        lastView = infoView;
    }
}

- (WMOrderFeedBackDTO *)DTO {
    if (!_DTO) {
        _DTO = WMOrderFeedBackDTO.new;
    }
    return _DTO;
}

@end
