//
//  RootCoordinator.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

final class RootCoordinator {
    private lazy var rootViewController: ContactsMainViewController = {
        let vc = ContactsMainViewController.makeInstance()
        vc.output = self
        return vc
    }()

    private lazy var rootNavigationController: UINavigationController = {
        return UINavigationController(rootViewController: rootViewController)
    }()

    private(set) var window: UIWindow?

    func instantiateWindow(makeKeyAndVisible: Bool) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootNavigationController
        if makeKeyAndVisible {
            window.makeKeyAndVisible()
        }
        self.window = window
        return window
    }
}

extension RootCoordinator: ContactsMainOutput {
    func didTouchAddContact(viewController: ContactsMainViewController) {
        let contactViewController = ContactViewController.makeInstance(mode: .addNew)
        contactViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: contactViewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        viewController.present(navigationController, animated: true)
    }

    func showDetailsOfContact(_ contactId: Int, viewController: ContactsMainViewController) {
        let toViewController = ContactViewController.makeInstance(mode: .view(contactId: contactId))
        toViewController.delegate = self
        rootNavigationController.pushViewController(toViewController, animated: true)
    }
}

extension RootCoordinator: ContactViewControllerDelegate {
    func contactViewDidTouchCancel(viewController: ContactViewController, mode: ContactScreenViewModel.Mode) {
        switch mode {
        case .addNew:
            viewController.navigationController?.dismiss(animated: true)
        case .view, .edit:
            viewController.navigationController?.popViewController(animated: true)
        }
    }

    func contactViewDidCreateNewContact(viewController: ContactViewController) {
        viewController.navigationController?.dismiss(animated: true)
    }

    func contactViewFailedToLoadContact(viewController: ContactViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }

    func contactViewDidDeleteContact(viewController: ContactViewController) {
        viewController.navigationController?.popViewController(animated: true)
        rootViewController.setNeedRefetchData()
    }
}
