//
//  PlaylistsViewController.m
//  XiamiCollect
//
//  Created by liuhongnian on 2021/2/12.
//

#import "PlaylistsViewController.h"
#import <CommonCrypto/CommonHMAC.h>
#import "SongDownloader.h"
#import "NSArray+AixCategory.h"

#import "PlaylistsDownloader.h"


#import "NSDictionary+AixCategory.h"
#import "NSString+AixCategory.h"

@interface PlaylistsViewController ()

@property (nonatomic, strong) PlaylistsDownloader *playlistDownloader1;
@property (nonatomic, strong) PlaylistsDownloader *playlistDownloader2;
@property (nonatomic, strong) PlaylistsDownloader *playlistDownloader3;
@property (nonatomic, strong) PlaylistsDownloader *playlistDownloader4;
@property (nonatomic, strong) PlaylistsDownloader *playlistDownloader5;
@property (nonatomic, strong) PlaylistsDownloader *playlistDownloader6;

@property (nonatomic, strong) PicDownloader *logoPicDownloader;
@property (nonatomic, strong) PicDownloader *authorAvatarDownloader;

@property (nonatomic, strong) PicDownloader *albumPicDownloader;
@property (nonatomic, strong) PicDownloader *artistPicDownloader;

@property (nonatomic, copy) void(^collectsDownloadCompletion1)(void);

@property (nonatomic, strong) UIButton *acidJazz;
@property (nonatomic, strong) UIButton *vocalJazz;
@property (nonatomic, strong) UIButton *nuJazz;
@property (nonatomic, strong) UIButton *skiffleJazz;
@property (nonatomic, strong) UIButton *gypsyJazz;
@property (nonatomic, strong) UIButton *bigBand;
@property (nonatomic, strong) UIButton *experimentalBig;

@property (nonatomic, strong) UIButton *style1Button;
@property (nonatomic, strong) UIButton *style2Button;
@property (nonatomic, strong) UIButton *style3Button;
@property (nonatomic, strong) UIButton *style4Button;
@property (nonatomic, strong) UIButton *style5Button;
@property (nonatomic, strong) UIButton *style6Button;
@property (nonatomic, strong) UIButton *style7Button;
@property (nonatomic, strong) UIButton *style8Button;
@property (nonatomic, strong) UIButton *style9Button;
@property (nonatomic, strong) UIButton *style10Button;

@property (nonatomic, strong) NSArray *classicStyles;
@property (nonatomic, strong) NSArray *recommendTags;//推荐
@property (nonatomic, strong) NSArray *languates;//语种
@property (nonatomic, strong) NSArray *styleTags;//风格
@property (nonatomic, strong) NSArray *themeTags;//主题
@property (nonatomic, strong) NSArray *scenarioTags;//场景
@property (nonatomic, strong) NSArray *moodTags;//心情

@property (nonatomic, strong) NSArray *specialTags;


@end

@implementation PlaylistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    _classicStyles = @[@"",@"",@"",@"",@"",@"",@"",@"",@""];
    
    _specialTags = @[@"Murakami"];
    
//    _languates = @[];
//
//    _styleTags = @[];
//
//    _themeTags = @[];
//
//    _scenarioTags = @[];
//
//    _moodTags = @[@"寂寞",@"振奋",@"思念"];
//
//    _styleTags = @[@"广播剧",
//                   @""];
//    _classicStyles = @[
//                       @"原声",
//                       @"电影原声",
//                       @"电视原声",
//                       @"卡通配乐",
//                       @"游戏配乐",
//                       @"音乐剧",
//                       @"歌舞剧",
//                       @"演出金曲",
//                       @"圣诞歌曲",
//                       @"宝莱坞电影配乐",
//                       @"节日音乐",
//                       @"史诗片配乐"];
    
//                       @"器乐摇滚",
//                       @"山区乡村摇滚",
//                       @"根源摇滚",
//                       @"新浪漫",
//                       @"冲浪摇滚",
//                       @"电力流行",
//                       @"沼泽摇滚",
//                       @"轻摇滚",
//                       @"车库摇滚",
//                       @"酸性摇滚",
//                       @"暗潮",
//                       @"爵士摇滚",
//                       @"仙音",
//                       @"学院摇滚",
//                       @"太空摇滚",
    _playlistDownloader1 = [[PlaylistsDownloader alloc] init];
    _playlistDownloader2 = [[PlaylistsDownloader alloc] init];
    _playlistDownloader3 = [[PlaylistsDownloader alloc] init];
    _playlistDownloader4 = [[PlaylistsDownloader alloc] init];
    _playlistDownloader5 = [[PlaylistsDownloader alloc] init];
    _playlistDownloader6 = [[PlaylistsDownloader alloc] init];
    
    
    _style1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_style1Button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    _style1Button.frame = CGRectMake(20, 60, 100, 40);
    [_style1Button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_style1Button setTitle:@"村上" forState:UIControlStateNormal];
    [_style1Button addTarget:self action:@selector(preBackupCollect1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_style1Button];
    

    _style2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _style2Button.frame = CGRectMake(20, 100, 100, 40);
    [_style2Button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_style2Button setTitle:@"下载某用户的歌单" forState:UIControlStateNormal];
    [_style2Button addTarget:self
                      action:@selector(downloadCollectByUser:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_style2Button];
    
//    _style3Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _style3Button.frame = CGRectMake(20, 160, 100, 40);
//    [_style3Button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
//    [_style3Button setTitle:@"主题" forState:UIControlStateNormal];
//    [_style3Button addTarget:self
//                   action:@selector(preBackupCollect3:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_style3Button];
    
    _style4Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _style4Button.frame = CGRectMake(20, 200, 100, 40);
    [_style4Button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    
    [_style4Button setTitle:@"场景" forState:UIControlStateNormal];
    [_style4Button addTarget:self
                 action:@selector(preBackupCollect4:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_style4Button];
    
    
    _style5Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _style5Button.frame = CGRectMake(20, 260, 100, 40);
    [_style5Button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_style5Button setTitle:@"心情" forState:UIControlStateNormal];
    [_style5Button addTarget:self
                         action:@selector(preBackupCollect5:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_style5Button];
    
//    _style6Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _style6Button.frame = CGRectMake(20, 300, 100, 40);
//    [_style6Button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
//    [_style6Button setTitle:_popStyles[5] forState:UIControlStateNormal];
//    [_style6Button addTarget:self
//                         action:@selector(preBackupCollect6:)
//         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_style6Button];
    
    _logoPicDownloader = [[PicDownloader alloc] init];
    _authorAvatarDownloader = [[PicDownloader alloc] init];
    
}


- (void)injected
{
    
    [self searchCollectWithName:@"风格大赏"];
}

- (void)searchCollectWithName:(NSString *)collectNameKey {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = @"/Users/liuhongnian/Desktop/待处理歌单/歌单分类/Ukulele";
    
    NSString *jsonName;
    
    for (NSString *subFileName in [fileManager contentsOfDirectoryAtPath:rootPath error:NULL]) {
        
        if ([subFileName hasSuffix:@".json"]) {
            jsonName = subFileName;
            
            NSString *collectJSONPath = [rootPath stringByAppendingPathComponent:jsonName];
            NSData *collectData = [fileManager contentsAtPath:collectJSONPath];
            
            NSDictionary *collectObj = [NSJSONSerialization JSONObjectWithData:collectData options:NSJSONReadingMutableContainers error:NULL];
            
            NSMutableDictionary *collectMutable = [collectObj mutableCopy];
            NSDictionary *collectDetail = [collectMutable[@"data"][@"data"] x_dictionaryValueForKey:@"collectDetail"];
            
            NSString *collectName = [collectDetail x_stringValueForKey:@"collectName"];
            
//            1203053492
            NSString *collectList = [collectDetail x_stringValueForKey:@"listId"];
            
            if ([collectName containsString:collectNameKey]) {
                NSLog(@"找到对应歌单:%@",[collectDetail x_stringValueForKey:@"listId"]);
            }
            
        }
    }

}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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

#pragma mark 下载风格歌单入口

- (void)downloadCollectByUser:(NSString *)userId {
    
//    NSString *uid = @"45281460";
    NSString *uid = @"318132";
//    NSString *uid = @"36244617";
    [self.playlistDownloader1 startDownloadCollectsByUser:uid completion:^{
            NSLog(@"用户 %@的歌单下载完成✅", uid);
    }];
}

- (void)preBackupCollect1:(UIButton *)sender {
    
//    [self.playlistDownloader1 startWithCompletion:^{
//
//        [weakSelf.style1Button setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
//
//    } tag:sender.currentTitle order:@"hot"];
    
    [self downloadRecommendOnebyOne:0];
}

- (void)downloadRecommendOnebyOne:(int)tagIndex {
    
    if (tagIndex >= _specialTags.count) {
//        NSLog(@"标签歌单下载完成✅");
        NSLog(@"全部下载完成");
        return;
    }

    __weak typeof(self) weakSelf = self;
    
    NSString *tag = [_specialTags objectAtIndex:tagIndex];
    
    [self.playlistDownloader1 startWithCompletion:^{
        int nextIndex = tagIndex + 1;
        [weakSelf downloadRecommendOnebyOne:nextIndex];
        
    } tag:tag order:@"hot"];
    
}

- (void)preBackupCollect2:(UIButton *)sender {
    
    [self downloadStyleTagsOnebyOne:0];
}

- (void)downloadStyleTagsOnebyOne:(int )tagIndex
{
    
    if (tagIndex >= _styleTags.count) {
        NSLog(@"风格标签歌单下载完成✅");
        return;
    }
    
    NSString *tag = [_styleTags objectAtIndex:tagIndex];
    
    __weak typeof(self) weakSelf = self;
    
    [self.playlistDownloader2 startWithCompletion:^{
        int nextTagIndex = tagIndex + 1;
        [weakSelf downloadStyleTagsOnebyOne:nextTagIndex];
    } tag:tag
                                            order:@"recommend"];
}

- (void)preBackupCollect3:(UIButton *)sender {
    
    [self downloadThemeOnebyOne:0];
}

- (void)downloadThemeOnebyOne:(int)tagIndex {
    
    if (tagIndex >= _themeTags.count) {
        NSLog(@"主题标签歌单下载完成✅");
        return;
    }
    
    NSString *tag = [_themeTags objectAtIndex:tagIndex];
    __weak typeof(self) weakSelf = self;
    
    [self.playlistDownloader3 startWithCompletion:^{
        int nextTagIndex = tagIndex + 1;
        [weakSelf downloadThemeOnebyOne:nextTagIndex];
    } tag:tag
                                            order:@"recommend"];
}

- (void)preBackupCollect4:(UIButton *)sender {
    
    [self downloadscenarioTagsOneByone:0];
    
}

- (void)downloadscenarioTagsOneByone:(int)tagIndex {
    
    if (tagIndex >= _scenarioTags.count) {
        NSLog(@"场景标签歌单下载完成✅");
        return;
    }
    
    NSString *tag = [_scenarioTags objectAtIndex:tagIndex];
    
    __weak typeof(self) weakSelf = self;
    [self.playlistDownloader4 startWithCompletion:^{
        int nextTagIndex = tagIndex + 1;
        [weakSelf downloadscenarioTagsOneByone:nextTagIndex];
    } tag:tag
                                            order:@"recommend"];
}


- (void)preBackupCollect5:(UIButton *)sender {
    
    [self downloadMoodTagsOnebyOne:0];
}

- (void)downloadMoodTagsOnebyOne:(int)tagIndex {
    
    if (tagIndex >= _moodTags.count) {
        NSLog(@"心情标签歌单下载完成✅");
        return;
    }
    
    NSString *tag = [_moodTags objectAtIndex:tagIndex];
    
    __weak typeof(self) weakSelf = self;
    [self.playlistDownloader5 startWithCompletion:^{
        int nextTagIndex = tagIndex + 1;
        [weakSelf downloadMoodTagsOnebyOne:nextTagIndex];
    } tag:tag
                                            order:@"recommend"];
}

- (void)preBackupCollect6:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;

    [self.playlistDownloader6 startWithCompletion:^{
        
        [weakSelf.style6Button setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    } tag:sender.currentTitle order:@"hot"];
}
@end
