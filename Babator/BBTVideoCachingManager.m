//
//  BBTVideoCachingManager.m
//  Babator
//
//  Created by Andrey Kulinskiy on 7/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "BBTVideoCachingManager.h"
#import "BBTFileDownloadInfo.h"
#import "BBTDownloadSession.h"

@interface BBTVideoCachingManager () <BBTDownloadSessionDelegate>

@property (nonatomic, strong) NSMutableArray* sessions;
@property (nonatomic, strong) NSString* cacheStorage;

@end

@implementation BBTVideoCachingManager

#pragma mark -
#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.sessions = [NSMutableArray array];
    
    NSString *path = [Utils pathForCachingData];
    self.cacheStorage = path;
    
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
    else {
        [self removeAllFilesFromCacheStorage];
    }
}

#pragma mark -
#pragma mark - Methods
- (NSString*)videoCachingForVideoItem:(VideoItem*)videoItem fullCaching:(BOOL)fullCaching {
    NSString* pathToFile;
    
    NSString* fileName = [NSString stringWithFormat:@"video_%ld.mp4", (long)videoItem.videoID];
    pathToFile = [self.cacheStorage stringByAppendingPathComponent:fileName];
    
    BBTFileDownloadInfo* fileInfo = [[BBTFileDownloadInfo alloc]initWithPathToFile:pathToFile downloadSource:videoItem.url durationSec:videoItem.durationSec];
    fileInfo.videoID = videoItem.videoID;
    
    BBTDownloadSession* downloadSession = [[BBTDownloadSession alloc]initWithFileDownloadInfo:fileInfo fullCaching:fullCaching];
    downloadSession.delegate = self;
    [self.sessions addObject:downloadSession];
    //[self performSelector:@selector(ttt) withObject:nil afterDelay:15];
    
    return pathToFile;
}

//- (void)ttt {
//    NSLog(@"ttt");
//    
//    BBTDownloadSession* downloadSession = self.sessions[0];
//    [downloadSession removeData];
//    
//    [self.sessions removeAllObjects];
//}

- (void)removeAllFilesFromCacheStorage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:self.cacheStorage]
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (NSURL* url in allFiles) {
        [fileManager removeItemAtURL:url error:nil];
    }
}

- (void)cachingForVideoID:(NSInteger)videoID {
    
    BBTDownloadSession* currentSession;
    for (BBTDownloadSession* downloadSession in self.sessions) {
        if (downloadSession.fileInfo.videoID == videoID) {
            currentSession = downloadSession;
            NSLog(@"====cachingForVideoID====");
        }
        else {
            [downloadSession removeData];
        }
    }
    
    if (currentSession) {
        [currentSession fullCachingVideo];
        [self.sessions removeAllObjects];
        [self.sessions addObject:currentSession];
    }
}

- (NSString*)pathForVideoID:(NSInteger)videoID {
    
    NSString* path;
    
    for (BBTDownloadSession* session in self.sessions) {
        if (session.fileInfo.videoID == videoID) {
            path = session.fileInfo.pathToFile;
        }
    }
    
    return path;
}

#pragma mark -
#pragma mark - BBTDownloadSession Delegate
- (void)readyToPlayDownloadSession:(BBTDownloadSession*)downloadSession size:(unsigned long)size {
    [self.delegate videoCachingManager:self readyToPlayForVideoID:downloadSession.fileInfo.videoID size:size];
}





@end


