

import UIKit
import EZSwiftExtensions

typealias AlertBlock = (_ success: AlertTag) -> ()

enum AlertTag {
    case done
    case yes
    case no
}

class Alerts: NSObject {
    static let shared = Alerts()
    func show(alert title : TitleType , message : String? , type : ISAlertType){
        ISMessages.hideAlert(animated: true)
        ez.runThisAfterDelay(seconds: 0.2) {
            ISMessages.showCardAlert(withTitle: title.localized , message: /message , duration: 3.0 , hideOnSwipe: true , hideOnTap: true , alertType: type , alertPosition: .top , didHide: nil)
        }
    }
    
}



    

