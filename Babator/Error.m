//
//  Error.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "Error.h"

@implementation Error

- (id)initWithValues:(NSString *)message errorType:(ServerConnectioErrorType)errorType
{
    self = [super init];
    if (self) {
        
        self.message = message;
        self.errorType = errorType;
    }
    return self;
}

@end
