//
//  SASelectableCouponTicketTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SASelectableCouponTicketTableViewCell.h"
#import "SASelectableCouponTicketView.h"


@interface SASelectableCouponTicketTableViewCell ()
/// 内容
@property (nonatomic, strong) SASelectableCouponTicketView *view;
@end


@implementation SASelectableCouponTicketTableViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;

    [self.contentView addSubview:self.view];

    @HDWeakify(self);
    self.view.clickedToUseBTNBlock = ^{
        @HDStrongify(self);
        !self.clickedToUseBTNBlock ?: self.clickedToUseBTNBlock();
    };
}

- (void)updateConstraints {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SACouponTicketModel *)model {
    _model = model;

    self.view.model = model;
    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.model.isSelected = selected;
    self.view.model = self.model;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SASelectableCouponTicketView *)view {
    return _view ?: ({ _view = SASelectableCouponTicketView.new; });
}

@end
