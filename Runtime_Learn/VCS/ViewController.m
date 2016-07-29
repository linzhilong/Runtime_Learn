//
//  ViewController.m
//  CALayer_Learn
//
//  Created by zhilong.lin on 16/3/4.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

#ifdef __IPHONE_7_0
#define IS_GE_IOS7                                    ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7)
#else
#define IS_GE_IOS7                                    NO
#endif

#define APPLICATION_SCREEN_HEIGHT                    (IS_GE_IOS7 ? ([UIScreen mainScreen].bounds.size.height) : ([UIScreen mainScreen].applicationFrame.size.height))
#define APPLICATION_SCREEN_WIDTH                     ([UIScreen mainScreen].applicationFrame.size.width)
#define DEFAULT_NAVIGATION_BAR_HEIGHT                (44 + (IS_GE_IOS7 ? DEFAULT_STATUS_BAR_HEIGHT : 0))
#define DEFAULT_APPLICATION_FRAME                    (CGRectMake(0, 0, APPLICATION_SCREEN_WIDTH, APPLICATION_SCREEN_HEIGHT))

@interface ViewController ()

@end

@implementation ViewController

+ (void)initialize {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:DEFAULT_APPLICATION_FRAME];
    self.view.backgroundColor = [UIColor whiteColor];
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}

@end
