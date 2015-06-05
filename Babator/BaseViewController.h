//
//  BaseViewController.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign)CGFloat heightHeader;

- (void)setup;
- (void)addAllViews;
- (void)reloadData;
- (void)resizeViews;

@end
