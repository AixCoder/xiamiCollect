//
//  GenresWebController.m
//  XiamiCollect
//
//  Created by liuhongnian on 2021/2/4.
//

#import "GenresWebController.h"

#import <CommonCrypto/CommonHMAC.h>

#import "NSDictionary+AixCategory.h"
#import "NSArray+AixCategory.h"
#import "SongDownloader.h"
#import "NSString+AixCategory.h"

@interface GenresWebController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSMutableDictionary *cookieDic;

@property (nonatomic , copy) void(^styleCollectCompletion)(void);

@property (nonatomic, strong) UIButton *recommendedBtn;
@property (nonatomic, strong) UIButton *downloadRecommendBtn;

@property (nonatomic, strong) PicDownloader *logoPicDownloader;
@property (nonatomic, strong) PicDownloader *authorAvatarDownloader;
//lyricInfo
@property (nonatomic, strong) LyricDownloader *lrcDownloader;

@property (nonatomic, strong) NSMutableArray *lrcFilesURLArr;
@property (nonatomic, assign) NSInteger lrcDownloadIndex;

@property (nonatomic, copy) void(^collectsDownloadCompletion)(void);

@end

@implementation GenresWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _lrcFilesURLArr = [NSMutableArray array];
    _lrcDownloadIndex = 0;
    
    _cookieDic = [NSMutableDictionary dictionary];
    
    
    _recommendedBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 60, 40)];
    [_recommendedBtn setTitle:@"recommend"
                     forState:UIControlStateNormal];
    [_recommendedBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_recommendedBtn addTarget:self
                        action:@selector(recommendBtnTapped)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recommendedBtn];
    
//    _downloadRecommendBtn
    
    self.logoPicDownloader = [[PicDownloader alloc] init];
    self.lrcDownloader = [[LyricDownloader alloc] init];
    self.authorAvatarDownloader = [[PicDownloader alloc] init];
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *rootPath = @"/Users/liuhongnian/Desktop/待处理歌单/AI推荐/commentLists";
//    NSArray *fileDirectoryNames = [fileManager contentsOfDirectoryAtPath:rootPath
//                                                                   error:NULL];
//
//
//    NSString *jsonName;
//    for (NSString *subFileName in [fileManager contentsOfDirectoryAtPath:rootPath error:NULL]) {
//
//        if ([subFileName hasSuffix:@".json"]) {
//            jsonName = subFileName;
//
//            NSString *collectJSONPath = [rootPath stringByAppendingPathComponent:jsonName];
//
//            NSData *collectData = [fileManager contentsAtPath:collectJSONPath];
//
//
//            NSDictionary *collectObj = [NSJSONSerialization JSONObjectWithData:collectData options:NSJSONReadingMutableContainers error:NULL];
//
//            NSMutableDictionary *collectMutable = [collectObj mutableCopy];
//            NSArray *commentList = [collectMutable[@"data"][@"data"] x_arrayValueForKey:@"commentVOList"];
//
//            for (NSDictionary *obj in commentList) {
//                //net easy list name
//                NSString *comment = obj[@"message"];
//
//                if ([comment containsString:@"音乐是咖啡绝对的灵魂伴侣～"]) {
//                    NSLog(@"yyeyeyye");
//                }
//
//            }
//        }
//    }
    
}

- (void)recommendBtnTapped {
//    [self requestRecommendCollectWithTag:@"华语"
//                                    page:1];
    

//    {\"objectId\":7299,\"objectType\":\"artist\",\"pagingVO\":{\"page\":2,\"pageSize\":20}}
    
//    NSDictionary *model = @{@"objectId":@(7299)}
//    self sendRequestWithAPI:@"mtop.alimusic.social.commentservice.getcommentlist" model:<#(NSDictionary *)#> success:<#^(NSDictionary *resultData)success#> failure:<#^(NSError *error)failured#>
    
//    {\"unlike\":\"\",\"context\":\"\",\"like\":\"\",\"listen\":\"\"}
//    NSDictionary *model = @{@"unlike":@"",
//                            @"context":@"",
//                            @"like":@"",
//                            @"listen":@""};
    
//    {"requestStr":"{\"header\":{\"platformId\":\"mac\",\"remoteIp\":\"192.168.2.1\",\"callId\":1612831896171,\"sign\":\"8d1d1e60de57a0fc22ef3b82a560434e\",\"appId\":200,\"deviceId\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\",\"accessToken\":\"3680110e80969af61e297b841d7c31e8943i21\",\"openId\":36244617,\"network\":1,\"appVersion\":3010300,\"resolution\":\"1178*704\",\"utdid\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\"},\"model\":{\"key\":\"\",\"limit\":50,\"order\":\"recommend\",\"page\":1}}"}
    
    
//        [self requestRecommendCollectWithTag:@"轻音乐"
//                                        page:2];
    
    
    
    
    [self requestRecommendCollectWithTag:@"英伦"
                                    page:2];
//
    [self requestRecommendCollectWithTag:@"舞曲"
                                    page:2];

    [self requestRecommendCollectWithTag:@"后摇"
                                    page:2];


    
//    [self requestRecommendCollectWithTag:@"数摇" page:2];
    
}

//- (void)requestHotCollects:(int)page {
//
//    NSDictionary *model = @{@"key":@"爵士",
//                            @"limit":@(100),
//                            @"order":@"recommend",
//                            @"page":@(page)};
//
//    NSString *api = @"mtop.alimusic.music.list.collectservice.getcollects";
//
//    __weak typeof(self) weakSelf = self;
//    [self sendRequestWithAPI:api
//                       model:model
//                     success:^(NSDictionary *resultData) {
//
//        NSDictionary *data = [[resultData x_dictionaryValueForKey:@"data"] x_dictionaryValueForKey:@"data"];
//
//        NSArray *collects = [data x_arrayValueForKey:@"collects"];
//
//        if (collects.count == 0) {
//            NSLog(@"热门歌单集合为空---不备份");
//        }
//
//        [weakSelf backupCollectsInfo:collects
//                             atIndex:0];
//
//    }
//
//                     failure:^(NSError *error) {
//
//        NSLog(@"获取第%d页推荐歌单失败------%@",page,error);
//
//    }];
//
//}

- (void)requestRecommendCollectWithTag:(NSString *)tag page:(int)page
{
    
    if(page > 10){
        NSLog(@"===============");
        NSLog(@"%@---1000张歌单下载完成",tag);
        return;
    }
    
    
    NSString *api = @"mtop.alimusic.music.list.collectservice.getcollects";
    
    //虾米AI最后推荐
    NSDictionary *header = @{@"platformId":@"mac",
//                             @"openId":@"36244617",
//                             @"accessToken":@"3680110e80969af61e297b841d7c31e8943i21",
                             @"network":@(1)
    };
    NSDictionary *model = @{@"key":tag,
                            @"limit":@(100),
                            @"order":@"recommend",
                            @"page":@(page)};
    
    
    __weak typeof(self) weakSelf = self;
    [self sendRequestWithAPI:api header:header
                       model:model
                     success:^(NSDictionary *resultData) {
        
        NSDictionary *data = [[resultData x_dictionaryValueForKey:@"data"] x_dictionaryValueForKey:@"data"];
        
        NSArray *collects = [data x_arrayValueForKey:@"collects"];
        
        if (collects.count == 0) {
            NSLog(@"热门歌单集合为空---不备份");
        }else{
            
            [weakSelf backupCollectsInfo:collects
                                 atIndex:0
                                     key:tag];
            
            weakSelf.collectsDownloadCompletion = ^{
                int nextPage = page + 1;
                [weakSelf requestRecommendCollectWithTag:tag
                                                    page:nextPage];
            };
        }
        
    }
                     failure:^(NSError *error) {

        NSLog(@"获取第%d页推荐歌单失败------%@",page,error);
        
    }];
    
    
}


- (void)backupCollectsInfo:(NSArray *)collects atIndex:(NSInteger)index key:(NSString *)key
{
    
    __weak typeof(self) weakSelf = self;
    
    if (index >= collects.count) {
        NSLog(@"%lu个歌单信息保存完毕", (unsigned long)collects.count);
        if (_collectsDownloadCompletion) {
            _collectsDownloadCompletion();
        }
        return;
    }
    
    
    //request collect detail
    NSString *listid = [[collects objectAtIndex:index] x_stringValueForKey:@"listId"];
    
    NSDictionary *model = @{@"listId": listid,
                            @"isFullTags": [NSNumber numberWithBool:YES],
                            @"pagingVO":@{@"pageSize": @(1000),
                                          @"page": @(1)}};
    
    [self sendRequestWithAPI:@"mtop.alimusic.music.list.collectservice.getcollectdetail" header:nil model:model success:^(NSDictionary *response) {
            
        //save collect detail info to json file
        NSDictionary *data = [[response x_dictionaryValueForKey:@"data"] x_dictionaryValueForKey:@"data"];
        
        NSDictionary *detail = [data x_dictionaryValueForKey:@"collectDetail"];
        NSArray *songs = [detail x_arrayValueForKey:@"songs"];
        
        int totalSongs = [detail x_numberForKey:@"songCount"].intValue;
        
        //ignore empty play list
        if (songs.count < 3 ) {
            NSLog(@"歌曲数太少，备份下一个歌单");
            NSInteger next = index + 1;
            [weakSelf backupCollectsInfo:collects atIndex:next key:key];
            
        }else{
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:response
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
            
            NSString *playlistid = [detail x_stringValueForKey:@"listId"];
            if ([playlistid isEqualToString:listid]) {
                
#pragma mark 保存歌单详情json
//                ==save play list json
                NSString *listFileName = [NSString stringWithFormat:@"%@.json",playlistid];
                NSString *listRootPath = [@"/Users/liuhongnian/Desktop/待处理歌单" stringByAppendingPathComponent:key];
                
                
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
                        NSLog(@"👥头像为空");
                    }
                    

                }
                
                
//                if (totalSongs > 100) {
//                    NSLog(@"抓到一条大鱼 哈哈🐟");
//                }

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
                
                [weakSelf.authorAvatarDownloader downloadWithURL:authorUrl localPath:authorSavePath picName:authorPicName success:^{
                                        
                                    } failure:^(NSError * _Nonnull error) {
                                        NSLog(@"头像：%@ 下载失败",uid);
                                    }];
                
                        
#pragma mark download lrc file
                BOOL needLRC = NO;
                if (needLRC) {
                    
                    for (NSDictionary *songObj in songs)
                    {
                        
                        NSDictionary *lrcInfo = songObj[@"lyricInfo"];
                        if (lrcInfo) {
                            NSString *lyricFileURL =lrcInfo[@"lyricFile"];
                            if (lyricFileURL != nil || [lyricFileURL isNotEmpty]) {
                                [weakSelf addLRCFileToDownloadQuen:songObj];
                            }
                        }
                        
                    }
                }
     
      
//                {"requestStr":"{\"header\":{\"platformId\":\"mac\",\"remoteIp\":\"192.168.2.1\",\"callId\":1612750587623,\"sign\":\"9542dca3b383caaa0075643e99d7848d\",\"appId\":200,\"deviceId\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\",\"accessToken\":\"3680110e80969af61e297b841d7c31e8943i21\",\"openId\":36244617,\"network\":1,\"appVersion\":3010300,\"resolution\":\"1178*704\",\"utdid\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\"},\"model\":{\"objectId\":7299,\"objectType\":\"artist\",\"pagingVO\":{\"page\":2,\"pageSize\":20}}}"}
                //getcommentlist
                
//                {\"objectId\":244377512,\"objectType\":\"collect\",\"pagingVO\":{\"page\":1,\"pageSize\":20}}
            
                
                NSDictionary *model = @{@"objectId": playlistid,
                                        @"objectType":@"collect",
                                        @"pagingVO":@{@"page":@(1),
                                                      @"pageSize":@(100)
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
                    
                    BOOL savecommentDetailSuccess = [commentData writeToFile:commentJSONPath
                                                                  atomically:YES];
                    if (!savecommentDetailSuccess) {
                        NSLog(@"保存歌单pinglun json 文件失败");
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
    NSString *_m_h5_tk = @"80c24681934ea86bfc645a703e64f8f5_1612867710275";
    NSString *_m_h5_tk_enc = @"705c0c1fbadfbf5b4a9eb31b6bfd2974";
    
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
    
    NSString *apiPath = [NSString stringWithFormat:@"https://acs.m.xiami.com/h5/%@/1.0/",api];
    NSURL* URL = [NSURL URLWithString:apiPath];
    
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";

    
    // Headers cookie values
    NSString *cookieString = [NSString stringWithFormat:@"xmgid=2cf10f00-375a-41b9-bdd9-ae42e9c7e10c;xm_oauth_state=d2865f94c017103a45b3b297e0924fc1;_m_h5_tk=%@;_m_h5_tk_enc=%@", _m_h5_tk, _m_h5_tk_enc];
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

- (void)testfavoriteCollects {
    
//    {"requestStr":"{\"header\":{\"platformId\":\"mac\",\"remoteIp\":\"192.168.2.1\",\"callId\":1612758488363,\"sign\":\"5a2519b9271f67d159b06f92b1d7b12f\",\"appId\":200,\"deviceId\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\",\"accessToken\":\"3680110e80969af61e297b841d7c31e8943i21\",\"openId\":36244617,\"network\":1,\"appVersion\":3010300,\"resolution\":\"1178*704\",\"utdid\":\"b2dd9481a676a0449898aa1c3e151d0fd60e59290db44584961a2b67929fcc52\"},\"model\":{\"userId\":36244617,\"pagingVO\":{\"page\":1,\"pageSize\":100}}}"}
    
//    2871
//    2871
    NSDictionary *header = @{@"platformId":@"mac"};
    
    NSDictionary *model = @{
        @"userId":@(2871),
        @"pagingVO":@{@"page":@(1),
                      @"pageSize":@(100)}
    };
    
    
    NSString *requestStr = @{@"header":header,
                          @"model":model}.toJsonString;
    
    NSDictionary *request_dic = @{@"requestStr":requestStr};
    [self favoriteCollectsRequest:request_dic];
    
}

- (void)favoriteCollectsRequest:(NSDictionary *)requestStrDic
{
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];

    
    NSURL* URL = [NSURL URLWithString:@"https://acs.m.xiami.com/h5/mtop.alimusic.fav.collectfavoriteservice.getfavoritecollects/1.0/"];
    
    NSString *_m_h5_tk = @"ba797ddff5a9fadf09e936b36b6fe076_1612763016816";
    
    NSString *token = [_m_h5_tk componentsSeparatedByString:@"_"].firstObject;
    NSString *t = @"1612758488370";
    NSString *appkey = @"12574478";
    NSString *requestString = requestStrDic.toJsonString;
    
    NSString *sign_org = [NSString stringWithFormat:@"%@&%@&%@&%@",token,t,appkey,requestString];
    //sigin
    NSString *sign = [self hMacMD5String:sign_org];
        
    NSDictionary* URLParams = @{
        @"appKey": appkey,
        @"t": t,
        @"sign": sign,
        @"v": @"1.0",
        @"type": @"originaljson",
        @"dataType": @"json",
        @"api": @"mtop.alimusic.fav.collectfavoriteservice.getfavoritecollects",
        @"data": requestString
    };
    
    
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";

    
    // Headers
    [request addValue:@"xmgid=2cf10f00-375a-41b9-bdd9-ae42e9c7e10c;xm_oauth_state=d2865f94c017103a45b3b297e0924fc1;_m_h5_tk=ba797ddff5a9fadf09e936b36b6fe076_1612763016816;_m_h5_tk_enc=e82ed0f272ed659c4effdfc3afc02b1c"
   forHTTPHeaderField:@"Cookie"];

    return;
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"获取用户歌单: %@",responseString);
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
    [session finishTasksAndInvalidate];

}

- (void)injected
{
    [self requestRecommendCollectWithTag:@"失恋"
                                    page:2];
}


- (void)startSaveStyleContent:(NSArray *)styleList
                      atIndex:(NSInteger)styleDownloadIndex;
{
//    16
    //jueshi liupai yijign xiazai  dao  di 16 la
    
    if (styleDownloadIndex >= styleList.count) {
        //风格全部抓取完毕
        NSLog(@"style all collects xia zai wan bi");
        
    }else{
        //1. save genreal  description json
        NSDictionary *style = styleList[styleDownloadIndex];
        NSString *style_title = [style x_stringValueForKey:@"title"];
        
        NSString *styleFolderPath = [@"/Users/liuhongnian/Desktop/虾米曲库" stringByAppendingPathComponent:style_title];

        //creat style folder
        BOOL isExists = [NSFileManager.defaultManager fileExistsAtPath:styleFolderPath isDirectory:nil];
//        if (!isExists) {
//            BOOL creatSuccess = [NSFileManager.defaultManager createDirectoryAtPath:styleFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
//            NSAssert(creatSuccess, @"创建风格目录失败");
//        }
        
        
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
        
        
        
        //2.下载风格热门歌单
        __weak typeof(self) weakSelf = self;
        //2.1 qing qiu xiang guan gedan
        [self getGenreCollectsWithStyleID:styleID
                                     type:type
                                 pageSize:@"100"
                                  Success:^(NSArray *collectsArray) {
                    
            [weakSelf downloadCollects:collectsArray
                                  path:styleFolderPath
                               atIndex:0
                            completion:^{}];
            
            weakSelf.styleCollectCompletion = ^{
                NSInteger nextStyleIndex = styleDownloadIndex + 1;
                [weakSelf startSaveStyleContent:styleList
                                        atIndex:nextStyleIndex];
                
            };
            
            
                } failured:^(NSError *error) {
                    
                    
                }];
        
        
        
        //3.0 re men yi ren
        [self getGenreHotArtistList:styleID type:type success:^(NSArray *aritstCards) {
                   
            [weakSelf downloadArtistDetail:aritstCards
                                    toPath:styleFolderPath
                                   atIndex:0];
            
                } failure:^(NSError *error) {
                    
                }];
        
        
    }
    

}



- (void)downloadArtistDetail:(NSArray *)artistItems
                      toPath:(NSString *)downloadPath
                     atIndex:(NSInteger )artistDownloadIndex
{
    //request artist detail
    if (artistDownloadIndex >= artistItems.count) {
        
        NSLog(@"hot artist finished download");
        
    }else{
        
        NSString *artist = [artistItems[artistDownloadIndex] x_stringValueForKey:@"stringId"];
        
        __weak typeof(self) weakSelf = self;

        [self getArtistInfo:artist Success:^(NSDictionary *artistResult) {
            
            //save hot artist info
            NSData *data = [NSJSONSerialization dataWithJSONObject:artistResult options:NSJSONWritingPrettyPrinted error:nil];
            
//            artistName
            NSDictionary *resultObj = [artistResult x_dictionaryValueForKey:@"result"];
            
            
            NSDictionary *resultdata = [resultObj x_dictionaryValueForKey:@"data"];
            
            NSDictionary *detail = [resultdata x_dictionaryValueForKey:@"artistDetail"];
            
            NSString *artistName = [detail x_stringValueForKey:@"artistName"];
            NSString *collectJSONFile = [NSString stringWithFormat:@"artist__%@.json",artistName];
            
            NSString *styleJSONPath = [downloadPath stringByAppendingPathComponent:collectJSONFile];
            BOOL saveCollectSuccess = [data writeToFile:styleJSONPath atomically:YES];
            if (!saveCollectSuccess) {
                NSLog(@"保存艺人介绍json 文件失败");
            }
            
            NSInteger next = artistDownloadIndex + 1;
            [weakSelf downloadArtistDetail:artistItems
                                    toPath:downloadPath
                                   atIndex:next];
                    
                } failured:^(NSError *error) {
                   
                    NSInteger next = artistDownloadIndex + 1;
                    [weakSelf downloadArtistDetail:artistItems
                                            toPath:downloadPath
                                           atIndex:next];
                }];
    }
}

- (void)downloadCollects:(NSArray *)collects
                    path:(NSString *)downloadPath
                 atIndex:(NSInteger)collectDownloadIndex
              completion:(void(^)(void))downloadCollectsFinished
{
    if (collectDownloadIndex >= collects.count) {
        //歌单下载完毕啦
        NSLog(@"re men ge dan xia zai wanbi");
        if (_styleCollectCompletion) {
            _styleCollectCompletion();
        }
        
    }else{
        //1 获取歌单静态🔗
        NSString *list_id = [collects[collectDownloadIndex] x_stringValueForKey:@"listId"];
        
        __weak typeof(self) weakSelf = self;

        [self getCollectStaticUrl:list_id success:^(NSString *url) {
            
            //2 请求歌单详细数据
            [weakSelf getCollectDetailWithUrl:url success:^(NSDictionary *collectResult) {
                
                //save collect detail json
                //2.保存风格介绍json
                NSData *data = [NSJSONSerialization dataWithJSONObject:collectResult options:NSJSONWritingPrettyPrinted error:nil];
                
                NSDictionary *resultObj = [collectResult x_dictionaryValueForKey:@"resultObj"];
                NSString *collect_id = [resultObj x_stringValueForKey:@"listId"];
                
                NSString *collectJSONFile = [NSString stringWithFormat:@"collectResult_%@.json",collect_id];
                
                NSString *styleJSONPath = [downloadPath stringByAppendingPathComponent:collectJSONFile];
                BOOL saveCollectSuccess = [data writeToFile:styleJSONPath atomically:YES];
                if (!saveCollectSuccess) {
                    NSLog(@"保存风格介绍json 文件失败");
                }
                
                NSLog(@"歌单已保存%ld / %lu",(long)collectDownloadIndex , (unsigned long)collects.count);
                
                // next collect
                NSInteger nextCollectIndex = collectDownloadIndex + 1;
                [weakSelf downloadCollects:collects path:downloadPath atIndex:nextCollectIndex completion:NULL];
                
                        
            } failure:^(NSError *error) {
                
                //continue to next collect
                //xia zai gedan shibai
                NSLog(@"xia zai ge dan shibai : start next download");
                NSInteger nextCollectIndex = collectDownloadIndex + 1;
                [weakSelf downloadCollects:collects path:downloadPath atIndex:nextCollectIndex completion:NULL];
                
            }];
            
                    
        } failured:^(NSError *error) {
                    
            
        }];
        
        
    }
    
    //3. 保存Json
    
}

- (void)getCollectDetailWithUrl:(NSString *)url
                        success:(void(^)(NSDictionary *collectResult))success failure:(void(^)(NSError *error))failured
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
     */

    NSURL* URL = [NSURL URLWithString:url];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";

    

    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            
            NSError *errorJson;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&errorJson];
            if (errorJson) {
                NSLog(@"歌单详情失败");
                failured(nil);
            }else{
                
                NSDictionary *result = [json x_dictionaryValueForKey:@"resultObj"];
                NSArray *allSongs = [result x_arrayValueForKey:@"allSongs"];
                if (allSongs.count > 1) {
                    //list not empty
                    success(json);
                }else{
                    NSLog(@"empty collect list");
                    failured(nil);
                }
            }
            
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
    
}


- (void)getCollectStaticUrl:(NSString *)listid success:(void(^)(NSString *url))success failured:(void(^)(NSError *error))failured
{
    
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    //    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/collect/getCollectStaticUrl"];
    //    NSDictionary* URLParams = @{
    //        @"_q": @"{\"listId\":22255265}",
    //        @"_s": @"39beb1b840874e11a2ef2b2aea1c4db8",
    //    };
    
    
    NSDictionary *genreDic = @{@"listId":listid};
    
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
    NSString *api = @"/api/collect/getCollectStaticUrl";
    
    NSString *par = [NSString stringWithFormat:@"%@_xmMain_%@_%@",xm_sg_tk,api,_q];
    NSString *_s = [self hMacMD5String:par];
    
    NSDictionary* URLParams = @{
        @"_q": _q,
        @"_s": _s,
    };
    
    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/collect/getCollectStaticUrl"];
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
                
                NSDictionary *data = json[@"result"][@"data"][@"data"][@"data"];
                
                NSString *url = data[@"url"];
                if (url.length > 0) {
                    success(url);
                }else{
                    NSLog(@"获取歌单url 失败");

                }
            }else{
                NSLog(@"获取歌单url 失败");
            }
            
        }
        else {
            // Faiilure
            NSLog(@"获取歌单url 失败");
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}


- (void)getArtistInfo:(NSString *)artistStringID
              Success:(void(^)(NSDictionary *artistResult))success failured:(void(^)(NSError *error))failured
{
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    //风格关联---歌单-----艺
    
    
    //风格热门歌单
//    {"id":"1155","type":2,"orderBy":1,"pagingVO":{"page":1,"pageSize":30}}
//    {"artistId":"6hG7d2d1"}
    NSDictionary *genreDic = @{@"artistId":artistStringID};
    
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
    NSString *api = @"/api/artist/initialize";
    
    NSString *par = [NSString stringWithFormat:@"%@_xmMain_%@_%@",xm_sg_tk,api,_q];
    NSString *_s = [self hMacMD5String:par];
    
    NSDictionary* URLParams = @{
        @"_q": _q,
        @"_s": _s,
    };
    
    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/artist/initialize"];
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
                NSLog(@"获取artist info 失败");
            }
            
        }
        else {
            // Faiilure
            NSLog(@"获取artist info 失败");
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}

- (void)getGenreCollectsWithStyleID:(NSString *)style_id
                               type:(NSString *)type
                           pageSize:(NSString *)pageSize Success:(void(^)(NSArray *collectsArray))success failured:(void(^)(NSError *error))failured
{
    
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    //风格关联---歌单-----艺人
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
    
//    {"id":"1155","type":2,"orderBy":1,"pagingVO":{"page":1,"pageSize":30}}
    
    NSDictionary *genreDic = @{@"id":style_id,
                               @"type":type,
                               @"orderBy":@"1",
                               @"pagingVO":@{@"page":@"1",
                                             @"pageSize":@"30"
                               }
    };
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
    NSString *api = @"/api/genre/getGenreCollects";
    
    NSString *par = [NSString stringWithFormat:@"%@_xmMain_%@_%@",xm_sg_tk,api,_q];
    NSString *_s = [self hMacMD5String:par];
    
    NSDictionary* URLParams = @{
        @"_q": _q,
        @"_s": _s,
    };
    
    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreCollects"];
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
                
                NSArray *collects = json[@"result"][@"data"][@"collects"];
                success(collects);
            }else{
                NSLog(@"获取热门歌单失败");
            }
            
        }
        else {
            // Faiilure
            NSLog(@"获取风格相关歌单信息失败");
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
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
//    NSArray *Cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    
    
//    for (NSHTTPCookie *subCookie in Cookies) {
//        if ([subCookie isKindOfClass:[NSHTTPCookie class]]) {
//
//            if ([subCookie.name isEqualToString:@"xm_sg_tk"]) {
//                NSArray *xm_sgArray = [subCookie.value componentsSeparatedByString:@"_"];
//                NSAssert(xm_sgArray.count == 2, @"xm_sg must have tk");
//                xm_sg_tk = xm_sgArray.firstObject;
//            }
//
//            if ([subCookie.domain containsString:@".xiami.com"]) {
//                _cookieDic[subCookie.name] = subCookie.value;
//            }
//        }
//    }
    
    
    [_cookieDic removeAllObjects];

    //准备测试api
    _cookieDic[@"bdshare_firstime"] = @"1489657813644";
    _cookieDic[@"cna"] = @"4SQVDYGZH24CAdpdNpP9zW9A";
    _cookieDic[@"xmgid"] = @"65490f30-c039-49f2-8c96-0535a3f8d0d4";
    
    _cookieDic[@"_uab_collina"] = @"155269776066873910563797";
    _cookieDic[@"_unsign_token"] = @"952c3266064ee84a5917ca57ecf481c5";
    _cookieDic[@"_xm_ncoToken_login"] = @"web_login_1590755694924_0.9517656030026849";
    
    _cookieDic[@"gid"] = @"160113068038831";
    _cookieDic[@"join_from"] = @"0T2dTo8YuGA12%2F%2FB";
    _cookieDic[@"UM_distinctid"] = @"174cada04782d2-037984d7f5df66-316c7004-fa000-174cada0479671";
    
    _cookieDic[@"xm_token"] = @"e069baf9dd9c599cf711eef6dd9ff9c0943i21";
    _cookieDic[@"uidXM"] = @"36244617";
    _cookieDic[@"_xm_umtoken"] = @"T2gAQ5Pk9xAA9vP8TvStackWZErsR9Q0_L-KEDEfoz_uWvL0sPVpRWsjIcbah5qQg9k=";
    
    _cookieDic[@"_xiamitoken"] = @"0034502eb9dd1c50f3729ee5fb9eb81e";
    _cookieDic[@"xlly_s"] = @"1";
    _cookieDic[@"radio_guest_listen"] = @"2";
    _cookieDic[@"_m_h5_tk"]  = @"2277cca00d66b2233840ab6ec2cfc5bf_1612585460985";
    _cookieDic[@"_m_h5_tk_enc"] = @"fac890c6136814325f5b2fe75d0b94cf";
    
    _cookieDic[@"xm_sg_tk"] = @"18d434bc7ed4ec976f3d89d7e6779283_1612579075067";
    NSArray *xm_sgArray = [@"18d434bc7ed4ec976f3d89d7e6779283_1612579075067" componentsSeparatedByString:@"_"];
    
    NSAssert(xm_sgArray.count == 2, @"xm_sg must have tk");
    NSString *xm_sg_tk;
    xm_sg_tk = xm_sgArray.firstObject;
    
    _cookieDic[@"xm_sg_tk.sig"] = @"r0ymCyBkQNZ3iSI-ghnlb-l2Jop5avD1gzfXwu-HFPw";
    _cookieDic[@"__guestplay"] = @"MTgxNDI5NzQwOSwx";
    _cookieDic[@"XMPLAYER_isOpen"] = @"0";
    
    
    _cookieDic[@"x5sec"] = @"7b22617365727665723b32223a223030613734383831666534323632323530633639323631343334363031313632435043442b494147454c4f353739716e32744c37744145776a757a432b51513d227d";
    _cookieDic[@"isg"] = @"BEdHqN4O68BnXFK-YyQ_o4Ff1v0RTBsuGfs8HRk0wFbyiGVKIR7Nf9YALkjWZPOm";
    _cookieDic[@"l"] = @"eBSUcWInq7MRXjKCBO5IFurza7yeVIRbzoVzaNbMiInca6sRtepSNNCILvCXSdtbgtf3fetrhC7JHdH654a3WjDDBeYBv_f1MxvOI";
    _cookieDic[@"tfstk"] = @"cfXAB3cUJunAak-RYsFo5AtQbqZhawqvSmTEBkxXErAaglMtCsjNK9ItYStKkLER.";
    _cookieDic[@"xm_traceid"] = @"0bba8b0f16125793406926313ec087";
    _cookieDic[@"xm_oauth_state"] = @"5eadbabb29de7cbdc2e3e470e3ec6f98";
    _cookieDic[@"_xm_cf_"] = @"9z73bG--UogNDkNZVFM0RJ8G";
    
    
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
                if ([genre_title isEqualToString:@"古典"]) {
                    
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


#pragma mark re men yi ren

// huo qu  re men yiren
- (void)getGenreHotArtistList:(NSString *)genreid
                  type:(NSString *)type
               success:(void(^)(NSArray *aritstCards))success
               failure:(void(^)(NSError *error))failured
{
 
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    //风格关联---歌单-----艺人
    //    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreRelations"];
    //    NSDictionary* URLParams = @{
    //        @"_q": @"{\"genreId\":\"846\",\"type\":2}",
    //        @"_s": @"050081505635515366d280208399c735",
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
    NSString *api = @"/api/genre/getGenreRelations";
    
    NSString *par = [NSString stringWithFormat:@"%@_xmMain_%@_%@",xm_sg_tk,api,_q];
    NSString *_s = [self hMacMD5String:par];
    
    NSDictionary* URLParams = @{
        @"_q": _q,
        @"_s": _s,
    };
    
    NSURL* URL = [NSURL URLWithString:@"https://www.xiami.com/api/genre/getGenreRelations"];
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
                
                NSDictionary *data = [[json x_dictionaryValueForKey:@"result"] x_dictionaryValueForKey:@"data"];
                NSArray *cardGroups = [data x_arrayValueForKey:@"cardGroups"];
                
                NSArray *artistItems;
                for (NSDictionary *card in cardGroups) {
                    
                    NSString *key = [card x_stringValueForKey:@"groupKey"];
                    if ([key isEqualToString:@"GENRE_ARTIST"]) {
                        
                        NSDictionary *cards = [[card x_arrayValueForKey:@"cards"] firstObject];
                        NSArray *items = [cards x_arrayValueForKey:@"items"];
                        artistItems = items;
                        
                    }
                }
                
                if (artistItems.count == 0) {
                    NSLog(@"没有风格相关的艺人");
                    failured(nil);
                }else{
                    success(artistItems);
                }
                
            }else{
                NSLog(@"获取风格相关艺人信息失败");
                
                failured(nil);
            }
            
        }
        else {
            // Failure
            NSLog(@"获取风格相关艺人信息失败");
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}

- (void)addLRCFileToDownloadQuen:(NSDictionary *)song
{
    
    __weak typeof(self) weakSelf = self;
    
    [_lrcFilesURLArr addObject:song];
    
    [weakSelf startDownloadLRCFile:_lrcFilesURLArr
                           atIndex:_lrcDownloadIndex];
    
}

- (void)startDownloadLRCFile:(NSArray *)song_lyrics
                     atIndex:(NSInteger )index
{
    if (index >= song_lyrics.count) {
        NSLog(@"nice 总共有%lu份歌词",(unsigned long)song_lyrics.count);
        NSLog(@"all lrcfiles download completion");
        return;
    }
    
    
    NSString *lrcSavePath = @"/Users/liuhongnian/Desktop/lrcFile";
    if (![NSFileManager.defaultManager fileExistsAtPath:lrcSavePath]) {
        BOOL created = [NSFileManager.defaultManager createDirectoryAtPath:lrcSavePath withIntermediateDirectories:YES attributes:nil error:NULL];
        NSAssert(created, @"lrc file 夹创建失败");
    }
    
    
    NSDictionary *song = song_lyrics[_lrcDownloadIndex];
    NSString *lyricFileURL = [[song x_dictionaryValueForKey:@"lyricInfo"] x_stringValueForKey:@"lyricFile"];
    
    
    NSString *lrcType = [lyricFileURL pathExtension];
    NSString *song_id = [song x_stringValueForKey:@"songId"];
    NSString *lrcFileName = [NSString stringWithFormat:@"lrc_%@.%@",song_id,lrcType];
    
    NSString *lrcDownloadPath = lrcSavePath;
    __weak typeof(self) weakSelf = self;
    
    [weakSelf.lrcDownloader downloadLyricFileWithURL:lyricFileURL
                                           localPath:lrcDownloadPath
                                         lrcFileName:lrcFileName
                                             success:^{
        
        NSInteger nextLrcIndex = index + 1;
        weakSelf.lrcDownloadIndex = nextLrcIndex;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf startDownloadLRCFile:song_lyrics atIndex:weakSelf.lrcDownloadIndex];
        });
        
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"lrc file download failred");
        
        if (error.code == NSURLErrorTimedOut) {
            
            NSLog(@"下载歌词超时，休息10S再下载");
            NSInteger nextLrcIndex = index + 1;
            weakSelf.lrcDownloadIndex = nextLrcIndex;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [weakSelf startDownloadLRCFile:song_lyrics atIndex: weakSelf.lrcDownloadIndex];
            });
        }

    }];
    
}

- (NSString *)dicToString:(NSDictionary *)dic
{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    NSMutableString *result = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,result.length};
    //去掉字符串中的空格
    [result replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,result.length};
    //去掉字符串中的换行符
    [result replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return result;
}
@end
