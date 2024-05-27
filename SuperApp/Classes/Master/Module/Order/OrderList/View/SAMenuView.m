//
//  SAMenuView.m
//  SAMenu
//
//  Created by Andy on 15/12/31.
//
//

#import "SAMenuView.h"
#import "SAAppTheme.h"
#import <HDKitCore/HDKitCore.h>

#define SAMenuHeight 34
#define SAMenuDismissNotification @"SAMenuDismissNotification"


@interface SAMenuView ()

@property (nonatomic, assign) BOOL hasShow;

@property (nonatomic, assign) CGFloat SAMenuWidth;

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *nameArray;
//@property (nonatomic, weak)    UIView * targetView;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, assign) CGRect targetRect;

@property (nonatomic, strong) NSMutableArray *btns;

@end


@implementation SAMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hasShow = NO;
    }
    return self;
}

- (void)setTargetView:(UIView *)targetView InView:(UIView *)superview {
    //    self.hasShow = NO;

    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 5.0;

    //    self.targetView = target;
    self.superView = superview;
    self.targetRect = [targetView.superview convertRect:targetView.frame toView:superview];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissOtherSAMenu) name:SAMenuDismissNotification object:nil];
}

- (void)setTitleArray:(NSArray *)array {
    self.nameArray = [NSArray arrayWithArray:array];
    self.SAMenuWidth = 0;
    if (self.subviews != nil && self.subviews.count != 0) { //移除所有子视图
        for (id object in self.subviews) {
            [object removeFromSuperview];
        }
    }

    [self.btns removeAllObjects];

    self.contentView = UIView.new;
    [self addSubview:self.contentView];

    for (int i = 0; i < array.count; i++) {
        //添加按钮
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        itemBtn.backgroundColor = UIColor.whiteColor;
        itemBtn.tag = 80000 + i;
        [itemBtn setTitle:self.nameArray[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGFloat length = [self.nameArray[i] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 32;

        itemBtn.frame = CGRectMake(0, i * SAMenuHeight, length, SAMenuHeight);
        self.SAMenuWidth = MAX(self.SAMenuWidth, length);
        [itemBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemBtn];
        [self.btns addObject:itemBtn];
    }

    //重新设置按钮宽度
    for (int i = 0; i < self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        CGRect rect = btn.frame;
        rect.size.width = self.SAMenuWidth;
        btn.frame = rect;
        //设置分割线
        if (i < array.count - 1) {
            UIView *dividingLine = [[UIView alloc] initWithFrame:CGRectMake(8, SAMenuHeight * (i + 1), self.SAMenuWidth - 8 * 2, 1)];
            dividingLine.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
            [self addSubview:dividingLine];
        }
    }

    self.contentView.frame = CGRectMake(0, 0, self.SAMenuWidth, self.nameArray.count * SAMenuHeight);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [self setFrame:CGRectMake(self.targetRect.origin.x + self.targetRect.size.width + 4, self.targetRect.origin.y, self.SAMenuWidth, self.nameArray.count * SAMenuHeight)];
}

- (void)click:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasSelectedSAMenuViewIndex:)]) {
        [_delegate hasSelectedSAMenuViewIndex:sender.tag - 80000];
    }
    [self dismiss];
}

- (void)show {
    if (!self.hasShow) {
        [SAMenuView dismissAllSAMenu];
        [self.superView bringSubviewToFront:self];
        self.hasShow = YES;
        [UIView animateWithDuration:.1 animations:^{
            self.alpha = 1;
        }];
    } else {
        [self dismiss];
    }
}

- (void)dismiss {
    if (self.hasShow) {
        self.hasShow = NO;
        [UIView animateWithDuration:.1 animations:^{
            self.alpha = 0;
        }];
    }
}

- (void)dismissOtherSAMenu {
    if (self.hasShow) {
        [self dismiss];
    }
}

+ (void)dismissAllSAMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:SAMenuDismissNotification object:nil];
}

- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = NSMutableArray.new;
    }
    return _btns;
}

@end
