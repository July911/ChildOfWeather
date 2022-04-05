import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    
    func SearchViewController(
        _ viewController: SearchViewController,
        didSelectCell infomation: City
    )
}

