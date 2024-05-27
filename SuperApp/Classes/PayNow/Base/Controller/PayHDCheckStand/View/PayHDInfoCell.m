//
//  PayHDInfoCell.m
//  ViPay
//
//  Created by Quin on 2021/9/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PayHDInfoCell.h"
#import "HDAppTheme.h"
#import "PNUtilMacro.h"
#import <Masonry/Masonry.h>


@implementation PayHDInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"PayHDInfoCell";
    PayHDInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PayHDInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(HDDealCommonInfoRowViewModel *)model {
    _model = model;
    _titleLabel.text = model.key;
    _detailLabel.text = model.value;
    [self setNeedsUpdateConstraints];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViews];
}
- (void)setupSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.left.equalTo(self.mas_left).offset(16);
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [HDAppTheme.font standard3];
        _titleLabel.textColor = [HDAppTheme.color G1];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [HDAppTheme.font standard3];
        _detailLabel.textColor = [HDAppTheme.color G1];
    }
    return _detailLabel;
}

@end
