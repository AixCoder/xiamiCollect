//
//  FavoriteSongsVC.swift
//  XiamiCollect
//
//  Created by liuhongnian on 2021/2/6.
//

import UIKit

class FavoriteSongsVC: UIViewController {

    let mp3Downloader = SongDownloader.init()
    
    let albumDownloader = PicDownloader.init()
    
    let logoMDownloader = PicDownloader.init()
    let logoLDownloader = PicDownloader.init()
    let artistImgDownloader = PicDownloader.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let path = Bundle.main.path(forResource: "mysong5", ofType: "json")
        
        var favoriteSongs: Array<Dictionary<String, Any>> = []
        
        let url = URL(fileURLWithPath: path!)
            do {

                    let resultData = try Data(contentsOf: url)
                    let jsonData:Any = try JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                let result = jsonData as! Dictionary<String, Any>
                let data_result = result["data"] as!Dictionary<String,Any>
                let data = data_result["data"] as! Dictionary<String, Any>
                favoriteSongs = data["songs"] as! Array<Dictionary<String, Any>>
                
                
                //准备下载歌曲
                //1. creat folder for 最爱的歌曲
                let downloadPath = "/Users/liuhongnian/Desktop/xiamibackup/挚爱歌曲"
                        
                let isExists = FileManager.default.fileExists(atPath: downloadPath, isDirectory: nil)
                if !isExists {
                    try? FileManager.default.createDirectory(atPath: downloadPath, withIntermediateDirectories: true, attributes: nil)
                }
  
                //批量下载歌曲
                downloadFavoriteSongs(favoriteSongs, downloadQueueNum: 0, downloadPath: downloadPath)
                
                
    
             
            } catch  {
                print("error reading json file")
            }


    }

    func downloadFavoriteSongs(_ songsList: Array<Dictionary <String, Any>>, downloadQueueNum: Int, downloadPath: String)
    {
        
        let songObj = songsList[downloadQueueNum]
        let songName = songObj["songName"] as! String
        let songFiles = songObj["listenFiles"] as! Array<Dictionary <String, Any>>
        
        var fileURL = ""
        var fileFormat = ""
        for song in songFiles {
            let q = song["quality"] as! String
            if q == "h" {//高质量mp3
                fileURL = song["listenFile"] as! String
                fileFormat = song["format"] as! String
                break
            }
        }
        
        
        if fileURL.isEmpty {
            for song in songFiles {
                //选择稍微低质量的mp4
                let format = song["format"] as! String
                if format == "m4a" {
                    fileURL = song["listenFile"] as! String
                    fileFormat = "m4a"
                    break
                }
            }
        }
        
        if !songName.isEmpty && !fileURL.isEmpty {
            
            //download mp3 file
            let mp3FileName = songName + "." + fileFormat
            print("downloading the %d song at playlist", downloadQueueNum + 1)
            
            downloadMP3File(fileURL, downloadPath, mp3FileName) {[weak self] in

                let nextQueueNum = downloadQueueNum + 1
                if nextQueueNum >= songsList.count {
                    print("all the songs have been downloaded")
                    return;

                }else{

                    self?.downloadFavoriteSongs(songsList,
                                                downloadQueueNum: nextQueueNum, downloadPath: downloadPath)

                }
            }
            
            //
            //download album large logo
            let albumID = songObj["albumId"] as! Int
            let albumURL = songObj["albumLogo"] as! String
            let albumFileName = "albumLogo" + String(albumID)
            
            let albumDownloadPath = downloadPath + "/image" + "/album"
            
            if !FileManager.default.fileExists(atPath: albumDownloadPath) {
                try? FileManager.default.createDirectory(atPath: albumDownloadPath, withIntermediateDirectories: true, attributes: nil)
            }
                        
            self.albumDownloader.download(withURL: albumURL, localPath: albumDownloadPath, picName: albumFileName) {
                
            } failure: { (error) in
                print("下载歌曲封面失败")
            }

            
            //download artist logo
            let artistLogoDownloadPath = downloadPath + "/image" + "/artistlogo"
            if !FileManager.default.fileExists(atPath: artistLogoDownloadPath) {
                try? FileManager.default.createDirectory(atPath: artistLogoDownloadPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            var artistid = -1
            if ((songObj["artistId"] as? Int) != nil){
                artistid = songObj["artistId"] as! Int
            }
            let artistPicName = "artistlogo_" + String(artistid)
            let artistlogoURL = songObj["artistLogo"] as! String
            self.artistImgDownloader.download(withURL: artistlogoURL,
                                              localPath: artistLogoDownloadPath,
                                              picName: artistPicName) {
                
            } failure: { (error) in
                print("download artis logo failed")
            }


        }else{
            print("歌名:%@ 没有匹配到下载地址--跳过--下载下一首")
            self.downloadFavoriteSongs(songsList, downloadQueueNum: downloadQueueNum + 1, downloadPath: downloadPath)
        }
    }

    func downloadMP3File(_ fileURL: String,
                         _ localPath: String ,
                         _ mp3FileName: String,
                         completion: @escaping() ->Void) {

        mp3Downloader.downloadSong(withURL: fileURL,
                                   savePath: localPath,
                                   fileName: mp3FileName) {

            completion()

        } failure: { (error) in
            print("download failed")
            completion()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
