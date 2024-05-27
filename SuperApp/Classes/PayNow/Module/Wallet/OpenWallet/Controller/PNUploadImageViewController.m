//
//  PNUploadImageViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNUploadImageViewController.h"
#import "PNAccountUpgradeDTO.h"
#import "PNUploadView.h"


@interface PNUploadImageViewController () <UIGestureRecognizerDelegate>
//@property (nonatomic, strong) PNUploadImageView *contentView;
@property (nonatomic, strong) SAOperationButton *postBtn;
@property (nonatomic, assign) PNUploadImageType viewType;
@property (nonatomic, assign) BOOL isUpgradeLevel;
@property (nonatomic, copy) void (^ResultPhotoURLBlock)(NSString *resultURL);
@property (nonatomic, strong) PNAccountUpgradeDTO *upgradeDTO;
@property (nonatomic, strong) PNUploadView *contentView;
@end


@implementation PNUploadImageViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        void (^callback)(NSString *) = parameters[@"callback"];
        self.ResultPhotoURLBlock = callback;

        if ([parameters.allKeys containsObject:@"viewType"]) {
            self.viewType = [parameters[@"viewType"] integerValue];
        } else {
            self.viewType = PNUploadImageType_Avatar;
        }

        if ([parameters.allKeys containsObject:@"upgradeLevel"]) {
            self.isUpgradeLevel = [parameters objectForKey:@"upgradeLevel"];
        } else {
            self.isUpgradeLevel = NO;
        }
    }
    return self;
}

- (void)hd_setupNavigation {
    if (self.viewType == PNUploadImageType_Avatar) {
        self.boldTitle = PNLocalizedString(@"Upload_Photo", @"上传用户信息");
    } else {
        self.boldTitle = PNLocalizedString(@"Upgrade_Platinum_account", @"升级尊享账户");
    }
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark
- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self.view addSubview:self.contentView];
    [self.view addSubview:self.postBtn];
}

#pragma mark
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.mas_equalTo(self.postBtn.mas_top).offset(kRealWidth(-25));
        make.left.right.mas_equalTo(self.view);
    }];

    [self.postBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(25)));
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-15));
        make.height.equalTo(@(kRealWidth(50)));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)upgradeSeniorLevel:(NSString *)photoURL {
    [self showloading];
    @HDWeakify(self);

    [self.upgradeDTO submitCardHandAuthWidthURL:photoURL successBlock:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"PAGE_TEXT_SUBMIT_SUCCESS", @"提交成功") type:HDTopToastTypeSuccess];
        [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletController") animated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
- (SAOperationButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_SUBMIT", @"提交") forState:UIControlStateNormal];
        _postBtn.enabled = NO;
        @HDWeakify(self);
        [_postBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            HDLog(@"click");
            /// 上传完图片返回
            if (self.isUpgradeLevel) {
                /// 升级到尊享
                [self upgradeSeniorLevel:self.contentView.imageURLStr];
            } else {
                if (self.ResultPhotoURLBlock) {
                    self.ResultPhotoURLBlock(self.contentView.imageURLStr);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];

        _postBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(25)];
        };
    }
    return _postBtn;
}

- (PNUploadView *)contentView {
    if (!_contentView) {
        _contentView = [[PNUploadView alloc] init];

        @HDWeakify(self);

        _contentView.buttonEnableBlock = ^(BOOL enabled, NSString *_Nonnull imageURL) {
            @HDStrongify(self);
            /// 额外加多一层判断， 保证返回的时候是有值
            if (enabled) {
                if (enabled && imageURL.length > 0) {
                    self.postBtn.enabled = YES;
                } else {
                    self.postBtn.enabled = NO;
                }
            } else {
                self.postBtn.enabled = NO;
            }
        };

        _contentView.demoArray = [self getArrayData]; // @[@"pn_huzhao_demo", @"pn_shenfenzheng_demo"];
        _contentView.imageURLStr = [self.parameters objectForKey:@"url"];
        _contentView.viewType = self.viewType;
    }
    return _contentView;
}

- (NSMutableArray *)getArrayData {
    NSMutableArray *arr = [NSMutableArray array];
    if (self.viewType == PNUploadImageType_Avatar) {
        [arr addObject:@"pn_user_avater_demo"];
    } else {
        if ([self.parameters.allKeys containsObject:@"cardType"]) {
            PNPapersType cardType = [[self.parameters objectForKey:@"cardType"] integerValue];
            if (cardType == PNPapersTypePassport) {
                [arr addObject:@"pn_huzhao_demo"];
            } else if (cardType == PNPapersTypeIDCard) {
                [arr addObject:@"pn_shenfenzheng_demo"];
            } else if (cardType == PNPapersTypeDrivingLince) {
                [arr addObject:@"pn_jiashizheng_demo"];
            } else if (cardType == PNPapersTypepolice) {
                [arr addObject:@"pn_jingchazheng_demo"];
                [arr addObject:@"pn_gongwuyuan_demo"];
            }
        }
    }
    return arr;
}

//- (PNUploadImageView *)contentView {
//    if (!_contentView) {
//        _contentView = [[PNUploadImageView alloc] init];
//        if ([self.parameters.allKeys containsObject:@"url"]) {
//            _contentView.leftImageURLStr = [self.parameters objectForKey:@"url"];
//        }
//        @HDWeakify(self);
//        _contentView.buttonEnableBlock = ^(BOOL enabled) {
//            @HDStrongify(self);
//            /// 额外加多一层判断， 保证返回的时候是有值
//            if (enabled) {
//                if (enabled && self.contentView.leftImageURLStr.length > 0) {
//                    self.postBtn.enabled = YES;
//                } else {
//                    self.postBtn.enabled = NO;
//                }
//            } else {
//                self.postBtn.enabled = NO;
//            }
//        };
//    }
//    return _contentView;
//}

- (PNAccountUpgradeDTO *)upgradeDTO {
    if (!_upgradeDTO) {
        _upgradeDTO = [[PNAccountUpgradeDTO alloc] init];
    }
    return _upgradeDTO;
}
@end
