//
//  GNGroupTextCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNGroupTextCell.h"


@interface GNGroupTextCell ()
/// 文字
@property (nonatomic, strong) HDLabel *leftLB;
/// leftIV
@property (nonatomic, strong) UIImageView *leftIV;
@end


@implementation GNGroupTextCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.leftIV];
}

- (void)updateConstraints {
    [self.leftIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.leftIV.hidden) {
            make.centerY.mas_equalTo(0);
            make.left.mas_offset(kRealWidth(12));
            make.size.mas_equalTo(self.leftIV.image.size);
        }
    }];

    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        if (!self.leftIV.hidden) {
            make.left.equalTo(self.leftIV.mas_right).offset(kRealWidth(12));
        } else {
            make.left.mas_offset(kRealWidth(12));
        }
        make.top.mas_offset(self.model.offset);
        make.bottom.mas_offset(-self.model.bottomOffset);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.leftLB.text = data.title;
    self.leftLB.font = data.titleFont;
    self.lineView.hidden = !data.lineHidden;
    self.leftLB.textColor = data.detailColor ?: HDAppTheme.color.gn_333Color;
    self.leftIV.hidden = !data.image;
    self.leftIV.image = data.image;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.leftLB.text];
    mstr.yy_lineSpacing = kRealWidth(4);
    self.leftLB.attributedText = mstr;
    [self setNeedsUpdateConstraints];
}

- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = HDLabel.new;
        _leftLB.numberOfLines = 0;
    }
    return _leftLB;
}

- (UIImageView *)leftIV {
    if (!_leftIV) {
        _leftIV = UIImageView.new;
    }
    return _leftIV;
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.right.hd_equalTo(self.hd_right - 15);
        make.left.hd_equalTo(15);
        make.top.hd_equalTo(10);
    }];
    return @[r1];
}

+ (CGFloat)skeletonViewHeight {
    return 50;
}

@end
