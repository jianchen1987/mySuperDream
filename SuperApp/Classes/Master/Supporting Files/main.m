//
//  main.m
//  SuperApp
//
//  Created by VanJay on 2020/3/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAAppDelegate.h"

int main(int argc, char *argv[]) {
    NSString *HDAppDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        HDAppDelegateClassName = NSStringFromClass([SAAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, HDAppDelegateClassName);
}
