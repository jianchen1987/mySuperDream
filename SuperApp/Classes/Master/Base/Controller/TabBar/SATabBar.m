//
//  SATabBar.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATabBar.h"
#import "UITabBarItem+SATabBar.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDAppTheme.h>


@interface SATabBar ()
/// 当前选中的按钮
@property (nonatomic, strong) SATabBarButton *selectedButton;
@property (nonatomic, strong) NSMutableArray<SATabBarButton *> *totalButtons; ///< 所有按钮
@end


@implementation SATabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 15.0, *)) {
            UITabBarAppearance *standard = [[UITabBarAppearance alloc] init];
            [standard configureWithOpaqueBackground];
            self.standardAppearance = standard;
            self.scrollEdgeAppearance = standard;
        }
    }
    return self;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    // 布局按钮
    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:SATabBarButton.class]) {
            [tabBarButtonArray addObject:view];
        }
    }

    CGFloat barWidth = self.bounds.size.width;
    CGFloat btnHeight = self.bounds.size.height - kiPhoneXSeriesSafeBottomHeight;
    // 平均分配宽度
    CGFloat barItemWidth = barWidth / tabBarButtonArray.count;
    // 逐个布局按钮 frame
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView *_Nonnull view, NSUInteger idx, BOOL *_Nonnull stop) {
        CGRect frame = view.frame;
        frame.origin.x = idx * barItemWidth;
        // 设置宽度
        frame.size.width = barItemWidth;
        frame.size.height = btnHeight;
        view.frame = frame;
    }];
}

#pragma mark - getters and setters
- (void)setItems:(NSArray<UITabBarItem *> *)items {
    // 拦截添加
    // [super setItems:items];
    self.isNewTabBar = YES; //重置了
    [self addCustomItemsWithOriginalItems:items];
}

- (void)setItems:(NSArray<UITabBarItem *> *)items animated:(BOOL)animated {
    // 拦截添加
    // [super setItems:items animated:animated];
    self.isNewTabBar = YES; //重置了
    [self addCustomItemsWithOriginalItems:items];
}

- (void)addCustomButtonsWithConfigArray:(NSArray<SATabBarItemConfig *> *)configArray {
    // 排序
    configArray = [configArray sortedArrayUsingComparator:^NSComparisonResult(SATabBarItemConfig *_Nonnull obj1, SATabBarItemConfig *_Nonnull obj2) {
        return obj1.index > obj2.index;
    }];

    // 移除原来的子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.totalButtons removeAllObjects];

    // 默认选中
    NSUInteger defaultIndex = 0;
    id delegate = self.delegate;
    if (delegate && [delegate isKindOfClass:UITabBarController.class]) {
        defaultIndex = ((UITabBarController *)delegate).selectedIndex;
        defaultIndex = defaultIndex >= configArray.count ? 0 : defaultIndex;
    }

    for (SATabBarItemConfig *config in configArray) {
        SATabBarButton *button = [SATabBarButton buttonWithType:UIButtonTypeCustom];
        button.config = config;
        // 与系统保持一致
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:button];
        [self.totalButtons addObject:button];

        // 设置默认选中
        if ([configArray indexOfObject:config] == defaultIndex) {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        } else {
            button.selected = false;
        }
    }
}

- (void)addCustomItemsWithOriginalItems:(NSArray<UITabBarItem *> *)items {
    [self addCustomButtonsWithConfigArray:[items mapObjectsUsingBlock:^id _Nonnull(UITabBarItem *_Nonnull item, NSUInteger idx) {
              SATabBarItemConfig *config = item.hd_config;
              return config;
          }]];
}

- (void)updateBadgeValue:(NSString *)badgeValue atIndex:(NSUInteger)index {
    if (index < 0 || index >= self.totalButtons.count) {
        return;
    }
    SATabBarButton *button = self.totalButtons[index];
    [button updateBadgeValue:badgeValue];
}

- (void)updateBadgeColor:(UIColor *)badgeColor atIndex:(NSUInteger)index {
    if (index < 0 || index >= self.totalButtons.count) {
        return;
    }
    SATabBarButton *button = self.totalButtons[index];
    [button updateBadgeColor:badgeColor];
}

- (void)updateBackgroundColor:(UIColor *)backgroundColor atIndex:(NSUInteger)index {
    if (index < 0 || index >= self.totalButtons.count) {
        return;
    }
    SATabBarButton *button = self.totalButtons[index];
    [button updateBackgroundColor:backgroundColor];
}

#pragma mark - getters and setters
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    // 已经选择过
    if (self.selectedButton && _selectedIndex == selectedIndex)
        return;

    _selectedIndex = selectedIndex;

    if (selectedIndex < self.totalButtons.count) {
        SATabBarButton *button = self.totalButtons[selectedIndex];
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (NSArray<SATabBarButton *> *)buttons {
    return [self.totalButtons mutableCopy];
}

- (NSArray<SATabBarButton *> *)shouldShowGuideViewArray {
    // 获取可见的 cell
    NSArray<SATabBarButton *> *buttons = self.totalButtons;
    // 过滤
    buttons = [buttons filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SATabBarButton *_Nullable button, NSDictionary<NSString *, id> *_Nullable bindings) {
                           SATabBarItemConfig *model = button.config;
                           return model && model.hasUpdated && !model.hasDisplayedNewFunctionGuide && HDIsStringNotEmpty(model.guideDesc.desc);
                       }]];
    // 排序
    buttons = [buttons sortedArrayUsingComparator:^NSComparisonResult(SATabBarButton *_Nonnull obj1, SATabBarButton *_Nonnull obj2) {
        return obj1.config.index > obj2.config.index;
    }];
    return buttons;
}

#pragma mark - event response
- (void)buttonClicked:(SATabBarButton *)button {
    NSInteger index = [self.totalButtons indexOfObject:button];
    // 是否需要拦截点击
    BOOL shouldIntercept = NO;
    if (self.customTarBarDelegate && [self.customTarBarDelegate respondsToSelector:@selector(tabBar:shouldInterceptClickAtIndex:)]) {
        shouldIntercept = [self.customTarBarDelegate tabBar:self shouldInterceptClickAtIndex:index];
    }
    if (shouldIntercept) {
        return;
    }
    // 设置选中index
    _selectedIndex = index;
    // 通知代理
    if (self.customTarBarDelegate && [self.customTarBarDelegate respondsToSelector:@selector(tabBar:didSelectButton:)]) {
        [self.customTarBarDelegate tabBar:self didSelectButton:button];
    }

    // 放下方拦截是因为外部可能需要需要回调触发
    if (button == self.selectedButton)
        return;

    button.selected = true;
    self.selectedButton.selected = false;
    self.selectedButton = button;
}

#pragma mark - lazy load
- (NSMutableArray<SATabBarButton *> *)totalButtons {
    return _totalButtons ?: ({ _totalButtons = NSMutableArray.array; });
}
@end
