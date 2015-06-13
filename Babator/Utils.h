//
//  Utils.h
//  TrackYourCash
//
//  Created by Andrey Kulinskiy on 9/4/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Error;

@interface Utils : NSObject

// Date & Time
+ (NSDate*)dateFromString:(NSString*)strDate;
+ (NSString*)stringFromDate:(NSDate*)date;
+ (NSString*)stringFromDate:(NSDate *)date withFormatString:(NSString*)dateFormatterString;
+ (NSString *)stringTimeFormatted:(NSInteger)totalSeconds;

// Style
+ (UIColor*)colorTitle;
+ (UIColor*)colorStatusBar;
+ (UIColor*)colorRed;
+ (UIColor*)colorGreen;
+ (UIColor*)colorLightGreen;
+ (UIColor*)colorBlue;
+ (UIColor*)colorYellow;
+ (UIColor*)colorDarkText;
+ (UIColor*)colorLightText;
+ (UIColor*)colorDarkBorder;
+ (UIColor*)colorLightBorder;
+ (UIColor*)colorNavigationBar;
+ (UIColor*)colorExchangeShift;
+ (UIColor*)colorLightExchangeShift;
+ (UIColor*)colorPickupShift;
+ (UIColor*)colorLightPickupShift;

// DeviceInfo
+ (NSString *)getDeviceId;
+ (NSString *)getDeviceName;
+ (NSString *)getOsVersion;
+ (NSString *)getApplicationVersion;
+ (NSString *)getDeviceModel;
+ (BOOL)isDisplay_iPhone4;

// HUD
+ (void)showHUD;
+ (void)hideHUD;

+ (void)connectionError:(Error*)error;

+ (NSString*)urlHDVideoForUrl:(NSString*)url;

@end

UIColor* UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue);
UIColor* UIColorMakeRGBAlpha(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
CGFloat radiansForDegrees(CGFloat degrees);

//extern FaultHandler defaultFaultHandler;
//extern FaultHandler defaultFaultHandlerHideHud;
