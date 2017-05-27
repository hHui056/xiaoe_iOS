import UIKit

//消息类型，我的还是别人的
enum ChatType {
    case mine
    case someone
}

class MessageItem {
    //用户信息
    var user:UserInfo
    //消息时间
    var date:Date
    //消息类型
    var mtype:ChatType
    //内容视图，标签或者图片
    var view:UIView
    //边距
    var insets:UIEdgeInsets
    //录音路径（如果没有则为nil）
    dynamic var recordUrl : URL?
    
    dynamic var recordImageView : UIImageView?
    
    //设置我的文本消息边距
    class func getTextInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:10, bottom:9, right:17)
    }
    
    //设置他人的文本消息边距
    class func getTextInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:15, bottom:9, right:10)
    }
    
    //设置我的图片消息边距
    class func getImageInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:10, bottom:9, right:17)
    }
    
    //设置他人的图片消息边距
    class func getImageInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:15, bottom:9, right:10)
    }
    
    //构造文本消息体
    convenience init(body:NSString, user:UserInfo, date:Date, mtype:ChatType) {
        let font =  UIFont.boldSystemFont(ofSize: 12)
        
        let width =  225, height = 10000.0
        
        let atts =  [NSFontAttributeName: font]
        
        let size =  body.boundingRect(with:
            CGSize(width: CGFloat(width), height: CGFloat(height)),
            options: .usesLineFragmentOrigin, attributes:atts, context:nil)
        
        let label =  UILabel(frame:CGRect(x: 0, y: 0, width: size.size.width,
                                          height: size.size.height))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = (body.length != 0 ? body as String : "")
        label.font = font
        label.backgroundColor = UIColor.clear
        
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ?
            MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:label, insets:insets)
    }
    
    //可以传入更多的自定义视图
    init(user:UserInfo, date:Date, mtype:ChatType, view:UIView, insets:UIEdgeInsets) {
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
    }
    
    
    
    //构造图片消息体
    convenience init(image:UIImage, user:UserInfo,  date:Date, mtype:ChatType) {
        var size = image.size
        //等比缩放
        if (size.width > 220) {
            size.height /= (size.width / 220);
            size.width = 220;
        }
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: size.width,height: size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user:user,  date:date, mtype:mtype, view:imageView, insets:insets)
    }
    
    //构造语音消息体
    convenience init(recordUrl:URL?, user:UserInfo,  date:Date, mtype:ChatType) {        
        let image : UIImage = UIImage(named:("voice_playing_3.png"))!
        var size = image.size
        //等比缩放
        if (size.width > 220) {
            size.height /= (size.width / 220);
            size.width = 220;
        }
        let urlString = recordUrl!.absoluteString
        let length = urlString.getFileSize() //获取语音文件的大小
        print("录音文件大小是：  \(length)")
        print("录音图片的size是: width \(size.width) height \(size.height)")
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: size.width*2.5 ,height: size.height*2))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ?
            MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        var images=[UIImage]()
        for i in 1...3{
            let img=UIImage(named: "voice_playing_\(i)")
            images.append(img!)
        }
        imageView.animationImages = images
        imageView.animationDuration = 1.5  //循环间隔
        imageView.animationRepeatCount=0 //动画循环次数
        self.init(user:user,  date:date, mtype:mtype, view:imageView, insets:insets)
        self.recordUrl = recordUrl
        self.recordImageView = imageView
    }
}
