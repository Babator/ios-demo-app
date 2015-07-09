//
//  BBTVideoLoader.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/30/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "BBTVideoLoader.h"
#import "VideoItem.h"
#import "BBTVideoItem.h"
#import "UserIDResponseModule.h"
#import "BBTVideoCachingManager.h"

typedef void (^SuccessFirstVideo)(BBTVideoItem* item);
typedef void (^SuccessVideos)(NSArray* videos);

@interface BBTVideoLoader () <BBTVideoCachingManagerDelegate>

@property (nonatomic, strong) NSString* apiKey;
@property (nonatomic, strong) BBTVideoCachingManager* cachingManager;

@property (nonatomic, strong) VideoItem* firstVideoItem;
@property (nonatomic, strong) BBTVideoItem* firstBBTVideoItem;
@property (nonatomic, strong) SuccessFirstVideo successFirstVideo;
@property (nonatomic, strong) SuccessVideos successVideos;
@property (nonatomic, strong) NSArray* arrVideos;
@property (nonatomic, strong) NSMutableArray* arrVideosNotReady;

@end

@implementation BBTVideoLoader

#pragma mark -
#pragma mark - Init
- (id)initWithApiKey:(NSString*)apiKey {
    
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.cachingManager = [[BBTVideoCachingManager alloc]init];
    self.cachingManager.delegate = self;
}

#pragma mark -
#pragma mark - Methods Framework
- (void) setServerURL: (NSString*) url {
    
}

- (void) firstVideoSuccess: (void (^)(BBTVideoItem* item)) successBlock
                   failure: (void (^)()) failureBlock {
    
    if (!self.apiKey) {
        NSLog(@"BBTVideoLoader Error: ApiKey == nil");
        failureBlock();
        return;
    }
    
    self.successFirstVideo = successBlock;
    
    [self loadUserIdSuccess:^(NSString *userID) {
        
                        if (userID) {
                            [DataContainer sharedInstance].configDataProvider.userID = userID;
                            ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
                            [serverAPI firstVideoSuccess:^(VideoModule *request) {
                                
                                if (request.videoItem) {
                                    BBTVideoItem* item = [self createBBTVideoItemForVideoItem:request.videoItem];
                                    self.firstVideoItem = request.videoItem;
                                    self.firstBBTVideoItem = item;
                                    
                                    NSString* pathToFile = [self.cachingManager videoCachingForVideoItem:request.videoItem fullCaching:YES];
                                    item.url = pathToFile;
                                    NSLog(@"%@", pathToFile);
                                }
                                else {
                                    failureBlock();
                                }
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
                        failureBlock();
                    }];
}

- (void) videosForVideo: (BBTVideoItem*) currentVideo
                  success: (void (^)(NSArray* items)) successBlock
                  failure: (void (^)()) failureBlock {
    
    self.successVideos = successBlock;
    
    ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
    [serverAPI videosForVideoID:currentVideo.videoID
                        success:^(VideosModule *request) {
                            NSMutableArray* newVideos = [NSMutableArray array];
                            self.arrVideosNotReady = [NSMutableArray array];
                            
                            for (VideoItem* item in request.videos) {
                                BBTVideoItem* bbtVideoItem = [self createBBTVideoItemForVideoItem:item];
                                
                                if (item.videoID == currentVideo.videoID) {
                                    bbtVideoItem.url = [self.cachingManager pathForVideoID:currentVideo.videoID];
                                    bbtVideoItem.size = currentVideo.size;
                                }
                                else {
                                    bbtVideoItem.url = [self.cachingManager videoCachingForVideoItem:item fullCaching:NO];
                                    [self.arrVideosNotReady addObject:bbtVideoItem];
                                }
                                
                                [newVideos addObject:bbtVideoItem];
                            }
                            self.arrVideos = newVideos;
                            
//                            NSInteger countVideos = [self.firstVideoItem.videos count];
//                            for (int index; index < countVideos; index++) {
//                                VideoItem* videoItem = [self.firstVideoItem.videos objectAtIndex:index];
//                                BBTVideoItem* bbtVideoItem = [self.firstBBTVideoItem.videos objectAtIndex:index];
//                                bbtVideoItem.url = [self.cachingManager videoCachingForVideoItem:videoItem fullCaching:NO];
//                            }
                            
                            //successBlock(newVideos);
                        } failure:^(Error *error) {
                            self.successVideos = nil;
                            failureBlock();
                        }];
}

- (void)cachingForVideoID:(NSInteger)videoID {
    [self.cachingManager cachingForVideoID:videoID];
}

#pragma mark -
#pragma mark - Methods
- (void)loadUserIdSuccess:(void (^)(NSString* userID))successBlock failure:(void (^)())failureBlock {
    ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
    
    [serverAPI userIdForApiKey:self.apiKey
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
                           failureBlock();
                       }];
}

- (BBTVideoItem*)createBBTVideoItemForVideoItem:(VideoItem*)videoItem {
    
    BBTVideoItem* item = [[BBTVideoItem alloc] init];
    item.videoID = videoItem.videoID;
    item.durationSec = videoItem.durationSec;
    item.title = videoItem.title;
    item.url = videoItem.url;
    item.imageUrl = videoItem.imageUrl;
    //item.videos = videoItem.videos;
    if (videoItem.videos) {
        NSMutableArray* arrVideos = [NSMutableArray array];
        for (VideoItem* vitem in videoItem.videos) {
            [arrVideos addObject:[self createBBTVideoItemForVideoItem:vitem]];
        }
        item.videos = arrVideos;
    }
    
    return item;
}

#pragma mark -
#pragma mark - BBTVideoCachingManager Delegate
- (void)videoCachingManager:(BBTVideoCachingManager*) videoCachingManager readyToPlayForVideoID:(NSInteger) videoID size:(unsigned long)size {
    if (self.firstVideoItem && self.successFirstVideo && self.firstVideoItem.videoID == videoID) {
        self.firstBBTVideoItem.size = size;
        self.successFirstVideo(self.firstBBTVideoItem);
        
        self.arrVideosNotReady = [NSMutableArray array];
        
        NSInteger countVideos = [self.firstVideoItem.videos count];
        //NSLog(@"count: %ld", (long)countVideos);
        for (int index; index < countVideos; index++) {
            VideoItem* videoItem = [self.firstVideoItem.videos objectAtIndex:index];
            BBTVideoItem* bbtVideoItem = [self.firstBBTVideoItem.videos objectAtIndex:index];
            
            if (bbtVideoItem.videoID == self.firstBBTVideoItem.videoID) {
                bbtVideoItem.url = [self.cachingManager pathForVideoID:self.firstBBTVideoItem.videoID];
                bbtVideoItem.size = self.firstBBTVideoItem.size;
            }
            else {
                bbtVideoItem.url = [self.cachingManager videoCachingForVideoItem:videoItem fullCaching:NO];
                [self.arrVideosNotReady addObject:bbtVideoItem];
            }
            
            //bbtVideoItem.url = [self.cachingManager videoCachingForVideoItem:videoItem fullCaching:NO];
        }
        
        self.firstVideoItem = nil;
        self.firstBBTVideoItem = nil;
        self.successFirstVideo = nil;
    }
    else {
        BBTVideoItem* itemReady;
        for (BBTVideoItem* item in self.arrVideosNotReady) {
            if (item.videoID == videoID) {
                item.size = size;
                itemReady = item;
                break;
            }
        }
        if (itemReady) {
            [self.arrVideosNotReady removeObject:itemReady];
        }
        
        if ([self.arrVideosNotReady count] == 0) {
            if (self.successVideos) {
                self.successVideos(self.arrVideos);
            }
            self.arrVideos = nil;
            self.arrVideosNotReady = nil;
            self.successVideos = nil;
        }
    }
    
    //NSLog(@"ready: %ld", (long)videoID);
}


@end




