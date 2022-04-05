import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    
    func searchViewController(
        _ viewController: SearchViewController,
        didSelectCell infomation: City
    )
    
    func searchViewController(
    _ viewController: SearchViewController,
    textInput text: String
    )
}

