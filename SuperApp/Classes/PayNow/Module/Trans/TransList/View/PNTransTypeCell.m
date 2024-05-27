//
//  TransTypeCell.m
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTransTypeCell.h"


@implementation PNTransTypeCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TransTypeCell";
    PNTransTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 去除选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.bgView];
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#F8F8F8"];
    [self.bgView addSubview:self.iconImg];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.arrowImg];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(5));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(5));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(kRealWidth(15));
        make.width.mas_equalTo(kRealWidth(25));
        make.height.mas_equalTo(kRealWidth(25));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.iconImg.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.arrowImg.mas_left).offset(-kRealWidth(10));
    }];
    [self.arrowImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
        make.width.mas_equalTo(kRealWidth(18));
        make.height.mas_equalTo(kRealWidth(18));
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - getters and setters
- (void)setModel:(PNTransTypeModel *)model {
    _model = model;

    [HDWebImageManager setGIFImageWithURL:model.logoPath size:CGSizeMake(kRealWidth(25), kRealWidth(25)) placeholderImage:[UIImage imageNamed:@"sa_placeholder_image"] imageView:self.iconImg];
    self.titleLabel.text = _model.title;
    [self setNeedsUpdateConstraints];
}
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = UIView.new;
        view.backgroundColor = [UIColor whiteColor];
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:7];
        };
        _bgView = view;
    }
    return _bgView;
}
- (SDAnimatedImageView *)iconImg {
    if (!_iconImg) {
        SDAnimatedImageView *imageView = SDAnimatedImageView.new;
        _iconImg = imageView;
    }
    return _iconImg;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:15];
        ;
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"trans_arrow"];
        _arrowImg = imageView;
    }
    return _arrowImg;
}
@end
