//
//  BBTVideoLoader.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/30/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTVideoLoader : NSObject

// Init BBTVideoLoader
// param: apiKey - GUID device
- (id)initWithApiKey:(NSString*)apiKey;

// Set Server URL (default: api.babator.com)
// param: url - new Server URL
- (void)setServerURL:(NSString*)url;

// returns a video to play and list of recommended videos.
- (void) firstVideoSuccess: (void (^)(VideoItem* item)) successBlock
                   failure: (void (^)()) failureBlock;

// Gets the currently watched video id and  returns a list of recommended videos.
// param: videoID - video ID
// return list VideoItem
- (void)videosForVideoID: (NSInteger) videoID
                  success: (void (^)(NSArray* items)) successBlock
                  failure: (void (^)()) failureBlock;

@end
