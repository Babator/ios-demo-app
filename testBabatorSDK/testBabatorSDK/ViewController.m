//
//  ViewController.m
//  testBabatorSDK
//
//  Created by Eliza Sapir on 16/05/2016.
//  Copyright © 2016 Babator. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import <BabatorUI/BabatorUI.h>
//#import <BabatorUI_Lib/BabatorUI.h>

@interface ViewController () <BabatorViewControllerDelegate>

@property (nonatomic,strong) AVPlayerViewController *avPlayer;
@property (nonatomic, strong) BabatorViewController *babtorViewController;
@property (nonatomic) CGRect playerRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSURL *mediaUrl = [NSURL URLWithString:@"http:\/\/mediadownload.calcalist.co.il\/Calcalist_TV\/2015\/sony_xperia_z5.mp4?source=babator"];
    
    AVPlayer *player = [AVPlayer playerWithURL:mediaUrl];
    _avPlayer = [AVPlayerViewController new];
    _avPlayer.player = player;
    [self presentViewController:_avPlayer animated:NO completion:nil];
    [_avPlayer.player play];
    CGSize screen = self.view.frame.size;
    _playerRect = CGRectMake(0, 0, screen.width, screen.height);
    //    [self.view addSubview:_mpPlayer.view];
    _babtorViewController = [[BabatorViewController alloc] initWithAPIKey:@"d035223d-8bba-40d2-bb13-5a22298250c6"];
    _babtorViewController.suggestionsSize = 10;
    
    //For better results, pageId should be unique per View (For example, it can be a category name)
    [_babtorViewController setPlayer:self.avPlayer pageId:@"AVViewController"];
    [[NSNotificationCenter defaultCenter] removeObserver:self.avPlayer.player
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    _babtorViewController.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _avPlayer = nil;
    NSLog(@"dealloc");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (size.width < size.height) {
            _avPlayer.view.frame = _playerRect;
        } else {
            _avPlayer.view.frame = (CGRect){CGPointZero, size};
        }
    } completion:nil];
}

#pragma mark BabatorViewControllerDelegate
- (void)controller:(BabatorViewController *)controller didSelectVideo:(id<BBVideoParams>)videoParams {
   // [self replaceVideoAndPlay:videoParams.url];
}

- (void)didSelectDone:(BabatorViewController *)contoller {
    [self.avPlayer dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/*
- (void)replaceVideoAndPlay:(NSURL *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.avPlayer.player pause];
        [self.avPlayer.player seekToTime:kCMTimeZero];
        if (url) {
            NSLog(@"video-url: %@", url);
            AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
            [self.avPlayer.player replaceCurrentItemWithPlayerItem:item];
        }
        [self.avPlayer.player play];
    });
}
*/
- (IBAction)play:(id)sender {
    [self.avPlayer.player play];
}

- (IBAction)pause:(id)sender {
    [self.avPlayer.player pause];
}

- (IBAction)removeNativePlayerControls:(id)sender {
    //    self.mpPlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
}
@end
