//
//  DataContainer.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "DataContainer.h"

@implementation DataContainer

+ (DataContainer*)sharedInstance
{
    static DataContainer * sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataContainer alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.configDataProvider = [[ConfigDataProvider alloc] init];
        self.serverAPI = [[ServerAPI alloc] init];
        [self.serverAPI setWebserviceURL:[ConfigDataProvider serverURL]];
    }
    return self;
}

@end
