//
//  SASuggestionDetailView.m
//  SuperApp
//
//  Created by Tia on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASuggestionDetailView.h"
#import "SASuggestionDetailTableViewCell.h"
#import "SASuggestionViewModel.h"
#import "SATableView.h"
// clang-format off
#if __has_include(<HXPhotoPicker/HXPhotoPicker.h>)
// clang-format on
#import <HXPhotoPicker/HXPhotoPicker.h>
#else
#import "HXPhotoPicker.h"
#endif


@interface SASuggestionDetailView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) SASuggestionViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;

/// 底部视图
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *tipsLabel;
/// 已解决按钮
@property (nonatomic, strong) HDUIButton *leftBTN;
/// 未解决按钮
@property (nonatomic, strong) HDUIButton *rightBTN;

@property (nonatomic, strong) UIButton *moreBTN;

@property (nonatomic, weak) SASuggestionDetailModel *model;

@end


@implementation SASuggestionDetailView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.tipsLabel];
    [self.bottomView addSubview:self.leftBTN];
    [self.bottomView addSubview:self.rightBTN];
    [self.bottomView addSubview:self.moreBTN];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);

    [self.KVOController hd_observe:self.viewModel keyPath:@"model" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.model = self.viewModel.model;
        if (self.model.solutionStatus != 10 && self.model.solutionStatus != 11) {
            self.leftBTN.userInteractionEnabled = self.rightBTN.userInteractionEnabled = true;
        } else if (self.model.solutionStatus == 10) {
            self.rightBTN.selected = true;
        } else {
            self.leftBTN.selected = true;
        }
        [self.tableView successGetNewDataWithNoMoreData:false];
    }];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.top.centerX.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
    }];

    CGFloat margin = kRealWidth(12);

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [self.leftBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsLabel);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(2 * margin);
    }];

    [self.rightBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.leftBTN);
        make.top.equalTo(self.leftBTN.mas_bottom).offset(kRealWidth(20));
    }];

    [self.moreBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightBTN.mas_bottom).offset(kRealWidth(30));
        make.centerX.mas_equalTo(self.bottomView);
        make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight - kRealWidth(10));
    }];

    [super updateConstraints];
}

#pragma mark - private method
- (void)clickedBTNHandler:(UIButton *)btn {
    if (btn.tag == 20) {
        [HDMediator.sharedInstance navigaveToSuggestionViewController:nil];
        return;
    }

    BOOL agree = btn.tag == 10 ? false : true;

    [self showloading];
    btn.selected = true;
    [self.viewModel clientUpdateStatusWithAgree:agree success:^{
        [self dismissLoading];
        self.leftBTN.userInteractionEnabled = self.rightBTN.userInteractionEnabled = false;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.viewController dismissAnimated:true completion:nil];
        });
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self dismissLoading];
        btn.selected = false;
    }];
}

- (void)previewClick:(SASuggestionDetailTableViewCellModel *)model row:(NSInteger)row {
    if (!model.imageUrls.count)
        return;

    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    NSMutableArray *mArr = NSMutableArray.new;
    for (NSString *urlStr in model.imageUrls) {
        HXCustomAssetModel *assetModel = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:urlStr] selected:YES];
        [mArr addObject:assetModel];
    }
    photoManager.configuration.photoMaxNum = mArr.count;
    photoManager.configuration.videoMaxNum = 0;
    photoManager.configuration.maxNum = mArr.count;

    [photoManager addCustomAssetModel:mArr];

    /// 这里需要注意一下
    /// 这里的photoManager 和 self.manager 不是同一个
    /// 虽然展示的是一样的内容但是是两个单独的东西
    /// 所以会出现通过外部预览时,网络图片是正方形被裁剪过了样子.这是因为photoManager这个里面的网络图片还未下载的原因
    /// 如果将 photoManager 换成 self.manager 则不会出现这样的现象
    [self.viewController hx_presentPreviewPhotoControllerWithManager:photoManager previewStyle:HXPhotoViewPreViewShowStyleDark currentIndex:row photoView:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model)
        return 2;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SASuggestionDetailTableViewCell *cell = [SASuggestionDetailTableViewCell cellWithTableView:tableView];
    SASuggestionDetailTableViewCellModel *model = SASuggestionDetailTableViewCellModel.new;
    if (indexPath.row == 1) { //我的意见
        model.title = SALocalizedString(@"sd_My_opinion", @"我的意见");
        model.time = self.model.createTime;
        model.imageUrls = self.model.imageUrls;
        model.content = self.model.suggestContent;
    } else { //最新回复
        model.title = SALocalizedString(@"sd_Latest_Reply", @"最新回复");
        model.time = self.model.replyTime;
        model.imageUrls = self.model.imageUrlsOfReply;
        model.content = self.model.contentOfReply;
    }
    cell.model = model;

    @HDWeakify(self);
    cell.clickPhotoBlock = ^(NSInteger row) {
        @HDStrongify(self);
        [self previewClick:model row:row];
    };
    return cell;
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = UILabel.new;
        _tipsLabel.font = HDAppTheme.font.sa_standard16SB;
        _tipsLabel.textColor = HDAppTheme.color.sa_C333;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.hd_lineSpace = 6;
        _tipsLabel.text = SALocalizedString(@"sd_tips", @"回复的内容是否已解决你的疑问？");
    }
    return _tipsLabel;
}

- (HDUIButton *)leftBTN {
    if (!_leftBTN) {
        _leftBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_leftBTN addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBTN setTitle:SALocalizedString(@"sd_solved", @"已解决") forState:UIControlStateNormal];
        [_leftBTN setImage:[UIImage imageNamed:@"ac_icon_radio_nor"] forState:UIControlStateNormal];
        [_leftBTN setImage:[UIImage imageNamed:@"ac_icon_radio_sel"] forState:UIControlStateSelected];
        [_leftBTN setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        _leftBTN.titleLabel.font = HDAppTheme.font.sa_standard16;
        _leftBTN.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _leftBTN.userInteractionEnabled = false;
    }
    return _leftBTN;
}

- (HDUIButton *)rightBTN {
    if (!_rightBTN) {
        _rightBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBTN addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBTN setTitle:SALocalizedString(@"sd_unsolved", @"未解决") forState:UIControlStateNormal];
        [_rightBTN setImage:[UIImage imageNamed:@"ac_icon_radio_nor"] forState:UIControlStateNormal];
        [_rightBTN setImage:[UIImage imageNamed:@"ac_icon_radio_sel"] forState:UIControlStateSelected];
        [_rightBTN setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        _rightBTN.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _rightBTN.titleLabel.font = HDAppTheme.font.sa_standard16;
        _rightBTN.userInteractionEnabled = false;

        _rightBTN.tag = 10;
    }
    return _rightBTN;
}

- (UIButton *)moreBTN {
    if (!_moreBTN) {
        _moreBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBTN addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBTN setTitle:SALocalizedString(@"sd_more", @"问题仍未解决，请前往意见反馈>") forState:UIControlStateNormal];
        _moreBTN.titleLabel.font = HDAppTheme.font.sa_standard12;
        [_moreBTN setTitleColor:HDAppTheme.color.sa_C999 forState:UIControlStateNormal];
        _moreBTN.tag = 20;
    }
    return _moreBTN;
}

@end
