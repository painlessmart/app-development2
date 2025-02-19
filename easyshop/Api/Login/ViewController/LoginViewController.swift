//
//  LoginViewController.swift
//  easyshop
//
//  Created by Ali Ghanavati on 3/23/1398 AP.
//  Copyright © 1398 AP Ali Ghanavati. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            txtUsername.text = "aliali3684@gmail.com"
            txtPassword.text = "Ali@218802@Ali"
        #endif

    }
    
    @IBAction func btnLogin(_ sender: LoadingButton) {
        self.login(work_email: txtUsername.text ?? "" , password: txtPassword.text ?? "" )
    }
    
    
    // MARK: - Networking In View Model
    private func login(work_email : String , password : String) {
        // MARK: - Injection
        let viewModel = LoginViewModel(dataService: DataServiceLogin())
        
        viewModel.Login(work_email: work_email, password: password)
        viewModel.updateLoadingStatus = {
            let _ = viewModel.isLoading ? self.btnLogin.showLoading() : self.btnLogin.hideLoading()
        }
        viewModel.showAlertClosure = {
            if viewModel.error != nil{
                guard let errorMessage = viewModel.error as? errorWithMessage else {
                    guard let errorAf = viewModel.error as? Alamofire.AFError else {
                        AlertShowWithoutView.sharedInstance.showAlert(title: "Error".localize() , message: "Error".localize() )
                        return
                    }
                    AlertShowWithoutView.sharedInstance.showAlert(title: "Error".localize() , message: errorAf.localizedDescription )
                    return
                }
                AlertShowWithoutView.sharedInstance.showAlert(title: "Error".localize() , message: errorMessage.localizedDescription )
            }
        }
        
        viewModel.didFinishFetch = {
            if viewModel.error == nil{
                MyProperties.sharedInstance.setToken(token: viewModel.model?.accessToken ?? "")
                MyProperties.sharedInstance.setRefreshToken(refreshToken: viewModel.model?.refreshToken ?? "")
                MyProperties.sharedInstance.setUserId(userId: viewModel.model?.uid ?? 0)
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
        }
    }
  

}
