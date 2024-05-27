//
//  TNCustomerServiceView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//  平台客服视图

#import "TNCustomerServiceView.h"
#import <HDKitCore/NSObject+HDKitCore.h>
#import <NSString+HD_Validator.h>
#import "TNCallPhoneItemView.h"


@interface TNCustomerServiceView ()
/// 背景视图
@property (strong, nonatomic) UIView *bgView;
@end


@implementation TNCustomerServiceView

- (void)hd_setupViews {
    [self addSubview:self.bgView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

- (void)layoutyImmediately {
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGFloat height = [self.bgView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT)].height;
    self.frame = CGRectMake(0, 0, kScreenWidth - kRealWidth(30), height);
}

- (void)setDataSource:(NSArray<TNCustomerServiceModel *> *)dataSource {
    _dataSource = dataSource;
    if (!HDIsArrayEmpty(dataSource)) {
        UIView *lastView = nil;
        for (int j = 0; j < dataSource.count; j++) {
            TNCustomerServiceModel *csModel = [dataSource objectAtIndex:j];
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
            titleLabel.textColor = HexColor(0x5D667F);
            titleLabel.text = csModel.title;
            [self.bgView addSubview:titleLabel];

            [titleLabel sizeToFit];
            [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(titleLabel.frame.size);
                make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(50.f));
                make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15.f));
                if (lastView) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(kRealWidth(12));
                } else {
                    make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(12));
                }
            }];

            UIView *itemLastView = titleLabel;
            NSArray *listArray = csModel.listArray;
            for (int i = 0; i < listArray.count; i++) {
                TNCustomerServiceItemModel *model = listArray[i];

                TNCallPhoneItemView *itemView = [[TNCallPhoneItemView alloc] init];
                itemView.model = model;
                itemView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
                    [view setGradualChangingColors:model.backgroundColors startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
                };
                [self.bgView addSubview:itemView];

                [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(kScreenWidth));
                    make.height.equalTo(@(115.f));
                    if (i == 0) {
                        make.top.mas_equalTo(itemLastView.mas_bottom).offset(kRealWidth(12.f));
                    } else {
                        make.top.mas_equalTo(itemLastView.mas_bottom);
                    }

                    if ((j == dataSource.count - 1) && (i == (listArray.count - 1))) {
                        make.bottom.equalTo(self.bgView.mas_bottom);
                    }
                }];
                itemLastView = itemView;
                lastView = itemView;
            }
        }
    }
}

- (NSArray<TNCustomerServiceModel *> *)getTinhnowDefaultPlatform {
    TNCustomerServiceItemModel *cellcardModel = TNCustomerServiceItemModel.new;
    cellcardModel.title = @"Cellcard";
    cellcardModel.key = @"085809809";
    cellcardModel.btnTitle = @"085809809";
    cellcardModel.btnImage = @"tn_phone_cellcard";
    cellcardModel.backgroundColors = @[HexColor(0xFFE7C3), [UIColor whiteColor]];
    cellcardModel.themeColor = HexColor(0xF9A01B);

    TNCustomerServiceItemModel *smartModel = TNCustomerServiceItemModel.new;
    smartModel.title = @"Smart";
    smartModel.key = @"0965550888";
    smartModel.btnTitle = @"0965550888";
    smartModel.btnImage = @"tn_phone_Smart";
    smartModel.backgroundColors = @[HexColor(0xCDFADC), [UIColor whiteColor]];
    smartModel.themeColor = HexColor(0x009432);

    TNCustomerServiceItemModel *metfoneModel = TNCustomerServiceItemModel.new;
    metfoneModel.title = @"metfone";
    metfoneModel.key = @"0314500888";
    metfoneModel.btnTitle = @"0314500888";
    metfoneModel.btnImage = @"tn_phone_metfone";
    metfoneModel.backgroundColors = @[HexColor(0xCBFEFF), [UIColor whiteColor]];
    metfoneModel.themeColor = HexColor(0x006668);

    TNCustomerServiceModel *model = [[TNCustomerServiceModel alloc] init];
    model.title = TNLocalizedString(@"tn_platform_phone", @"平台客服");
    model.listArray = @[cellcardModel, smartModel, metfoneModel];

    return @[model];
}

#pragma mark - 电话拨打
- (void)callClick:(HDUIButton *)btn {
    TNCustomerServiceItemModel *model = [btn hd_getBoundObjectForKey:@"callBtn"];
    NSString *phoneStr = model.key;
    if (HDIsStringNotEmpty(phoneStr) && [phoneStr hd_isPureDigitCharacters]) {
        [HDSystemCapabilityUtil makePhoneCall:phoneStr];
    }
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

@end


@implementation TNCustomerServiceModel

@end


@implementation TNCustomerServiceItemModel

@end
