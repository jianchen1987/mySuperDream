//
//  WMHistoryTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/4/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMHistoryTableViewCell.h"


@interface WMHistoryTableViewCell ()
@property (nonatomic, strong) HDUIButton *button;
@end


@implementation WMHistoryTableViewCell
- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contentView addSubview:self.button];
}

- (void)updateConstraints {
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
        make.right.equalTo(self.contentView).offset(-kRealWidth(10));
        make.centerY.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setHistoryModel:(WMHistoryTableViewCellModel *)historyModel {
    _historyModel = historyModel;
    self.imageView.image = historyModel.image;
    self.textLabel.text = historyModel.title;
}

- (void)clearAtion:(HDUIButton *)sender {
    //    RWEvent *event = [[RWEvent alloc]init];
    //    event.sender = self;
    //    [event.userInfo setObject:@"clearAction" forKey:@"clearAction"];
    //    [self.nextResponder respondEvent:event];
    //
    [GNEvent eventResponder:self target:sender key:@"clearAction"];
}

- (HDUIButton *)button {
    if (!_button) {
        _button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:@"address_delete"] forState:UIControlStateNormal];
        [_button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clearAtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end


@implementation WMHistoryTableViewCellModel

@end
