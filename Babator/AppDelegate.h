//
//  AppDelegate.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/2/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScreenManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ScreenManager *screenManager;

@end

