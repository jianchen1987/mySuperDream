//
//  SAMessageCenterListTableViewHeaderView.m
//  SuperApp
//
//  Created by seeu on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageCenterListTableViewHeaderView.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface SAMessageCenterListTableViewHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel; ///< 标题
@property (nonatomic, strong) UIView *leftLine;    ///< 左线
@property (nonatomic, strong) UIView *rightLine;   ///< 右线
@end


@implementation SAMessageCenterListTableViewHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"SAMessageCenterListTableViewHeaderView";
    // 创建cell
    SAMessageCenterListTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];

    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    if (@available(iOS 14.0, *)) {
        UIBackgroundConfiguration *config = UIBackgroundConfiguration.clearConfiguration;
        config.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
        self.backgroundConfiguration = config;
    } else {
        self.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
    }

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftLine];
    [self.contentView addSubview:self.rightLine];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedViewHandler)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)updateConstraints {
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];

    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(40.5);
        make.right.equalTo(self.titleLabel.mas_left).offset(-12);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];

    [self.rightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-40.5);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];

    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setText:(NSString *)text {
    _text = text;

    self.titleLabel.text = text;

    [self setNeedsUpdateConstraints];
}

#pragma mark - event response

- (void)clickedViewHandler {
    !self.viewClickedHandler ?: self.viewClickedHandler();
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor hd_colorWithHexString:@"#2F2F2F"];
    }
    return _titleLabel;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = UIView.new;
        _leftLine.backgroundColor = [UIColor hd_colorWithHexString:@"#D3D3D3"];
    }
    return _leftLine;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = UIView.new;
        _rightLine.backgroundColor = [UIColor hd_colorWithHexString:@"#D3D3D3"];
    }
    return _rightLine;
}

@end
