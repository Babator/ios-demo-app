//
//  BBTDownloadSession.m
//  Babator
//
//  Created by Andrey Kulinskiy on 7/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "BBTDownloadSession.h"
#import "BBTFileDownloadInfo.h"

@interface BBTDownloadSession () <NSURLSessionDelegate>

@property (nonatomic, strong) BBTFileDownloadInfo* fileInfo;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, assign) int cachingSeconds;
@property (nonatomic, assign) BOOL fullCaching;

@property (nonatomic, assign) BOOL isReadyToPlay;

@end

@implementation BBTDownloadSession

#pragma mark -
#pragma mark Init
- (id)initWithFileDownloadInfo:(BBTFileDownloadInfo*)fileDownloadInfo fullCaching:(BOOL)fullCaching {
    
    self = [super init];
    if (self) {
        
        self.fileInfo = fileDownloadInfo;
        self.fullCaching = fullCaching;
        //self.fullCaching = NO;
        [self setup];
        
        [self cachingVideo];
    }
    return self;
}

- (void)setup {
    
    self.cachingSeconds = 10;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = sessionConfiguration.timeoutIntervalForResource = 3600;
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
}

//- (void)dealloc {
//    NSLog(@"dealloc");
//}

#pragma mark -
#pragma mark Methods
- (void) cachingVideo {
    if (!self.fileInfo.isDownloading) {
        
        if (self.fileInfo.taskIdentifier == -1) {
            
            self.fileInfo.outputStream = [NSOutputStream outputStreamToFileAtPath:self.fileInfo.pathToFile append:NO];
            if (!self.fileInfo.outputStream) {
                NSLog(@"BBTVideoCachingManager Error: open NSOutputStream == nil");
                return;
            }
            [self.fileInfo.outputStream open];
            
            self.fileInfo.dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:self.fileInfo.downloadSource]];
            self.fileInfo.taskIdentifier = self.fileInfo.dataTask.taskIdentifier;
            [self.fileInfo.dataTask resume];
        }
        else{
            
//            self.fileInfo.outputStream = [NSOutputStream outputStreamToFileAtPath:self.fileInfo.pathToFile append:YES];
//            if (!self.fileInfo.outputStream) {
//                NSLog(@"BBTVideoCachingManager Error: reopen NSOutputStream == nil");
//                [self.fileInfo.dataTask cancel];
//                return;
//            }
//            [self.fileInfo.outputStream open];
            
            [self.fileInfo.dataTask resume];
        }
        self.fileInfo.isDownloading = YES;
    }
    else {
        
    }
}

- (void)stopDownloading {
    [self.fileInfo.dataTask cancel];
    [self.fileInfo.outputStream close];
}

- (void)removeCacheData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSString *path = [Utils pathForCachingData];
    
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:path]
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    NSString* videoName = [[self.fileInfo.pathToFile componentsSeparatedByString:@"/"]lastObject];
    
    for (NSURL* url in allFiles) {
        NSString* itemName = [[[url absoluteString] componentsSeparatedByString:@"/"]lastObject];
        if ([itemName isEqualToString:videoName]) {
            [fileManager removeItemAtURL:url error:&error];
        }
    }
    if (error) {
        NSLog(@"BBTDownloadSession Error: %@", error);
    }
}

- (void)removeData {
    [self stopDownloading];
    [self.session finishTasksAndInvalidate];
    self.fileInfo.outputStream = nil;
    self.fileInfo.dataTask = nil;
    [self removeCacheData];
}

- (void)fullCachingVideo {
    self.fullCaching = YES;
    [self cachingVideo];
}

//- (void) ttt {
//    NSLog(@"===   ttt   ===");
//    self.fullCaching = YES;
//    [self cachingVideo];
//}

#pragma mark -
#pragma mark NSURLSession Delegate method implementation
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    //NSLog(@"%@", data);
    //[self.fileHandle writeData:data];
    
    //NSLog(@"totalBytesWritten: %lld  totalBytesExpectedToWrite: %lld", dataTask.countOfBytesReceived, dataTask.countOfBytesExpectedToReceive);
    
    if (self.fileInfo.outputStream.streamStatus == NSStreamStatusOpen) {
        [self.fileInfo.outputStream write:(uint8_t *)[data bytes] maxLength:[data length]];
        //NSLog(@"write");
    }
    else {
        //NSLog(@"not write");
    }
    
    if (!self.fullCaching) {
        //double oneSecondBytes = (double)dataTask.countOfBytesExpectedToReceive / self.fileInfo.durationSec;
        
//        NSLog(@"durationSec: %ld", (long)self.fileInfo.durationSec);
//        //NSLog(@"countOfBytesExpectedToReceive: %ld", (long)dataTask.countOfBytesExpectedToReceive);
//        //NSLog(@"oneSecondBytes: %lld", oneSecondBytes);
//        NSLog(@"oneSecondBytes: %f", oneSecondBytes);
//        NSLog(@"====================================");
        
        //if (dataTask.countOfBytesReceived >= (oneSecondBytes * self.cachingSeconds)) {
        if (dataTask.countOfBytesReceived >= (dataTask.countOfBytesExpectedToReceive / 10)) {
            if (self.fileInfo.dataTask.state != NSURLSessionTaskStateSuspended) {
                [self.fileInfo.dataTask suspend];
                self.fileInfo.isDownloading = NO;
                //[self.fileInfo.outputStream close];
                //[self performSelector:@selector(ttt) withObject:nil afterDelay:30.0];
                //NSLog(@"suspend");
                
                if (!self.isReadyToPlay) {
                    self.isReadyToPlay = YES;
                    [self.delegate readyToPlayDownloadSession:self size:dataTask.countOfBytesExpectedToReceive];
                }
            }
        }
        else {
            
        }
    }
    
    if (!self.isReadyToPlay && dataTask.countOfBytesReceived >= 100000) {
    //if (!self.isReadyToPlay && dataTask.countOfBytesReceived >= dataTask.countOfBytesExpectedToReceive) {
    //if (!self.isReadyToPlay && (dataTask.countOfBytesReceived >= (dataTask.countOfBytesExpectedToReceive / 10))) {
        self.isReadyToPlay = YES;
        [self.delegate readyToPlayDownloadSession:self size:dataTask.countOfBytesExpectedToReceive];
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
    }
    else{
        NSLog(@"Download finished successfully.");
    }
    [self.fileInfo.outputStream close];
    self.fileInfo.isDownloading = NO;
    self.fileInfo.downloadComplete = YES;
}




@end




