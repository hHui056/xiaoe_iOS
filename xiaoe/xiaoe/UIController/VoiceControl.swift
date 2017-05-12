//
//  VoiceControl.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/10.
//  Copyright © 2017年 何辉. All rights reserved.
//

import UIKit

class VoiceControl: BaseViewController , IFlySpeechRecognizerDelegate {
    
    let APPID = "appid=5912a568"
    
    var iflySpeechRecognizer : IFlySpeechRecognizer!
    
    var resultText = ""
    
    var isRecongnizer = false
    
    @IBAction func start() {
        iflySpeechRecognizer.startListening()
    
    }
    
    
    @IBAction func stop() {
         iflySpeechRecognizer.stopListening()
    }
    
    
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "语音控制"
        // Do any additional setup after loading the view.
        IFlySpeechUtility.createUtility(APPID)
        
        self.iflySpeechRecognizer = IFlySpeechRecognizer.sharedInstance() as IFlySpeechRecognizer
        self.iflySpeechRecognizer.delegate = self
        self.iflySpeechRecognizer.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        self.iflySpeechRecognizer.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        self.iflySpeechRecognizer.setParameter("plain", forKey: IFlySpeechConstant.result_TYPE())
        self.iflySpeechRecognizer.setParameter("-1", forKey: IFlySpeechConstant.speech_TIMEOUT())
        self.iflySpeechRecognizer.setParameter("8000", forKey: IFlySpeechConstant.vad_EOS())
        self.iflySpeechRecognizer.setParameter("8000", forKey: IFlySpeechConstant.vad_BOS())
        self.iflySpeechRecognizer.setParameter("500000", forKey: IFlySpeechConstant.speech_TIMEOUT())
        self.iflySpeechRecognizer.setParameter("50000", forKey: IFlySpeechConstant.net_TIMEOUT())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onResults(_ results: [Any]!, isLast: Bool) {//语音识别结果
        var resultStr : String = ""
        if results != nil {
            let resultDic : Dictionary<String, String> = results[0] as! Dictionary<String, String>
            
            for key in resultDic.keys {
                resultStr += key
            }
        }
        
        if resultText != "" {
            if (resultText as NSString).substring(with: NSMakeRange( resultText.characters.count - 1, 1)) != "," {
                resultText += ","
            }
        }
        
        resultText += resultStr
        result.text = resultText
        
        if isRecongnizer {
            iflySpeechRecognizer.startListening()
        } else {
            iflySpeechRecognizer.stopListening()
            if resultText != "" {
                resultText = (resultText as NSString).substring(with: NSMakeRange( 0, resultText.characters.count - 1))
                result.text = resultText
            }
        }
    }
    
    func onError(_ errorCode: IFlySpeechError!) { //语音识别错误
        
    }

}
