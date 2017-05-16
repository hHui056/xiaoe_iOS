//
//  Instruction.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/3.
//  Copyright © 2017年 何辉. All rights reserved.
//

import Foundation
class Instruction{
    // ===========================================================================================================
    //  filed             length               description
    //  start_flag          2               固定头部，0xFF,0xFF
    //  length              2               cmd 开始到整个数据包结束所占用的字节数
    //  cmd                 1               表示具体的命令含义，详见命令数据详解
    //  seq                 1               发送者给出的序号，回复者必须把相应序号返回发送者
    //  data                n               具体数据，详见命令数据详解说明
    //  bcc                 1               数据校验，length到data数据校验和（异或）
    // ===========================================================================================================
  
    let header : [UInt8] = [0xFF,0xFF]
    
    var length = [UInt8](repeating: 0x00,count: 2)
    
    var cmd : UInt8?
    
    var seq : UInt8?
    
    var body : Body?
    
    var bcc : UInt8?
    
    init() {
        
    }
    
    func getLength()->Int{
        return Int((self.length[0]) ^ self.length[1]);
    }
    
    func getCmd()->UInt8{
        return self.cmd!
    }
    func getBody()->Body{
        return self.body!
    }
    
    func toByteArray()->[UInt8]{
       
        var input = [UInt8](repeating: 0x00,count: self.getLength()+4)
        input[0] = self.header[0]
        input[1] = self.header[1]
        input[2] = self.length[0]
        input[3] = self.length[1]
        input[4] = self.cmd!
        input[5] = self.seq!
        if self.body != nil{
            let data = self.body!.toByteArray()!
            var i = 0
            repeat{
                input[6+i] = data[i]
                i += 1
            }while i < data.count
            
            input[6+i] = self.bcc!
        }else{
            input[6] = self.bcc!
        }
        
        return input;
    }
    
    class Builder {
        let header : [UInt8] = [0xFF,0xFF]
        
        var length = [UInt8](repeating: 0x00,count: 2)
        
        var cmd : UInt8?
        
        var seq : UInt8 = 0x00
        
        var body : Body?
        
        init() {
            
        }
        func setCmd(cmd:UInt8)->Builder{
            self.cmd = cmd
            return self
        }
        
        func setBody(body:Body)->Builder{
            self.body = body
            return self
        }
        
        /**
         * 根据设置的字段值，生成一个条新指令。
         *
         * @return 生成的指令，或者返回nil。
         */
        
        func createInstruction() -> Instruction? {
            if !Cmd.verify(cmd:self.cmd){
                return nil
            }
            let instruction = Instruction()
            calculateLength()
            instruction.length = self.length
            instruction.cmd = self.cmd
            instruction.seq = generateSeqNumber()
            instruction.body = self.body
            instruction.bcc = calculateBcc()
            return instruction
        }
        
        func calculateLength(){
            let length = 1 + 1 + (self.body == nil ? 0 : (self.body?.getLength())!) + 1
            self.length[0] = UInt8(UInt16(length >> 8))
            self.length[1] = UInt8(length)
            
        }
        
        func generateSeqNumber()->UInt8{
            self.seq = seq + 1
            return seq
            
        }
        // 封装从length到data的字节数组
        func calculateBcc()->UInt8{
            let length = 2 + 1 + 1 + 1 + (self.body == nil ? 0 : (self.body?.getLength())!)
            var input = [UInt8](repeating: 0x00,count: length)
            
            input[0] = self.length[0]
            input[1] = self.length[1]
            input[2] = self.cmd!
            input[3] = self.seq
            if self.body != nil {
                let data : [UInt8] = self.body!.toByteArray()!
                var i = 0
                repeat{
                    input[4+i] = data[i]
                    i = i+1
                }while i < data.count
            }
            var xor = input[0];
            var index = 1
            repeat{
                  xor ^= input[index]
                  index += 1
            }while index < input.count
            
            return xor
        }
    }
    
class Cmd {
    public static let CONTROL : UInt8 = 0x70;//控制
    public static let CONTROL_BACK : UInt8 = 0x7f;//控制反馈
    public static let QUERY : UInt8 =  0x80;//查询
    public static let QUERY_BACK : UInt8 =  0x8f;//查询反馈
        
    public static func verify(cmd:UInt8?)->Bool{
            if cmd == nil {
                return false
            }
            if cmd! != CONTROL && cmd! != CONTROL_BACK && cmd! != QUERY && cmd! != QUERY_BACK {
                return false
            }else{
                return true
            }
        }
    }
    
    class RequestType{
        public static  let BOTH : UInt8 = 0x20  //温湿度
        public static  let TEMPERA : UInt8 = 0x21  //温度
        public static  let  HUM : UInt8 = 0x22  //湿度
        public static  let  AIR : UInt8 = 0x30  //大气压
        public static  let RGB : UInt8 = 0x10  //RGB控制
        public static  let LED : UInt8 = 0x40 //LED控制
    }
}
