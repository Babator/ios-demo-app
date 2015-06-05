//
//  AlertView.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "AlertViewUtil.h"
#import "AlertView.h"

AlertView* __strong alertView;

@implementation AlertViewUtil

+(void)showAlert:(NSString *)title message:(NSString *)message okBlock:(VoidHandler)block
{
    alertView = [[AlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"***Cancel", nil) otherButtonTitles:NSLocalizedString(@"***Ok", nil), nil];
    alertView.cancelBlock = ^{
        alertView = nil;
    };
    alertView.doneBlock = ^{
        if (block) {
            block();
        }
        alertView = nil;
    };
    [alertView show];
}

+(void)showAlert:(NSString *)message okBlock:(VoidHandler)block
{
    alertView = [[AlertView alloc]initWithTitle:NSLocalizedString(@"***Alert", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"***Ok", nil) otherButtonTitles:nil, nil];
    alertView.cancelBlock = ^{
        if (block) {
            block();
        }
        alertView = nil;
    };
    [alertView show];
}

+(void)showAlert:(NSString *)title message:(NSString *)message
{
    alertView = [[AlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"***Ok", nil) otherButtonTitles:nil, nil];
    alertView.cancelBlock = ^{
        alertView = nil;
    };
    [alertView show];
}

+(void)showAlert:(NSString *)message
{
    [AlertViewUtil showAlert:NSLocalizedString(@"***Alert", nil) message:message];
}

+(void)showAlert:(NSString *)title message:(NSString *)message titleCancelButton:(NSString*)titleCancelButton cancelBlock:(VoidHandler)cancelBlock titleDoneButton:(NSString*)titleDoneButton doneBlock:(VoidHandler)doneBlock
{
    alertView = [[AlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:titleCancelButton otherButtonTitles:titleDoneButton, nil];
    alertView.cancelBlock = ^{
        cancelBlock();
        alertView = nil;
    };
    alertView.doneBlock = ^{
        doneBlock();
        alertView = nil;
    };
    [alertView show];
}

+(void)hideAlertView
{
    if (alertView) {
        [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
        alertView = nil;
    }
}

@end
