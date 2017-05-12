//
//  VoiceControl.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/10.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit

class VoiceControl: BaseViewController , IFlyRecognizerViewDelegate {
    let TAG = "VoiceControl"
    
    // - 测试appid最多访问500次语音服务
    let APPID = "appid=5912a568"
    
    var iflyRecognizerView:IFlyRecognizerView!
    
    var resultText = ""
    
    var isRecongnizer = false
    
    @IBAction func start() {
        
       iflyRecognizerView.start()
    }
    
    
    @IBAction func stop() {
        iflyRecognizerView.cancel()
    }
    
    
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "语音控制"
        // Do any additional setup after loading the view.
        
        IFlySpeechUtility.createUtility(APPID)
     
        
        self.iflyRecognizerView = IFlyRecognizerView.init(center: self.view.center)as IFlyRecognizerView
        self.iflyRecognizerView.delegate = self
        self.iflyRecognizerView.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        self.iflyRecognizerView.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        // | result_type   | 返回结果的数据格式 plain,只支持plain
        self.iflyRecognizerView.setParameter("plain", forKey: IFlySpeechConstant.result_TYPE())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // - 语音识别结果
    func onResult(_ resultArray: [Any]!, isLast: Bool) {
        
        var resultStr : String = ""
        if resultArray != nil {
            let resultDic : Dictionary<String, String> = resultArray[0] as! Dictionary<String, String>
            
            for key in resultDic.keys {
                resultStr += key
                showPrint(resultStr)
            }
        }
        resultText += resultStr
        result.text = resultText
    }
    // - 语音识别出错
    func onError(_ error: IFlySpeechError!) {
        showPrint("error is \(error)")
    }
    
    func showPrint(_ data:String){
        print("\(TAG) \(data)\n")
    }
}
