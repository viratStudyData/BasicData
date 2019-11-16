
import UIKit
import EZSwiftExtensions

class AlertsClass: NSObject,FCAlertViewDelegate{
    
    static let shared = AlertsClass()
    var responseBack : AlertBlock?
    var alertView: FCAlertView = {
        let alert = FCAlertView()
        alert.dismissOnOutsideTouch = true
        return alert
    }()
    
    override init() {
        super.init()
    }
    
    //MARK: Alert Controller
    func showAlertController(withTitle title : String?, message : String, buttonTitles : [String], responseBlock : @escaping AlertBlock){
        
        alertView.dismissAlertView()
        alertView = FCAlertView()
        alertView.delegate = self
        responseBack = responseBlock
        alertView.colorScheme = UIColor.theme
        alertView.numberOfButtons = buttonTitles.count
        
        buttonTitles.count > 0 ? (alertView.hideDoneButton = true) : (alertView.hideDoneButton = false)
        alertView.showAlert(inView: ez.topMostVC, withTitle: title, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: buttonTitles.count > 0 ? buttonTitles : nil)

    }
    
    func alertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        switch index {
        case 0:
            responseBack?(.yes)
        case 1:
            responseBack?(.no)
        default: return
        }
    }
    
}

