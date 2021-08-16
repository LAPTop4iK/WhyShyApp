//
//  Extensions.swift
//  WhyShy
//
//  Created by Nikita Laptyonok on 04.08.2021.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
    }
    func showLoader(_ show: Bool, withText text: String = "Loading") {
        view.endEditing(true)
        UIViewController.hud.textLabel.text = text
        show ?  UIViewController.hud.show(in: view) :  UIViewController.hud.dismiss()
    }
    
    func configureNavigationBar(withTitle title: String, preferLargeTitle: Bool) {
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        apperance.backgroundColor = UIColor(named: K.mainColor)
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        
        navigationController?.navigationBar.prefersLargeTitles = preferLargeTitle
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true //Полупрозрачный
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
