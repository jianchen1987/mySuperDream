//
//  GNStoreTimeView.m
//  SuperApp
//
//  Created by wmz on 2021/11/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreTimeView.h"
#import <YYText/YYText.h>


@interface GNStoreTimeView ()
@property (nonatomic, strong) HDLabel *merchantLB;
@property (nonatomic, strong) HDLabel *buinessLB;
@property (nonatomic, strong) HDLabel *timeLB;
@property (nonatomic, strong) HDFloatLayoutView *buinessContentLB;
@property (nonatomic, strong) HDFloatLayoutView *serverContentLB;
@property (nonatomic, strong) UIView *centerLine;

@end


@implementation GNStoreTimeView

- (void)hd_setupViews {
    [self addSubview:self.merchantLB];
    [self addSubview:self.buinessLB];
    [self addSubview:self.timeLB];
    [self addSubview:self.buinessContentLB];
    [self addSubview:self.serverContentLB];
    [self addSubview:self.centerLine];
}

- (void)updateConstraints {
    [self.buinessLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.top.mas_equalTo(kRealWidth(20));
    }];

    CGFloat width = kScreenWidth - 2 * HDAppTheme.value.gn_marginL;
    [self.buinessContentLB sizeToFit];
    [self.buinessContentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.top.equalTo(self.buinessLB.mas_bottom).offset(kRealWidth(12));
        CGSize size = [self.buinessContentLB sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.buinessLB);
        make.top.equalTo(self.buinessContentLB.mas_bottom).offset(kRealWidth(12));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.buinessLB);
        make.top.equalTo(self.timeLB.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
    }];

    [self.merchantLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.buinessLB);
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(20));
    }];

    [self.serverContentLB sizeToFit];
    [self.serverContentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.buinessLB);
        make.top.equalTo(self.merchantLB.mas_bottom).offset(kRealWidth(12));
        CGSize size = [self.serverContentLB sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
    }];
    [super updateConstraints];
}

- (void)setDetailModel:(GNStoreDetailModel *)detailModel {
    _detailModel = detailModel;
    NSArray *inServiceArr = [NSArray arrayWithArray:detailModel.inServiceName];
    if (HDIsArrayEmpty(inServiceArr)) {
        GNInternationalizationModel *model = [GNInternationalizationModel modelWithCN:@"暂无设置" en:@"No settings" kh:@"គ្មានការកំណត់"];
        inServiceArr = @[model];
    }

    self.timeLB.text = GNFillEmpty(detailModel.shortBusinessStr);
    [self.buinessContentLB.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDictionary *info = @{
        @"MONDAY": WMLocalizedString(@"monday", @"MONDAY"),
        @"TUESDAY": WMLocalizedString(@"tuesday", @"TUESDAY"),
        @"WEDNESDAY": WMLocalizedString(@"wednesday", @"WEDNESDAY"),
        @"THURSDAY": WMLocalizedString(@"thursday", @"THURSDAY"),
        @"FRIDAY": WMLocalizedString(@"friday", @"FRIDAY"),
        @"SATURDAY": WMLocalizedString(@"saturday", @"SATURDAY"),
        @"SUNDAY": WMLocalizedString(@"sunday", @"SUNDAY"),
    };
    for (int i = 0; i < detailModel.businessDays.count; i++) {
        GNMessageCode *code = detailModel.businessDays[i];
        if ([code isKindOfClass:GNMessageCode.class]) {
            NSString *tag = GNFillEmpty(info[code.codeId]);
            HDLabel *label = HDLabel.new;
            label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(2), kRealWidth(8), kRealWidth(2), kRealWidth(8));
            label.layer.backgroundColor = HDAppTheme.color.gn_mainBgColor.CGColor;
            ;
            label.layer.cornerRadius = kRealWidth(2);
            label.text = tag;
            label.textColor = HDAppTheme.color.gn_666Color;
            label.font = [HDAppTheme.font gn_ForSize:12];
            [self.buinessContentLB addSubview:label];
        }
    }

    [self.serverContentLB.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [inServiceArr enumerateObjectsUsingBlock:^(GNInternationalizationModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HDLabel *label = HDLabel.new;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(2), kRealWidth(8), kRealWidth(2), kRealWidth(8));
        label.layer.backgroundColor = HDAppTheme.color.gn_mainBgColor.CGColor;
        ;
        label.layer.cornerRadius = kRealWidth(2);
        label.text = obj.desc;
        label.textColor = HDAppTheme.color.gn_666Color;
        label.font = [HDAppTheme.font gn_ForSize:12];
        [self.serverContentLB addSubview:label];
    }];
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.serverContentLB.frame) + kRealWidth(20));
}

- (UIView *)centerLine {
    if (!_centerLine) {
        _centerLine = UIView.new;
        _centerLine.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _centerLine;
}

- (HDFloatLayoutView *)buinessContentLB {
    if (!_buinessContentLB) {
        _buinessContentLB = HDFloatLayoutView.new;
        _buinessContentLB.itemMargins = UIEdgeInsetsMake(0, 0, kRealWidth(8), kRealWidth(8));
    }
    return _buinessContentLB;
}

- (HDFloatLayoutView *)serverContentLB {
    if (!_serverContentLB) {
        _serverContentLB = HDFloatLayoutView.new;
        _serverContentLB.itemMargins = UIEdgeInsetsMake(0, 0, kRealWidth(8), kRealWidth(8));
    }
    return _serverContentLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        _timeLB = HDLabel.new;
        _timeLB.textColor = HDAppTheme.color.gn_333Color;
        _timeLB.font = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightMedium];
    }
    return _timeLB;
}

- (HDLabel *)merchantLB {
    if (!_merchantLB) {
        _merchantLB = HDLabel.new;
        _merchantLB.textColor = HDAppTheme.color.gn_333Color;
        _merchantLB.text = GNLocalizedString(@"gn_serve_merchant", @"店内服务");
        _merchantLB.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightHeavy];
    }
    return _merchantLB;
}

- (HDLabel *)buinessLB {
    if (!_buinessLB) {
        _buinessLB = HDLabel.new;
        _buinessLB.textColor = HDAppTheme.color.gn_333Color;
        _buinessLB.text = GNLocalizedString(@"gn_store_businessTime", @"营业时间");
        _buinessLB.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightHeavy];
    }
    return _buinessLB;
}

@end
