//
//  ViewController.swift
//  ShareCam
//
//  Created by ycctw1443 on 2015/09/14.
//  Copyright (c) 2015年 ycctw1443. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController,AVCaptureFileOutputRecordingDelegate {

    
    @IBOutlet weak var liveView: LiveView!
    @IBOutlet weak var recordButton: UIButton!

    
    let captureSession: AVCaptureSession = AVCaptureSession()
    let movieOut = AVCaptureMovieFileOutput()
    let photoOut = AVCaptureStillImageOutput()
    
    func setupCaptureSession(){
        var error: NSError?
        //720pで撮影するプリセットを指定
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720
        
        //カメラのデフォルトデバイスを取得（背面カメラ）
        //ipod touch 5thのみ前面カメラがデフォルト
        let device: AVCaptureDevice! = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        //デバイスをキャプチャセッションにつなげるためのインプットを取得
        let deviceIn: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error)
    
        //インプットが接続できるか確認した上でキャプチャセッションに接続
        if captureSession.canAddInput(deviceIn as? AVCaptureInput){
            captureSession.addInput(deviceIn as! AVCaptureInput)
        }
    
        //カメラ出力をムービーファイルとして読み込むアウトプットを接続
        if captureSession.canAddOutput(movieOut){
            captureSession.addOutput(movieOut)
        }
        
        //カメラ出力から写真を撮影するアウトプットを接続
        if captureSession.canAddOutput(photoOut){
            captureSession.addOutput(photoOut)
        }
        
        //ライブビューに表示対象のキャプチャセッションを指定
        liveView.session = captureSession
        
        //動画の解像度にかかわらず、写真を最大解像度で撮影するように指定
        photoOut.highResolutionStillImageOutputEnabled = true
        
    }
    
    
    
    
    @IBAction func record(sender: AnyObject){
        if !movieOut.recording{
            //録画の開始
            //ムービーファイルのURLを指定
            let fileURL = movieURL("movie.MOV")
            
            //同じ名前のファイルがある場合は削除する
            self.removeFile(fileURL)
            
            //作成したURLを使って録画を開始
            movieOut.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
            
        }else{
            //録画終了
            movieOut.stopRecording()
            
            //ファイルが完成するまで、録画ボタンを無効化
            let button = sender as! UIButton
            button.enabled = false;
        }
        
    }
    
    private func movieURL(filename: NSString) -> NSURL! {
        //テンポラリディレクトリ直下のファイルURLを作成
        let filepath = NSTemporaryDirectory()?.stringByAppendingPathComponent(filename as String)
        
        return NSURL(fileURLWithPath: filepath!)
    }
    
    private func removeFile(fileURL: NSURL) -> Bool{
        var success = false
        
        //ファイルが存在する場合にのみ削除処理を実行
        let filepath = fileURL.path
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(filepath!){
            success = fileManager.removeItemAtPath(filepath!, error: nil)
        }
        return success
    }
    
    //AVCaptureFileOutputRecordingDelegateプロトコルのメソッド
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!){
        
        //カメラロールに保存
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image:UIImage, didFinishSavingWithError error:NSError, contextInfo info:UnsafeMutablePointer<Void>){
        
        //ボタンの状態を戻す
        self.recordButton.enabled = true
    
        println("ムービーをカメラロールに保存しました")
    }
    
    
    @IBAction func takeAndShare(sender: AnyObject){
        //カメラにつながっているコネクションを選択
        let connection = photoOut.connectionWithMediaType(AVMediaTypeVideo)
    
        //コネクション経由で撮影
        photoOut.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (sampleBuffer, error) -> Void in
            if error != nil{
                //撮影データに対する処理
                self.shareImageToSNS(sampleBuffer) //SNS投稿機能（こいつを入れなきゃ撮影するだけになっちゃう）
            }
        })
    }
    
    func shareImageToSNS(sbuf:CMSampleBufferRef){
        //撮影データをJPEG画像に変換し、UIImageに変換する
        let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sbuf)
        let image = UIImage(data: data)
        
        //Twitter投稿用のビューコントローラを作成
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) //SLServiceTypeTwitterをSLServiceTypeFacebookにすればfacebookに投稿できる
        vc.addImage(image)
        vc.completionHandler = {(result) -> Void in
            println("SNSへの投稿処理が終わりました")
        }
        
        //投稿画面を表示
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    


}

