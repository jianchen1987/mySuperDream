//
//  WMStoreInfoViewModel.m
//  SuperApp
//
//  Created by Chaos on 2020/6/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreInfoViewModel.h"
#import <YYText.h>

#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SACaculateNumberTool.h"
#import "SAInfoViewModel.h"
#import "SAInternationalizationModel.h"
#import "WMStoreDetailDTO.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreDetailRspModel.h"
#import "WMStoreLadderRuleModel.h"


@interface WMStoreInfoViewModel ()

@property (nonatomic, copy) NSString *reviewImg;
@property (nonatomic, strong) UIFont *reviewFont;
@property (nonatomic, strong) UIColor *reviewTextColor;
@property (nonatomic, strong) UIColor *reviewStartColor;
/// reviews
@property (nonatomic, strong, readwrite) NSAttributedString *reviewsDesc;
/// 折扣
@property (nonatomic, strong, readwrite) SAInfoViewModel *discountModel;
/// 满减
@property (nonatomic, strong, readwrite) SAInfoViewModel *fullReductionModel;
/// 配送折扣
@property (nonatomic, strong, readwrite) SAInfoViewModel *deliveryFeeModel;
/// 营业时间
@property (nonatomic, copy, readwrite) NSString *businessHours;
/// 特色
@property (nonatomic, copy, readwrite) NSString *cusines;
/// 图片数组
@property (nonatomic, strong, readwrite) NSArray *pictureArray;
/// DTO
@property (nonatomic, strong) WMStoreDetailDTO *detailDTO;

@end


@implementation WMStoreInfoViewModel

- (instancetype)initWithImage:(NSString *)image font:(UIFont *)font textColor:(nonnull UIColor *)color startColor:(nonnull UIColor *)startColor {
    if (self = [super init]) {
        _reviewImg = image;
        _reviewFont = font;
        _reviewTextColor = color;
        _reviewStartColor = startColor;
    }
    return self;
}

#pragma mark - public methods
- (void)getStoreDetialinfo {
    @HDWeakify(self);
    [self.detailDTO getStoreDetailInfoWithStoreNo:self.storeNo success:^(WMStoreDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.repModel = rspModel;
    } failure:nil];
}

#pragma mark - setter
- (void)setRepModel:(WMStoreDetailRspModel *)repModel {
    _repModel = repModel;

    _reviewsDesc = nil;

    // 营业时间
    NSArray<NSString *> *arrayList = [repModel.businessHours mapObjectsUsingBlock:^id _Nonnull(NSArray<NSString *> *_Nonnull obj, NSUInteger idx) {
        return [obj componentsJoinedByString:@"-"];
    }];
    self.businessHours = [arrayList componentsJoinedByString:@"\n"];
    NSMutableString *str = [NSMutableString stringWithString:[self transformDay]];
    [str appendString:@"\n"];
    [str appendString:self.businessHours];
    self.businessHours = str;

    // 品类
    if ([repModel.businessScopesV2 isKindOfClass:NSArray.class] && repModel.businessScopesV2.count) {
        NSMutableString *categories = NSMutableString.new;
        NSMutableArray *stack = [NSMutableArray new];
        [stack addObjectsFromArray:repModel.businessScopesV2];
        IficationModel *treeModel = nil;

        while (stack.count) {
            treeModel = stack.firstObject;
            if ([treeModel isKindOfClass:IficationModel.class] && treeModel.classificationName) {
                [categories appendFormat:@"%@、", treeModel.classificationName];
            }
            [stack removeObjectAtIndex:0];
            for (NSInteger i = 0; i < treeModel.subClassifications.count; i++) {
                [stack insertObject:treeModel.subClassifications[i] atIndex:0];
            }
        }
        if (categories.length > 0 && [[categories substringFromIndex:categories.length - 1] isEqualToString:@"、"]) {
            [categories deleteCharactersInRange:NSMakeRange(categories.length - 1, 1)];
        }
        self.cusines = categories;
    }

    // 支付方式
    NSMutableArray *payStrArray = [NSMutableArray array];
    if ([repModel.supportedPayments containsObject:WMStoreSupportedPaymentTypeOnline]) {
        [payStrArray addObject:WMLocalizedString(@"choose_payment_online", @"Pay Online")];
    }
    if ([repModel.supportedPayments containsObject:WMStoreSupportedPaymentTypeOffline]) {
        [payStrArray addObject:WMLocalizedString(@"5K8ZBMsK", @"Cash On Delivery")];
    }
    self.payMethod = [payStrArray componentsJoinedByString:@"，"];
}

- (NSString *)transformDay {
    NSMutableArray *temp = [NSMutableArray array];
    NSArray *day = @[@"MONDAY", @"TUESDAY", @"WEDNESDAY", @"THURSDAY", @"FRIDAY", @"SATURDAY", @"SUNDAY"];
    NSArray *transform = @[
        WMLocalizedString(@"monday", @"MONDAY"),
        WMLocalizedString(@"tuesday", @"TUESDAY"),
        WMLocalizedString(@"wednesday", @"WEDNESDAY"),
        WMLocalizedString(@"thursday", @"THURSDAY"),
        WMLocalizedString(@"friday", @"FRIDAY"),
        WMLocalizedString(@"saturday", @"SATURDAY"),
        WMLocalizedString(@"sunday", @"SUNDAY")
    ];
    for (int i = 0; i < self.repModel.businessDays.count; i++) {
        if (i < day.count) {
            int index = -1;
            if ([self.repModel.businessDays[i] isEqualToString:day[0]]) {
                index = 0;
            } else if ([self.repModel.businessDays[i] isEqualToString:day[1]]) {
                index = 1;
            } else if ([self.repModel.businessDays[i] isEqualToString:day[2]]) {
                index = 2;
            } else if ([self.repModel.businessDays[i] isEqualToString:day[3]]) {
                index = 3;
            } else if ([self.repModel.businessDays[i] isEqualToString:day[4]]) {
                index = 4;
            } else if ([self.repModel.businessDays[i] isEqualToString:day[5]]) {
                index = 5;
            } else if ([self.repModel.businessDays[i] isEqualToString:day[6]]) {
                index = 6;
            }
            [temp addObject:transform[index]];
        }
    }
    return [temp componentsJoinedByString:@" "];
}

- (NSAttributedString *)discountAndDelievry {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    UIFont *font = HDAppTheme.font.standard4;
    // 空格
    NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];

    UIImage *clockImage = [UIImage imageNamed:@"delivery_time_clock_gray"];
    NSMutableAttributedString *appendingStr = [NSMutableAttributedString yy_attachmentStringWithContent:clockImage contentMode:UIViewContentModeCenter
                                                                                         attachmentSize:CGSizeMake(clockImage.size.width, font.lineHeight)
                                                                                            alignToFont:font
                                                                                              alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:appendingStr];
    [text appendAttributedString:whiteSpace];

    NSString *distanceAndTimeStr = [NSString
        stringWithFormat:@"%@ %zdmins", [SACaculateNumberTool distanceStringFromNumber:self.repModel.distance toFixedCount:0 roundingMode:SANumRoundingModeOnlyUp], self.repModel.deliveryTime];
    appendingStr = [[NSMutableAttributedString alloc] initWithString:distanceAndTimeStr attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: font}];

    [text appendAttributedString:appendingStr];
    [text appendAttributedString:whiteSpace];
    [text appendAttributedString:whiteSpace];

    UIImage *dotImage = [UIImage imageNamed:@"point_indi"];
    appendingStr = [NSMutableAttributedString yy_attachmentStringWithContent:dotImage contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(dotImage.size.width, font.lineHeight)
                                                                 alignToFont:font
                                                                   alignment:YYTextVerticalAlignmentCenter];

    [text appendAttributedString:appendingStr];
    [text appendAttributedString:whiteSpace];
    [text appendAttributedString:whiteSpace];

    if(self.repModel.showDeliveryStr) {
        appendingStr = [[NSMutableAttributedString alloc] initWithString:self.repModel.showDeliveryStr attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: font}];
        [text appendAttributedString:appendingStr];
    }

    return text.copy;
}

- (NSAttributedString *)reviewsDesc {
    if (!_reviewsDesc) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];

        UIImage *image = [UIImage imageNamed:self.reviewImg];
        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(image.size.width, 14)
                                                                                              alignToFont:self.reviewFont
                                                                                                alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachment];

        NSString *score = [NSString stringWithFormat:@" %.1f ", self.repModel.reviewScore];
        NSAttributedString *stars = [[NSAttributedString alloc] initWithString:score attributes:@{NSForegroundColorAttributeName: self.reviewStartColor, NSFontAttributeName: self.reviewFont}];
        [text appendAttributedString:stars];

        // 拼接评价
        NSString *countStr;
        if (self.repModel.reviewCount <= 10000) {
            countStr = [NSString stringWithFormat:@"%zd", self.repModel.reviewCount];
        } else {
            NSUInteger integeCount = self.repModel.reviewCount / 10000;
            countStr = [NSString stringWithFormat:@"%zdk+", integeCount];
        }

        NSString *reviewStr = [NSString stringWithFormat:@"| %@ %@ ", countStr, WMLocalizedString(@"reviews", @"条评价")];

        NSAttributedString *reviews = [[NSAttributedString alloc] initWithString:reviewStr attributes:@{NSForegroundColorAttributeName: self.reviewTextColor}];
        [text appendAttributedString:reviews];

        _reviewsDesc = text.copy;
    }
    return _reviewsDesc;
}

- (NSString *)name {
    return self.repModel.storeName.desc;
}

- (NSString *)distanceAndTimeStr {
    NSString *distanceAndTimeStr = [NSString
        stringWithFormat:@"%zdmins %@", self.repModel.deliveryTime, [SACaculateNumberTool distanceStringFromNumber:self.repModel.distance toFixedCount:0 roundingMode:SANumRoundingModeOnlyUp]];

    return distanceAndTimeStr;
}

- (NSString *)delivery {
    NSString *fee = self.repModel.deliveryFee.cent.doubleValue > 0 ? self.repModel.deliveryFee.thousandSeparatorAmount : WMLocalizedString(@"free_delivery", @"免配送费");
    return fee;
}

- (NSString *)iconUrl {
    return self.repModel.logo;
}

- (NSString *)notice {
    return self.repModel.announcement.desc;
}

- (NSArray *)pictureArray {
    return self.repModel.photos;
}

- (NSString *)address {
    return self.repModel.address;
}

- (NSNumber *)longitude {
    return self.repModel.longitude;
}

- (NSNumber *)latitude {
    return self.repModel.latitude;
}

- (SAInfoViewModel *)hd_setupInfoViewModelWithImage:(NSString *)image keyText:(NSString *)keyText {
    SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
    model.leftImage = [UIImage imageNamed:image];
    model.keyText = keyText;
    model.keyColor = HDAppTheme.color.G2;
    model.keyFont = HDAppTheme.font.standard3;
    model.lineWidth = 0;
    model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    return model;
}

- (SAInfoViewModel *)discountModel {
    if (!_discountModel) {
        _discountModel = [self hd_setupInfoViewModelWithImage:@"store_info_promotion_discount" keyText:nil];
        _discountModel.leftImageSize = CGSizeMake(14, 14 * (_discountModel.leftImage.size.height / _discountModel.leftImage.size.width));
    }
    return _discountModel;
}

- (SAInfoViewModel *)deliveryFeeModel {
    if (!_deliveryFeeModel) {
        _deliveryFeeModel = [self hd_setupInfoViewModelWithImage:@"store_info_promotion_delivery" keyText:nil];
        _deliveryFeeModel.leftImageSize = CGSizeMake(14, 14 * (_deliveryFeeModel.leftImage.size.height / _deliveryFeeModel.leftImage.size.width));
    }
    return _deliveryFeeModel;
}

- (SAInfoViewModel *)fullReductionModel {
    if (!_fullReductionModel) {
        _fullReductionModel = [self hd_setupInfoViewModelWithImage:@"store_info_promotion_full_reduction" keyText:nil];
        _fullReductionModel.leftImageSize = CGSizeMake(14, 14 * (_fullReductionModel.leftImage.size.height / _fullReductionModel.leftImage.size.width));
    }
    return _fullReductionModel;
}

- (WMStoreDetailDTO *)detailDTO {
    if (!_detailDTO) {
        _detailDTO = [[WMStoreDetailDTO alloc] init];
    }
    return _detailDTO;
}

@end
