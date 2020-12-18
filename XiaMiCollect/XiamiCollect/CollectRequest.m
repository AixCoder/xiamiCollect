//
//  CollectRequest.m
//  XiamiCollect
//
//  Created by liuhongnian on 2020/12/8.
//

#import "CollectRequest.h"
#import "AFNetworking.h"

@implementation CollectRequest

- (void)requestWithCollectURL:(NSString *)collectURL
                          key:(NSString *)authKey
                      success:(void (^)(NSString * _Nonnull))success
                      failure:(void (^)(NSError * _Nonnull))failure
{
    /* Configure session, choose between:
       * defaultSessionConfiguration
       * ephemeralSessionConfiguration
       * backgroundSessionConfigurationWithIdentifier:
     And set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
 
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];

    /* Create the Request:
       My API (GET https://music.xiami.com/resource/collect/v2/detail/36244617/841057771/1556869819)
     */
    NSString *URL = [collectURL componentsSeparatedByString:@"?"].firstObject;
    NSString *auth_key = [collectURL componentsSeparatedByString:@"="].lastObject;
    NSDictionary* URLParams = @{
        @"auth_key": auth_key
    };
    
    NSURL *requestURL = NSURLByAppendingQueryParameters([NSURL URLWithString:URL], URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"GET";

    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            success(responseString);
            
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            failure(error);
        }
    }];
    [task resume];
    [session finishTasksAndInvalidate];
}

/*
 * Utils: Add this section before your class implementation
 */

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
*/
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
            [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
            [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
        ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
*/
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
        [URL absoluteString],
        NSStringFromQueryParameters(queryParameters)
    ];
    return [NSURL URLWithString:URLString];
}

- (void)testDownload
{
    
     AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
       
    // Create request
//     NSDictionary* URLParameters = @{
//         @"ccode":@"xiami__",
//         @"expire":@"86400",
//         @"duration":@"59",
//         @"psid":@"77472281ecffa0b5456f5e788d44935e",
//         @"ups_client_netip":@"null",
//         @"ups_ts":@"1607389914",
//         @"ups_userid":@"0",
//         @"utid":@"",
//         @"vid":@"1771162592",
//         @"fn":@"1771162592_1479870304103.m4a",
//         @"vkey":@"Bedd56251601ba407941196596ec9e27f",
//     };
    
     NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"http://s320.xiami.net/758/42758/527946/1771162592_3487351_h.mp3?ccode=xiami__&expire=86400&duration=59&psid=77472281ecffa0b5456f5e788d44935e&ups_client_netip=null&ups_ts=1607389914&ups_userid=0&utid=&vid=1771162592&fn=1771162592_3487351_h.mp3&vkey=B5bf18920b235ae68a5f26833aac9665f" parameters:nil error:NULL];

       
    NSURLSessionDownloadTask *_task=[session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

        //download progress
         NSLog(@"%@",downloadProgress);
           
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             
         }];
           
     } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

         //save path
         NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
           
         NSString *fileName = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
           
         return [NSURL fileURLWithPath:fileName];
           
     } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

         NSLog(@"download complete: %@",filePath);
     }];
    
    [_task resume];//start download task
}

@end
