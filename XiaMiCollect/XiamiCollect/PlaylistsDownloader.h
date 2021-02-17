//
//  PlaylistsDownloader.h
//  XiamiCollect
//
//  Created by liuhongnian on 2021/2/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaylistsDownloader : NSObject

- (void)startWithCompletion:(void(^)(void))downloadCompletion
                        tag:(NSString *)tagKey
                      order:(NSString *)orderType;

- (void)startDownloadCollectsByUser:(NSString *)userId
                         completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
