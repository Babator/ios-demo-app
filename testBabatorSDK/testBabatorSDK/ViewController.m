//
//  ViewController.m
//  testBabatorSDK
//
//  Created by Eliza Sapir on 16/05/2016.
//  Copyright © 2016 Babator. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import <MediaPlayer/MPMoviePlayerController.h>

#import <BabatorUI_Lib/BabatorUI.h>

@interface ViewController () <BabatorViewControllerDelegate>

@property (nonatomic,strong) MPMoviePlayerViewController *mpPlayer;
@property (nonatomic, strong) BabatorViewController *babtorViewController;
@property (nonatomic) CGRect playerRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mpPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http:\/\/mediadownload.calcalist.co.il\/Calcalist_TV\/2015\/sony_xperia_z5.mp4?source=babator"]];
    _mpPlayer.moviePlayer.shouldAutoplay = YES;
    [_mpPlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [self presentMoviePlayerViewControllerAnimated:_mpPlayer];
    
    CGSize screen = self.view.frame.size;
    _playerRect = CGRectMake(0, 0, screen.width, screen.height);
    [self.view addSubview:_mpPlayer.view];
    _babtorViewController = [[BabatorViewController alloc] initWithAPIKey:@"d035223d-8bba-40d2-bb13-5a22298250c6"];
    _babtorViewController.suggestionsSize = 10;
    [_babtorViewController setPlayer:self.mpPlayer pageId:@"someId"];
    _babtorViewController.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_mpPlayer.moviePlayer.fullscreen) {
        return;
    }
    
    [_babtorViewController removeBabatorRecommendations];
    _babtorViewController = nil;
    [_mpPlayer.moviePlayer stop];
    [_mpPlayer removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _mpPlayer = nil;
    NSLog(@"dealloc");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (size.width < size.height) {
            _mpPlayer.view.frame = _playerRect;
        } else {
            _mpPlayer.view.frame = (CGRect){CGPointZero, size};
        }
    } completion:nil];
}

#pragma mark BabatorViewControllerDelegate
- (void)controller:(BabatorViewController *)controller didSelectVideo:(id<BBVideoParams>)videoParams {
    [self replaceVideoAndPlay:videoParams.url];
}

- (void)playNextSuggetion:(id<BBVideoParams>)videoParams {
    [self replaceVideoAndPlay:videoParams.url];
}

- (void)replaceVideoAndPlay:(NSURL *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mpPlayer.moviePlayer stop];
        if (url) {
            NSLog(@"video-url: %@", url);
            [self.mpPlayer.moviePlayer setContentURL:url];
        }
        [self.mpPlayer.moviePlayer play];
    });
}

- (IBAction)play:(id)sender {
    [self.mpPlayer.moviePlayer play];
}

- (IBAction)pause:(id)sender {
    [self.mpPlayer.moviePlayer pause];
}

- (IBAction)removeNativePlayerControls:(id)sender {
    //    self.mpPlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
}
@end
