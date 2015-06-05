//
//  AlertView.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewUtil : NSObject

+(void)showAlert:(NSString *)title message:(NSString *)message okBlock:(VoidHandler)block;

+(void)showAlert:(NSString *)message okBlock:(VoidHandler)block;

+(void)showAlert:(NSString *)title message:(NSString *)message;

+(void)showAlert:(NSString *)message;

+(void)showAlert:(NSString *)title message:(NSString *)message titleCancelButton:(NSString*)titleCancelButton cancelBlock:(VoidHandler)cancelBlock titleDoneButton:(NSString*)titleDoneButton doneBlock:(VoidHandler)doneBlock;

+(void)hideAlertView;

@end
