//
//  PNSingleSelectedAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNSingleSelectedAlertView.h"
#import "PNTableView.h"
#import "PNTableViewCell.h"
#import "PNView.h"


@interface PNSingleSelectedCell : PNTableViewCell
///
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UIImageView *selectedImageView;
///
@property (strong, nonatomic) UIView *lineView;
///
@property (strong, nonatomic) PNSingleSelectedModel *model;
@end


@implementation PNSingleSelectedCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.selectedImageView];
    [self.contentView addSubview:self.lineView];
}

- (void)setModel:(PNSingleSelectedModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.selectedImageView.hidden = !model.isSelected;
}

- (void)updateConstraints {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(16));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(16));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(50));
    }];

    [self.selectedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(PixelOne);
    }];

    [super updateConstraints];
}

/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.PayNowFont.standard16;
        _nameLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

/** @lazy selectedImageView */
- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pn_single_selected"]];
        [_selectedImageView sizeToFit];
    }
    return _selectedImageView;
}

/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _lineView;
}
@end


@interface PNSingleSelectedAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
///
@property (nonatomic, strong) UIView *topLineView;
///
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) PNOperationButton *closeBtn;
///
@property (strong, nonatomic) NSArray<PNSingleSelectedModel *> *dataSource;
/// 标题
@property (strong, nonatomic) NSString *title;
///
@property (nonatomic, assign) CGFloat tableHeight;
/// 是否强制选择 [去掉取消按钮，和 点击背景 取消]  => 必须选择一个选项才行
@property (nonatomic, assign) BOOL isForceSelect;
@end


@implementation PNSingleSelectedAlertView
- (instancetype)initWithDataArr:(NSArray<PNSingleSelectedModel *> *)dataArr title:(NSString *)title {
    return [self initWithDataArr:dataArr title:title forceSelect:NO];
}

- (instancetype)initWithDataArr:(NSArray<PNSingleSelectedModel *> *)dataArr title:(NSString *)title forceSelect:(BOOL)forceSelect {
    self = [super init];
    if (self) {
        self.title = title;
        self.dataSource = dataArr;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.isForceSelect = forceSelect;
        self.allowTapBackgroundDismiss = !self.isForceSelect;
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    if (HDIsStringNotEmpty(self.title)) {
        [self.containerView addSubview:self.titleLabel];
        self.titleLabel.text = _title;

        [self.containerView addSubview:self.topLineView];
    }
    [self.containerView addSubview:self.tableView];

    if (!self.isForceSelect) {
        [self.containerView addSubview:self.closeBtn];
    }

    [self.tableView successGetNewDataWithNoMoreData:YES];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.tableView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat height = self.tableView.contentSize.height;
            CGFloat maxHeight = kScreenHeight * 0.6;
            if (height > maxHeight) {
                height = maxHeight;
            }
            if (self.tableView.height < height) {
                self.tableHeight = height;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(self.tableHeight);
                }];
            }
        });
    }];
}

- (void)layoutContainerViewSubViews {
    if (HDIsStringNotEmpty(self.title)) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView);
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(12));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(56));
        }];

        [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.height.mas_equalTo(@(PixelOne));
        }];
    }

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        if (HDIsStringNotEmpty(self.title)) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(PixelOne);
        } else {
            make.top.equalTo(self.containerView);
        }
        if (self.isForceSelect) {
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-(kRealWidth(15) + kiPhoneXSeriesSafeBottomHeight));
        }
        make.height.mas_equalTo(60);
    }];

    if (!self.isForceSelect) {
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView.mas_centerX);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(15) - kiPhoneXSeriesSafeBottomHeight);
            make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(15));
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNSingleSelectedCell *cell = [PNSingleSelectedCell cellWithTableView:tableView];
    PNSingleSelectedModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PNSingleSelectedModel *model = self.dataSource[indexPath.row];
    [self.dataSource enumerateObjectsUsingBlock:^(PNSingleSelectedModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isSelected = NO;
    }];
    model.isSelected = YES;
    [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    !self.selectedCallback ?: self.selectedCallback(model);
    [self dismiss];
}

#pragma mark
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.PayNowFont fontBold:16];
        _titleLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //        _titleLabel.hd_borderColor = HDAppTheme.PayNowColor.lineColor;
        //        _titleLabel.hd_borderWidth = 0.5;
        //        _titleLabel.hd_borderPosition = HDViewBorderPositionBottom;
    }
    return _titleLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _topLineView = view;
    }
    return _topLineView;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

/** @lazy closeBtn */
- (PNOperationButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _closeBtn.titleLabel.font = [HDAppTheme.PayNowFont fontBold:14];
        _closeBtn.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(9), kRealWidth(16), kRealWidth(9), kRealWidth(16));
        [_closeBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"关闭") forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
        @HDWeakify(self);
        [_closeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _closeBtn;
}

@end


@implementation PNSingleSelectedModel

@end
