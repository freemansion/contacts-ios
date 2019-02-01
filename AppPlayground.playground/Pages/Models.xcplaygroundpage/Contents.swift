import Foundation
import ContactModels

// In order to execute this Playground page make sure you've built `ContactModels` framework
// or select `contacts-ios` build scheme and press '⌘ B'

let profileImageURL = URL(string: "https://bit.ly/2RuUQuM")!
let fullInfoURL = URL(string: "http://young-atoll-90416.herokuapp.com/contacts/3002.json")!
let email = URL(string: "john.doe@gmail.com")!

let contactPerson = ContactsListPerson(id: 1,
                                       firstName: "John",
                                       lastName: "Doe",
                                       profileImageURL: profileImageURL,
                                       favorite: true,
                                       fullInfoURL: fullInfoURL)
print(contactPerson.fullName)

let person = Person(id: 1,
                    firstName: "John",
                    lastName: "Doe",
                    email: email,
                    profileImageURL: profileImageURL,
                    favorite: true,
                    createdAt: Date(),
                    updatedAt: Date())
print(person.fullName)
