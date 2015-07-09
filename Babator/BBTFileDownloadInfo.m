//
//  BBTFileDownloadInfo.m
//  Babator
//
//  Created by Andrey Kulinskiy on 7/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "BBTFileDownloadInfo.h"

@implementation BBTFileDownloadInfo

- (id)initWithPathToFile:(NSString *)pathToFile downloadSource:(NSString *)source durationSec:(NSInteger)durationSec {
    if (self == [super init]) {
        self.pathToFile = pathToFile;
        self.durationSec = durationSec;
        self.downloadSource = source;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
    }
    
    return self;
}

@end
