//
//  MainScreenController.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/2/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "MainScreenController.h"
#import "UserIDResponseModule.h"
#import "VideoModule.h"
#import "AKPlayerView.h"
#import "ThumbnailView.h"
#import "ListVideosView.h"
#import "VideoView.h"

//@import AVFoundation;

@interface MainScreenController () <ListVideosViewDelegate, VideoViewDelegate>

@property (nonatomic, strong) NSURL* urlTest;
@property (nonatomic, strong) VideoItem* videoItem;
@property (nonatomic, strong) VideoView* videoView;
@property (nonatomic, strong) ListVideosView* listVideosView;
@property (nonatomic, assign) BOOL isFullScreen;

@end

@implementation MainScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Methods
- (void)setup {
    [super setup];
    
    [DataContainer sharedInstance].configDataProvider.apiKey = @"bec4606-ce32-4ba2-8e58-f6183cd2fdf9";
    
    self.urlTest = [NSURL URLWithString:@"http://n23.filecdn.to/ff/NDcxMjk4MGZmNmRmNDBiMGY2ZjE2OTJiM2YyYmU5ZTl8ZnN0b3wxMzQ4MjY0NTc0fDEwMDAwfDJ8MHw1fDIzfGUzY2FjMTY3NjY5OWJhZjI0ZjNlNmE4ZDQ0NTMzYWQxfDB8MjQ6aC40MjpzfDB8MjAxODU5NjYwNnwxNDMzMzE4MjE4LjUzMzk,/play_698j93w00plnrodv1itd0heuu.0.4278037390.2185543202.1433148971.mp4"];
}

- (void)addAllViews {
    [super addAllViews];
    
    [self.view addSubview:self.listVideosView];
    [self.view addSubview:self.videoView];
    
    [self reloadData];
    [self resizeViews];
}

- (void)reloadData {
    [super reloadData];
    
    [self loadFirstVideo];
}

- (void)resizeViews {
    [super resizeViews];
    
    if (self.isFullScreen) {
        self.videoView.frame = self.view.bounds;
    }
    else {
        self.videoView.frame = CGRectMake(0, self.heightHeader, self.view.width, 200);
        self.listVideosView.frame = CGRectMake(0, self.videoView.edgeY, self.view.width, self.view.height - self.videoView.edgeY);
    }
}

#pragma mark -
#pragma mark API
- (void)loadFirstVideo {
    
    [Utils showHUD];
    [self loadUserIdSuccess:^(NSString *userID) {
        
        [DataContainer sharedInstance].configDataProvider.userID = userID;
        ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
        [serverAPI firstVideoSuccess:^(VideoModule *request) {
                               self.videoItem = request.videoItem;
                               [Utils hideHUD];
                           } failure:^(Error *error) {
                               [Utils connectionError:error];
                               [Utils hideHUD];
                           }];
        
                    }
                    failure:^{
                        [Utils hideHUD];
                    }];
}

- (void)loadUserIdSuccess:(void (^)(NSString* userID))successBlock failure:(void (^)())failureBlock {
    ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
    
    [serverAPI userIdForApiKey:[DataContainer sharedInstance].configDataProvider.apiKey
                       success:^(UserIDResponseModule *request) {
                           
                           if (request.status != 200) {
                               
                               NSString* strError = @"Error Connection";
                               if ([request.errors count] > 0) {
                                   strError = request.errors[0];
                               }
                               
                               [AlertViewUtil showAlert:strError okBlock:^{
                                   
                               }];
                           }
                           else {
                               successBlock(request.userID);
                           }
                           
                       } failure:^(Error *error) {
                           [Utils connectionError:error];
                           failureBlock();
                       }];
}

#pragma mark -
#pragma mark Actions

#pragma mark -
#pragma mark Property
- (VideoView*)videoView {
    if (!_videoView) {
        _videoView = [[VideoView alloc]initWithFrame:CGRectZero];
        _videoView.delegate = self;
    }
    return _videoView;
}

- (ListVideosView *)listVideosView {
    if (!_listVideosView) {
        _listVideosView = [[ListVideosView alloc]initWithFrame:CGRectZero];
        _listVideosView.delegate = self;
    }
    return _listVideosView;
}

- (void)setVideoItem:(VideoItem *)videoItem {
    _videoItem = videoItem;
    
    [self.videoView setUrl:videoItem.imageUrl duration:videoItem.durationSec];
    [self.videoView loadVideoForURL:videoItem.url];
    
    if (!videoItem.videos) {
        self.videoView.isPlay = YES;
        ServerAPI* serverAPI = [DataContainer sharedInstance].serverAPI;
        [serverAPI videosForVideoID:videoItem.videoID
                            success:^(VideosModule *request) {
                                self.listVideosView.videos = request.videos;
                            } failure:^(Error *error) {
                                [Utils connectionError:error];
                            }];
    }
    else {
        self.listVideosView.videos = videoItem.videos;
    }
}

#pragma mark -
#pragma mark ListVideosView Delegate
- (void)listVideosView:(ListVideosView*)listVideosView selectItem:(VideoItem*)item {
    self.videoItem = item;
}


#pragma mark -
#pragma mark VideoView Delegate
- (void)fullScreenForVideoView:(VideoView*)videoView {
    self.isFullScreen = !self.isFullScreen;
    
    self.view.transform = CGAffineTransformIdentity;
    UIScreen* screen = [UIScreen mainScreen];
    if (self.isFullScreen) {
        self.view.transform = CGAffineTransformMakeRotation((M_PI * (90) / 180.0));
        self.view.bounds = CGRectMake(0.0, 0.0, screen.bounds.size.height, screen.bounds.size.width);
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationFade];
    }
    else {
        self.view.transform = CGAffineTransformMakeRotation((M_PI * (0) / 180.0));
        self.view.bounds = CGRectMake(0.0, 0.0, screen.bounds.size.width, screen.bounds.size.height);
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
    }
    
    [self resizeViews];
}

#pragma mark -
#pragma mark Notifications



@end




