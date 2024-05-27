//
//  WMSpecialStoreSignaturesCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMSpecialStoreSignaturesCell.h"
#import "WMStoreProductModel.h"


@interface WMSpecialStoreSignaturesCell ()
/// 图片
@property (nonatomic, strong) UIImageView *imageV;
/// 原价
@property (nonatomic, strong) SALabel *priceLB;
/// 售价
@property (nonatomic, strong) SALabel *saleLB;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 新标签背景
@property (nonatomic, strong) UIView *logoTagBgView;
/// 新标签
@property (nonatomic, strong) SALabel *logoTagLabel;

@end


@implementation WMSpecialStoreSignaturesCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.priceLB];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.saleLB];
    [self.contentView addSubview:self.logoTagBgView];
    [self.logoTagBgView addSubview:self.logoTagLabel];
    self.imageV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(6)];
    };
}

- (void)updateConstraints {
    [self.logoTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.imageV);
    }];

    [self.logoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoTagBgView.mas_left).offset(kRealWidth(5));
        make.top.equalTo(self.logoTagBgView.mas_top);
        make.bottom.equalTo(self.logoTagBgView.mas_bottom);
        make.right.equalTo(self.logoTagBgView.mas_right).offset(kRealWidth(-5));
    }];

    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.imageV.mas_width);
        make.left.top.equalTo(self.contentView);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.top.equalTo(self.imageV.mas_bottom).offset(kRealWidth(4));
    }];

    [self.saleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(4));
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.saleLB);
        make.left.equalTo(self.saleLB.mas_right).offset(kRealWidth(0.5));
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(WMSpecialStoreSignaturesModel *)model {
    _model = model;
    NSString *imagePath;
    NSString *nameStr;
    NSString *discountNumber;
    NSString *salePriceNumber;
    NSString *lowerCaseKeyWord;
    ///招牌菜
    if ([model isKindOfClass:WMSpecialStoreSignaturesModel.class]) {
        imagePath = model.imagePath;
        nameStr = model.nameLanguage.desc;
        discountNumber = [self removeSuffix:model.discountPrice.thousandSeparatorAmount];
        salePriceNumber = [self removeSuffix:model.salePrice.thousandSeparatorAmount];
        self.logoTagBgView.hidden = YES;
        ///商品
    } else if ([model isKindOfClass:WMStoreProductModel.class]) {
        WMStoreProductModel *productModel = (WMStoreProductModel *)model;
        imagePath = productModel.imagePath;
        nameStr = productModel.name.desc;
        lowerCaseKeyWord = productModel.keyWord.lowercaseString;
        discountNumber = productModel.salePrice.thousandSeparatorAmount;
        salePriceNumber = productModel.price.thousandSeparatorAmount;
        self.logoTagBgView.hidden = !productModel.isNewStore;
    }
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(75), kRealWidth(75))]];
    self.saleLB.textColor = HDAppTheme.WMColor.mainRed;

    NSString *lowerCaseName = nameStr.lowercaseString;
    NSString *pattern = [NSString stringWithFormat:@"%@", lowerCaseKeyWord];
    NSArray *matches = nil;
    if (pattern && lowerCaseName) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        matches = [regex matchesInString:lowerCaseName options:0 range:NSMakeRange(0, lowerCaseName.length)];
    }
    ///关键词
    if (HDIsStringNotEmpty(lowerCaseKeyWord) && matches.count > 0) {
        NSMutableAttributedString *attrStr =
            [[NSMutableAttributedString alloc] initWithString:nameStr attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:12]}];
        for (NSTextCheckingResult *result in [matches objectEnumerator]) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed, NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:12]} range:[result range]];
        }
        self.nameLB.attributedText = attrStr;
    } else {
        self.nameLB.textColor = HDAppTheme.WMColor.B3;
        self.nameLB.font = [HDAppTheme.WMFont wm_ForSize:12];
        ;
        self.nameLB.text = WMFillEmpty(nameStr);
    }
    self.saleLB.text = discountNumber;

    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleThick]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:salePriceNumber attributes:attribtDic];
    self.priceLB.attributedText = attribtStr;
    self.priceLB.hidden = [self.priceLB.attributedText.string isEqualToString:self.saleLB.text];

    [self setNeedsUpdateConstraints];
}

- (NSString *)removeSuffix:(NSString *)numberStr {
    if (numberStr.length > 1) {
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            } else {
                if ([[last substringFromIndex:last.length - 1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    } else {
        return nil;
    }
}

#pragma mark - lazy load
- (UIImageView *)imageV {
    if (!_imageV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = HDHelper.placeholderImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageV = imageView;
    }
    return _imageV;
}

- (SALabel *)saleLB {
    if (!_saleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:12];
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.numberOfLines = 1;
        _saleLB = label;
    }
    return _saleLB;
}

- (SALabel *)priceLB {
    if (!_priceLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        label.textColor = [UIColor hd_colorWithHexString:@"#B1B1B1"];
        label.numberOfLines = 1;
        _priceLB = label;
    }
    return _priceLB;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        _nameLB = label;
    }
    return _nameLB;
}

- (UIView *)logoTagBgView {
    if (!_logoTagBgView) {
        _logoTagBgView = [[UIView alloc] init];
        _logoTagBgView.backgroundColor = HDAppTheme.WMColor.mainRed;
        _logoTagBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:5];
        };
    }
    return _logoTagBgView;
}

- (SALabel *)logoTagLabel {
    if (!_logoTagLabel) {
        _logoTagLabel = [[SALabel alloc] init];
        _logoTagLabel.textColor = UIColor.whiteColor;
        _logoTagLabel.font = HDAppTheme.font.standard5Bold;
        _logoTagLabel.text = WMLocalizedString(@"is_new_product", @"New");
    }
    return _logoTagLabel;
}

@end
