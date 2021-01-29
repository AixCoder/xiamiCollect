//
//  SongDownloader.m
//  XiamiCollect
//
//  Created by liuhongnian on 2020/12/17.
//

#import "SongDownloader.h"

#import "AFNetworking.h"

@implementation SongDownloader

- (void)downloadSongWithURL:(NSString *)songLink
                   savePath:(NSString *)localPath
                   fileName:(NSString *)mp3FileName
                    success:(void (^)(void))completion
                    failure:(void (^)(NSError * _Nonnull))downloadFailed
{
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:songLink]];
    NSURLSessionDownloadTask *task = [httpManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *MP3_filePath = [localPath stringByAppendingPathComponent:mp3FileName];
        return [NSURL fileURLWithPath:MP3_filePath];
        
        
      //下载到哪个文件夹
//      NSString *cachePath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
//      NSString *fileName=[cachePath stringByAppendingPathComponent:response.suggestedFilename];
//
//      return [NSURL fileURLWithPath:fileName];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error && filePath) {
            if (completion) {
                completion();
            }
        }else{
            downloadFailed(error);
        }
    }];
    [task resume];
}

@end

@implementation AlbumLogoDownloader

- (void)downloadAlbumWithURL:(NSString *)picURL
                   localPath:(NSString *)localPath
                   albumName:(NSString *)albumName
                     success:(void (^)(void))completion
                     failure:(void (^)(NSError * _Nonnull))downloadFailed
{
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:picURL]];
    NSURLSessionDownloadTask *task = [httpManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //下载到----本地路径
        
        NSString *albumPath = [localPath stringByAppendingPathComponent:albumName];
        
        return [NSURL fileURLWithPath:albumPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error && filePath) {
            if (completion) {
                completion();
            }
        }else{
            downloadFailed(error);
        }
    }];
    [task resume];
}

@end

@implementation PicDownloader

- (void)downloadWithURL:(NSString *)picURL
              localPath:(NSString *)localPath
                picName:(NSString *)picName
                success:(void (^)(void))completion
                failure:(void (^)(NSError * _Nonnull))downloadFailed
{
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:picURL]];
    NSURLSessionDownloadTask *task = [httpManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //下载到----本地路径
//        NSString *sugName = response.suggestedFilename;
        NSString *type = @"";
        if ([response.MIMEType isEqualToString:@"image/webp"]) {
            type = @"webp";
        }else if ([response.MIMEType isEqualToString:@"image/png"]){
            type = @"png";
        }else if ([response.MIMEType isEqualToString:@"image/jpeg"]){
            type = @"jpeg";
        }else{
            NSAssert(false, @"下载图片格式---不支持");
            return [NSURL URLWithString:@""];
        }
        
        NSString *fullPicName = [NSString stringWithFormat:@"%@.%@",picName,type];
        NSString *picPath = [localPath stringByAppendingPathComponent:fullPicName];
        
        return [NSURL fileURLWithPath:picPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error && filePath) {
            if (completion) {
                completion();
            }
        }else{
            downloadFailed(error);
        }
    }];
    [task resume];
}

@end
