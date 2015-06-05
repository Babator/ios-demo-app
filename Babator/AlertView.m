//
//  AlertView.m
//  mECG
//
//  Created by Andrey Kulinskiy on 7/31/13.
//  Copyright (c) 2013 McKesson. All rights reserved.
//

#import "AlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface AlertView () <UIAlertViewDelegate>

@end

@implementation AlertView

- (void)show
{
    [super show];
    self.delegate = self;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.numberOfButtons == 1)
    {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    else
    {
        if (buttonIndex == self.cancelButtonIndex) {
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }
        else {
            if (self.doneBlock) {
                self.doneBlock();
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
