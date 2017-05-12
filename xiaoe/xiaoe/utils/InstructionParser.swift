//
//  InstructionParser.swift
//  xiaoe
//
//  Created by 何辉 on 2017/5/3.
//  Copyright © 2017年 何辉. All rights reserved.
//
// - 指令解析器
class InstructionParser{
   
    /**
     * 解析成一条指令。
     *
     * @param content 指令的字节数组
     * @return 解析后的指令，或者nil。
     */
    func parseInstruction(content:[UInt8]?)->Instruction?{
        if content == nil {
            return nil
        }
        // 校验header -> 校验length -> 校验bcc ->
        // 解析cmd -> 解析type -> 解析seq -> 解析data
        
          let instruction = Instruction()
        // verify header
        
        if content![0] != 0xff || content![1] != 0xff {
            print("header is wrong")
            return nil
        }
        // verify length
        let length : Int = Int((content![2]) ^ content![3])
        if length != content!.count - 4 {
          print("length is wrong")
            return nil
        }
        // verify bcc
        var bcc : UInt8 = content![2]
        var i = 3
        repeat{
             bcc ^= content![i]
             i += 1
        }while i < content!.count - 1
        
        if bcc != content![content!.count - 1] {
            print("bcc is wrong")
            return nil
        }
        
        if !parseCmd(cmd: content![4], instruction: instruction){
            print("cmd field is wrong")
            return nil
        }
        
        instruction.seq = content![5]
        if instruction.seq! <= 0 {
            print("seq field is below 0");
            return nil
        }
        var data_index = 0
        var cont_index = 6
        var data : [UInt8] = [UInt8](repeating: 0x00,count: content!.count-1-6)
     
        repeat{
            data[data_index] = content![cont_index]
            data_index += 1
            cont_index += 1
        }while cont_index < content!.count - 1
        
        
        if !parseData(data: data, instruction: instruction) {
            print("data field is invalid")
            return nil
        }
        return instruction
    }
    
    func parseCmd(cmd:UInt8,instruction:Instruction)->Bool{
        if !Instruction.Cmd.verify(cmd: cmd){
            return false
        }
        instruction.cmd = cmd
        return true
    }
    
    func parseData(data:[UInt8],instruction:Instruction)->Bool{
        var body : Body?
        
        switch instruction.getCmd() {
        case Instruction.Cmd.QUERY_BACK://查询指令反馈
            if data[0] == Instruction.RequestType.BOTH || data[0] == Instruction.RequestType.HUM || data[0] == Instruction.RequestType.TEMPERA {
                            print("解析温湿度查询应答报文");
                            if data[1] == 0x00 {
                                body = TemperatureAndHumidityResBody()
                                body!.parseContent(content: data)
                                instruction.body = body
                                body!.setIsAvailable(isavailable: true)
                            } else {
                                print("发送报文不正确 \(data[1])")
                            }
            }else if data[0] == Instruction.RequestType.AIR {
                if data[1] == 0x00 {
                body = AirResBody()
                    body!.parseContent(content:data)
                    instruction.body = body
                    body!.setIsAvailable(isavailable: true)
                }
            }
        case Instruction.Cmd.CONTROL_BACK://控制指令反馈
            print("返回的为控制指令反馈")
            
        default:
            print("")
        }
        

         return body != nil && body!.isAvailable()
    }
}
