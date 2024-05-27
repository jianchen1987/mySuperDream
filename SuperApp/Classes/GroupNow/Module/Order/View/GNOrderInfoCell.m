//
//  GNOrderInfoCell.m
//  SuperApp
//
//  Created by wmz on 2022/6/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderInfoCell.h"
#import "GNStringUntils.h"


@interface GNOrderInfoCell ()
/// 右侧图片
@property (nonatomic, strong) HDUIButton *rightBtn;
/// 左侧文字
@property (nonatomic, strong) HDLabel *leftLB;
/// 右侧文字
@property (nonatomic, strong) HDLabel *rightLB;

@end


@implementation GNOrderInfoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.rightLB];
}

- (void)updateConstraints {
    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.top.mas_equalTo(kRealWidth(4));
        make.bottom.mas_lessThanOrEqualTo(-(self.model.bottomOffset ?: kRealWidth(4)));
    }];

    [self.rightLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLB.mas_right).offset(kRealWidth(4));
        make.top.equalTo(self.leftLB);
        if (self.rightBtn.isHidden) {
            make.right.mas_offset(-HDAppTheme.value.gn_marginL);
        }
        make.bottom.mas_lessThanOrEqualTo(-(self.model.bottomOffset ?: kRealWidth(4)));
    }];

    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightBtn.isHidden) {
            make.centerY.mas_equalTo(self.leftLB);
            make.left.equalTo(self.rightLB.mas_right).offset(kRealWidth(4));
            make.height.mas_equalTo(kRealWidth(18));
        }
    }];

    [self.rightLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    if ([data isKindOfClass:GNCellModel.class]) {
        [self.rightBtn setTitle:data.imageTitle forState:UIControlStateNormal];
        self.rightBtn.hidden = !data.imageTitle;
        self.rightBtn.layer.borderWidth = data.imageTitle ? 0.5 : 0;
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:GNFillEmptySpace(data.detail)];
        [GNStringUntils attributedString:mstr lineSpacing:kRealWidth(6) colorRange:mstr.string];

        NSMutableAttributedString *mleftStr = [[NSMutableAttributedString alloc] initWithString:GNFillEmptySpace(data.title)];
        [GNStringUntils attributedString:mleftStr lineSpacing:kRealWidth(6) colorRange:mleftStr.string];
        self.leftLB.attributedText = mleftStr;
        self.rightLB.attributedText = mstr;
    }
    [self setNeedsUpdateConstraints];
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.userInteractionEnabled = NO;
        _rightBtn.layer.borderColor = HDAppTheme.color.gn_666Color.CGColor;
        _rightBtn.layer.cornerRadius = kRealWidth(2);
        _rightBtn.titleLabel.font = [HDAppTheme.font gn_ForSize:11];
        [_rightBtn setTitleColor:HDAppTheme.color.gn_666Color forState:UIControlStateNormal];
        _rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(6), 0, kRealWidth(6));
        _rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _rightBtn.userInteractionEnabled = NO;
    }
    return _rightBtn;
}

- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = HDLabel.new;
        _leftLB.numberOfLines = 1;
        _leftLB.textColor = HDAppTheme.color.gn_999Color;
        _leftLB.font = HDAppTheme.font.gn_12;
    }
    return _leftLB;
}

- (HDLabel *)rightLB {
    if (!_rightLB) {
        _rightLB = HDLabel.new;
        _rightLB.numberOfLines = 0;
        _rightLB.textColor = HDAppTheme.color.gn_333Color;
        _rightLB.font = HDAppTheme.font.gn_12;
    }
    return _rightLB;
}

@end
