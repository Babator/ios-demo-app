//
//  HTTPClient.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient

- (id)initWithBaseURL:(NSURL *)baseUrl {
    self = [super initWithBaseURL:baseUrl];
    if (self)
    {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Content-Type" value:@"application/json"];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setParameterEncoding:AFJSONParameterEncoding];
    }
    
    return self;
}

- (void)setApiKey:(NSString *)apiKey {
    _apiKey = apiKey;
    //[self setDefaultHeader:@"apiKey" value:apiKey];
}

- (void)setUserID:(NSString *)userID {
    _userID = userID;
    //[self setDefaultHeader:@"userId" value:userID];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //NSLog(@"%@", self);
    //[self setAuthorizationHeaderWithToken:token];
    
    //NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    //[request setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
    
	//AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    //[self enqueueHTTPRequestOperation:operation];
    
    [super postPath:path parameters:parameters success:success failure:failure];
}

@end
