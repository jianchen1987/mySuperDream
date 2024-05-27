//
//  WMStoreListNavView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreListNavView.h"
#import "SAAddressCacheAdaptor.h"
#import "SAMessageButton.h"
#import "WMHomeAddressView.h"


@interface WMStoreListNavView ()
/// 地址
@property (nonatomic, strong) WMHomeAddressView *addressView;
/// 搜索按钮
@property (nonatomic, strong) HDUIButton *searchBTN;
/// 分类信息
@property (nonatomic, strong) HDLabel *cateLB;

@end


@implementation WMStoreListNavView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.backBTN];
    [self addSubview:self.cateLB];
    [self addSubview:self.searchBTN];
    [self addSubview:self.messageBTN];
    // 监听位置改变
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];

    CGFloat offsetY = UIApplication.sharedApplication.statusBarFrame.size.height;

    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(offsetY * 0.5);
        make.size.mas_equalTo(self.backBTN.bounds.size);
    }];

    [self.cateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBTN.mas_right);
        make.top.equalTo(self).offset(offsetY);
        make.bottom.equalTo(self);
        make.right.lessThanOrEqualTo(self.searchBTN.mas_left);
    }];

    [self.searchBTN sizeToFit];
    [self.searchBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.right.equalTo(self.messageBTN.mas_left);
        make.size.mas_equalTo(self.searchBTN.bounds.size);
    }];

    [self.messageBTN sizeToFit];
    [self.messageBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.right.equalTo(self);
        make.size.mas_equalTo(self.messageBTN.bounds.size);
    }];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
}

#pragma mark - event response
- (void)clickBackHandler {
    !self.clickBackOperatingBlock ?: self.clickBackOperatingBlock();
    [self.viewController dismissAnimated:true completion:nil];
}

#pragma mark - Notification
- (void)userChangedLocationHandler:(NSNotification *)notification {
    SAClientType clientType = notification.userInfo[@"clientType"];
    if (!notification || [clientType isEqualToString:SAClientTypeMaster]) {
        [self.addressView updateCurrentAdddress];
    }
}

#pragma mark - public methods
- (void)updateNavUIWithTipViewHidden:(BOOL)tipViewHidden {
    self.addressView.hidden = !tipViewHidden;
    self.searchBTN.hidden = !tipViewHidden;
    self.messageBTN.hidden = !tipViewHidden;
}

#pragma mark - lazy load
- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self clickBackHandler];
        }];
        _backBTN = button;
    }
    return _backBTN;
}

- (WMHomeAddressView *)addressView {
    if (!_addressView) {
        _addressView = WMHomeAddressView.new;
        _addressView.hideArrowImage = true;
        @HDWeakify(self);
        _addressView.clickedHandler = ^{
            @HDStrongify(self);
            void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
                self.addressView.detailAddressLB.text = addressModel.address;
                HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
                if (status == HDCLAuthorizationStatusNotAuthed) {
                    addressModel.fromType = SAAddressModelFromTypeOnceTime;
                }
                // 这里的缓存key是 kCacheKeyYumNowUserChoosedCurrentAddress
                [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
            };
            /// 当前选择的地址模型
            //            SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
            SAAddressModel *currentAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];

            [HDMediator.sharedInstance navigaveToChooseAddressViewController:@{@"callback": callback, @"currentAddressModel": currentAddressModel}];
        };
    }
    return _addressView;
}

- (HDUIButton *)searchBTN {
    if (!_searchBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"wm_ic_search_black"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [GNEvent eventResponder:self target:btn key:@"clickToSearch" indexPath:nil info:nil];
        }];
        _searchBTN = button;
    }
    return _searchBTN;
}

- (SAMessageButton *)messageBTN {
    if (!_messageBTN) {
        SAMessageButton *button = [SAMessageButton buttonWithType:UIButtonTypeCustom clientType:SAClientTypeYumNow];
        [button setImage:[UIImage imageNamed:@"sa_home_message"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{
                @"clientType": SAClientTypeYumNow,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖门店列表.分类%@.消息", self.viewModel.filterModel.businessScope] : [NSString stringWithFormat:@"外卖门店列表.分类%@.消息", self.viewModel.filterModel.businessScope],
                @"associatedId" : self.viewModel.associatedId
            }];
        }];
        _messageBTN = button;
    }
    return _messageBTN;
}

- (void)setCateName:(NSString *)cateName {
    _cateName = cateName;
    self.cateLB.text = cateName ?: @"";
}

- (HDLabel *)cateLB {
    if (!_cateLB) {
        _cateLB = HDLabel.new;
        _cateLB.font = HDAppTheme.font.standard2Bold;
    }
    return _cateLB;
}
@end
