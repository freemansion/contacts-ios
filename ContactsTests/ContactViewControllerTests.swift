//
//  ContactViewControllerTests.swift
//  ContactsTests
//
//  Created by Stanislau Baranouski on 2/5/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Contacts
import ContactModels

class ContactViewControllerTests: XCTestCase {

    var contact: Person!
    var record = false
    
    override func setUp() {
        contact = Person(id: 1,
                         firstName: "Elon",
                         lastName: "Musk",
                         email: URL(string: "elon@musk.com")!,
                         mobile: "+66845683412",
                         profileImageURL: URL(string: "https://bit.ly/2TrtYxv")!,
                         favorite: true,
                         createdAt: Date(),
                         updatedAt: Date())
    }

    override func tearDown() {
        contact = nil
    }

    func testAddNewContact() {
        let vc = ContactViewController.makeInstance(mode: .addNew)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: record)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneSe), record: record)
    }

    func testEditNewContact() {
        let vc = ContactViewController.makeInstance(mode: .edit(contactId: contact.id))
        vc.screenViewModel.actions.setContact(contact)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: record)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneSe), record: record)
    }
    
    func testViewContact() {
        let vc = ContactViewController.makeInstance(mode: .view(contactId: contact.id))
        vc.screenViewModel.actions.setContact(contact)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: record)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneSe), record: record)
    }

}
