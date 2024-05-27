//
//  TNExpressFreightDetailCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressFreightDetailCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNExpressDetailsModel.h"


@interface TNExpressFreightDetailCell ()
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 子视图
@property (strong, nonatomic) UIView *listContainerView;

@end


@implementation TNExpressFreightDetailCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.listContainerView];
}
- (void)setModel:(TNExpressFreightDetailCellModel *)model {
    _model = model;
    [self createContainerView];
}
- (void)createContainerView {
    [self.listContainerView hd_removeAllSubviews];
    UIView *lastView = nil;
    for (int i = 0; i < self.model.dataArr.count; i++) {
        NSString *key = self.model.dataArr[i];
        UILabel *subLabel = [[UILabel alloc] init];
        if (i == self.model.dataArr.count - 1) {
            subLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
            subLabel.textColor = HexColor(0xFF2323);
        } else {
            subLabel.font = HDAppTheme.TinhNowFont.standard12;
            subLabel.textColor = HexColor(0x5D667F);
        }
        subLabel.text = key;
        [self.listContainerView addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.listContainerView);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(5));
            } else {
                make.top.equalTo(self.listContainerView.mas_top);
            }
            if (i == self.model.dataArr.count - 1) {
                make.bottom.equalTo(self.listContainerView);
            }
        }];
        lastView = subLabel;
    }
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(5));
    }];
    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"m7q6Rfk6", @"运费明细");
    }
    return _titleLabel;
}
/** @lazy listContainerView */
- (UIView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[UIView alloc] init];
    }
    return _listContainerView;
}
@end


@implementation TNExpressFreightDetailCellModel
+ (instancetype)configCellModelWithDetailModel:(TNExpressDetailsModel *)detailModel {
    TNExpressFreightDetailCellModel *cellModel = [[TNExpressFreightDetailCellModel alloc] init];
    //    NSString *ceFright =
    //        [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"Te3WGmBJ", @"合计运费"), HDIsObjectNil(detailModel.ceFreight) ? @"-" : detailModel.ceFreight.thousandSeparatorAmount];
    //    NSString *ceActualWeight =
    //        [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"6jX8JysY", @"计费总重"), HDIsStringEmpty(detailModel.ceActualWeightUnit) ? @"-" : detailModel.ceActualWeightUnit];
    //    NSString *ceSafeWorth =
    //        [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"goC0O6Uj", @"保险费"), HDIsObjectNil(detailModel.ceSafeWorth) ? @"-" : detailModel.ceSafeWorth.thousandSeparatorAmount];
    //    NSString *ceRemoteCost =
    //        [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"TVTi60bs", @"附加费"), HDIsObjectNil(detailModel.ceRemoteCost) ? @"-" : detailModel.ceRemoteCost.thousandSeparatorAmount];
    //    NSString *ceVasCost =
    //        [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"3ZuRbAB4", @"增值服务"), HDIsObjectNil(detailModel.ceVasCost) ? @"-" : detailModel.ceVasCost.thousandSeparatorAmount];
    //    NSString *ceWorth = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"S416PauM", @"应付总额"), HDIsObjectNil(detailModel.ceWorth) ? @"-" :
    //    detailModel.ceWorth.thousandSeparatorAmount];
    NSMutableArray *arr = [NSMutableArray array];
    for (id item in detailModel.pricingItems) {
        if ([item isKindOfClass:NSDictionary.class]) {
            NSDictionary *dic = item;
            NSString *name = dic[@"name"];
            NSString *value = dic[@"value"];
            if (name && value) {
                NSString *showName = [NSString stringWithFormat:@"%@: %@", name, value];
                [arr addObject:showName];
            }
        }
    }
    cellModel.dataArr = arr;
    return cellModel;
}
@end
