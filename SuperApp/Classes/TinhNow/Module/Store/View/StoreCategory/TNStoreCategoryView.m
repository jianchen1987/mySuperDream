//
//  TNStoreCategoryView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  店铺分类页面

#import "TNStoreCategoryView.h"
#import "TNCategoryContainerView.h"
#import "TNMicroShopInfoCell.h"
#import "TNStoreIntroductionView.h"
#import "TNStoreViewModel.h"


@interface TNStoreCategoryView ()
/// 店铺介绍
@property (strong, nonatomic) TNStoreIntroductionView *storeIntroductionView;
/// 分类容器
@property (strong, nonatomic) TNCategoryContainerView *containerView;
/// storeviewmodel
@property (nonatomic, strong) TNStoreViewModel *storeViewModel;
/// 微店头部
@property (strong, nonatomic) TNMicroShopInfoCell *microStoreInfoView;

@end


@implementation TNStoreCategoryView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.storeViewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.G5;
    if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
        [self addSubview:self.microStoreInfoView];
        self.microStoreInfoView.model = self.storeViewModel.microShopInfo;
    } else {
        [self addSubview:self.storeIntroductionView];
        self.storeIntroductionView.storeInfo = self.storeViewModel.storeInfo;
    }
    [self addSubview:self.containerView];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
        [self.KVOController hd_observe:self.storeViewModel keyPath:@"microShopInfo" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            self.microStoreInfoView.model = self.storeViewModel.microShopInfo;
            [self setNeedsUpdateConstraints];
        }];
    } else {
        [self.KVOController hd_observe:self.storeViewModel keyPath:@"storeInfo" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            self.storeIntroductionView.storeInfo = self.storeViewModel.storeInfo;
            [self setNeedsUpdateConstraints];
        }];
    }
}

- (void)updateConstraints {
    UIView *topView;
    if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
        topView = self.microStoreInfoView;
        [self.microStoreInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(kRealWidth(100));
        }];

    } else {
        topView = self.storeIntroductionView;
        [self.storeIntroductionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(self.storeViewModel.storeInfo.storeIntroductionViewHeight + (HDIsStringNotEmpty(self.storeViewModel.storeInfo.address) ? kRealWidth(15) : 0));
        }];
    }
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(topView.mas_bottom).offset(kRealWidth(10));
    }];
    [super updateConstraints];
}

/** @lazy  storeIntroductionView*/
- (TNStoreIntroductionView *)storeIntroductionView {
    if (!_storeIntroductionView) {
        _storeIntroductionView = [[TNStoreIntroductionView alloc] init];
        if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeSellerToAdd) {
            [_storeIntroductionView hiddenFavoriteButton];
        }
    }
    return _storeIntroductionView;
}
/** @lazy containerView */
- (TNCategoryContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[TNCategoryContainerView alloc] initWithViewModel:self.storeViewModel];
    }
    return _containerView;
}
/** @lazy microStoreInfoView */
- (TNMicroShopInfoCell *)microStoreInfoView {
    if (!_microStoreInfoView) {
        _microStoreInfoView = [[TNMicroShopInfoCell alloc] init];
    }
    return _microStoreInfoView;
}
@end
