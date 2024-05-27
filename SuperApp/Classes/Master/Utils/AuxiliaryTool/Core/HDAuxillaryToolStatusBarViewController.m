//
//  HDAuxillaryToolStatusBarViewController.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxillaryToolStatusBarViewController.h"


@interface HDAuxillaryToolStatusBarViewController ()

@end


@implementation HDAuxillaryToolStatusBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
