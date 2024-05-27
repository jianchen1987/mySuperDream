//
//  TNTelegramGroupViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNTelegramGroupViewController.h"
#import "TNTelegramDTO.h"
#import "TNTelegramGroupModel.h"


@interface TNTelegramGroupViewController ()
///
@property (strong, nonatomic) TNTelegramDTO *dto;
///
@property (strong, nonatomic) TNTelegramGroupModel *model;
@end


@implementation TNTelegramGroupViewController
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_telegram_group", @"Telegram群");
}
- (void)hd_setupViews {
}
- (void)hd_getNewData {
    [self.view showloading];
    [self removePlaceHolder];
    @HDWeakify(self);
    [self.dto queryTelegramGroupInfoSuccess:^(TNTelegramGroupModel *_Nonnull model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.model = model;
        [self updataUI];
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
- (void)updataUI {
    self.view.backgroundColor = HDAppTheme.TinhNowColor.C1;

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:8];
    };
    [self.view addSubview:bgView];

    UIImageView *qrImageView = [[UIImageView alloc] init];
    if (HDIsStringNotEmpty(self.model.link)) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *qrCodeImage = [HDCodeGenerator qrCodeImageForStr:self.model.link size:CGSizeMake(kRealWidth(160), kRealWidth(160)) logoImage:[UIImage imageNamed:@"tn_telegram_k"]
                                                             logoSize:CGSizeMake(kRealWidth(30), kRealWidth(30))
                                                           logoMargin:3
                                                                level:HDInputCorrectionLevelL];
            dispatch_async(dispatch_get_main_queue(), ^{
                qrImageView.image = qrCodeImage;
            });
        });
    }

    [bgView addSubview:qrImageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
    titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.model.title;
    [bgView addSubview:titleLabel];

    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
    desLabel.font = HDAppTheme.TinhNowFont.standard14;
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.numberOfLines = 0;
    desLabel.text = self.model.instruction;
    [bgView addSubview:desLabel];

    UIView *linkBgView = [[UIView alloc] init];
    linkBgView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    linkBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:4];
    };
    [bgView addSubview:linkBgView];

    UILabel *linkLabel = [[UILabel alloc] init];
    linkLabel.textColor = HexColor(0x1889FF);
    linkLabel.font = HDAppTheme.TinhNowFont.standard14;
    linkLabel.text = [NSString stringWithFormat:@"%@:%@", TNLocalizedString(@"tn_link", @"链接"), self.model.link];
    linkLabel.numberOfLines = 0;
    linkLabel.textAlignment = NSTextAlignmentCenter;
    [linkBgView addSubview:linkLabel];

    SAOperationButton *pasteBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
    [pasteBtn applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G1];
    [pasteBtn setTitle:TNLocalizedString(@"tn_copy", @"复制") forState:UIControlStateNormal];
    pasteBtn.titleEdgeInsets = UIEdgeInsetsMake(8, 26, 8, 26);
    pasteBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
    [pasteBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        if (HDIsStringNotEmpty(self.model.link)) {
            [UIPasteboard generalPasteboard].string = self.model.link;
            [HDTips showSuccess:TNLocalizedString(@"tn_copy_success", @"复制成功")];
        }
    }];
    [linkBgView addSubview:pasteBtn];

    SAOperationButton *enterBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
    [enterBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
    enterBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
    [enterBtn setTitle:TNLocalizedString(@"tn_enter", @"进入") forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        if (HDIsStringNotEmpty(self.model.link)) {
            NSURL *url = [NSURL URLWithString:self.model.link];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }
    }];
    [bgView addSubview:enterBtn];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(12));
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(12));
    }];
    [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(kRealHeight(40));
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(160), kRealWidth(160)));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrImageView.mas_bottom).offset(kRealHeight(10));
        make.left.equalTo(bgView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(bgView.mas_right).offset(-kRealWidth(10));
    }];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(kRealHeight(10));
        make.left.equalTo(bgView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(bgView.mas_right).offset(-kRealWidth(10));
    }];
    [linkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(kRealHeight(10));
        make.left.equalTo(bgView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(bgView.mas_right).offset(-kRealWidth(10));
    }];
    [linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linkBgView.mas_top).offset(kRealHeight(20));
        make.left.equalTo(linkBgView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(linkBgView.mas_right).offset(-kRealWidth(10));
    }];

    [pasteBtn sizeToFit];
    [pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linkLabel.mas_bottom).offset(kRealHeight(20));
        make.bottom.equalTo(linkBgView.mas_bottom).offset(-kRealHeight(20));
        make.centerX.equalTo(linkBgView.mas_centerX);
        make.size.mas_equalTo(pasteBtn.bounds.size);
    }];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linkBgView.mas_bottom).offset(kRealHeight(30));
        make.left.equalTo(bgView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(bgView.mas_right).offset(-kRealWidth(12));
        make.height.mas_equalTo(kRealHeight(45));
        make.bottom.equalTo(bgView.mas_bottom).offset(-kRealHeight(30));
    }];
}
/** @lazy dto */
- (TNTelegramDTO *)dto {
    if (!_dto) {
        _dto = [[TNTelegramDTO alloc] init];
    }
    return _dto;
}
@end
