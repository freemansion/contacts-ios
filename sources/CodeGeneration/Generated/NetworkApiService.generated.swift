// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension NetworkApiService {
    var requestData: RequestDataProvidable {
        switch self {
            case .fetchAllContacts(let request):
                return request
            case .fetchContact(let request):
                return request
            case .createContact(let request):
                return request
            case .updateContact(let request):
                return request
            case .deleteContact(let request):
                return request
        }
    }
}


