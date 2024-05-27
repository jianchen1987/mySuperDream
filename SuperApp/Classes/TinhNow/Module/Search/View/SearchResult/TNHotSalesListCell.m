//
//  TNHotSalesListCell.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHotSalesListCell.h"
#import "TNGoodsModel.h"


@interface TNHotSalesListCell ()
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollViewContainer;
@property (nonatomic, strong) UILabel *nameLabel;
///保存模型  用于判断是否刷新视图
@property (nonatomic, strong) TNHotSalesListCellModel *oldModel;
@end


@implementation TNHotSalesListCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.containView addSubview:self.nameLabel];
}

- (void)updateConstraints {
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.containView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.containView.mas_top).offset(kRealWidth(10));
    }];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containView);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self.containView.mas_bottom).offset(-kRealWidth(15));
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    [super updateConstraints];
}
- (void)setModel:(TNHotSalesListCellModel *)model {
    _model = model;
    if (HDIsObjectNil(self.oldModel) || ![self.oldModel.list isEqualToArray:model.list]) {
        [self createContainerView:model.list];
        self.oldModel = model;
    }
}
//创建子视图
- (void)createContainerView:(NSArray<TNGoodsModel *> *)list {
    if (HDIsArrayEmpty(list)) {
        return;
    }
    [self.scrollViewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView = nil;
    for (int i = 0; i < list.count; i++) {
        TNGoodsModel *gModel = list[i];
        ///包裹一层点击视图
        UIView *clickView = [[UIView alloc] init];
        clickView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickGood:)];
        [clickView addGestureRecognizer:tap];
        [self.scrollViewContainer addSubview:clickView];

        UIImageView *imageView = [[UIImageView alloc] init];
        [HDWebImageManager setImageWithURL:gModel.productImages.firstObject.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(100, 100)] imageView:imageView];
        imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
        [clickView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(clickView);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(100), kRealWidth(100)));
        }];
        //热销图标
        UIImageView *hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_hot_k"]];
        [imageView addSubview:hotImageView];
        [hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top).offset(kRealWidth(3));
            make.right.equalTo(imageView.mas_right).offset(-kRealWidth(3));
            make.size.mas_equalTo(hotImageView.image.size);
        }];

        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.text = gModel.price.thousandSeparatorAmount;
        priceLabel.textColor = [UIColor hd_colorWithHexString:@"#FF2323"];
        priceLabel.font = HDAppTheme.TinhNowFont.standard17B;
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.numberOfLines = 2;
        [clickView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).offset(10);
        }];
        [clickView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == nil) {
                make.left.equalTo(self.scrollViewContainer);
            } else {
                make.left.equalTo(lastView.mas_right).offset(10);
            }
            make.top.bottom.equalTo(self.scrollViewContainer);
            if (i == list.count - 1) {
                make.right.equalTo(self.scrollViewContainer);
            }
        }];
        lastView = clickView;
    }
    [self setNeedsUpdateConstraints];
}
- (void)tapClickGood:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    TNGoodsModel *gModel = self.model.list[index];
    [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": gModel.productId}];
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _scrollView.automaticallyAdjustsScrollIndicatorInsets = false;
        }
    }
    return _scrollView;
}

- (UIView *)scrollViewContainer {
    if (!_scrollViewContainer) {
        _scrollViewContainer = UIView.new;
    }
    return _scrollViewContainer;
}
- (UIView *)containView {
    if (!_containView) {
        _containView = UIView.new;
        _containView.backgroundColor = [UIColor whiteColor];
        _containView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _containView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.TinhNowFont.standard17B;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.text = TNLocalizedString(@"tn_best_sellers", @"热销商品");
    }
    return _nameLabel;
}
@end


@implementation TNHotSalesListCellModel
- (CGFloat)cellHeight {
    CGFloat height = 0;
    if (!HDIsArrayEmpty(self.list)) {
        //标题距离头部
        height += kRealWidth(10);
        //标题高度
        height += [@"热销商品" boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(60), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard17B].height;
        //标题距离图片
        height += kRealWidth(10);
        //图片高度
        height += kRealWidth(100);
        //图片距离价格间距
        height += kRealWidth(10);
        //价格高度
        height += [@"9.99" boundingAllRectWithSize:CGSizeMake(kRealWidth(100), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard17B].height;
        //价格距离底部
        height += kRealWidth(10);
        //底部
        height += kRealWidth(15);
    }
    return height;
}
@end
