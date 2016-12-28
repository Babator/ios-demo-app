//
//  AdsManager.h
//  BabatorUI
//
//  Created by Eliza Sapir on 25/10/2016.
//  Copyright © 2016 babatordemo. All rights reserved.
//

#pragma mark AdEventType

/**
 *  Different event types sent by the Ads Manager to its delegate.
 */
typedef NS_ENUM(NSInteger, AdEventType){
    /**
     *  Ad Loaded
     */
    bbAdEvent_LOADED,
    /**
     *  Ad Started
     */
    bbAdEvent_STARTED,
    /**
     *  Ad Skipped
     */
    bbAdEvent_SKIPPED,
    /**
     *  Ad Complete
     */
    bbAdEvent_COMPLETE
};

@protocol AdsManager <NSObject>
@optional
/**
 *  Called when there is an AdEvent.
 *
 *  @param adsManager the IMAAdsManager receiving the event
 *  @param event      the IMAAdEvent received
 */
- (void)adsManagerdidReceiveAdEvent:(AdEventType)event;

@end
