//
//  TNMoreTableHeaderView.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNMoreTableHeaderView.h"
#import "TNMoreViewModel.h"
#import <HDVendorKit/HDVendorKit.h>


@interface TNMoreTableHeaderView ()
/// viewmodel
@property (nonatomic, strong) TNMoreViewModel *viewModel;
/// head
@property (nonatomic, strong) UIImageView *headImageView;
/// nickname
@property (nonatomic, strong) UILabel *nickNameLabel;
///  助力和拼团
@property (strong, nonatomic) UIView *itemView;
@end


@implementation TNMoreTableHeaderView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.headImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.itemView];
    [self updateUserInfo];
    //监听用户登录成功 刷新用户资料
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateUserInfo) name:kNotificationNameLoginSuccess object:nil];
}
#pragma mark - 设置用户资料
- (void)updateUserInfo {
    [HDWebImageManager setImageWithURL:self.viewModel.headUrlStr placeholderImage:[UIImage imageNamed:@"tinhnow-default-avatar"] imageView:self.headImageView];
    if (HDIsStringNotEmpty(self.viewModel.nickName)) {
        self.nickNameLabel.text = self.viewModel.nickName;
    }
}
- (void)updateConstraints {
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(20);
        //        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.bottom.equalTo(self.itemView.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(53, 53));
    }];

    [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.headImageView.mas_centerY);
    }];

    [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(50);
    }];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, kScreenWidth, size.height);

    [super updateConstraints];
}
#pragma mark - privite method
- (void)itemBtnClick:(HDUIButton *)btn {
    switch (btn.tag) {
        case 0:
            !self.myBargainClickCallBack ?: self.myBargainClickCallBack();
            break;
        case 1:
            !self.myJoinGroupClickCallBack ?: self.myJoinGroupClickCallBack();
            break;

        default:
            break;
    }
}
#pragma mark - lazy load
/** @lazy headImageView */
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow-default-avatar"]];
        _headImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = CGRectGetHeight(precedingFrame) / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _headImageView;
}
/** @lazy nickNameLabel */
- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = HDAppTheme.font.standard2Bold;
        _nickNameLabel.textColor = UIColor.whiteColor;
        _nickNameLabel.text = @"";
    }
    return _nickNameLabel;
}
/** @lazy itemView */
- (UIView *)itemView {
    if (!_itemView) {
        _itemView = [[UIView alloc] init];
        _itemView.backgroundColor = [UIColor whiteColor];
        NSArray *images = @[@"tinhnow-my_bargain_record", @"tinhnow-my_join_group"];
        NSArray *titles = @[TNLocalizedString(@"tn_more_my_help_tips", @"我的助力"), TNLocalizedString(@"tn_more_my_group_buy_tips", @"我的拼团")];
        for (int i = 0; i < images.count; i++) {
            HDUIButton *btn = [[HDUIButton alloc] init];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            btn.titleLabel.font = HDAppTheme.TinhNowFont.standard16;
            [btn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
            btn.spacingBetweenImageAndTitle = 5;
            btn.tag = i;
            [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_itemView addSubview:btn];
            CGFloat width = kScreenWidth / 2;
            btn.frame = CGRectMake(width * i, 0, width, 50);

            //分割线
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
            [_itemView addSubview:lineView];
            lineView.frame = CGRectMake((width - 0.5) * i, 4, 0.5, 42);
            if (i == 0) {
                lineView.hidden = true;
            }
        }
    }
    return _itemView;
}
@end
