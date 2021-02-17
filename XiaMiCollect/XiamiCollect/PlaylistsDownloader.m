//
//  PlaylistsDownloader.m
//  XiamiCollect
//
//  Created by liuhongnian on 2021/2/12.
//

#import "PlaylistsDownloader.h"
#import "SongDownloader.h"

#import "NSData+AixCategory.h"
#import "NSArray+AixCategory.h"
#import "NSDictionary+AixCategory.h"
#import "NSString+AixCategory.h"

#import <CommonCrypto/CommonHMAC.h>

@interface PlaylistsDownloader ()

@property (nonatomic, strong) PicDownloader *logoPicDownloader;
@property (nonatomic, strong) PicDownloader *authorAvatarDownloader;

@property (nonatomic, copy) void(^collectsDownloadCompletion)(void);


@property (nonatomic,copy) void(^allDownloadCompetion)(void);

@property (nonatomic, assign) int pagesCount;
@end

@implementation PlaylistsDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _logoPicDownloader = [[PicDownloader alloc] init];
        _authorAvatarDownloader = [[PicDownloader alloc] init];
    }
    return self;
}

- (void)startWithCompletion:(void (^)(void))downloadCompletion
                        tag:(NSString *)tagKey
                      order:(NSString *)orderType
{
    
    _allDownloadCompetion = downloadCompletion;

    [self requestCollectsWithTag:tagKey
                            page:1
                       orderType:orderType];
        
}

- (void)startDownloadCollectsByUser:(NSString *)userId
                         completion:(void (^)(void))completion
{
    
    _allDownloadCompetion = completion;
    [self getCollectsByUserID:userId page:1];
}

- (void)getCollectsByUserID:(NSString *)userId page:(int) page
{
    __weak typeof(self) weakSelf = self;

    if (page > 8) {
        NSLog(@"用户:%@所创建的歌单全部缓存完毕",userId);
        _allDownloadCompetion();
        return;
    }
    
    NSString *api = @"mtop.alimusic.music.list.collectservice.getcollectbyuser";
    
    NSDictionary *header = @{@"platformId": @"h5"};
    NSDictionary *model =  @{@"pagingVO":@{@"pageSize": @(100),
                                           @"page": @(page)},
                             @"userId": userId
    };
    
    [self sendRequestWithAPI:api
                      header:header
                       model:model
                     success:^(NSDictionary *resultData) {
        
        NSDictionary *data = [[resultData x_dictionaryValueForKey:@"data"] x_dictionaryValueForKey:@"data"];
        
        NSArray *collects = [data x_arrayValueForKey:@"collects"];
        
        weakSelf.pagesCount = [[[data x_dictionaryValueForKey:@"pagingVO"]
                                x_numberForKey:@"pages"] intValue] ;
        
        if (collects.count == 0 && weakSelf.pagesCount == page) {
            NSLog(@"用户创建歌单集合为空---不备份");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.allDownloadCompetion();
            });
            
        }else{
            
            weakSelf.collectsDownloadCompletion = ^{
                NSLog(@"用户--的%d张歌单备份完成", page * 100);
                int nextPage = page + 1;
            
                [weakSelf getCollectsByUserID:userId page:nextPage];
            };
            
            [weakSelf backupCollectsInfo:collects
                                 atIndex:0
                                     key:userId];
        }
        
    }
                     failure:^(NSError *error) {
        
        NSLog(@"获取第%d页推荐歌单失败------%@",page,error);
    }];
}


//    @"order":@"recommend" , hot , new
- (void)requestCollectsWithTag:(NSString *)tag
                         page:(int)page
                     orderType:(NSString *)order
{
    
    if(page > 1){
        
        NSLog(@"===============");
        NSLog(@"%@标签---600张热门歌单备份完成",tag);
            // 3.GCD
        __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.allDownloadCompetion();
            });
        return;
    }
    
    
    NSDictionary *header = @{@"platformId":@"mac",
//                             @"openId":@"36244617",
//                             @"accessToken":@"056688b9a35dfd32fc1cb031461f353e943i21",
                             @"network":@(1)
    };
    NSDictionary *model = @{@"key":tag,
                            @"limit":@(100),
                            @"order":order,
                            @"page":@(page)};
    
    __weak typeof(self) weakSelf = self;
    NSString *api = @"mtop.alimusic.music.list.collectservice.getcollects";
    [self sendRequestWithAPI:api
                      header:header
                       model:model
                     success:^(NSDictionary *resultData) {
        
        NSDictionary *data = [[resultData x_dictionaryValueForKey:@"data"] x_dictionaryValueForKey:@"data"];
        
        NSArray *collects = [data x_arrayValueForKey:@"collects"];
        weakSelf.pagesCount = [[[data x_dictionaryValueForKey:@"pagingVO"]
                                x_numberForKey:@"pages"] intValue] ;
        
        if (collects.count == 0 && weakSelf.pagesCount == page) {
            NSLog(@"热门歌单集合为空---不备份");
            NSLog(@"风格歌单总数不满1000，已经全部下载完成啦");
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.allDownloadCompetion();
            });
        }else{
            
            weakSelf.collectsDownloadCompletion = ^{
                NSLog(@"%@标签--%d张歌单备份完成",tag, page * 100);
                int nextPage = page + 1;
                [weakSelf requestCollectsWithTag:tag
                                            page:nextPage
                                       orderType:order];
            };
            
            [weakSelf backupCollectsInfo:collects
                                 atIndex:0
                                     key:tag];
        }
        
    }
                     failure:^(NSError *error) {
        
        NSLog(@"获取第%d页推荐歌单失败------%@",page,error);
    }];
    
    
}

- (void)backupCollectsInfo:(NSArray *)collects
                   atIndex:(NSInteger)index
                       key:(NSString *)key

{
    
    __weak typeof(self) weakSelf = self;
    if (index >= collects.count) {
        if (_collectsDownloadCompletion) {
            _collectsDownloadCompletion();
        }
        return;
    }
    
    //request collect detail
    NSString *listid = [[collects objectAtIndex:index] x_stringValueForKey:@"listId"];
    
    NSAssert(listid, @"要备份的歌单缺少id");
    
    NSDictionary *model = @{@"listId": listid,
                            @"isFullTags": [NSNumber numberWithBool:YES],
                            @"pagingVO":@{@"pageSize": @(2000),
                                          @"page": @(1)}};
    
    [self sendRequestWithAPI:@"mtop.alimusic.music.list.collectservice.getcollectdetail"
                      header:nil
                       model:model
                     success:^(NSDictionary *response) {
            
        //save collect detail info to json file
        NSDictionary *data = [[response x_dictionaryValueForKey:@"data"] x_dictionaryValueForKey:@"data"];
        NSDictionary *detail = [data x_dictionaryValueForKey:@"collectDetail"];
        
        int totalSongs = [detail x_numberForKey:@"songCount"].intValue;
        NSInteger songs = [detail x_arrayValueForKey:@"songs"].count;
        

        //ignore empty play list
        if (totalSongs < 5 || songs < 5) {
            NSLog(@"歌曲数太少--跳过，备份下一个歌单");
            NSInteger next = index + 1;
            [weakSelf backupCollectsInfo:collects
                                 atIndex:next
                                     key:key];
            
        }else{
            
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:response
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
            
            NSString *playlistid = [detail x_stringValueForKey:@"listId"];
            if ([playlistid isEqualToString:listid]) {
                
                if (totalSongs > 1000) {
                    NSLog(@"抓到一条大鱼 playlist: %@ 哈哈🐟",playlistid);
                }
#pragma mark 保存歌单详情json
//                ==save play list json
                NSString *listFileName = [NSString stringWithFormat:@"%@.json",playlistid];
                NSString *listRootPath = [@"/Users/liuhongnian/Desktop/待处理歌单/歌单分类" stringByAppendingPathComponent:key];
                
                NSString *JSONPath = [listRootPath stringByAppendingPathComponent:listFileName];
                
                if (![NSFileManager.defaultManager fileExistsAtPath:listRootPath]) {
                   BOOL created = [NSFileManager.defaultManager createDirectoryAtPath:listRootPath withIntermediateDirectories:YES attributes:nil error:NULL];
                    NSAssert(created, @"歌单baocun 文件夹创建失败");
                }
                BOOL saveCellectDetailSuccess = [data writeToFile:JSONPath
                                                       atomically:YES];
                
                if (!saveCellectDetailSuccess) {
                    NSLog(@"保存歌单详情json 文件失败");
                }
                
                
#pragma mark save collect logo pic
                {
                    
                    //downloader collect logo pic
                    NSString *logoUrl = [detail x_stringValueForKey:@"collectLogoLarge"];
                    if ([logoUrl isNotEmpty]) {
                        
                        NSString *collectSavePath = [listRootPath stringByAppendingPathComponent:@"image/collectCover"];
                        
                        if (![NSFileManager.defaultManager fileExistsAtPath:collectSavePath]) {
                           BOOL created = [NSFileManager.defaultManager createDirectoryAtPath:collectSavePath withIntermediateDirectories:YES attributes:nil error:NULL];
                            NSAssert(created, @"歌单封面文件夹创建失败");
                        }
                        
                        NSString *logoFileName = [NSString stringWithFormat:@"collectLogoL_%@",playlistid];
                        
                        [weakSelf.logoPicDownloader downloadWithURL:logoUrl localPath:collectSavePath picName:logoFileName success:^{
                            
                                            } failure:^(NSError * _Nonnull error) {
                                                NSLog(@"下载歌单%@封面失败啦",playlistid);
                                            }];
                    }else{
                        NSLog(@"歌单封面为空");
                    }
                    

                }
                
                
                
#pragma mark save author avatar view pic
                //保存创建者头像
                NSString *authorUrl = [detail x_stringValueForKey:@"authorAvatar"];
                
                NSString *authorSavePath = [listRootPath stringByAppendingPathComponent:@"image/authorAvatar"];
                
                if (![NSFileManager.defaultManager fileExistsAtPath:authorSavePath]) {
                    
                   BOOL created = [NSFileManager.defaultManager createDirectoryAtPath:authorSavePath withIntermediateDirectories:YES attributes:nil error:NULL];
                    NSAssert(created, @"头像文件夹创建失败");
                }
                
                NSString *uid = [detail x_stringValueForKey:@"userId"];
                NSString *authorPicName = [NSString stringWithFormat:@"authorAvatar_%@",uid];
                
                
                NSAssert(weakSelf.authorAvatarDownloader, @"");
                [weakSelf.authorAvatarDownloader downloadWithURL:authorUrl localPath:authorSavePath picName:authorPicName success:^{
                                        
                                    } failure:^(NSError * _Nonnull error) {
                                        NSLog(@"头像：%@ 下载失败",uid);
                                    }];
                
                        
#pragma mark download lrc file
                BOOL needLRC = NO;
//                if (needLRC) {
//
//                    for (NSDictionary *songObj in songs)
//                    {
//
//                        NSDictionary *lrcInfo = songObj[@"lyricInfo"];
//                        if (lrcInfo) {
//                            NSString *lyricFileURL =lrcInfo[@"lyricFile"];
//                            if (lyricFileURL != nil || [lyricFileURL isNotEmpty]) {
//                                [weakSelf addLRCFileToDownloadQuen:songObj];
//                            }
//                        }
//
//                    }
//                }
     
      
//                {"requestStr":"{\"header\":{\"platformId\":\"mac\",\"remoteIp\":\"192.168.2.1\",\"callId\":1612750587623,\"sign\":\"9542dca3b383caaa0075643e99d7848d\",\"appId\":200,\"deviceId\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\",\"accessToken\":\"3680110e80969af61e297b841d7c31e8943i21\",\"openId\":36244617,\"network\":1,\"appVersion\":3010300,\"resolution\":\"1178*704\",\"utdid\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\"},\"model\":{\"objectId\":7299,\"objectType\":\"artist\",\"pagingVO\":{\"page\":2,\"pageSize\":20}}}"}
                //getcommentlist
                
//                {\"objectId\":244377512,\"objectType\":\"collect\",\"pagingVO\":{\"page\":1,\"pageSize\":20}}
            
                
#pragma mark get comment lists
                //get comment list
                NSDictionary *model = @{@"objectId": playlistid,
                                        @"objectType":@"collect",
                                        @"pagingVO":@{@"page":@(1),
                                                      @"pageSize":@(200)
                                        }
                };
                NSString *api = @"mtop.alimusic.social.commentservice.getcommentlist";
                [weakSelf sendRequestWithAPI:api header:nil model:model success:^(NSDictionary *resultData) {
                    

                    NSString *commitFileName = [NSString stringWithFormat:@"comment_%@.json",playlistid];
                    
                    NSString *commitlistPath = [listRootPath stringByAppendingPathComponent:@"commentLists"];
                    
                    NSString *commentJSONPath = [commitlistPath stringByAppendingPathComponent:commitFileName];
                    
                    if (![NSFileManager.defaultManager fileExistsAtPath:commitlistPath]) {
                        BOOL created = [NSFileManager.defaultManager createDirectoryAtPath:commitlistPath withIntermediateDirectories:YES attributes:nil error:NULL];
                        NSAssert(created, @"歌单pinglun baocun 文件夹创建失败");
                    }
                    
                    NSData *commentData = [NSJSONSerialization dataWithJSONObject:resultData
                                                                          options:NSJSONWritingPrettyPrinted
                                                                            error:nil];
//                    commentVOList
                    NSArray *commentVO = [[[resultData x_dictionaryValueForKey:@"data"] x_dictionaryValueForKey:@"data"] x_arrayValueForKey:@"commentVOList"];
                    if (commentVO.count > 0) {
                        BOOL savecommentDetailSuccess = [commentData writeToFile:commentJSONPath
                                                                      atomically:YES];
                        if (!savecommentDetailSuccess) {
                            NSLog(@"保存歌单pinglun json 文件失败");
                        }
                    }

                    
                } failure:^(NSError *error) {
                                    
                    NSLog(@"get commentlist: %@ failured",playlistid);
                }];
   
                
                NSInteger nextCollectIndex = index + 1;
                [self backupCollectsInfo:collects
                                 atIndex:nextCollectIndex
                                     key:key];
                
            }

        }
        
        

        } failure:^(NSError *error) {
            
            NSLog(@"歌单详情获取失败: %@",error);
        }];
    
}

- (void)sendRequestWithAPI:(NSString *)api
                    header:(NSDictionary *)header
                     model:(NSDictionary*)model
                   success:(void(^)(NSDictionary *resultData))success
                   failure:(void(^)(NSError *error))failured
{
    
    if (header == nil) {
        header = @{@"platformId":@"mac"};
    }
    
    NSString *requestStr = @{@"header":header,
                             @"model":model}.toJsonString;
    NSDictionary *data = @{@"requestStr":requestStr};
    
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];

    
    //sigin --------request par created
    NSString *_m_h5_tk = @"09128781225eff63f91dabec93a3344f_1613571189114";
    NSString *_m_h5_tk_enc = @"388571ad1c71ddd084b6dd1fa408b1cf";
    
    NSString *token = [_m_h5_tk componentsSeparatedByString:@"_"].firstObject;
    NSString *t = @"1612763225000";
    NSString *appkey = @"12574478";
    
    NSString *dataString = data.toJsonString;
    
    NSString *sign_org = [NSString stringWithFormat:@"%@&%@&%@&%@",token,t,appkey,dataString];
    NSString *sign = [self hMacMD5String:sign_org];
        
    
    NSDictionary* URLParams = @{
        @"appKey": appkey,
        @"t": t,
        @"sign": sign,
        @"v": @"1.0",
        @"type": @"originaljson",
        @"dataType": @"json",
        @"api": api,
        @"data": dataString
    };
    
//https://h5api.m.xiami.com
//https://acs.m.xiami.com
//http://h5api.m.taobao.com
    NSString *apiPath = [NSString stringWithFormat:@"https://h5api.m.xiami.com/h5/%@/1.0/",api];
    NSURL* URL = [NSURL URLWithString:apiPath];
    
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";

    
    // Headers cookie values
    NSString *cookieString = [NSString stringWithFormat:@"xmgid=7515f88b-9f92-4136-a94b-8a9dc16f3df9;xm_oauth_state=d2865f94c017103a45b3b297e0924fc1;_m_h5_tk=%@;_m_h5_tk_enc=%@", _m_h5_tk, _m_h5_tk_enc];
    [request addValue:cookieString forHTTPHeaderField:@"Cookie"];

    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSError *errorJson;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&errorJson];
            
            NSString *ret = [json x_arrayValueForKey:@"ret"].firstObject;
            if ([ret isEqualToString:@"SUCCESS::调用成功"]) {
                
                success(json);
                
            }else {
                if ([ret isEqualToString:@"FAIL_SYS_TOKEN_EXOIRED::令牌过期"]) {
                    NSLog(@"fail sys token");
                    NSLog(@"response:%@",response);
                }
                NSLog(@"请求%@失败:%@",api, error);
                failured(nil);
            }

            
        }
        else {
            // Failure
            NSLog(@"请求%@失败:%@",api, error);
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
@end
