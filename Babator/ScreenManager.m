//
//  ScreenManager.m
//  TrackYourCash
//
//  Created by Andrey Kulinskiy on 9/4/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "ScreenManager.h"
#import "MainScreenController.h"

typedef void (^CompletBlock) ();

@interface ScreenManager ()

@property (nonatomic, weak)UIWindow* window;

@property (nonatomic, strong)MainScreenController* mainScreen;
@property (nonatomic, strong)UINavigationController* navigationController;

@end

@implementation ScreenManager

- (id)initWithMainWindow:(UIWindow *)window {
    self = [super init];
    if (self)
    {
        self.window = window;
        self.navigationController = (UINavigationController*)self.window.rootViewController;
        self.navigationController.navigationBarHidden = YES;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self subscribeToEvents];
        [self showMainScreenAnimation:NO];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Test Methods for data

#pragma mark -

-(void)subscribeToEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainScreenNotification:)
                                                 name:SHOW_MAIN_SCREEN_EVENT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackgroundHandler:)
                                                 name:APP_DID_ENTER_BACKGROUND
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterForegroundHandler:)
                                                 name:APP_DID_ENTER_FOREGROUND
                                               object:nil];
}

         /*
- (void)setNavigationScreen {
    if (!self.window.rootViewController) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.pincodeController];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                          forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBarHidden = YES;
        
        //[self.mainNavigationController pushViewController:self.splashController animated:NO];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.window setRootViewController:self.navigationController];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
          */

- (UINavigationController*)navigationControllerForViewController:(UIViewController*)viewController {
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [navigationController.navigationBar setBackgroundImage:[UIImage new]
                                             forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.translucent = YES;
    return navigationController;
}

- (void)showScreenController:(UIViewController*)showController animation:(BOOL)animation {
    
    UIViewController* topViewController = self.navigationController.topViewController;
    UIViewController* visibleViewController = self.navigationController.visibleViewController;
    
    if (topViewController != visibleViewController) {
        [topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (showController) {
        
        NSArray* controllers = self.navigationController.viewControllers;
        BOOL thereScreen = NO;
        for (UIViewController* controller in controllers) {
            if (controller && controller == showController) {
                thereScreen = YES;
                break;
            }
        }
        
        if (thereScreen) {
            [self.navigationController popToViewController:showController animated:animation];
        }
        else {
            [self.navigationController pushViewController:showController animated:animation];
        }
    }
}

#pragma mark - Notification
- (void)showMainScreenNotification:(NSNotification*)notification {
    [self showMainScreenAnimation:YES];
}

- (void) applicationDidEnterBackgroundHandler:(NSNotification*) notification {
    NSLog(@"applicationDidEnterBackgroundHandler");
}

- (void) applicationDidEnterForegroundHandler:(NSNotification*) notification {
    NSLog(@"applicationDidEnterForegroundHandler");
}

#pragma mark -
- (void)showMainScreenAnimation:(BOOL)animation {

    [self showScreenController:self.mainScreen animation:animation];
}

#pragma mark - property
- (MainScreenController *)mainScreen {
    if (!_mainScreen) {
        _mainScreen = [[MainScreenController alloc]init];
    }
    return _mainScreen;
}

@end



