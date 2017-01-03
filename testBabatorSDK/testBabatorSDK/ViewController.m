//
//  ViewController.m
//  TestPods
//
//  Created by Nissim Pardo on 27/12/2016.
//  Copyright © 2016 babator. All rights reserved.
//

#import "ViewController.h"
#import <BabatorUI/BabatorUI.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <BabatorViewControllerDelegate>
    @property (nonatomic,strong) AVPlayerViewController *avPlayer;
    @property (nonatomic, strong) BabatorViewController *babtorViewController;
    @property (nonatomic) CGRect playerRect;
    @end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
    
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSURL *mediaUrl = [NSURL URLWithString:@"http://rmcdn.2mdn.net/MotifFiles/html/1248596/android_1330378998288.mp4"];
    
    AVPlayer *player = [AVPlayer playerWithURL:mediaUrl];
    _avPlayer = [AVPlayerViewController new];
    _avPlayer.player = player;
    [self presentViewController:_avPlayer animated:NO completion:nil];
    [_avPlayer.player play];
    CGSize screen = self.view.frame.size;
    _playerRect = CGRectMake(0, 0, screen.width, screen.height);
    //    [self.view addSubview:_mpPlayer.view];
    _babtorViewController = [[BabatorViewController alloc] initWithAPIKey:@"34e91060-d0dc-11e5-8fe6-19263f12cd2a"];
    _babtorViewController.suggestionsSize = 6;
    _babtorViewController.videoHolder = self.avPlayer.view;
    //For better results, pageId should be unique per View (For example, it can be a category name)
    [_babtorViewController setPlayer:self.avPlayer.player pageId:@"AVViewController"];
    [[NSNotificationCenter defaultCenter] removeObserver:self.avPlayer.player
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    _babtorViewController.delegate = self;
}
    
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark BabatorViewControllerDelegate
- (void)controller:(BabatorViewController *)controller didSelectVideo:(id<BBVideoParams>)videoParams {
    if(videoParams != nil){
        NSString *url = [[videoParams url] absoluteString];
        NSLog(@"url: %@", url);
        NSString *pageUrl = [videoParams pageUrl];
        NSLog(@"pageUrl: %@", pageUrl);
    }
    
}
    
- (void) controller:(BabatorViewController *)controller willChangeSource:(id<BBVideoParams>)videoSource {
    if(videoSource != nil){
        NSString *url = [[videoSource url] absoluteString];
        NSLog(@"url: %@", url);
        NSString *pageUrl = [videoSource pageUrl];
        NSLog(@"pageUrl: %@", pageUrl);
    }
}
    
- (void) controller:(BabatorViewController *)controller didChangeSource:(id<BBVideoParams>)videoSource {
    if(videoSource != nil){
        NSString *url = [[videoSource url] absoluteString];
        NSLog(@"url: %@", url);
        NSString *pageUrl = [videoSource pageUrl];
        NSLog(@"pageUrl: %@", pageUrl);
    }
}
    
    
    
    @end
