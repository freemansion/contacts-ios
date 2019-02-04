//
//  ContactProfilePreviewCellTests.swift
//  ContactsTests
//
//  Created by Stanislau Baranouski on 2/5/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Contacts
import ContactModels

class ContactProfilePreviewCellTests: XCTestCase {
    
    var contact1: Person!
    var contact2: Person!
    var record = false
    
    override func setUp() {
        contact1 = Person(id: 1,
                         firstName: "John",
                         lastName: "Doe",
                         email: URL(string: "john.doe@gmail.com")!,
                         mobile: "+66845683412",
                         profileImageURL: URL(string: "/images/missing.png")!,
                         favorite: false,
                         createdAt: Date(),
                         updatedAt: Date())
        contact2 = Person(id: 1,
                          firstName: "Elon",
                          lastName: "Musk",
                          email: URL(string: "elon@musk.com")!,
                          mobile: "+66845683412",
                          profileImageURL: URL(string: "/images/missing.png")!,
                          favorite: true,
                          createdAt: Date(),
                          updatedAt: Date())
    }
    
    override func tearDown() {
        contact1 = nil
        contact2 = nil
    }
    
    func testContactProfilePreviewCell() {
        let cellViewModel1 = ContactProfilePreviewCellViewModel(contact: contact1,
                                                               isUpdatingFavorite: false,
                                                               isUploadingImage: false,
                                                               state: .view,
                                                               avatarImage: nil)
        let cellViewModel2 = ContactProfilePreviewCellViewModel(contact: contact2,
                                                               isUpdatingFavorite: false,
                                                               isUploadingImage: false,
                                                               state: .view,
                                                               avatarImage: nil)
        let nib = R.nib.contactProfilePreviewCell
        let cell = nib.instantiate(withOwner: nil).first as! ContactProfilePreviewCell
        
        cell.configure(with: cellViewModel1)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 269)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 269)), record: record)
        
        cell.configure(with: cellViewModel2)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 269)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 269)), record: record)
    }
    
    func testContactProfileEditCell() {
        let cellViewModel1 = ContactProfilePreviewCellViewModel(contact: nil,
                                                                isUpdatingFavorite: false,
                                                                isUploadingImage: false,
                                                                state: .edit,
                                                                avatarImage: nil)
        let cellViewModel2 = ContactProfilePreviewCellViewModel(contact: contact2,
                                                                isUpdatingFavorite: false,
                                                                isUploadingImage: false,
                                                                state: .edit,
                                                                avatarImage: nil)
        let nib = R.nib.contactProfilePreviewCell
        let cell = nib.instantiate(withOwner: nil).first as! ContactProfilePreviewCell
        
        cell.configure(with: cellViewModel1)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 269)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 269)), record: record)
        
        cell.configure(with: cellViewModel2)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 269)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 269)), record: record)
    }
    
    func testContactProfileAddContactCell() {
        let cellViewModel1 = ContactProfilePreviewCellViewModel(contact: contact1,
                                                                isUpdatingFavorite: false,
                                                                isUploadingImage: false,
                                                                state: .add,
                                                                avatarImage: nil)
        let cellViewModel2 = ContactProfilePreviewCellViewModel(contact: nil,
                                                                isUpdatingFavorite: false,
                                                                isUploadingImage: false,
                                                                state: .add,
                                                                avatarImage: nil)
        let nib = R.nib.contactProfilePreviewCell
        let cell = nib.instantiate(withOwner: nil).first as! ContactProfilePreviewCell
        
        cell.configure(with: cellViewModel1)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 269)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 269)), record: record)
        
        cell.configure(with: cellViewModel2)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 375, height: 269)), record: record)
        assertSnapshot(matching: cell, as: .image(size: .init(width: 320, height: 269)), record: record)
    }
    
}
