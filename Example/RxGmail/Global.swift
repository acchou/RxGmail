import GoogleAPIClientForREST
import RxGmail

var global = Global()

struct Global {
    var gmailService: GTLRGmailService
    var rxGmail: RxGmail
    var labelViewModel: LabelViewModelType
    var labelDetailViewModel: LabelDetailViewModelType
    var messagesViewModel: MessagesViewModelType
}

extension Global {
    init(gmailService: GTLRGmailService? = nil,
         rxGmail: RxGmail? = nil,
         labelViewModel: LabelViewModelType? = nil,
         labelDetailViewModel: LabelDetailViewModelType? = nil,
         messagesViewModel: MessagesViewModelType? = nil) {

        let gmailService = gmailService ?? GTLRGmailService()
        let rxGmail = rxGmail ?? RxGmail(gmailService: gmailService)
        let labelViewModel = labelViewModel ?? LabelViewModel(rxGmail: rxGmail)
        let labelDetailViewModel = labelDetailViewModel ?? LabelDetailViewModel(rxGmail: rxGmail)
        let messagesViewModel = messagesViewModel ?? MessagesViewModel(rxGmail: rxGmail)

        self.init (
            gmailService: gmailService,
            rxGmail: rxGmail,
            labelViewModel: labelViewModel,
            labelDetailViewModel: labelDetailViewModel,
            messagesViewModel: messagesViewModel
        )
    }
}
