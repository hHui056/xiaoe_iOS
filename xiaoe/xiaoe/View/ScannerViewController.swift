//
//  ScannerViewController.swift
//  QRCode
//
//  Created by Erwin on 16/5/5.
//  Copyright © 2016年 Erwin. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class ScannerViewController: BaseViewController,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
    //相机显示视图
    let cameraView = ScannerBackgroundView(frame: UIScreen.main.bounds)
    //来自哪个uicontroller
    var WhereFrom = FIRST_BIND_DEVICE
    
    let captureSession = AVCaptureSession()
    //扫描结果
    var scanresult = ""
    
    var delegate : MessageDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WhereFrom == FIRST_BIND_DEVICE {
           self.title = "绑定设备"
        }else{
            self.title = "添加设备"
        }
        
        self.view.backgroundColor = UIColor.black
        
//        //设置导航栏
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ScannerViewController.selectPhotoFormPhotoLibrary(_:)))
//        self.navigationItem.rightBarButtonItem = barButtonItem
        
        self.view.addSubview(cameraView)
        
        //初始化捕捉设备（AVCaptureDevice），类型AVMdeiaTypeVideo
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let input :AVCaptureDeviceInput
        //创建媒体数据输出流
        let output = AVCaptureMetadataOutput()
        //捕捉异常
        do{
            //创建输入流
            input = try AVCaptureDeviceInput(device: captureDevice)
            
            //把输入流添加到会话
            captureSession.addInput(input)
            
            //把输出流添加到会话
            captureSession.addOutput(output)
        }catch {
            print("异常  \(error)")
        }
        
        //创建串行队列
        let dispatchQueue = DispatchQueue(label: "queue", attributes: [])
        
        //设置输出流的代理
        output.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        
        //设置输出媒体的数据类型
        output.metadataObjectTypes = NSArray(array: [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]) as [AnyObject]
        
        //创建预览图层
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //设置预览图层的填充方式
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //设置预览图层的frame
        videoPreviewLayer?.frame = cameraView.bounds
        
        //将预览图层添加到预览视图上
        cameraView.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        //设置扫描范围
        output.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.scannerStart()
    }
    
    func scannerStart(){
        captureSession.startRunning()
        cameraView.scanning = "start"
    }
    
    func scannerStop() {
        captureSession.stopRunning()
        cameraView.scanning = "stop"
    }
    func showDialog(data:String){
        let alertController:UIAlertController = UIAlertController(title: nil, message: data, preferredStyle:  UIAlertControllerStyle.alert)
        let maction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: {(alertAction)-> Void in
            
            self.scannerStart()
        })
        alertController.addAction(maction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //扫描代理方法
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count > 0 {
            let metaData : AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            
            DispatchQueue.main.async(execute: {
                if self.delegate != nil {
                    
               //     self.navigationController?.popViewController(animated: true)
                    print("======\(metaData.stringValue)")
                    do{
                        let result = try JSON(parseJSON:metaData.stringValue)
                        let uid = result["uid"].stringValue
                        print("uid是：\(uid)")
                        let appkey = result["appkey"].stringValue
                         print("APPKEY是：\(appkey)")
                        
                        if appkey != "" && uid != "" {//扫描到正确的二维码信息
                            let storyboard = UIStoryboard(name: "QRCodeSuccess", bundle: nil)
                            let anotherView = (storyboard.instantiateViewController(withIdentifier:"QRSuccess")) as! QRCodeSuccess
                            anotherView.device_appkey = appkey
                            anotherView.device_uid = uid
                            if self.WhereFrom == FIRST_BIND_DEVICE {
                                anotherView.btn_str = SURE_BIND_DEVICE
                            }else{
                                anotherView.btn_str = SURE_ADD_DEVICE
                            }
                            self.delegate?.sendMessage(message: uid)
                            self.navigationController?.pushViewController(anotherView, animated:true)
                        }else{
                             self.showDialog(data:"请扫描开发板背面的二维码")
                        }
                    }catch{
                        self.showDialog(data:"请扫描开发板背面的二维码")
                        print("扫描的不是json数据")
                    }
                }
             })
            captureSession.stopRunning()
        }
    }
    
    //从相册中选择图片
    func selectPhotoFormPhotoLibrary(_ sender : AnyObject){
        let picture = UIImagePickerController()
        picture.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picture.delegate = self
        self.present(picture, animated: true, completion: nil)
        
    }
    
    //选择相册中的图片完成，进行获取二维码信息
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]
        
        let imageData = UIImagePNGRepresentation(image as! UIImage)
        
        let ciImage = CIImage(data: imageData!)
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        
        let array = detector?.features(in: ciImage!)
        
        let result : CIQRCodeFeature = array!.first as! CIQRCodeFeature
        
        
//        let resultView = WebViewController()
//        resultView.url = result.messageString
//        
//        self.navigationController?.pushViewController(resultView, animated: true)
        picker.dismiss(animated: true, completion: nil)
        print(result.messageString ?? String())

    }
}
protocol MessageDelegete {
    func sendMessage(message:String)
}
