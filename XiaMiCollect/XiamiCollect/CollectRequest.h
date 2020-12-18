//
//  CollectRequest.h
//  XiamiCollect
//
//  Created by liuhongnian on 2020/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectRequest : NSObject

- (void)sendRequest;

- (void)requestWithCollectURL:(NSString *)collectURL
                          key:(NSString *)authKey
                      success:(void (^)(NSString *collectInfo))success
                      failure:(void (^)(NSError *error))failure;

- (void)testDownload;

@end

NS_ASSUME_NONNULL_END
