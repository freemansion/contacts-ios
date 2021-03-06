import Foundation
import ContactModels
import ContactsNetwork
import Alamofire
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// In order to execute this Playground page make sure you've built `ContactModels` and `ContactsNetwork` target
// alternatively - you can select `contacts-ios` build scheme and press '⌘ B'

// Setup environment
let url = URL(string: "https://young-atoll-90416.herokuapp.com")!
let env = Environment.development(baseURL: url)
NetworkApiService.setupEnvironment(usingEnv: env)

let performFetchContacts = true
let performFetchContact = false

if performFetchContacts {
    let request = FetchContactsRequest()
    DataProvider.shared.request(.fetchAllContacts(request), source: .network) { (result: Result<[ContactsListPerson]>) in
        switch result {
        case .success(let contacts):
            print(contacts.map { $0.fullName })
        case .failure(let error):
            print(error.localizedDescription)
        }
        PlaygroundPage.current.finishExecution()
    }
}

if performFetchContact {
    let request = FetchContactRequest(contactId: 3366)
    DataProvider.shared.request(.fetchContact(request), source: .sampleData) { (result: Result<Person>) in
        switch result {
        case .success(let contact):
            print("\(contact.fullName)\n\(contact.email)")
        case .failure(let error):
            print(error.localizedDescription)
        }
        PlaygroundPage.current.finishExecution()
    }
}


