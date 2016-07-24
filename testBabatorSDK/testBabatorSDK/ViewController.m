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

//#import <BabatorUI/BabatorUI.h>
#import <BabatorUI_Lib/BabatorUI.h>

@interface ViewController () <BabatorViewControllerDelegate>

@property (nonatomic,strong) MPMoviePlayerViewController *mpPlayer;
@property (nonatomic, strong) BabatorViewController *babtorViewController;
@property (nonatomic) CGRect playerRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_mpPlayer) {
        _mpPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http:\/\/mediadownload.calcalist.co.il\/Calcalist_TV\/2015\/sony_xperia_z5.mp4?source=babator"]];
        _mpPlayer.moviePlayer.shouldAutoplay = YES;
        [_mpPlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        
        //If player is passed to the framework, you need to remove the observer.
        //If view controller is passed, the framework will remove the observer.
        [[NSNotificationCenter defaultCenter] removeObserver:self.mpPlayer
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:nil];
        [self presentMoviePlayerViewControllerAnimated:_mpPlayer];
        
        CGSize screen = self.view.frame.size;
        _playerRect = CGRectMake(0, 0, screen.width, screen.height);
        _babtorViewController = [[BabatorViewController alloc] initWithAPIKey:@"d035223d-8bba-40d2-bb13-5a22298250c6"];
        _babtorViewController.suggestionsSize = 10;
        
        //For better results, pageId should be unique per View (For example, it can be a category name)
        [_babtorViewController setPlayer:self.mpPlayer pageId:@"someId"];
        _babtorViewController.delegate = self;
    }
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

- (void)didSelectDone:(BabatorViewController *)contoller {
    [self.mpPlayer dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
