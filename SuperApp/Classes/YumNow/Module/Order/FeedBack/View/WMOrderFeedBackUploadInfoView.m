//
//  WMOrderFeedBackUploadInfoView.m
//  SuperApp
//
//  Created by wmz on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackUploadInfoView.h"
#import "WMCommonSelectAlertView.h"
#import "WMCustomViewActionView.h"
#import "WMOrderFeedBackDTO.h"


@interface WMOrderFeedBackUploadInfoView () <HDTextViewDelegate, HXPhotoViewDelegate, HXPhotoViewCellCustomProtocol>
/// reasonControl
@property (nonatomic, strong) UIControl *reasonControl;
/// reasonTitleLB
@property (nonatomic, strong) HDLabel *reasonTitleLB;
/// reasonContentLB
@property (nonatomic, strong) HDLabel *reasonContentLB;
/// rightIV
@property (nonatomic, strong) UIImageView *rightIV;
/// contentPlaceHolderLB
@property (nonatomic, strong) HDLabel *contentPlaceHolderLB;
/// contentMaxLengthLB
@property (nonatomic, strong) HDLabel *contentMaxLengthLB;
/// uploadTitleLB
@property (nonatomic, strong) HDLabel *uploadTitleLB;
/// manager
@property (nonatomic, strong) SAPhotoManager *manager;
/// photoView
@property (nonatomic, strong) SAPhotoView *photoView;
///图片选择器最小高度
@property (nonatomic, assign) CGFloat selectImageMinimumHeight;
/// DTO
@property (nonatomic, strong) WMOrderFeedBackDTO *DTO;

@end


@implementation WMOrderFeedBackUploadInfoView

- (void)hd_setupViews {
    self.selectImageMinimumHeight = kRealWidth(100);
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.reasonTitleLB];
    [self addSubview:self.reasonContentLB];
    [self addSubview:self.rightIV];
    [self addSubview:self.reasonControl];

    [self addSubview:self.contentBg];
    [self.contentBg addSubview:self.contentTV];
    [self.contentBg addSubview:self.contentPlaceHolderLB];
    [self.contentBg addSubview:self.contentMaxLengthLB];

    [self addSubview:self.uploadTitleLB];
    [self addSubview:self.photoView];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.reasonControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(44));
    }];

    [self.reasonTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightIV.isHidden) {
            make.width.height.mas_equalTo(kRealWidth(24));
            make.right.mas_equalTo(-kRealWidth(12));
            make.centerY.equalTo(self.reasonTitleLB.mas_centerY);
        }
    }];

    [self.reasonContentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightIV.isHidden) {
            make.right.equalTo(self.rightIV.mas_left);
        } else {
            make.right.mas_equalTo(-kRealWidth(12));
        }
        make.centerY.equalTo(self.reasonTitleLB.mas_centerY);
        make.left.equalTo(self.reasonTitleLB.mas_right).offset(kRealWidth(12));
    }];

    [self.contentBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.reasonTitleLB.mas_bottom).offset(kRealWidth(12));
    }];

    [self.contentTV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(64));
    }];

    [self.contentPlaceHolderLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(12));
        make.left.mas_equalTo(kRealWidth(14));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.contentMaxLengthLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.contentTV.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.bottom.mas_equalTo(-kRealWidth(12));
    }];

    [self.uploadTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        make.top.equalTo(self.contentBg.mas_bottom).offset(kRealWidth(12));
    }];

    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.equalTo(self.uploadTitleLB.mas_bottom).offset(kRealWidth(12));
        make.right.bottom.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(self.selectImageMinimumHeight);
    }];

    [self.reasonTitleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.reasonTitleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

///原因列表
- (void)selectReasonAction {
    if ([self.type isEqualToString:WMOrderFeedBackPostOther])
        return;
    @HDWeakify(self)[self.viewController.view showloading];
    [self.DTO requestFindFeedbackReasonListWithSuccess:^(NSArray<WMOrderFeedBackReasonRspModel *> *_Nonnull rspModel) {
        @HDStrongify(self)[self.viewController.view dismissLoading];
        [self showReasonView:rspModel];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self.viewController.view dismissLoading];
    }];
}

///展示原因列表
- (void)showReasonView:(NSArray<WMOrderFeedBackReasonRspModel *> *)dataSource {
    WMCommonSelectAlertView *reasonView = [[WMCommonSelectAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [dataSource enumerateObjectsUsingBlock:^(WMOrderFeedBackReasonRspModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.select = [obj.no isEqualToString:self.selectReasonModel.no];
    }];
    reasonView.dataSource = dataSource;
    [reasonView layoutyImmediately];
    @HDWeakify(self) WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:reasonView block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.title = WMLocalizedString(@"wm_order_feedback_aftersales_reason_select", @"After Sale Reasons");
        config.shouldAddScrollViewContainer = YES;
    }];
    [actionView show];
    @HDWeakify(actionView) reasonView.clickedConfirmBlock = ^(WMSelectRspModel *_Nonnull model) {
        @HDStrongify(self) @HDStrongify(actionView)[actionView dismiss];
        self.selectReasonModel = (id)model;
    };
}

- (void)setSelectReasonModel:(WMOrderFeedBackReasonRspModel *)selectReasonModel {
    _selectReasonModel = selectReasonModel;
    self.reasonContentLB.text = selectReasonModel.showName;
    self.reasonContentLB.textColor = HDAppTheme.WMColor.B3;
    [self changeRequirStr];
    self.flag = !self.flag;
}

- (BOOL)textViewShouldReturn:(HDTextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(HDTextView *)textView {
    self.contentMaxLengthLB.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, textView.maximumTextLength];
    self.contentPlaceHolderLB.hidden = textView.text.length;
    self.flag = !self.flag;
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView
    changeComplete:(NSArray<HXPhotoModel *> *)allList
            photos:(NSArray<HXPhotoModel *> *)photos
            videos:(NSArray<HXPhotoModel *> *)videos
          original:(BOOL)isOriginal {
    self.selectedPhotos = photos;
    [photos enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        if (isOriginal) {
            size = PHImageManagerMaximumSize;
        } else {
            size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
        }
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil success:nil failed:nil];
    }];
    self.flag = !self.flag;
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.selectImageMinimumHeight = frame.size.height;
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.selectImageMinimumHeight);
    }];
}

- (UIView *)customView:(HXPhotoSubViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = kRealWidth(4);
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = HDAppTheme.WMColor.lineColorE9.CGColor;
    UIView *cornerView = [[UIView alloc] init];
    return cornerView;
}

/// 自定义删除按钮的位置大小
- (CGRect)customDeleteButtonFrame:(HXPhotoSubViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    return CGRectMake(cell.frame.size.width - kRealWidth(16), 0, kRealWidth(16), kRealWidth(16));
}

- (void)setType:(WMOrderFeedBackPostShowType)type {
    _type = type;
    self.rightIV.hidden = [type isEqualToString:WMOrderFeedBackPostOther];
    [self changeRequirStr];
    [self setNeedsUpdateConstraints];
}

- (void)changeRequirStr {
    BOOL remark = YES;
    BOOL photo = YES;
    if (self.selectReasonModel) {
        remark = self.selectReasonModel.isRemark;
    }
    if (self.selectReasonModel) {
        photo = self.selectReasonModel.isPhoto;
    }

    NSString *requireStr = remark ? WMLocalizedString(@"wm_order_feedback_required", @"Required") : @"";
    NSString *tip = WMLocalizedString(@"wm_order_feedback_required_content", @"");
    if ([self.type isEqualToString:WMOrderFeedBackPostOther]) {
        tip = WMLocalizedString(@"wm_order_feedback_required_other_content", @"");
    }
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", requireStr, tip]];
    mstr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
    mstr.yy_color = HDAppTheme.WMColor.CCCCCC;
    mstr.yy_lineSpacing = kRealWidth(4);
    [mstr yy_setColor:HDAppTheme.WMColor.mainRed range:[mstr.string rangeOfString:requireStr]];
    self.contentPlaceHolderLB.attributedText = mstr;

    NSString *maxStr = [NSString stringWithFormat:@"(%@)", [NSString stringWithFormat:SALocalizedString(@"upload_image_count_not_longer_than", @"(up to 6)"), 6]];
    NSString *re = photo ? @"*" : @"";
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%@%@%@", re, WMLocalizedString(@"wm_order_feedback_required_image_pick", @"Uploading valid images helps with faster processing"), maxStr]];
    titleStr.yy_font = [HDAppTheme.WMFont wm_boldForSize:16];
    titleStr.yy_color = HDAppTheme.WMColor.B3;
    [titleStr yy_setColor:HDAppTheme.WMColor.mainRed range:[titleStr.string rangeOfString:re]];
    [titleStr yy_setColor:HDAppTheme.WMColor.B9 range:[titleStr.string rangeOfString:maxStr]];
    [titleStr yy_setFont:[HDAppTheme.WMFont wm_ForSize:14] range:[titleStr.string rangeOfString:maxStr]];
    self.uploadTitleLB.attributedText = titleStr;

    NSString *remarkRe = remark ? @"*" : @"";
    titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", remarkRe, WMLocalizedString(@"wm_order_feedback_sales_reason", @"After Sale Reasons")]];
    titleStr.yy_font = [HDAppTheme.WMFont wm_boldForSize:16];
    titleStr.yy_color = HDAppTheme.WMColor.B3;
    [titleStr yy_setColor:HDAppTheme.WMColor.mainRed range:[titleStr.string rangeOfString:remarkRe]];
    self.reasonTitleLB.attributedText = titleStr;
}

- (UIControl *)reasonControl {
    if (!_reasonControl) {
        _reasonControl = UIControl.new;
        [_reasonControl addTarget:self action:@selector(selectReasonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reasonControl;
}

- (HDLabel *)reasonTitleLB {
    if (!_reasonTitleLB) {
        HDLabel *label = HDLabel.new;
        _reasonTitleLB = label;
    }
    return _reasonTitleLB;
}

- (HDLabel *)uploadTitleLB {
    if (!_uploadTitleLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        _uploadTitleLB = label;
    }
    return _uploadTitleLB;
}

- (HDLabel *)reasonContentLB {
    if (!_reasonContentLB) {
        HDLabel *label = HDLabel.new;
        label.text = WMLocalizedString(@"wm_order_feedback_please_select", @"Please select");
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = HDAppTheme.WMColor.B9;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        _reasonContentLB = label;
    }
    return _reasonContentLB;
}

- (UIImageView *)rightIV {
    if (!_rightIV) {
        _rightIV = UIImageView.new;
        _rightIV.image = [UIImage imageNamed:@"yn_submit_gengd"];
    }
    return _rightIV;
}

- (UIView *)contentBg {
    if (!_contentBg) {
        _contentBg = UIView.new;
        _contentBg.layer.backgroundColor = HDAppTheme.WMColor.F6F6F6.CGColor;
        _contentBg.layer.cornerRadius = kRealWidth(8);
    }
    return _contentBg;
}

- (HDTextView *)contentTV {
    if (!_contentTV) {
        _contentTV = HDTextView.new;
        _contentTV.font = [HDAppTheme.WMFont wm_ForSize:12.0];
        _contentTV.scrollEnabled = NO;
        _contentTV.bounces = false;
        _contentTV.backgroundColor = UIColor.clearColor;
        _contentTV.showsVerticalScrollIndicator = false;
        _contentTV.tintColor = HDAppTheme.WMColor.mainRed;
        _contentTV.maximumTextLength = 200;
        _contentTV.returnKeyType = UIReturnKeyDone;
        _contentTV.delegate = self;
        _contentTV.textContainerInset = UIEdgeInsetsZero;
    }
    return _contentTV;
}

- (HDLabel *)contentMaxLengthLB {
    if (!_contentMaxLengthLB) {
        HDLabel *label = HDLabel.new;
        label.text = @"0/200";
        label.textAlignment = NSTextAlignmentRight;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.CCCCCC;
        _contentMaxLengthLB = label;
    }
    return _contentMaxLengthLB;
}

- (HDLabel *)contentPlaceHolderLB {
    if (!_contentPlaceHolderLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        _contentPlaceHolderLB = label;
    }
    return _contentPlaceHolderLB;
}

- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 6;
        _manager.configuration.themeColor = HDAppTheme.WMColor.mainRed;
    }
    return _manager;
}

- (SAPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [SAPhotoView photoManager:self.manager];
        _photoView.delegate = self;
        _photoView.spacing = kRealWidth(12);
        _photoView.addImageName = @"";
        _photoView.deleteImageName = @"yn_order_feedback_uploadclose";
        _photoView.cellCustomProtocol = self;
        _photoView.backgroundColor = UIColor.whiteColor;
        if ([_photoView respondsToSelector:NSSelectorFromString(@"addModel")]) {
            HXPhotoModel *addModel = [_photoView valueForKey:@"addModel"];
            if ([addModel isKindOfClass:HXPhotoModel.class]) {
                UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kRealWidth(100), kRealWidth(100))];
                addImageView.contentMode = UIViewContentModeCenter;
                addImageView.image = [UIImage imageNamed:@"yn_order_feedback_uploadadd"];
                addImageView.layer.borderWidth = 1;
                addImageView.layer.cornerRadius = kRealWidth(4);
                addImageView.layer.borderColor = HDAppTheme.WMColor.lineColorE9.CGColor;
                [addImageView setNeedsLayout];
                [addImageView layoutIfNeeded];
                UIImage *addImage = [addImageView snapshotImage];
                addModel.thumbPhoto = addImage;
            }
        }
    }
    return _photoView;
}

- (WMOrderFeedBackDTO *)DTO {
    if (!_DTO) {
        _DTO = WMOrderFeedBackDTO.new;
    }
    return _DTO;
}

@end
