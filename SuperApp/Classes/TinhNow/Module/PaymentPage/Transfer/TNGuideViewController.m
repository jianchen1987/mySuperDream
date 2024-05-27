//
//  TNGuideViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNGuideViewController.h"
#import "TNTransferDTO.h"
#import <SDWebImage.h>
#import "TNGuideRspModel.h"


@interface TNGuideViewController ()
/// 数据源
@property (strong, nonatomic) NSArray *dataArr;
/// dto
@property (strong, nonatomic) TNTransferDTO *transferDTO;
@end


@implementation TNGuideViewController
- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_how_transfer_wownow", @"如何转账到WOWNOW");
}
- (void)hd_getNewData {
    [self.view showloading];
    @HDWeakify(self);
    [self.transferDTO queryGuideDataByAdvId:@"50004" Success:^(TNGuideRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (!HDIsObjectNil(rspModel) && !HDIsArrayEmpty(rspModel.advList)) {
            self.dataArr = [rspModel.advList mapObjectsUsingBlock:^id _Nonnull(TNGuideItemModel *_Nonnull obj, NSUInteger idx) {
                return obj.path;
            }];
            [self updateData];
        } else {
            [self showNoDataPlaceHolderNeedRefrenshBtn:NO refrenshCallBack:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self hd_getNewData];
        }];
    }];
}
- (void)updateData {
    if (!HDIsArrayEmpty(self.dataArr)) {
        CGFloat width = kScreenWidth;
        UIView *lastView = nil;
        for (int i = 0; i < self.dataArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            NSString *imageStr = self.dataArr[i];
            [self.scrollViewContainer addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
                make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
                make.height.mas_equalTo(width);
                if (lastView) {
                    make.top.equalTo(lastView.mas_bottom);
                } else {
                    make.top.equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(15));
                }
                if (i == self.dataArr.count - 1) {
                    make.bottom.equalTo(self.scrollViewContainer.mas_bottom);
                }
            }];
            lastView = imageView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(width, width)]
                                completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                    if (image) {
                                        CGFloat height = image.size.height / image.size.width * width;
                                        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                                            make.height.mas_equalTo(height);
                                        }];
                                        [self.view setNeedsUpdateConstraints];
                                    }
                                }];
        }
        [self.view setNeedsUpdateConstraints];
    }
}
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [super updateViewConstraints];
}
- (TNTransferDTO *)transferDTO {
    if (!_transferDTO) {
        _transferDTO = [[TNTransferDTO alloc] init];
    }
    return _transferDTO;
}
@end
