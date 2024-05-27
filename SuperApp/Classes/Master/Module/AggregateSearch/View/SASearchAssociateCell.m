//
//  SASearchAssociateCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SASearchAssociateCell.h"


@interface SASearchAssociateCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) HDLabel *nameLB;

@end


@implementation SASearchAssociateCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLB];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(12);
        make.top.mas_equalTo(12);
        make.bottom.right.mas_equalTo(-12);
    }];
    [super updateConstraints];
}

- (void)setModel:(SASearchAssociateModel *)model {
    _model = model;
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
                                                   attributes:@{NSForegroundColorAttributeName: UIColor.sa_C333, NSFontAttributeName: HDAppTheme.font.sa_standard14SB}];
        for (NSTextCheckingResult *result in [matches objectEnumerator]) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: UIColor.sa_C1, NSFontAttributeName: HDAppTheme.font.sa_standard14} range:[result range]];
        }
        self.nameLB.attributedText = attrStr;
    } else {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:WMFillEmpty(model.name.desc)
                                                                                    attributes:@{NSForegroundColorAttributeName: UIColor.sa_C333, NSFontAttributeName: HDAppTheme.font.sa_standard14}];
        self.nameLB.attributedText = attrStr;
    }
    [self setNeedsUpdateConstraints];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.image = [UIImage imageNamed:@"search_icon_searchBar"];
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
