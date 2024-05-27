//
//  GNCommonBTNCell.m
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCommonBTNCell.h"


@interface GNCommonBTNCell ()
///按钮
@property (nonatomic, strong) HDUIButton *BTN;

@end


@implementation GNCommonBTNCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.BTN];
}

- (void)updateConstraints {
    [self.BTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.model.outInsets.top);
        make.bottom.mas_equalTo(-self.model.outInsets.bottom);
        make.left.mas_equalTo(self.model.outInsets.left);
        make.right.mas_equalTo(-self.model.outInsets.right);
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.BTN.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.BTN.contentEdgeInsets = data.innerInsets;
    self.BTN.titleLabel.font = data.titleFont;
    self.BTN.layer.cornerRadius = data.offset;
    [self.BTN setTitle:GNFillEmpty(data.title) forState:UIControlStateNormal];
    [self.BTN setTitleColor:data.titleColor forState:UIControlStateNormal];
    self.BTN.layer.borderColor = data.nameColor ? data.nameColor.CGColor : UIColor.clearColor.CGColor;
    self.BTN.layer.borderWidth = 1;
    self.BTN.layer.backgroundColor = data.backgroundColor ? data.backgroundColor.CGColor : UIColor.clearColor.CGColor;
    [self setNeedsUpdateConstraints];
}

- (HDUIButton *)BTN {
    if (!_BTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"operationAction" indexPath:nil];
        }];
        _BTN = btn;
    }
    return _BTN;
}

@end
