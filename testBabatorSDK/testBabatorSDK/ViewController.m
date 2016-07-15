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

#import <BabatorUI/BabatorUI.h>

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
    [self addChildViewController:self.mpPlayer];
    CGSize screen = self.view.frame.size;
    _playerRect = CGRectMake(0, 0, screen.width, screen.height);
    [self.view addSubview:_mpPlayer.view];
    _babtorViewController = [[BabatorViewController alloc] initWithAPIKey:@"d035223d-8bba-40d2-bb13-5a22298250c6"];
    _babtorViewController.suggestionsSize = 10;
    [_babtorViewController setPlayer:self.mpPlayer.moviePlayer pageId:@"someid"];
    _babtorViewController.delegate = self;
    [_babtorViewController loadBabatorRecommendationsInto:self];

}

- (void)viewWillDisappear:(BOOL)animated {
//    [_babtorViewController removeFromParentViewController];
    _babtorViewController = nil;
    [_mpPlayer.moviePlayer stop];
    [_mpPlayer removeFromParentViewController];
    [super viewWillDisappear:animated];
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
   //         _babtorViewController.view.hidden = NO;
        } else {
    //        _babtorViewController.view.hidden = YES;
            _mpPlayer.view.frame = (CGRect){CGPointZero, size};
        }
    } completion:nil];
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

#pragma mark BabatorViewControllerDelegate
- (void)controller:(BabatorViewController *)controller didSelectVideo:(id<BBVideoParams>)videoParams {
    [self replaceVideoAndPlay:videoParams.url];
}

@end
