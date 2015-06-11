//
//  BaseViewController.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup {
    //self.view.backgroundColor = [Utils colorLightBorder];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelectorOnMainThread:@selector(addAllViews) withObject:nil waitUntilDone:NO];
}

- (void)addAllViews {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)reloadData {
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self resizeViews];
}

- (void)resizeViews {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)heightHeader {
    CGFloat height = 0.0;
    if (self.navigationController.navigationBarHidden) {
        height = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationMaskPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationMaskPortraitUpsideDown)
        ? [UIApplication sharedApplication].statusBarFrame.size.width : [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    else {
        height = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    }
    return height;
}

#pragma mark - property

#pragma mark - action

#pragma mark - Notification



@end
