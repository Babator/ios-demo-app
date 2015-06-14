//
//  Utils.m
//  TrackYourCash
//
//  Created by Andrey Kulinskiy on 9/4/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "Utils.h"
#import <sys/utsname.h>
#import "MBProgressHUD.h"

@implementation Utils

#pragma mark - Date
+ (NSDate*)dateFromString:(NSString*)strDate
{
    if (!strDate || (id)strDate == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
//    Branch* branch = [DataContainer sharedInstance].user.branch;
//    if (branch && branch.timeZone && [ConfigDataProvider useBranchTimeZoneConfig]) {
//        [df setTimeZone:[NSTimeZone timeZoneWithName:branch.timeZone]];
//    }
    NSDate* date = [df dateFromString: strDate];
    if (!date) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [df dateFromString: strDate];
    }
    return date;
}

+ (NSString*)stringFromDate:(NSDate*)date
{
    //return [date description];
    NSString* result = nil;
    
    if (!date || (id)date == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    result = [df stringFromDate:date];
    if (!date) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        result = [df stringFromDate:date];
    }
    
    return result;
}

+ (NSString*)stringFromDate:(NSDate *)date withFormatString:(NSString*)dateFormatterString {
	
    if (!dateFormatterString || (id)dateFormatterString == [NSNull null])
        return nil;
	
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    //[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:dateFormatterString];
//    Branch* branch = [DataContainer sharedInstance].user.branch;
//    if (branch && branch.timeZone && [ConfigDataProvider useBranchTimeZoneConfig]) {
//        [formatter setTimeZone:[NSTimeZone timeZoneWithName:branch.timeZone]];
//    }
    
	return [formatter stringFromDate:date];
}

+ (NSString *)stringTimeFormatted:(NSInteger)totalSeconds
{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    NSString* strResult = @"";
    if (hours == 0) {
        strResult = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
    else {
        strResult = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    }
    
    return strResult;
}

#pragma mark - Style

// Style
+ (UIColor*)colorTitle
{
    return [Utils colorRed];
}

+ (UIColor*)colorStatusBar
{
    return [Utils colorRed];
}

+ (UIColor*)colorRed
{
    return UIColorMakeRGB(255, 83, 61);
}

+ (UIColor*)colorGreen
{
    return UIColorMakeRGB(158, 182, 107);
}

+ (UIColor*)colorLightGreen
{
    return UIColorMakeRGB(193, 217, 142);
}

+ (UIColor*)colorBlue
{
    return UIColorMakeRGB(0, 114, 143);
}

+ (UIColor*)colorYellow
{
    return UIColorMakeRGB(255, 202, 88);
}

+ (UIColor*)colorDarkText
{
    return UIColorMakeRGB(65, 65, 65);
}

+ (UIColor*)colorLightText
{
    return UIColorMakeRGB(129, 129, 129);
}

+ (UIColor*)colorDarkBorder
{
    return UIColorMakeRGB(159, 159, 159);
}

+ (UIColor*)colorLightBorder
{
    return UIColorMakeRGB(239, 239, 239);
}

+ (UIColor*)colorNavigationBar
{
    return UIColorMakeRGB(250, 250, 250);
}

+ (UIColor*)colorExchangeShift
{
    return UIColorMakeRGB(255, 53, 31);
}

+ (UIColor*)colorLightExchangeShift
{
    return UIColorMakeRGB(255, 88, 66);
}

+ (UIColor*)colorPickupShift
{
    return UIColorMakeRGB(238, 118, 0);
}

+ (UIColor*)colorLightPickupShift
{
    return UIColorMakeRGB(236, 164, 93);
}

#pragma mark- DeviceInfo

+ (NSString *)getDeviceId
{
    NSString* udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //NSString* udid = [OpenUDID value];
    return  udid;
}

+ (NSString *)getDeviceName
{
    NSString* deviceName = [[UIDevice currentDevice] name];
    return deviceName;
}

+ (NSString *)getDeviceModel
{ //string like: iPad3,3
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *)getOsVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getApplicationVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (BOOL)isDisplay_iPhone4
{
    BOOL result = NO;
    
    UIScreen* screen = [UIScreen mainScreen];
    if (screen.bounds.size.height < 568) {
        result = YES;
    }
    
    return result;
}

#pragma - mark HUD
+ (void)showHUD {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows[0] rootViewController].view animated:YES];
}

+ (void)hideHUD {
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows[0] rootViewController].view animated:YES];
}

+ (void)connectionError:(Error*)error
{
    if (!error) {
        return;
    }
    NSString * text = [Utils connectionErrorText:error];
    [AlertViewUtil showAlert:text];
    
//    switch(error.errorType)
//    {
//        case OperationNotPermitted:
//        case NoServerConnection:
//        case ServerError:
//        case ClientError:
//        case UnknownError:
//        case SSLError:
//            break;
//    }
}

+(NSString *)connectionErrorText:(Error *) error
{
    switch(error.errorType)
    {
        case TokenExpired:
            return NSLocalizedString(@"***TokenExpiredAlert", nil);
            break;
            
        case OperationNotPermitted:
            return NSLocalizedString(@"***OperationNotPermittedAlert", nil);
            break;
            
        case NoServerConnection:
            return NSLocalizedString(@"***MessageNoServerConnectionAlert", nil);
            break;
            
        case ServerError:
            return NSLocalizedString(@"***MessageErrorOnServerAlert", nil);
            break;
            
        case SSLError:
            return NSLocalizedString(@"***SSLErrorAlert", nil);
            break;
            
        case ClientError:
            return NSLocalizedString(@"***ClientErrorAlert", nil);
            break;
            
        case UnknownError:
            return NSLocalizedString(@"***UnknownErrorAlert", nil);
            break;
    }
}

+ (NSString*)urlHDVideoForUrl:(NSString*)url {
    NSString* strUrlImage = url;
    NSArray* arrTmp = [strUrlImage componentsSeparatedByString:@"."];
    NSMutableString* strSendUrl = [NSMutableString string];
    
    for (int i = 0; i < [arrTmp count] - 1; i++) {
        NSString* item = arrTmp[i];
        [strSendUrl appendString:item];
        if (i < [arrTmp count] - 2) {
            [strSendUrl appendString:@"."];
        }
    }
    
    [strSendUrl appendFormat:@"%@.%@", @"_640_300", arrTmp.lastObject];
    return strSendUrl;
}


@end


UIColor* UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return UIColorMakeRGBAlpha(red, green, blue, 1.0f);
}

UIColor* UIColorMakeRGBAlpha(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

CGFloat radiansForDegrees(CGFloat degrees)
{
    return degrees * 2 * M_PI / 360;
}

