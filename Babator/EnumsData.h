//
//  EnumsData.h
//  TrackYourCash
//
//  Created by Andrey Kulinskiy on 9/4/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ServerConnectioErrorType {
    TokenExpired,
    OperationNotPermitted,
    NoServerConnection,
    ServerError,
    SSLError,
    ClientError, //used in riskControl
    UnknownError
} ServerConnectioErrorType;


