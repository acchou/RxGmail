import GoogleAPIClientForREST
import RxGmail

var global = Global()

struct Global {
    var gmailService: GTLRGmailService
    var rxGmail: RxGmail
    var labelViewModel: LabelViewModelType
}

extension Global {
    init(gmailService: GTLRGmailService? = nil,
         rxGmail: RxGmail? = nil,
         labelViewModel: LabelViewModelType? = nil) {
        let gmailService = gmailService ?? GTLRGmailService()
        let rxGmail = rxGmail ?? RxGmail(gmailService: gmailService)
        let labelViewModel = labelViewModel ?? LabelViewModel(rxGmail: rxGmail)

        self.init(gmailService: gmailService, rxGmail: rxGmail, labelViewModel: labelViewModel)
    }
}

protocol LabelViewModelInjector { }
extension LabelViewModelInjector {
    var labelViewModel: LabelViewModelType { return global.labelViewModel }
}
