//
//  PNMStoreMiddleViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMStoreMiddleViewController.h"
#import "PNInfoView.h"


@interface PNMStoreMiddleViewController ()
@property (nonatomic, copy) NSString *storeNo;
@property (nonatomic, copy) NSString *storeName;
/// 门店详情
@property (nonatomic, strong) PNInfoView *storeDetialInfoView;
/// 门店收款码
@property (nonatomic, strong) PNInfoView *receiveCodeInfoView;
/// 店员管理
@property (nonatomic, strong) PNInfoView *operatorManagerInfoView;
@end


@implementation PNMStoreMiddleViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.storeNo = [parameters objectForKey:@"storeNo"];
        self.storeName = [parameters objectForKey:@"storeName"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = [self.parameters objectForKey:@"storeName"];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.storeDetialInfoView];
    [self.scrollViewContainer addSubview:self.receiveCodeInfoView];
    [self.scrollViewContainer addSubview:self.operatorManagerInfoView];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<UIView *> *visableViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView;
    for (UIView *view in visableViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(12));
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            if (view == visableViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
                if ([view isKindOfClass:PNInfoView.class]) {
                    PNInfoView *infoView = (PNInfoView *)view;
                    infoView.model.lineWidth = 0;
                    [infoView setNeedsUpdateContent];
                }
            }
        }];
        lastView = view;
    }

    [super updateViewConstraints];
}

#pragma mark
- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.lineColor = HDAppTheme.PayNowColor.lineColor;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(12), kRealWidth(18), kRealWidth(12));
    model.rightButtonImage = [UIImage imageNamed:@"pn_icon_black_arrow"];
    model.enableTapRecognizer = YES;
    return model;
}

- (PNInfoView *)storeDetialInfoView {
    if (!_storeDetialInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_store_detail", @"门店详情")];
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.model = model;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesStoreInfoVC:@{
                @"storeNo": self.storeNo,
            }];
        };

        _storeDetialInfoView = view;
    }
    return _storeDetialInfoView;
}

- (PNInfoView *)receiveCodeInfoView {
    if (!_receiveCodeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_Store_receiving_KHQR", @"门店收款码")];
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.model = model;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesReceiveCodeVC:@{
                @"storeNo": self.storeNo,
                @"storeName": self.storeName,
            }];
        };

        _receiveCodeInfoView = view;
    }
    return _receiveCodeInfoView;
}

- (PNInfoView *)operatorManagerInfoView {
    if (!_operatorManagerInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_Staff_management", @"店员管理")];
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.model = model;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesStoreOperatorManagerVC:@{
                @"storeNo": self.storeNo,
                @"storeName": self.storeName,
            }];
        };

        _operatorManagerInfoView = view;
    }
    return _operatorManagerInfoView;
}

@end
