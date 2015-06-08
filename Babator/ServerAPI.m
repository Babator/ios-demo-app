//
//  ServerAPI.m
//  BCScheduling
//
//  Created by Andrey Kulinskiy on 4/10/14.
//  Copyright (c) 2014 Andrey Kulinskiy. All rights reserved.
//

#import "ServerAPI.h"
#import "HTTPClient.h"
#import "UserIDResponseModule.h"

@interface ServerAPI ()

@property (strong) HTTPClient *httpClientInstance;

@end

@implementation ServerAPI

-(void)setWebserviceURL:(NSString *)webserviceURL
{
    if(self.httpClientInstance)
        [self releaseOldHTTPClientInstance];
    [self createHTTPClientInstance:webserviceURL];
}

- (void)setToken:(NSString *)token
{
    [self.httpClientInstance setToken:token];
}

- (void) releaseToken
{
    [self.httpClientInstance setToken:nil];
}

-(void)releaseOldHTTPClientInstance
{
    
}

-(void)createHTTPClientInstance:(NSString *)webserviceURL
{
    NSURL *baseUrl = [NSURL URLWithString:webserviceURL];
    self.httpClientInstance = [[HTTPClient alloc] initWithBaseURL:baseUrl];
}

-(Error *)connectionErrorHandling:(AFHTTPRequestOperation *)operation
                               error:(NSError *)error
{
    NSString *message = [self getErrorMessage:operation error:error];
    ServerConnectioErrorType errorType = [self getErrorType:operation];
    Error * _error = [[Error alloc] initWithValues:message errorType:errorType];
    return _error;
}

-(NSString *)getErrorMessage:(AFHTTPRequestOperation *)operation
                       error:(NSError *)error
{
    if(!operation.response)
        return [NSString stringWithFormat:@"Server did not respond. Error: %@", error];
    
    if (operation.response.statusCode == 500)
    {
        return [NSString stringWithFormat:@"Error code: 500. Error: %@", error];
    }
    else
    {
        NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *errorMessage = nil;
        if (jsonData)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            errorMessage = [json objectForKey:@"error"];
        }
        
        NSString *errorText = [NSString stringWithFormat:@"Message: %@. Error: %@. Error code: %ld", errorMessage, error, (long)operation.response.statusCode];
        
        return errorText;
    }
}

-(ServerConnectioErrorType)getErrorType:(AFHTTPRequestOperation *)operation
{
    //400 - exception on Server in .NET
    //404 - no Server response
    
    if(!operation.response)
        return NoServerConnection;//"Server did not respond" - timeout
    
    NSInteger statusCode = operation.response.statusCode;
    
    //list of HTTP status codes
    if (statusCode == 500 || statusCode == 417 || statusCode == 400) //internal server error
        return ServerError;
    else if(statusCode == 406 || statusCode == 407) //proxy authentication requered
        return TokenExpired;
    else if(statusCode == 403) //SSL: The page you are trying to access is secured with Secure Sockets Layer (SSL).
        return SSLError;
    else if(statusCode == 405)//forbidden
        return OperationNotPermitted;
    //else if(statusCode == 400) //bad request
    //    return ClientError;
    else if(statusCode == 404) //server is not responded
        return NoServerConnection;
    else
        return UnknownError;
}

#pragma mark- Server API Methods
- (void)userIdForApiKey:(NSString *)apiKey
               success:(void (^)(UserIDResponseModule *request))successBlock
               failure:(FaultHandler)failureBlock {

    [self.httpClientInstance postPath:[NSString stringWithFormat:@"/user-api/%@", apiKey]
                           parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  //NSLog(@"%@",responseObject);
                                  UserIDResponseModule *response = [JsonConvertor userIDResponseModuleFromDictionary:(NSDictionary *)responseObject];
                                  
                                  self.httpClientInstance.apiKey = apiKey;
                                  self.httpClientInstance.userID = response.userID;
                                  
                                  successBlock(response);
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  self.httpClientInstance.token = nil;
                                  Error* _error = [self connectionErrorHandling: operation error:error];

                                  if (failureBlock)
                                      failureBlock(_error);
                              }];
}

- (void)firstVideoSuccess:(void (^)(VideoModule *request))successBlock
                  failure:(FaultHandler)failureBlock {
    
    id params = [NSDictionary dictionaryWithObjectsAndKeys: self.httpClientInstance.apiKey, @"apiKey", self.httpClientInstance.userID, @"userId", nil];
    
    [self.httpClientInstance postPath:[NSString stringWithFormat:@"/babator-api/%ld", (long)0]
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  //NSLog(@"%@", responseObject);
                                  VideoModule *response = [JsonConvertor firstVideoModuleModuleFromDictionary:(NSDictionary *)responseObject];
                                  successBlock(response);
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  self.httpClientInstance.token = nil;
                                  Error* _error = [self connectionErrorHandling: operation error:error];
                                  
                                  if (failureBlock)
                                      failureBlock(_error);
                              }];
}

- (void)videosForVideoID:(NSInteger)videoID
                 success:(void (^)(VideosModule *request))successBlock
                 failure:(FaultHandler)failureBlock {
    
    id params = [NSDictionary dictionaryWithObjectsAndKeys: self.httpClientInstance.apiKey, @"apiKey", self.httpClientInstance.userID, @"userId", nil];
    
    [self.httpClientInstance postPath:[NSString stringWithFormat:@"/babator-api/%ld", (long)videoID]
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  //NSLog(@"%@", responseObject);
                                  VideosModule *response = [JsonConvertor videosModuleModuleFromDictionary:(NSDictionary *)responseObject];
                                  successBlock(response);
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  self.httpClientInstance.token = nil;
                                  Error* _error = [self connectionErrorHandling: operation error:error];
                                  
                                  if (failureBlock)
                                      failureBlock(_error);
                              }];
}

//-(void)login:(LoginParams *)loginParams
//     success:(void (^)(LoginResult *loginResult))successBlock
//     failure:(FaultHandler)failureBlock
//{
//    id params = [JsonConvertor dictionaryFormLoginParams:loginParams];
//    id params = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:isShowPhone], @"show_phone", [NSNumber numberWithBool:isShowEmail], @"show_email", nil];
//    
//    self.httpClientInstance.token = nil;
//    
//    [self.httpClientInstance postPath:@"/api/user/login"
//                           parameters:params
//                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                  //NSLog(@"%@",responseObject);
//                                  LoginResult *loginResult = [JsonConvertor loginResultFromDictionary:(NSDictionary *)responseObject];
//                                  self.httpClientInstance.token = loginResult.token;
//                                  successBlock(loginResult);
//                              }
//                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                  self.httpClientInstance.token = nil;
//                                  Error* _error = [self connectionErrorHandling: operation error:error];
//                                  
//                                  if (failureBlock)
//                                      failureBlock(_error);
//                              }];
//}



@end



