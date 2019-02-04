//
//  ContactMainContactCellTests.swift
//  ContactsTests
//
//  Created by Stanislau Baranouski on 2/4/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Contacts
import ContactModels

class ContactMainContactCellTests: XCTestCase {

    var contact1: ContactsListPerson!
    var contact2: ContactsListPerson!
    var record = false

    override func setUp() {
        contact1 = ContactsListPerson(id: 1,
                                     firstName: "John",
                                     lastName: "Doe",
                                     profileImageURL: URL(string: "/images/missing.png")!,
                                     favorite: true,
                                     fullInfoURL: URL(string: "https://young-atoll-90416.herokuapp.com/1.json")!)
        
        contact2 = ContactsListPerson(id: 2,
                                      firstName: "Elon",
                                      lastName: "Musk",
                                      profileImageURL: URL(string: "/images/missing.png")!,
                                      favorite: false,
                                      fullInfoURL: URL(string: "https://young-atoll-90416.herokuapp.com/contacts/1.json")!)
    }

    override func tearDown() {
        contact1 = nil
        contact2 = nil
    }

    func testMainContactCellFavorite() {
        let cellViewModel = ContactsMainContactCellViewModel(groupName: "A",
                                                             contact: contact1,
                                                             placeholderIcon: R.image.contact_avatar_placeholder()!)
        let nib = R.nib.contactsMainContactCell
        let cell = nib.instantiate(withOwner: nil).first as! ContactsMainContactCell
        cell.configure(with: cellViewModel)
        
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 64)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 64)), record: record)
    }
    
    func testMainContactCellNotFavorite() {
        let cellViewModel = ContactsMainContactCellViewModel(groupName: "B",
                                                             contact: contact2,
                                                             placeholderIcon: R.image.contact_avatar_placeholder()!)
        let nib = R.nib.contactsMainContactCell
        let cell = nib.instantiate(withOwner: nil).first as! ContactsMainContactCell
        cell.configure(with: cellViewModel)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 64)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 64)), record: record)
    }

}
