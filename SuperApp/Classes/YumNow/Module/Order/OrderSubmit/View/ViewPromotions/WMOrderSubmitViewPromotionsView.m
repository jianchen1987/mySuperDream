//
//  WMOrderSubmitViewPromotionsView.m
//  SuperApp
//
//  Created by VanJay on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitViewPromotionsView.h"
#import "SAInfoView.h"
#import "SAMoneyModel.h"
#import "WMOrderSubmitPromotionModel.h"
#import "WMPromotionItemView.h"


@interface WMOrderSubmitViewPromotionsView ()
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 所有的属性
//@property (nonatomic, strong) NSMutableArray<SAInfoView *> *infoViewList;
/// 所有属性
@property (nonatomic, strong) NSMutableArray<WMPromotionItemView *> *infoViewList;

@end


@implementation WMOrderSubmitViewPromotionsView

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.titleLB];
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), size.height);
}

#pragma mark - setter
- (void)setNoneDeliveryPromotionList:(NSArray<WMOrderSubmitPromotionModel *> *)noneDeliveryPromotionList {
    _noneDeliveryPromotionList = noneDeliveryPromotionList;

    [self.infoViewList makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // 促销活动
    @HDWeakify(self);
    [noneDeliveryPromotionList enumerateObjectsUsingBlock:^(WMOrderSubmitPromotionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        WMPromotionItemView *infoView = WMPromotionItemView.new;

        @HDStrongify(self);
        switch (obj.marketingType) {
            case WMStorePromotionMarketingTypeDiscount: {
                NSString *desc;
                if (obj.discountRatio.doubleValue > 0) {
                    if (SAMultiLanguageManager.isCurrentLanguageCN) {
                        desc = [NSString stringWithFormat:WMLocalizedString(@"store_detail_discount", @"%@%@%@折"),
                                                          [SAGeneralUtil getDayStringWithDateWeekdayIndex:obj.openingWeekdays.integerValue],
                                                          obj.openingTimes ?: @"",
                                                          obj.discountRadioStr];
                    } else {
                        desc = [NSString stringWithFormat:WMLocalizedString(@"store_detail_discount", @"全场%.1f折%@%@"),
                                                          obj.discountRatio.doubleValue,
                                                          [SAGeneralUtil getDayStringWithDateWeekdayIndex:obj.openingWeekdays.integerValue],
                                                          obj.openingTimes ?: @""];
                    }
                }
                infoView.itemType = WMStorePromotionMarketingTypeDiscount;
                infoView.showTips = desc;

                //                SAInfoViewModel *infoViewModel = [self hd_setupInfoViewModelWithImage:@"store_info_promotion_discount" keyText:desc];
                //                SAInfoView *infoView = [SAInfoView infoViewWithModel:infoViewModel];
                [self.infoViewList addObject:infoView];
                [self addSubview:infoView];
            } break;

            case WMStorePromotionMarketingTypeLabber:
            case WMStorePromotionMarketingTypeStoreLabber: {
                WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;

                NSString *desc;
                desc = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "),
                                                  inUseLadderRuleModel.thresholdAmt.thousandSeparatorAmount,
                                                  inUseLadderRuleModel.discountAmt.thousandSeparatorAmount];

                //
                //                SAInfoViewModel *infoViewModel = [self hd_setupInfoViewModelWithImage:@"store_info_promotion_discount" keyText:desc];
                //                SAInfoView *infoView = [SAInfoView infoViewWithModel:infoViewModel];
                infoView.itemType = WMStorePromotionMarketingTypeLabber;
                infoView.showTips = desc;

                [self.infoViewList addObject:infoView];
                [self addSubview:infoView];
            } break;
            case WMStorePromotionMarketingTypeFirst: {
                NSString *desc = [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @"%@ Off 1st Order"), obj.firstOrderReductionAmount.thousandSeparatorAmount];

                infoView.itemType = WMStorePromotionMarketingTypeFirst;
                infoView.showTips = desc;

                [self.infoViewList addObject:infoView];
                [self addSubview:infoView];
            } break;
            case WMStorePromotionMarketingTypeCoupon: {
                WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;

                NSString *desc;
                desc = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "),
                                                  inUseLadderRuleModel.thresholdAmt.thousandSeparatorAmount,
                                                  inUseLadderRuleModel.discountAmt.thousandSeparatorAmount];
                infoView.itemType = WMStorePromotionMarketingTypeCoupon;
                infoView.showTips = desc;

                [self.infoViewList addObject:infoView];
                [self addSubview:infoView];
            } break;
            default:
                break;
        }
    }];
}

#pragma mark - private methods
- (SAInfoViewModel *)hd_setupInfoViewModelWithImage:(NSString *)image keyText:(NSString *)keyText {
    SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
    model.leftImage = [UIImage imageNamed:image];
    model.keyText = keyText;
    model.lineWidth = 0;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, kRealWidth(12), 0);
    return model;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kRealWidth(20));
        if (HDIsArrayEmpty(self.infoViewList)) {
            make.bottom.equalTo(self).offset(-kRealWidth(20));
        }
    }];
    WMPromotionItemView *lastInfoView;
    for (WMPromotionItemView *infoView in self.infoViewList) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(15));
            }
            make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
            make.centerX.equalTo(self);
            if (infoView == self.infoViewList.lastObject) {
                make.bottom.equalTo(self);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"order_participated_promotions", @"You have participated in the following offers");
        _titleLB = label;
    }
    return _titleLB;
}

- (NSMutableArray *)infoViewList {
    if (!_infoViewList) {
        _infoViewList = [NSMutableArray arrayWithCapacity:2];
    }
    return _infoViewList;
}
@end
