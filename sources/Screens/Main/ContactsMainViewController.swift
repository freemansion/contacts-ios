//
//  ContactListViewController.swift
//  Contacts
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class ContactsMainViewController: UIViewController, UIStoryboardIdentifiable {

    @IBOutlet private weak var groupsBarButton: UIBarButtonItem!
    @IBOutlet private weak var addBarButton: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!
    private lazy var screenViewModel: ContactsMainScreenViewModelType = {
        let viewModel = ContactsMainScreenViewModel()
        viewModel.delegate = self
        return viewModel
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        screenViewModel.actions.viewWillAppear()
    }

    private func configureView() {
        navigationItem.title = screenViewModel.dataSource.screenTitle
    }
    
    @IBAction func didTouchAddContactButton(_ sender: Any) {
        print("didTouchAddContactButton")
    }

    @IBAction func didTouchContactGroupsButton(_ sender: Any) {
        print("didTouchAddContactButton")
    }

    static func makeInstance() -> ContactsMainViewController {
        return Storyboard.Main.instantiate(viewControllerType: ContactsMainViewController.self)
    }
}

extension ContactsMainViewController: ContactsMainScreenViewModelDelegate {

}
