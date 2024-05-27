//
//  bankListCell.m
//  ViPay
//
//  Created by Quin on 2021/8/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNBankListCell.h"
#import "HDAppTheme.h"
#import "PNUtilMacro.h"
#import "SAAppEnvManager.h"
#import <HDVendorKit/HDWebImageManager.h>
#import <Masonry/Masonry.h>


@implementation PNBankListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"bankListCell";
    PNBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PNBankListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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

- (void)setModel:(PNBankListModel *)model {
    _model = model;
    NSString *logoURLStr = [NSString stringWithFormat:@"%@/files/files/app/%@", SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer, model.logo];
    HDLog(@"%@", logoURLStr);
    [HDWebImageManager setImageWithURL:logoURLStr placeholderImage:[UIImage imageNamed:@"toBank1"] imageView:self.iconImageView];

    _titleLabel.text = model.bin;
    [self setNeedsUpdateConstraints];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineview];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(23);
        make.width.height.mas_equalTo(30);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.left.equalTo(self.iconImageView.mas_right).offset(16);
    }];
    [self.lineview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.width.equalTo(self.contentView.mas_width).offset(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - lazy load
/** @lazy iconImageView */
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

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

- (UIView *)lineview {
    if (!_lineview) {
        _lineview = UIView.new;
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineview;
}
@end
