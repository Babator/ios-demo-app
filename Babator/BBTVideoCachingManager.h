//
//  BBTVideoCachingManager.h
//  Babator
//
//  Created by Andrey Kulinskiy on 7/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoItem;
@protocol BBTVideoCachingManagerDelegate;

@interface BBTVideoCachingManager : NSObject

@property (nonatomic, weak) id <BBTVideoCachingManagerDelegate> delegate;

- (NSString*)videoCachingForVideoItem:(VideoItem*)videoItem fullCaching:(BOOL)fullCaching;
- (void)cachingForVideoID:(NSInteger)videoID;
- (NSString*)pathForVideoID:(NSInteger)videoID;

@end

@protocol BBTVideoCachingManagerDelegate <NSObject>

- (void)videoCachingManager:(BBTVideoCachingManager*) videoCachingManager readyToPlayForVideoID:(NSInteger) videoID size:(unsigned long)size;

@end
