//
//  TNContactCustomerServiceViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNContactCustomerServiceViewController.h"
#import "TNContactCustomerServiceModel.h"
#import "TNReviceMethodView.h"
#import "TNTransferDTO.h"


@interface TNContactCustomerServiceViewController ()
///
@property (strong, nonatomic) TNTransferDTO *dto;
///
@property (strong, nonatomic) TNContactCustomerServiceModel *model;
@end


@implementation TNContactCustomerServiceViewController
- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [self.scrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_customer", @"联系客服");
}
- (void)hd_getNewData {
    [self removePlaceHolder];
    [self.view showloading];
    @HDWeakify(self);
    [self.dto queryContactCustomerServiceWithSuccess:^(TNContactCustomerServiceModel *_Nonnull model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.model = model;
        [self updateData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self hd_getNewData];
        }];
    }];
}

- (void)updateData {
    UIView *lastView; //记录视图
    //电话视图
    UIView *phoneView;
    if (!HDIsArrayEmpty(self.model.PhoneCall)) {
        phoneView = [self createPhoneContactView];
        [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.scrollViewContainer);
        }];
        lastView = phoneView;
    }

    //电报视图
    UIView *tgView;
    if (!HDIsArrayEmpty(self.model.Telegram)) {
        tgView = [self createTelgramContactView];
        [tgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scrollViewContainer);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(self.scrollViewContainer);
            }
        }];
        lastView = tgView;
    }

    //其他方式
    UIView *otherView;
    if (!HDIsArrayEmpty(self.model.Other)) {
        otherView = [self createOtherContactView];
        [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scrollViewContainer);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(self.scrollViewContainer);
            }
        }];
        lastView = otherView;
    }
    if (lastView) {
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.scrollViewContainer.mas_bottom);
        }];
    }
}
///创建电话视图
- (UIView *)createPhoneContactView {
    UIView *bgView = [[UIView alloc] init];
    [self.scrollViewContainer addSubview:bgView];

    UIView *headerView = [self getCommonHeaderViewWithLogo:@"tn_contact_phone" name:TNLocalizedString(@"1OcNTCXR", @"电话客服")];
    [bgView addSubview:headerView];

    NSDictionary *imageNameDict = @{@"CellCard": @"tn_phone_cellcard", @"Metfone": @"tn_phone_metfone", @"Smart": @"tn_phone_Smart"};
    HDFloatLayoutView *floatLayoutView = [[HDFloatLayoutView alloc] init];
    floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, kRealWidth(30));
    [bgView addSubview:floatLayoutView];
    for (TNTransferItemModel *model in self.model.PhoneCall) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        if (HDIsStringNotEmpty(model.name)) {
            [btn setImage:[UIImage imageNamed:imageNameDict[model.name]] forState:UIControlStateNormal];
        }
        btn.size = CGSizeMake(kRealWidth(70), kRealWidth(30));
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            if (HDIsStringNotEmpty(model.value) && [model.value hd_isPureDigitCharacters]) {
                [HDSystemCapabilityUtil makePhoneCall:model.value];
            }
        }];
        [floatLayoutView addSubview:btn];
    }

    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = TNLocalizedString(@"M3WSeFCc", @"点击可拨打电话");
    tipsLabel.font = HDAppTheme.TinhNowFont.standard12;
    tipsLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
    [bgView addSubview:tipsLabel];

    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [bgView addSubview:sectionView];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
    }];
    [floatLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(bgView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(headerView.mas_bottom);
        make.size.mas_equalTo([floatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(30), CGFLOAT_MAX)]);
    }];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(bgView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(floatLayoutView.mas_bottom).offset(kRealWidth(10));
    }];
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(tipsLabel.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(10));
        make.bottom.equalTo(bgView);
    }];
    return bgView;
}
///创建电报视图
- (UIView *)createTelgramContactView {
    UIView *bgView = [[UIView alloc] init];
    [self.scrollViewContainer addSubview:bgView];

    UIView *headerView = [self getCommonHeaderViewWithLogo:@"tn_express_tg" name:TNLocalizedString(@"Zq59QECC", @"电报客服")];
    [bgView addSubview:headerView];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
    }];

    UIView *lastView;
    for (TNTransferItemModel *model in self.model.Telegram) {
        model.isCustomerService = YES;
        TNReviceMethodView *methodView = [[TNReviceMethodView alloc] init];
        methodView.item = model;
        methodView.enterClickCallBack = ^{
            NSURL *url = [NSURL URLWithString:model.value];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        };
        [bgView addSubview:methodView];
        [methodView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(bgView.mas_right).offset(-kRealWidth(15));
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(headerView.mas_bottom);
            }
        }];
        lastView = methodView;
    }

    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [bgView addSubview:sectionView];

    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(10));
        make.bottom.equalTo(bgView);
    }];

    return bgView;
}
///创建其它方式视图
- (UIView *)createOtherContactView {
    UIView *bgView = [[UIView alloc] init];
    [self.scrollViewContainer addSubview:bgView];

    UIView *headerView = [self getCommonHeaderViewWithLogo:@"tn_contact_other" name:TNLocalizedString(@"AXSH62N2", @"其他方式")];
    [bgView addSubview:headerView];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
    }];

    UIView *lastView;
    for (TNTransferItemModel *model in self.model.Other) {
        model.isCustomerService = YES;
        TNReviceMethodView *methodView = [[TNReviceMethodView alloc] init];
        methodView.item = model;
        methodView.enterClickCallBack = ^{
            NSURL *url = [NSURL URLWithString:model.value];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        };
        [bgView addSubview:methodView];
        [methodView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(bgView.mas_right).offset(-kRealWidth(15));
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(headerView.mas_bottom);
            }
        }];
        lastView = methodView;
    }

    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    return bgView;
}
///获取头部
- (UIView *)getCommonHeaderViewWithLogo:(NSString *)logo name:(NSString *)name {
    UIView *headerView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:logo]];
    [headerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    label.text = name;
    label.textColor = HDAppTheme.TinhNowColor.G1;
    label.font = [HDAppTheme.TinhNowFont fontMedium:15];
    [headerView addSubview:label];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(headerView.mas_top).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(25), kRealWidth(25)));
        make.bottom.equalTo(headerView.mas_bottom).offset(-kRealWidth(15));
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(kRealWidth(5));
    }];

    return headerView;
}
/** @lazy dto */
- (TNTransferDTO *)dto {
    if (!_dto) {
        _dto = [[TNTransferDTO alloc] init];
    }
    return _dto;
}
@end
