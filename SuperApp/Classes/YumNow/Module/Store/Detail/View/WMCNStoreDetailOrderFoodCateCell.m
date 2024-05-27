//
//  WMCNStoreDetailOrderFoodCateCell.m
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCNStoreDetailOrderFoodCateCell.h"


@interface WMCNStoreDetailOrderFoodCateCell ()
@property (nonatomic, strong) HDLabel *nameLB;
@end


@implementation WMCNStoreDetailOrderFoodCateCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLB];
}

- (void)setModel:(WMStoreMenuItem *)model {
    _model = model;
    NSString *name = WMFillEmpty(model.name);
    NSRange range = [name rangeOfString:@" "];
    if (range.location != NSNotFound) {
        name = [name stringByReplacingCharactersInRange:range withString:@"\n"];
    }
    self.nameLB.text = name;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.nameLB.text];
    mstr.yy_lineSpacing = kRealWidth(2);
    mstr.yy_alignment = NSTextAlignmentCenter;
    self.nameLB.attributedText = mstr;
    self.nameLB.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentView.backgroundColor = model.isSelected ? UIColor.whiteColor : HDAppTheme.WMColor.bgGray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setModel:self.model];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(kRealWidth(11));
        //        make.right.mas_equalTo(-kRealWidth(11));
        //        make.top.mas_equalTo(kRealWidth(6));
        //        make.bottom.mas_equalTo(-kRealWidth(6));
        //        make.height.mas_greaterThanOrEqualTo(kRealWidth(36));
        make.edges.mas_equalTo(0).insets(UIEdgeInsetsMake(kRealWidth(13), kRealWidth(12), kRealWidth(13), kRealWidth(12)));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.textColor = HDAppTheme.WMColor.B3;
        _nameLB.numberOfLines = 2;
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _nameLB;
}

@end
