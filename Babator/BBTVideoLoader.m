//
//  BBTVideoLoader.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/30/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "BBTVideoLoader.h"
#import "VideoItem.h"
#import "UserIDResponseModule.h"

@interface BBTVideoLoader ()

@property (nonatomic, strong) NSString* apiKey;

@end

@implementation BBTVideoLoader

#pragma mark -
#pragma mark - Init
- (id)initWithApiKey:(NSString*)apiKey {
    
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
    }
    return self;
}

#pragma mark -
#pragma mark - Methods Framework
- (void) setServerURL: (NSString*) url {
    
}

- (void) firstVideoSuccess: (void (^)(VideoItem* item)) successBlock
                   failure: (void (^)()) failureBlock {
    
    [self loadUserIdSuccess:^(NSString *userID) {
        
                        if (userID) {
                            [DataContainer sharedInstance].configDataProvider.userID = userID;
                            ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
                            [serverAPI firstVideoSuccess:^(VideoModule *request) {
                                
                                if (request.videoItem) {
                                    successBlock(request.videoItem);
                                }
                                else {
                                    failureBlock();
                                }
                                [Utils hideHUD];
                            } failure:^(Error *error) {
                                //[Utils connectionError:error];
                                failureBlock();
                            }];
                        }
                        else {
                            failureBlock();
                        }
                        
                    }
                    failure:^{
                        [Utils hideHUD];
                    }];
}

- (void) videosForVideoID: (NSInteger) videoID
                  success: (void (^)(NSArray* items)) successBlock
                  failure: (void (^)()) failureBlock {
    
}

#pragma mark -
#pragma mark - Methods
- (void)loadUserIdSuccess:(void (^)(NSString* userID))successBlock failure:(void (^)())failureBlock {
    ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
    
    [serverAPI userIdForApiKey:[DataContainer sharedInstance].configDataProvider.apiKey
                       success:^(UserIDResponseModule *request) {
                           
                           if (request.status != 200) {
                               
                               NSString* strError = @"Error Connection";
                               if ([request.errors count] > 0) {
                                   strError = request.errors[0];
                               }
                               successBlock(nil);
                           }
                           else {
                               successBlock(request.userID);
                           }
                           
                       } failure:^(Error *error) {
                           [Utils connectionError:error];
                           failureBlock();
                       }];
}

@end
