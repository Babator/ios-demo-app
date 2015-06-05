//
//  Error.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

@property (nonatomic, strong) NSString * message;
@property (nonatomic) ServerConnectioErrorType errorType;
@property (nonatomic) int code;

- (id)initWithValues:(NSString *)message errorType:(ServerConnectioErrorType)errorType;

@end

typedef void (^FaultHandler)(Error * error);
typedef void (^VoidHandler)();
//typedef void (^MCKGetProcInfoHandler)(NSArray* worklistProcedureInfo);
