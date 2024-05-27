//
//  WMAssociateSearchCell.m
//  SuperApp
//
//  Created by wmz on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAssociateSearchCell.h"
#import "GNStringUntils.h"


@interface WMAssociateSearchCell ()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) HDLabel *nameLB;
@end


@implementation WMAssociateSearchCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLB];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
        }
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(12));
        } else {
            make.left.mas_equalTo(kRealWidth(12));
        }
        make.top.mas_equalTo(kRealWidth(12));
        make.bottom.right.mas_equalTo(-kRealWidth(12));
    }];
    [super updateConstraints];
}

- (void)setModel:(WMAssociateSearchModel *)model {
    _model = model;
    self.iconIV.hidden = !model.name;
    if (!model.name && !model.history) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"searchfor", @"Seach for")];
        NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"“%@”", WMFillEmpty(model.keyword)]];
        [GNStringUntils attributedString:string color:HDAppTheme.WMColor.B3 colorRange:string.string font:[HDAppTheme.WMFont wm_boldForSize:14] fontRange:string.string];
        [GNStringUntils attributedString:resultString color:HDAppTheme.WMColor.mainRed colorRange:model.keyword font:[HDAppTheme.WMFont wm_boldForSize:14] fontRange:model.keyword];
        [string appendAttributedString:resultString];
        self.nameLB.attributedText = string;
    } else {
        NSString *lowerCaseStoreName = model.name.desc.lowercaseString;
        NSString *lowerCaseKeyWord = model.keyword.lowercaseString;
        NSString *pattern = [NSString stringWithFormat:@"%@", lowerCaseKeyWord];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        NSArray *matches = @[];
        if (lowerCaseStoreName) {
            matches = [regex matchesInString:lowerCaseStoreName options:0 range:NSMakeRange(0, lowerCaseStoreName.length)];
        }
        if (HDIsStringNotEmpty(lowerCaseKeyWord) && matches.count > 0) {
            NSMutableAttributedString *attrStr =
                [[NSMutableAttributedString alloc] initWithString:WMFillEmpty(model.name.desc)
                                                       attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B9, NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14]}];
            for (NSTextCheckingResult *result in [matches objectEnumerator]) {
                [attrStr addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:14]} range:[result range]];
            }
            self.nameLB.attributedText = attrStr;
        } else {
            NSMutableAttributedString *attrStr =
                [[NSMutableAttributedString alloc] initWithString:WMFillEmpty(model.name.desc)
                                                       attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B9, NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14]}];
            self.nameLB.attributedText = attrStr;
        }
        self.iconIV.image = [UIImage imageNamed:model.history ? @"yn_searchresult_lenovo" : @"yn_search_lenovo"];
    }
    [self setNeedsUpdateConstraints];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.image = [UIImage imageNamed:@"yn_search_lenovo"];
    }
    return _iconIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.numberOfLines = 0;
    }
    return _nameLB;
}

@end
