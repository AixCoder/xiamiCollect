//
//  GenresWebController.m
//  XiamiCollect
//
//  Created by liuhongnian on 2021/2/4.
//

#import "GenresWebController.h"

#import <CommonCrypto/CommonHMAC.h>

#import "NSDictionary+AixCategory.h"

@interface GenresWebController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSMutableDictionary *cookieDic;

@end

@implementation GenresWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _cookieDic = [NSMutableDictionary dictionary];
    
    NSString *webUrl = @"https://www.xiami.com/genre/gid/5";
    _webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]];
    [_webView loadRequest:request];
    
}

- (void)startSaveStyleContent:(NSArray *)styleList
                      atIndex:(NSInteger)styleDownloadIndex
{
    
    if (styleDownloadIndex >= styleList.count) {
        //风格全部抓取完毕
    }else{
        //1. save genreal  description json
        NSDictionary *style = styleList[styleDownloadIndex];
        NSString *style_title = [style x_stringValueForKey:@"title"];
        
        NSString *styleFolderPath = [@"/Users/liuhongnian/Desktop/虾米曲库" stringByAppendingPathComponent:style_title];

        //creat style folder
        BOOL isExists = [NSFileManager.defaultManager fileExistsAtPath:styleFolderPath isDirectory:nil];
        if (!isExists) {
            BOOL creatSuccess = [NSFileManager.defaultManager createDirectoryAtPath:styleFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSAssert(creatSuccess, @"创建风格目录失败");
        }
        
        
        //获取风格介绍
        NSString *styleID = [style x_stringValueForKey:@"id"];
        NSString *type = [style x_stringValueForKey:@"type"];
        [self getGenreDetail:styleID
                        type:type
                     success:^(NSDictionary *response) {
            
            //2.保存风格介绍json
            NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *styleJSONFile = [NSString stringWithFormat:@"style_%@.json",style_title];
            
            NSString *styleJSONPath = [styleFolderPath stringByAppendingPathComponent:styleJSONFile];
            BOOL saveStyleDetailSuccess = [data writeToFile:styleJSONPath atomically:YES];
            if (!saveStyleDetailSuccess) {
                NSLog(@"保存风格介绍json 文件失败");
            }
            
        }
                     failure:^(NSError *error) {
                
        }];
        
    }
    
            //2.下载风格热门歌单
    
    
//    /Users/liuhongnian/Desktop/虾米曲库

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //get cookie
    NSArray *Cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    NSString *xm_sg_tk;
    
    [_cookieDic removeAllObjects];
    
    for (NSHTTPCookie *subCookie in Cookies) {
        if ([subCookie isKindOfClass:[NSHTTPCookie class]]) {
            
            if ([subCookie.name isEqualToString:@"xm_sg_tk"]) {
                NSArray *xm_sgArray = [subCookie.value componentsSeparatedByString:@"_"];
                NSAssert(xm_sgArray.count == 2, @"xm_sg must have tk");
                xm_sg_tk = xm_sgArray.firstObject;
            }
            
            if ([subCookie.domain containsString:@".xiami.com"]) {
                _cookieDic[subCookie.name] = subCookie.value;
            }
        }
    }
    
    if (xm_sg_tk == nil) {
        NSLog(@"empty xm sg tk");
        return;
    }else{
        //save xm_sg_tk
        [[NSUserDefaults standardUserDefaults] setObject:xm_sg_tk forKey:@"xm_sg_tk"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"nice ready");
        
        //set cookie value string
        
        //读取jazz所有风格
        __weak typeof(self) weakSelf = self;
        
        static dispatch_once_t disOnce;
        dispatch_once(&disOnce, ^{
            
            // 获取文件路径
             NSString *path = [[NSBundle mainBundle] pathForResource:@"Genres" ofType:@"json"];
             // 将文件数据化
             NSData *data = [[NSData alloc] initWithContentsOfFile:path];
             // 对数据进行JSON格式化并返回字典形式
            NSDictionary *genres = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            
            NSArray *allGenres = genres[@"result"][@"data"][@"genres"];
            for (NSDictionary *genre in allGenres) {
                
                NSString *genre_title = genre[@"title"];
                if ([genre_title isEqualToString:@"爵士"]) {
                    
                    NSArray *styleList = genre[@"styleList"];
                    [weakSelf startSaveStyleContent:styleList atIndex:0];
                    
                }
            }
        });
        
    }
    
}


- (void)saveStyleRelationship:(NSDictionary *)style
{
    //detail
    
}
//tools
- (NSString *)hMacMD5String:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}


//- (void)sendRequest:(NSString *)cookieValuesString
//{
//    /* Configure session, choose between:
//       * defaultSessionConfiguration
//       * ephemeralSessionConfiguration
//       * backgroundSessionConfigurationWithIdentifier:
//     And set session-wide properties, such as: HTTPAdditionalHeaders,
//     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
//     */
//    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//    /* Create session, and optionally set a NSURLSessionDelegate. */
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
//
//    /* Create the Request:
//       My API (GET https://www.xiami.com/api/genre/getGenreDetail)
//     */
//
//    //风格关联---歌单-----艺人
////    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreRelations"];
////    NSDictionary* URLParams = @{
////        @"_q": @"{\"genreId\":\"846\",\"type\":2}",
////        @"_s": @"050081505635515366d280208399c735",
////    };
////    URL = NSURLByAppendingQueryParameters(URL, URLParams);
////    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
////    request.HTTPMethod = @"GET";
//
//
//    //风格热门歌单
////    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreCollects"];
////    NSDictionary* URLParams = @{
////        @"_q": @"{\"id\":\"846\",\"type\":2,\"orderBy\":1,\"pagingVO\":{\"page\":1,\"pageSize\":30}}",
////        @"_s": @"6f6bb837f1fafbc30fa8afded1849fb3",
////    };
//
////    NSDictionary *genreDic = @{@"genreId": @"846",
////                               @"type": @"2"};
////    NSDictionary *genreDic = @{@"id":@"846",
////                               @"type":@"2",
////                               @"orderBy":@"1",
////                               @"pagingVO":@{@"page":@"1",
////                                             @"pageSize":@"30"}
////    };
//
//
////    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/collect/getCollectStaticUrl"];
////    NSDictionary* URLParams = @{
////        @"_q": @"{\"listId\":22255265}",
////        @"_s": @"39beb1b840874e11a2ef2b2aea1c4db8",
////    };
//
//    NSDictionary *genreDic = @{@"listId":@"22255265"};
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:genreDic options:NSJSONWritingPrettyPrinted error:&error];
//
//    NSString *jsonString;
//     if (!jsonData) {
//         NSLog(@"%@",error);
//         return;
//     } else {
//         jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//     }
//
//
//    NSMutableString *_q = [NSMutableString stringWithString:jsonString];
//    NSRange range = {0,_q.length};
//    //去掉字符串中的空格
//    [_q replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//    NSRange range2 = {0,_q.length};
//    //去掉字符串中的换行符
//    [_q replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
//
//    NSString *xm_sg_tk = [[NSUserDefaults standardUserDefaults] objectForKey:@"xm_sg_tk"];
////    data = xm_sg_tk + "_xmMain_" + api + "_" + _q
////    NSString *api = @"/api/genre/getGenreRelations";
//    NSString *api = @"/api/collect/getCollectStaticUrl";
//    NSString *_s = [NSString stringWithFormat:@"%@_xmMain_%@_%@",xm_sg_tk,api,_q];
//    NSString *_s_md5 = [self hMacMD5String:_s];
//
//    NSDictionary* URLParams = @{
//        @"_q": _q,
//        @"_s": _s_md5,
//    };
//
//    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/collect/getCollectStaticUrl"];
//    URL = NSURLByAppendingQueryParameters(URL, URLParams);
//
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"GET";
//
//    // Headers
//    NSMutableString *cookieValuesString = [NSMutableString stringWithString:@""];
//    for (NSString *key in self.cookieDic) {
//         NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [self.cookieDic valueForKey:key]];
//         [cookieValuesString appendString:appendString];
//     }
//    [request addValue:cookieValuesString forHTTPHeaderField:@"Cookie"];
//
//    /* Start a new Task */
//    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error == nil) {
//            // Success
//            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
//
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             NSLog(@"\n data = %@\n ---------\n  ,str2 = %@ \n ",data,responseString );
//        }
//        else {
//            // Failure
//            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
//        }
//    }];
//
//
//    [task resume];
//    [session finishTasksAndInvalidate];
//}

- (void)requestCollectWithUrl
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

    NSURL* URL = [NSURL URLWithString:@"https://music.xiami.com/resource/collect/v2/detail/6123089/22255265/1561012796"];
    NSDictionary* URLParams = @{
        @"auth_key": @"1612507510827-0-0-62dd2b66eefc01222c8d76aab38f3fb0",
    };
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";

    // Headers
//    [request addValue:@"xmgid=809a43c2-c500-4355-95da-11774ee0c60d; xm_sg_tk=df377198d6d389def47c6e7eacfaeea5_1612411681159; xm_sg_tk.sig=e8IAaoiOIdAbMlZelwFTmlgUGvM2VN_Nz7Vta07yrtA" forHTTPHeaderField:@"Cookie"];
//    [request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];

    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"歌单：%@",responseString);

        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
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


#pragma mark API

- (void)getGenreDetail:(NSString *)genreid
                  type:(NSString *)type
               success:(void(^)(NSDictionary *response))success
               failure:(void(^)(NSError *error))failured {
    
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

    //风格关联---歌单-----艺人
//    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreRelations"];
//    NSDictionary* URLParams = @{
//        @"_q": @"{\"genreId\":\"846\",\"type\":2}",
//        @"_s": @"050081505635515366d280208399c735",
//    };
//    URL = NSURLByAppendingQueryParameters(URL, URLParams);
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"GET";
    

    //风格热门歌单
//    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreCollects"];

//    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/collect/getCollectStaticUrl"];
//    NSDictionary* URLParams = @{
//        @"_q": @"{\"listId\":22255265}",
//        @"_s": @"39beb1b840874e11a2ef2b2aea1c4db8",
//    };
    
    
    NSDictionary *genreDic = @{@"genreId":genreid,
                               @"type":type};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:genreDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
     if (!jsonData) {
         NSLog(@"%@",error);
         failured(error);
         
     } else {
         jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
     }
    
    
    NSMutableString *_q = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,_q.length};
    //去掉字符串中的空格
    [_q replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,_q.length};
    //去掉字符串中的换行符
    [_q replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSString *xm_sg_tk = [[NSUserDefaults standardUserDefaults] objectForKey:@"xm_sg_tk"];
//    data = xm_sg_tk + "_xmMain_" + api + "_" + _q
    NSString *api = @"/api/genre/getGenreDetail";
    
    NSString *par = [NSString stringWithFormat:@"%@_xmMain_%@_%@",xm_sg_tk,api,_q];
    NSString *_s = [self hMacMD5String:par];

    NSDictionary* URLParams = @{
        @"_q": _q,
        @"_s": _s,
    };
    
    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreDetail"];
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    //拼接cookie
    NSMutableString *cookieValuesString = [NSMutableString stringWithFormat:@""];
    for (NSString *key in self.cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [self.cookieDic valueForKey:key]];
        [cookieValuesString appendString:appendString];
    }
    // Headers set cookie
    [request addValue:cookieValuesString forHTTPHeaderField:@"Cookie"];

    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSError *errorJson;
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&errorJson];
            
            if ([[[json x_dictionaryValueForKey:@"result"] x_stringValueForKey:@"status"] isEqualToString:@"SUCCESS"]) {
                success(json);
            }else{
                NSLog(@"获取风格介绍信息失败");
            }
            
        }
        else {
            // Failure
            NSLog(@"获取风格介绍信息失败");
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}

@end
