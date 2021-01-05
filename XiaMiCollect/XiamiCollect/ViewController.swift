//
//  ViewController.swift
//  XiamiCollect
//
//  Created by liuhongnian on 2020/12/8.
//

import UIKit

class ViewController: UIViewController {

    let collectReq = CollectRequest.init()
    let mp3Downloader = SongDownloader.init()
    
    let albumDownloader = AlbumLogoDownloader.init()
    
    let logoMDownloader = PicDownloader.init()
    let logoLDownloader = PicDownloader.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectReq.request(withCollectURL:"https://music.xiami.com/resource/collect/v2/detail/36244617/841057771/1556869819?auth_key=1609840882-0-0-43796324d49d0173d0072ec26bb01c83",
                           key:"") {[weak self] (responseString) in
            
            let data = responseString.data(using: .utf8)
            let JSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            self?.downloadCollect(JSON as! Dictionary<String, Any>)
            
        } failure: { (error) in
            
        }

    }

    func downloadCollect(_ JSON: Dictionary<String, Any>)  {
        
        if (!JSONSerialization.isValidJSONObject(JSON)) {
            print("is not a valid json object")
            return
        }
        
        //设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data: NSData = try! JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted) as NSData
        
        //creat folder for collectID
        let resultObj = JSON["resultObj"] as! Dictionary<String, Any>
        let collectID = resultObj["listId"] as! Int
        let collectName = resultObj["collectName"] as! String
        
        let jsonFileName = String(collectID) + ".json"
        
        let downloadPath = "/Users/liuhongnian/Desktop/" + String(collectName)
        let jsonFilePath = downloadPath + "/" + jsonFileName
                
        let isExists = FileManager.default.fileExists(atPath: downloadPath, isDirectory: nil)
        if !isExists {
            try? FileManager.default.createDirectory(atPath: downloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let success = data.write(toFile: jsonFilePath, atomically:false)
        if success == false {
            print("创建下载目录失败")
            return
        }
        
        
        //download collect logo S M L size
        let logoDownloadPath = downloadPath + "/image" + "/collectCover"
        if !FileManager.default.fileExists(atPath: logoDownloadPath) {
            try? FileManager.default.createDirectory(atPath: logoDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        var logoM = resultObj["collectLogoMiddle"] as? String
        logoM = logoM ?? ""
        if logoM?.isEmpty == false {
            
            logoMDownloader.download(withURL: logoM!, localPath: logoDownloadPath, picName: "collectLogoM") {
                
            } failure: { (error) in
                print("下载歌单封面失败")
            }
        }
        
        


        
        //download music
        let songsList = resultObj["songs"] as! Array<Dictionary <String , Any>>
        startDownloadSong(songsList,
                          downloadQueueNum: 0,
                          downloadPath: downloadPath)
        
    }
    
    func startDownloadSong(_ songsList: Array<Dictionary <String, Any>>, downloadQueueNum: Int, downloadPath: String) {
        //
        if downloadQueueNum >= songsList.count {
            print("all the songs have been downloaded")
            return;
        }
        
        let songObj = songsList[downloadQueueNum]
        let songName = songObj["songName"] as! String
        let songFiles = songObj["listenFiles"] as! Array<Dictionary <String, Any>>
        var fileURL = ""
        var fileFormat = ""
        for song in songFiles {
           let format = song["format"] as! String
            if format == "m4a" {
                fileURL = song["listenFile"] as! String
                fileFormat = "m4a"
                break
            }
        }
        
        if fileURL.isEmpty {
            for song in songFiles {
                let format = song["format"] as! String
                if format == "mp3" {
                    fileURL = song["listenFile"] as! String
                    fileFormat = "mp3"
                    break
                }
            }
        }
        
        if !songName.isEmpty && !fileURL.isEmpty {
            //download mp3 file
            let mp3FileName = songName + "." + fileFormat
            downloadMP3File(fileURL, downloadPath, mp3FileName) {[weak self] in
                let queueNum = downloadQueueNum + 1
                self?.startDownloadSong(songsList, downloadQueueNum: queueNum, downloadPath: downloadPath)
            }
            
            
            //download album logo
            let albumID = songObj["albumId"] as! Int
            let album_webp = songObj["albumLogoS"] as! String
            let songID = songObj["songId"] as! Int
            let albumFileName = String(albumID) + "_"  + String(songID) + ".webp"
            
            let albumDownloadPath = downloadPath + "/image" + "/album"
            
            if !FileManager.default.fileExists(atPath: albumDownloadPath) {
                try? FileManager.default.createDirectory(atPath: albumDownloadPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            self.albumDownloader.downloadAlbum(withURL: album_webp, localPath: albumDownloadPath, albumName: albumFileName) {
                
            } failure: { (error) in
                print("下载专辑封面----失败")
            }

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

}

