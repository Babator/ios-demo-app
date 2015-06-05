//
//  DataContainer.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigDataProvider.h"
#import "ServerAPI.h"

@interface DataContainer : NSObject

+ (DataContainer*)sharedInstance;

@property (nonatomic, strong) ConfigDataProvider* configDataProvider;
@property (nonatomic, strong) ServerAPI * serverAPI;

@end
