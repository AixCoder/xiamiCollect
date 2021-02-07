//
//  SongDownloader.h
//  XiamiCollect
//
//  Created by liuhongnian on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SongDownloader : NSObject

//- (void)downloadSongWithURL:(NSString *)
- (void)downloadSongWithURL:(NSString *)songLink
                   savePath:(NSString *)localPath
                   fileName:(NSString *)mp3FileName
                    success:(void (^)(void))completion
                    failure:(void (^)(NSError *error))downloadFailed;

@end

@interface AlbumLogoDownloader : NSObject

- (void)downloadAlbumWithURL:(NSString *)picURL
                   localPath:(NSString *)localPath
                   albumName:(NSString *)albumName
                     success:(void (^)(void))completion
                     failure:(void (^)(NSError *error))downloadFailed;

@end

@interface PicDownloader : NSObject

- (void)downloadWithURL:(NSString *)picURL
                   localPath:(NSString *)localPath
                   picName:(NSString *)picName
                     success:(void (^)(void))completion
                     failure:(void (^)(NSError *error))downloadFailed;

@end

NS_ASSUME_NONNULL_END
