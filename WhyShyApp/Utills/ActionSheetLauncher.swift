//
//  ActionSheetLauncher.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 14.08.2021.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: AnyObject {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate: ActionSheetLauncherDelegate?
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [cancelButton.heightAnchor.constraint(equalToConstant: K.Sizes.actionSheetCancelButtonHeight),
             cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
             cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
             cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        cancelButton.layer.cornerRadius = K.Sizes.actionSheetCancelButtonHeight / 2
        
       return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Licecycle
    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        }
    }
    
    // MARK: - Helpers
    
    func showTableView(_ shoulShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        let y = shoulShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.bounds
        
        window.addSubview(tableView)
        let height = CGFloat(viewModel.options.count * Int(K.Sizes.actionSheetRowHeight)) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height,
                                 width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    
    func configureTableView(){
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = K.Sizes.actionSheetRowHeight
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
    }
}

// MARK: - UITableViewDataSource

extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: { _ in
            self.delegate?.didSelect(option: option)
        }
        
    }
    
}
