//
//  PlaylistMatch.m
//  XiamiCollect
//
//  Created by liuhongnian on 2021/1/12.
//

#import "PlaylistMatch.h"
#import "AFNetworking.h"

@interface PlaylistMatch ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation PlaylistMatch

- (void)start
{
    
    NSURLRequest *playListReq = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://autumnfish.cn/user/playlist?uid=40261911&limit=11"]];
    
    
    _dataTask = [[AFHTTPSessionManager manager] dataTaskWithRequest:playListReq
                                                     uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error == nil) {
            NSDictionary *response = (NSDictionary *)responseObject;
            NSArray *playlist = response[@"playlist"];
            
            NSMutableArray *netEasyLists = [NSMutableArray arrayWithCapacity:10];
            
            for (NSDictionary *obj in playlist) {
                NSString *playlistName = obj[@"name"];
                if ([playlistName isEqualToString:@"404音乐喜欢的音乐"]) {
                    continue;
                }
                [netEasyLists addObject:obj];
            }
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *rootPath = @"/Users/liuhongnian/Desktop/待处理歌单";
            NSArray *fileDirectoryNames = [fileManager contentsOfDirectoryAtPath:rootPath
                                                                           error:NULL];
            
            for (NSString *listDirector in fileDirectoryNames) {
                
                NSString *playListPath = [rootPath stringByAppendingPathComponent:listDirector];
                
                NSString *jsonName;
                for (NSString *subFileName in [fileManager contentsOfDirectoryAtPath:playListPath error:NULL]) {
                    if ([subFileName hasPrefix:@"collectResult"]) {
                        jsonName = subFileName;
                    }
                }
                
                if (!jsonName) {
                    continue;
                }
                
                NSString *collectJSONPath = [playListPath stringByAppendingPathComponent:jsonName];
                NSData *collectData = [fileManager contentsAtPath:collectJSONPath];
                
                NSDictionary *collectObj = [NSJSONSerialization JSONObjectWithData:collectData options:NSJSONReadingMutableContainers error:NULL];
                
                NSMutableDictionary *collectMutable = [collectObj mutableCopy];
                NSString *collectName = collectMutable[@"resultObj"][@"collectName"];
                
                for (NSDictionary *obj in netEasyLists) {
                    //net easy list name
                    NSString *playListName = obj[@"name"];
                    //net easy list id
                    NSNumber *listid = obj[@"id"];
                    if ([playListName isEqualToString:collectName]) {
                        
                        collectMutable[@"resultObj"][@"ThirdPartyMusic"][@"music163PlayListID"] = listid;
                        
                        NSData *modifiedData = [NSJSONSerialization dataWithJSONObject:collectMutable
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:NULL];
                        BOOL modSuccess = [modifiedData writeToFile:collectJSONPath
                                                         atomically:YES];
                        if (modSuccess) {
                            
                            NSString *goodDirector = @"/Users/liuhongnian/Desktop/good";
                            NSString *goodPath = [goodDirector stringByAppendingPathComponent:collectName];
                            
                            if (![fileManager fileExistsAtPath:goodPath]) {
                                [fileManager createDirectoryAtPath:goodPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:NULL];
                            }
                            NSString *goodJSONFilePath = [goodPath stringByAppendingPathComponent:jsonName];
                            //拷贝 json 文件
                            BOOL copySuccess = [fileManager copyItemAtPath:collectJSONPath
                                                                    toPath:goodJSONFilePath
                                                                     error:NULL];
                            NSAssert(copySuccess, @"");
                            
                            //copy image
                            NSString *collectImagesPath = [playListPath stringByAppendingPathComponent:@"image"];
                            NSString *goodImgsPath = [goodPath stringByAppendingPathComponent:@"image"];
                            copySuccess = [fileManager copyItemAtPath:collectImagesPath toPath:goodImgsPath error:NULL];
                            NSAssert(copySuccess, @"");
                            
                            NSString *xiamiRootPath = @"/Users/liuhongnian/Desktop/虾米的回忆";
                            NSString *moveToPath = [xiamiRootPath stringByAppendingPathComponent:collectName];
                                                            
                            BOOL move = [fileManager moveItemAtPath:playListPath
                                                 toPath:moveToPath
                                                  error:NULL];
                            
                            if (!move) {
                                NSLog(@"迁移歌单文件失败");
                            }
                            break;
                            
                        }else{
                            NSLog(@"歌单id 匹配后,存入json文件失败");
                        }
                    }
                    
                    
                    
                    
                }
                        
            }
            
        }
    }];
    
    [_dataTask resume];
}
@end
