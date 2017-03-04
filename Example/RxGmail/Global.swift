import GoogleAPIClientForREST
import RxGmail

var global = Global()

struct Global {
    var gmailService: GTLRGmailService
    var rxGmail: RxGmail
    var labelViewModel: LabelViewModelType
    var messagesViewModel: MessagesViewModelType
}

extension Global {
    init(gmailService: GTLRGmailService? = nil,
         rxGmail: RxGmail? = nil,
         labelViewModel: LabelViewModelType? = nil,
         messagesViewModel: MessagesViewModelType? = nil) {
        let gmailService = gmailService ?? GTLRGmailService()
        let rxGmail = rxGmail ?? RxGmail(gmailService: gmailService)
        let labelViewModel = labelViewModel ?? LabelViewModel(rxGmail: rxGmail)
        let messagesViewModel = messagesViewModel ?? MessagesViewModel(rxGmail: rxGmail)

        self.init (
            gmailService: gmailService,
            rxGmail: rxGmail,
            labelViewModel: labelViewModel,
            messagesViewModel: messagesViewModel
        )
    }
}

protocol LabelViewModelInjector { }
extension LabelViewModelInjector {
    var labelViewModel: LabelViewModelType { return global.labelViewModel }
}


protocol MessagesViewModelInjector { }
extension MessagesViewModelInjector {
    var messagesViewModel: MessagesViewModelType { return global.messagesViewModel }
}
