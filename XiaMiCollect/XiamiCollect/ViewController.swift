//
//  ViewController.swift
//  XiamiCollect
//
//  Created by liuhongnian on 2020/12/8.
//

import UIKit
//
class ViewController: UIViewController {

    let collectReq = CollectRequest.init()
    let mp3Downloader = SongDownloader.init()
    
    let albumSDownloader = AlbumLogoDownloader.init()
    let albumLDownloader = PicDownloader.init()
    
    let logoMDownloader = PicDownloader.init()
    let logoLDownloader = PicDownloader.init()
    let artistImgDownloader = PicDownloader.init()
    
    let matchButton = UIButton(type: .custom)
    let match = PlaylistMatch()
    
    let downloadButton = UIButton(type: .custom)
    
    var downloadIndex = 0
    let collectURLS = ["https://music.xiami.com/resource/collect/v2/detail/1059958/3105065/1467078216?auth_key=1609999835-0-0-38723b29ae8ffaa9aaf958ddbbc629de",
    "https://music.xiami.com/resource/collect/v2/detail/2365987/100851462/1609823525?auth_key=1609916765-0-0-11f054714535845bb59bb2e9cedbc6a8",
    "https://music.xiami.com/resource/collect/v2/detail/2365987/42477498/1483791850?auth_key=1609916788-0-0-8d31a8c8583971bfad00b6e4f015eff0"]
    
    
    @objc func injected() {
        //
        downloadCollectTapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        matchButton.setTitle("Playlist match", for: .normal)
        matchButton.frame = CGRect.init(x: 20,
                                        y: 60,
                                        width: 100,
                                        height: 40)
        matchButton.setTitleColor(UIColor.blue, for: .normal)
        matchButton.addTarget(self, action: #selector(matchButtonTapped), for: .touchUpInside)
        view.addSubview(matchButton)
        
        downloadButton.setTitle("downCollect", for: .normal)
        downloadButton.frame = CGRect.init(x: 200, y: 60, width: 100, height: 40)
        downloadButton.setTitleColor(UIColor.blue, for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadCollectTapped), for: .touchUpInside)
        view.addSubview(downloadButton)
        
    
    }
    
    private func prepareToDownloadCollect(_ collectUrl: String) {
        
        collectReq.request(withCollectURL: collectUrl,
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
        
        let path = Bundle.main.path(forResource: "collectResult", ofType: "json")
        
        var xiamiCollect: Dictionary<String, Any> = [:]
        
        let url = URL(fileURLWithPath: path!)
        
            do {
                      /*
                         * try 发生异常会跳到catch代码中
                         * try! 发生异常程序会直接crash
                         */
                    let data = try Data(contentsOf: url)
                    let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                var collectResult = jsonData as! Dictionary<String, Any>
                
                let responseObj = JSON["resultObj"] as! Dictionary<String, Any>
                let name = responseObj["collectName"] as! String
                
                //collect name
                var result = collectResult["resultObj"] as! Dictionary<String, Any>
                result["collectName"] = name
                
                //collect des
                let desc = responseObj["cleanDesc"] as! String
                result["description"] = desc
                
                //collect tags
                let tagArr = responseObj["tags"] as! Array<String>
                result["tags"] = tagArr
                
                //play list id
                let playlisID = responseObj["listId"] as! Int
                result["playListID"] = playlisID
                result["playlistFrom"] = "xiami"
                
                //collect cover
                let collectLogoL = responseObj["collectLogoLarge"] as! String
                result["collectLogoM"] = responseObj["collectLogoMiddle"] as! String
                result["collectLogoL"] = collectLogoL
                
                
                let songs = responseObj["songs"] as! Array<Dictionary<String, Any>>
                var tracks: Array<Dictionary<String, Any>> = []
                for song in songs {
                    //track info
                    var track: Dictionary<String, Any> = [:]
                    track["enablePlay"] = true
                    track["whoAlsoLike"] = []
                    //song name
                    let name = song["songName"] as! String
                    track["trackName"] = name
                    //artist
                    let artists = song["artistName"] as! String
                    track["artistName"] = artists
                    //artist logo
                    let artistLogo = song["artistLogo"] as! String
                    track["artistLogo"] = artistLogo
                    //albumId
                    let album_id = song["albumId"] as! Int
                    track["albumID"] = album_id
                    //track id
                    let track_id = song["songId"] as! Int
                    track["trackID"] = track_id
                    //track logo S
                    let logourl = song["albumLogoS"] as! String
                    track["albumLogoS"] = logourl
                    //track logo m
                    let albumlogoM = song["albumLogo"] as! String
                    track["albumLogo"] = albumlogoM
                    
                    //track des
                    let des = song["description"] as! String
                    track["trackDes"] = des
                    tracks.append(track)
                    
                }
                result["trackObjs"] = tracks
                
                collectResult["resultObj"] = result
                xiamiCollect = collectResult
             
            } catch  {
                print("error reading json file")
            }

        
        //1. creat folder for collectID
        let resultObj = JSON["resultObj"] as! Dictionary<String, Any>
        let collectID = resultObj["listId"] as! Int
        let collectName = resultObj["collectName"] as! String
        
        let jsonFileName = String(collectID) + ".json"
        let downloadPath = "/Users/liuhongnian/Desktop/待处理歌单/" + String(collectName)
        let jsonFilePath = downloadPath + "/" + jsonFileName
                
        let isExists = FileManager.default.fileExists(atPath: downloadPath, isDirectory: nil)
        if !isExists {
            try? FileManager.default.createDirectory(atPath: downloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let success = data.write(toFile: jsonFilePath, atomically:false)
        if success == false {
            print("保存歌单原始JSON文件失败---")
            return
        }
        
        
        
        //2. save collect result json
        let collectJsonPath = downloadPath + "/collectResult_" + String(collectID) + ".json"
        let collectData: NSData = try! JSONSerialization.data(withJSONObject: xiamiCollect, options: .prettyPrinted) as NSData
        collectData.write(toFile: collectJsonPath, atomically: false)
        
        
        //download collect logo S M L size
        let logoDownloadPath = downloadPath + "/image" + "/collectCover"
        if !FileManager.default.fileExists(atPath: logoDownloadPath) {
            try? FileManager.default.createDirectory(atPath: logoDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        //collect logo M
        var logoM = resultObj["collectLogoMiddle"] as? String
        logoM = logoM ?? ""
        if logoM?.isEmpty == false {
            let logoName = "collectLogoM" + "_" + String(collectID)
            logoMDownloader.download(withURL: logoM!,
                                     localPath: logoDownloadPath,
                                     picName: logoName) {
                
            } failure: { (error) in
                print("下载歌单封面失败")
            }
        }
        //collect logo L
        let collectLogoL = resultObj["collectLogoLarge"] as? String
        if collectLogoL?.isEmpty == false {
            let logoName = "collectLogoL_" + String(collectID)
            logoLDownloader.download(withURL: collectLogoL!, localPath: logoDownloadPath, picName: logoName) {
                
            } failure: { (error) in
                print("下载歌单---封面L失败")
            }

        }

        
        //download music
        let songsList = resultObj["songs"] as! Array<Dictionary <String , Any>>
        startDownloadSong(songsList,
                          downloadQueueNum: 0,
                          downloadPath: downloadPath)
        
    }
    
    func startDownloadSong(_ songsList: Array<Dictionary <String, Any>>, downloadQueueNum: Int, downloadPath: String) {
        
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
            print("downloading the %d song at playlist", downloadQueueNum + 1)
            
            downloadMP3File(fileURL, downloadPath, mp3FileName) {[weak self] in
                let nextQueueNum = downloadQueueNum + 1

                if nextQueueNum >= songsList.count {
                    print("all the songs have been downloaded")
                    return;

                }else{
                    self?.startDownloadSong(songsList, downloadQueueNum: nextQueueNum, downloadPath: downloadPath)

                }
            }
            
            
            //download albumS logo
            let albumID = songObj["albumId"] as! Int
            let albumS_webp = songObj["albumLogoS"] as! String
            let songID = songObj["songId"] as! Int
            let albumFileName = String(albumID) + "_"  + String(songID) + ".webp"
            
            let albumDownloadPath = downloadPath + "/image" + "/album"
            
            if !FileManager.default.fileExists(atPath: albumDownloadPath) {
                try? FileManager.default.createDirectory(atPath: albumDownloadPath, withIntermediateDirectories: true, attributes: nil)
            }
                        
            print("downloading the %d album at playlist", downloadQueueNum + 1)
            self.albumSDownloader.downloadAlbum(withURL: albumS_webp, localPath: albumDownloadPath, albumName: albumFileName)
            {
                
            } failure: {(error) in
                print("下载专辑封面----失败")
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
            self.startDownloadSong(songsList, downloadQueueNum: downloadQueueNum + 1, downloadPath: downloadPath)
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

    
    @objc func matchButtonTapped() {
        
        match.start()
    }
    
    @objc func downloadCollectTapped() {
        //
        let url = "https://music.xiami.com/resource/collect/v2/detail/13529947/1264191996/1602742431?auth_key=1612015950-0-0-e46b34ad61d496b16badbb4858cb84b2"
        prepareToDownloadCollect(url)
    }
}

