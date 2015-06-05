//
//  HTTPClient.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface HTTPClient : AFHTTPClient

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *userID;

@end
