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

    @IBAction func didTouchAddContactButton(_ sender: Any) {
        print("didTouchAddContactButton")
    }

    @IBAction func didTouchContactGroupsButton(_ sender: Any) {
        print("didTouchAddContactButton")
    }
}
