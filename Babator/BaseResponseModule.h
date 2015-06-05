//
//  BaseResponseModule.h
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 5/7/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponseModule : NSObject

@property (nonatomic, assign)NSInteger status;
@property (nonatomic, strong)NSArray* errors;

@end
