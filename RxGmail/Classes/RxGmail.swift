import GoogleAPIClientForREST
import RxSwift
import RxSwiftExt

// Protocols used to retroactively model all paged query types in the Gmail API.

public protocol PagedQuery {
    var pageToken: String? { get set }
}

public protocol PagedResponse {
    var nextPageToken: String? { get }
}

extension RxGmail.MessageListQuery: PagedQuery { }
extension RxGmail.MessageListResponse: PagedResponse { }

extension RxGmail.DraftsListQuery: PagedQuery { }
extension RxGmail.DraftsListResponse: PagedResponse { }

extension RxGmail.HistoryQuery: PagedQuery { }
extension RxGmail.HistoryResponse: PagedResponse { }

extension RxGmail.ThreadListQuery: PagedQuery { }
extension RxGmail.ThreadListResponse: PagedResponse { }

extension Observable where Element: RxGmail.Response {
    /**
     Override of Observable.debug for GTLRObjects prints a json string.
     */
    public func debug(_ identifier: String? = "", trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) -> Observable<E> {
        let identifier = identifier ?? ""
        let prefix = "\(function) \(identifier) ->"
        return self.do (
            onNext: { print("\(prefix) next \($0.jsonString())") },
            onError: { print("\(prefix) error \($0.localizedDescription)") },
            onCompleted: { print("\(prefix) *completed*") },
            onSubscribe: { print("\(prefix) *subscribed*") },
            onDispose: { print("\(prefix) *disposed*") }
        )
    }
}

public class RxGmail {
    let service: GTLRGmailService

    public init(gmailService: GTLRGmailService) {
        GTMSessionFetcher.setLoggingEnabled(true)
        self.service = gmailService
    }

    // MARK: - Types
    public typealias GmailService = GTLRGmailService
    public typealias QueryType = GTLRQueryProtocol
    public typealias Query = GTLRQuery
    public typealias Response = GTLRObject
    public typealias BatchQuery = GTLRBatchQuery
    public typealias BatchResult = GTLRBatchResult
    public typealias ServiceTicket = GTLRServiceTicket
    public typealias UploadParameters = GTLRUploadParameters

    public typealias ErrorObject = GTLRErrorObject
    public typealias ErrorObjectDetail = GTLRErrorObjectDetail
    public typealias ErrorObjectItem = GTLRErrorObjectErrorItem

    public typealias Label = GTLRGmail_Label
    public typealias LabelsListQuery = GTLRGmailQuery_UsersLabelsList
    public typealias LabelsListResponse = GTLRGmail_ListLabelsResponse
    public typealias LabelsCreateQuery = GTLRGmailQuery_UsersLabelsCreate
    public typealias LabelsDeleteQuery = GTLRGmailQuery_UsersLabelsDelete
    public typealias LabelsGetQuery = GTLRGmailQuery_UsersLabelsGet
    public typealias LabelsPatchQuery = GTLRGmailQuery_UsersLabelsPatch
    public typealias LabelsUpdateQuery = GTLRGmailQuery_UsersLabelsUpdate

    public typealias Message = GTLRGmail_Message
    public typealias MessagePartBody = GTLRGmail_MessagePartBody
    public typealias MessagePart = GTLRGmail_MessagePart
    public typealias MessagePartHeader = GTLRGmail_MessagePartHeader
    public typealias MessageListQuery = GTLRGmailQuery_UsersMessagesList
    public typealias MessageListResponse = GTLRGmail_ListMessagesResponse
    public typealias MessageBatchDeleteQuery = GTLRGmailQuery_UsersMessagesBatchDelete
    public typealias MessageBatchDeleteRequest = GTLRGmail_BatchDeleteMessagesRequest
    public typealias MessageBatchModifyQuery = GTLRGmailQuery_UsersMessagesBatchModify
    public typealias MessageBatchModifyRequest = GTLRGmail_BatchModifyMessagesRequest
    public typealias MessageDeleteQuery = GTLRGmailQuery_UsersMessagesDelete
    public typealias MessageGetQuery = GTLRGmailQuery_UsersMessagesGet
    public typealias MessageImportQuery = GTLRGmailQuery_UsersMessagesImport
    public typealias MessageInsertQuery = GTLRGmailQuery_UsersMessagesInsert
    public typealias MessageModifyQuery = GTLRGmailQuery_UsersMessagesModify
    public typealias MessageModifyRequest = GTLRGmail_ModifyMessageRequest
    public typealias MessageSendQuery = GTLRGmailQuery_UsersMessagesSend
    public typealias MessageTrashQuery = GTLRGmailQuery_UsersMessagesTrash
    public typealias MessageUntrashQuery = GTLRGmailQuery_UsersMessagesUntrash
    public typealias MessageAttachmentQuery = GTLRGmailQuery_UsersMessagesAttachmentsGet

    public typealias Profile = GTLRGmail_Profile
    public typealias ProfileQuery = GTLRGmailQuery_UsersGetProfile

    public typealias WatchRequest = GTLRGmail_WatchRequest
    public typealias WatchResponse = GTLRGmail_WatchResponse
    public typealias WatchStartQuery = GTLRGmailQuery_UsersWatch
    public typealias WatchStopQuery = GTLRGmailQuery_UsersStop

    public typealias Draft = GTLRGmail_Draft
    public typealias DraftsCreateQuery = GTLRGmailQuery_UsersDraftsCreate
    public typealias DraftsDeleteQuery = GTLRGmailQuery_UsersDraftsDelete
    public typealias DraftsGetQuery = GTLRGmailQuery_UsersDraftsGet
    public typealias DraftsListQuery = GTLRGmailQuery_UsersDraftsList
    public typealias DraftsListResponse = GTLRGmail_ListDraftsResponse
    public typealias DraftsSendQuery = GTLRGmailQuery_UsersDraftsSend
    public typealias DraftsUpdateQuery = GTLRGmailQuery_UsersDraftsUpdate

    public typealias HistoryQuery = GTLRGmailQuery_UsersHistoryList
    public typealias HistoryResponse = GTLRGmail_ListHistoryResponse

    public typealias SettingsAutoForwardingQuery = GTLRGmailQuery_UsersSettingsGetAutoForwarding
    public typealias SettingsAutoForwarding = GTLRGmail_AutoForwarding
    public typealias SettingsAutoForwardingUpdateQuery = GTLRGmailQuery_UsersSettingsUpdateAutoForwarding
    public typealias SettingsImapQuery = GTLRGmailQuery_UsersSettingsGetImap
    public typealias SettingsImapUpdateQuery = GTLRGmailQuery_UsersSettingsUpdateImap
    public typealias SettingsImap = GTLRGmail_ImapSettings
    public typealias SettingsPopQuery = GTLRGmailQuery_UsersSettingsGetPop
    public typealias SettingsPopUpdateQuery = GTLRGmailQuery_UsersSettingsUpdatePop
    public typealias SettingsPop = GTLRGmail_PopSettings
    public typealias SettingsVacationQuery = GTLRGmailQuery_UsersSettingsGetVacation
    public typealias SettingsVacationUpdateQuery = GTLRGmailQuery_UsersSettingsUpdateVacation
    public typealias SettingsVacation = GTLRGmail_VacationSettings

    public typealias FilterCreateQuery = GTLRGmailQuery_UsersSettingsFiltersCreate
    public typealias Filter = GTLRGmail_Filter
    public typealias FilterGetQuery = GTLRGmailQuery_UsersSettingsFiltersGet
    public typealias FilterDeleteQuery = GTLRGmailQuery_UsersSettingsFiltersDelete
    public typealias FilterListQuery = GTLRGmailQuery_UsersSettingsFiltersList
    public typealias FilterListResponse = GTLRGmail_ListFiltersResponse

    public typealias ForwardingAddress = GTLRGmail_ForwardingAddress
    public typealias ForwardingAddressGetQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesGet
    public typealias ForwardingAddressDeleteQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesDelete
    public typealias ForwardingAddressCreateQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesCreate
    public typealias ForwardingAddressListQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesList
    public typealias ForwardingAddressListResponse = GTLRGmail_ListForwardingAddressesResponse

    public typealias SendAsAlias = GTLRGmail_SendAs
    public typealias SendAsListResponse = GTLRGmail_ListSendAsResponse
    public typealias SendAsGetQuery = GTLRGmailQuery_UsersSettingsSendAsGet
    public typealias SendAsListQuery = GTLRGmailQuery_UsersSettingsSendAsList
    public typealias SendAsPatchQuery = GTLRGmailQuery_UsersSettingsSendAsPatch
    public typealias SendAsCreateQuery = GTLRGmailQuery_UsersSettingsSendAsCreate
    public typealias SendAsDeleteQuery = GTLRGmailQuery_UsersSettingsSendAsDelete
    public typealias SendAsUpdateQuery = GTLRGmailQuery_UsersSettingsSendAsUpdate
    public typealias SendAsVerifyQuery = GTLRGmailQuery_UsersSettingsSendAsVerify

    public typealias ThreadListQuery = GTLRGmailQuery_UsersThreadsList
    public typealias ThreadListResponse = GTLRGmail_ListThreadsResponse
    public typealias Thread = GTLRGmail_Thread
    public typealias ThreadModifyRequest = GTLRGmail_ModifyThreadRequest
    public typealias ThreadGetQuery = GTLRGmailQuery_UsersThreadsGet
    public typealias ThreadTrashQuery = GTLRGmailQuery_UsersThreadsTrash
    public typealias ThreadDeleteQuery = GTLRGmailQuery_UsersThreadsDelete
    public typealias ThreadModifyQuery = GTLRGmailQuery_UsersThreadsModify
    public typealias ThreadUntrashQuery = GTLRGmailQuery_UsersThreadsUntrash

    // MARK: - Generic request helper functions
    fileprivate func createRequest(observer: AnyObserver<Any?>, query: QueryType) -> ServiceTicket {
        let serviceTicket = service.executeQuery(query) { ticket, object, error in
            if let error = error {
                observer.onError(error)
            } else {
                observer.onNext(object)
                observer.onCompleted()
            }
        }
        return serviceTicket
    }

    /**
     Execute a query.

     - Parameter query: the query to execute.
     - Returns: An observable with the fetched response. This variant of `execute` returns an optional, which will be `nil` only for queries that explicitly return `nil` to signal success. Most responses will return an instance of `GTLRObject`.

     */
    public func execute<R: Response>(query: QueryType) -> Observable<R?> {
        return Observable<Any?>.create { [weak self] observer in
            let serviceTicket = self?.createRequest(observer: observer, query: query)
            return Disposables.create {
                serviceTicket?.cancel()
            }
        }
        .map { $0 as! R? }
        .shareReplayLatestWhileConnected()
    }

    /**
     Execute a query.

     - Parameter query: the query to execute.
     - Returns: an instance of GTLRObject fetched by the query upon success.
     */
    public func execute<R: Response>(query: QueryType) -> Observable<R> {
        return execute(query: query).map { $0! }
    }

    public func execute(query: QueryType) -> Observable<Void> {
        let response: Observable<Response?> = execute(query: query)
        return response.map { _ in () }
    }

    /**
     Execute a query returning a paged response.

     - Parameter query: the query to execute, the result of the query should
     be a paged response.

     - Returns: an observable that sends one event per page.
     */
    public func executePaged<Q, R>(query: Q) -> Observable<R>
        where Q: QueryType, Q: PagedQuery, R: Response, R: PagedResponse {
            func getRemainingPages(after previousPage: R?) -> Observable<R> {
                let nextPageToken = previousPage?.nextPageToken
                if previousPage != nil && nextPageToken == nil {
                    return .empty()
                }
                var query = query.copy() as! Q
                query.pageToken = nextPageToken
                let response: Observable<R> = execute(query: query)
                return response.flatMap { page -> Observable<R> in
                    return Observable.just(page).concat(getRemainingPages(after: page))
                }
            }
            return getRemainingPages(after: nil)
                .shareReplayLatestWhileConnected()
    }

    // MARK: - Users

    public func getProfile(forUserId userId: String = "me") -> Observable<Profile> {
        let query = ProfileQuery.query(withUserId: userId)
        return getProfile(query: query)
    }

    public func getProfile(query: ProfileQuery) -> Observable<Profile> {
        return execute(query: query)
    }

    public func watchRequest(request: WatchRequest, forUserId userId: String = "me") -> Observable<WatchResponse> {
        let query = WatchStartQuery.query(withObject: request, userId: userId)
        return watchRequest(query: query)
    }

    public func watchRequest(query: WatchStartQuery) -> Observable<WatchResponse> {
        return execute(query: query)
    }

    public func stopNotifications(forUserId userId: String = "me") -> Observable<Void> {
        let query = WatchStopQuery.query(withUserId: userId)
        return stopNotifications(query: query)
    }

    public func stopNotifications(query: WatchStopQuery) -> Observable<Void> {
        return execute(query: query)
    }

    // MARK: - Drafts

    public func createDraft(draft: Draft, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Draft> {
        let query = DraftsCreateQuery.query(withObject: draft, userId: userId, uploadParameters: uploadParameters)
        return createDraft(query: query)
    }

    public func createDraft(query: DraftsCreateQuery) -> Observable<Draft> {
        return execute(query: query)
    }

    public func deleteDraft(draftID: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = DraftsDeleteQuery.query(withUserId: userId, identifier: draftID)
        return deleteDraft(query: query)
    }

    public func deleteDraft(query: DraftsDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func getDraft(draftID: String, format: String? = nil, forUserId userId: String = "me") -> Observable<Draft> {
        let query = DraftsGetQuery.query(withUserId: userId, identifier: draftID)
        query.format = format
        return getDraft(query: query)
    }

    public func getDraft(query: DraftsGetQuery) -> Observable<Draft> {
        return execute(query: query)
    }

    public func listDrafts(forUserId userId: String = "me") -> Observable<DraftsListResponse> {
        let query = DraftsListQuery.query(withUserId: userId)
        return listDrafts(query: query)
    }

    public func listDrafts(query: DraftsListQuery) -> Observable<DraftsListResponse> {
        return executePaged(query: query)
    }

    public func sendDraft(draft: Draft, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = DraftsSendQuery.query(withObject: draft, userId: userId, uploadParameters: uploadParameters)
        return sendDraft(query: query)
    }

    public func sendDraft(query: DraftsSendQuery) -> Observable<Message> {
        return execute(query: query)
    }

    public func updateDraft(draftID: String, draft: Draft, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Draft> {
        let query = DraftsUpdateQuery.query(withObject: draft, userId: userId, identifier: draftID, uploadParameters: uploadParameters)
        return updateDraft(query: query)
    }

    public func updateDraft(query: DraftsUpdateQuery) -> Observable<Draft> {
        return execute(query: query)
    }

    // MARK: - History

    public func history(startHistoryId: UInt64, forUserId userId: String = "me") -> Observable<HistoryResponse> {
        let query = HistoryQuery.query(withUserId: userId)
        query.startHistoryId = startHistoryId
        return history(query: query)
    }

    public func history(query: HistoryQuery) -> Observable<HistoryResponse> {
        return executePaged(query: query)
    }

    // MARK: - Labels

    public func listLabels(forUserId userId: String = "me") -> Observable<LabelsListResponse> {
        let query = LabelsListQuery.query(withUserId: userId)
        return self.listLabels(query: query)
    }

    public func listLabels(query: LabelsListQuery) -> Observable<LabelsListResponse> {
        return execute(query: query)
    }

    public func createLabel(label: Label, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsCreateQuery.query(withObject: label, userId: userId)
        return createLabel(query: query)
    }

    public func createLabel(query: LabelsCreateQuery) -> Observable<Label> {
        return execute(query: query)
    }

    public func deleteLabel(labelId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = LabelsDeleteQuery.query(withUserId: userId, identifier: labelId)
        return deleteLabel(query: query)
    }

    public func deleteLabel(query: LabelsDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func getLabel(labelId: String, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsGetQuery.query(withUserId: userId, identifier: labelId)
        return getLabel(query: query)
    }

    public func getLabel(query: LabelsGetQuery) -> Observable<Label> {
        return execute(query: query)
    }

    public func patchLabel(labelId: String, updatedLabel: Label, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsPatchQuery.query(withObject: updatedLabel, userId: userId, identifier: userId)
        return patchLabel(query: query)
    }

    public func patchLabel(query: LabelsPatchQuery) -> Observable<Label> {
        return execute(query: query)
    }

    public func updateLabel(labelId: String, updatedLabel: Label, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsUpdateQuery.query(withObject: updatedLabel, userId: userId, identifier: labelId)
        return updateLabel(query: query)
    }

    public func updateLabel(query: LabelsUpdateQuery) -> Observable<Label> {
        return execute(query: query)
    }

    // MARK: - Messages

    // Each event returns a page of messages.
    public func listMessages(forUserId userId: String = "me") -> Observable<MessageListResponse> {
        let query = MessageListQuery.query(withUserId: userId)
        return listMessages(query: query)
    }

    public func listMessages(query: MessageListQuery) -> Observable<MessageListResponse> {
        return executePaged(query: query)
    }

    public func batchDeleteMessages(request: MessageBatchDeleteRequest, forUserId userId: String = "me") -> Observable<Void> {
        let query = MessageBatchDeleteQuery.query(withObject: request, userId: userId)
        return batchDeleteMessages(query: query)
    }

    public func batchDeleteMessages(query: MessageBatchDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func batchModifyMessages(request: MessageBatchModifyRequest, forUserId userId: String = "me") -> Observable<Void> {
        let query = MessageBatchModifyQuery.query(withObject: request, userId: userId)
        return batchModifyMessages(query: query)
    }

    public func batchModifyMessages(query: MessageBatchModifyQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func deleteMessage(messageId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = MessageDeleteQuery.query(withUserId: userId, identifier: messageId)
        return deleteMessage(query: query)
    }

    public func deleteMessage(query: MessageDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func getMessage(messageId: String, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageGetQuery.query(withUserId: userId, identifier: messageId)
        return getMessage(query: query)
    }

    public func getMessage(query: MessageGetQuery) -> Observable<Message> {
        return execute(query: query)
    }

    public func importMessage(message: Message, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageImportQuery.query(withObject: message, userId: userId, uploadParameters: uploadParameters)
        return importMessage(query: query)
    }

    public func importMessage(query: MessageImportQuery) -> Observable<Message> {
        return execute(query: query)
    }

    public func insertMessage(message: Message, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageInsertQuery.query(withObject: message, userId: userId, uploadParameters: uploadParameters)
        return insertMessage(query: query)
    }

    public func insertMessage(query: MessageInsertQuery) -> Observable<Message> {
        return execute(query: query)
    }

    public func modifyMessage(messageId: String, request: MessageModifyRequest, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageModifyQuery.query(withObject: request, userId: userId, identifier: messageId)
        return modifyMessage(query: query)
    }

    public func modifyMessage(query: MessageModifyQuery) -> Observable<Message> {
        return execute(query: query)
    }

    public func sendMessage(message: Message, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageSendQuery.query(withObject: message, userId: userId, uploadParameters: uploadParameters)
        return sendMessage(query: query)
    }

    public func sendMessage(query: MessageSendQuery) -> Observable<Message> {
        return execute(query: query)
    }

    public func trashMessage(messageId: String, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageTrashQuery.query(withUserId: userId, identifier: messageId)
        return trashMessage(query: query)
    }

    public func trashMessage(query: MessageTrashQuery) -> Observable<Message> {
        return execute(query: query)
    }

    public func untrashMessage(messageId: String, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageUntrashQuery.query(withUserId: userId, identifier: messageId)
        return untrashMessage(query: query)
    }

    public func untrashMessage(query: MessageUntrashQuery) -> Observable<Message> {
        return execute(query: query)
    }

    // MARK: - Attachments
    public func getAttachments(messageId: String, attachmentId: String, forUserId userId: String = "me") ->  Observable<MessagePartBody> {
        let query = MessageAttachmentQuery.query(withUserId: userId, messageId: messageId, identifier: attachmentId)
        return getAttachments(query: query)
    }

    public func getAttachments(query: MessageAttachmentQuery) -> Observable<MessagePartBody> {
        return execute(query: query)
    }

    // Mark: - Settings
    public func getAutoForwarding(forUserId userId: String = "me") -> Observable<SettingsAutoForwarding> {
        let query = SettingsAutoForwardingQuery.query(withUserId: userId)
        return getAutoForwarding(query: query)
    }

    public func getAutoForwarding(query: SettingsAutoForwardingQuery) -> Observable<SettingsAutoForwarding> {
        return execute(query: query)
    }

    public func updateAutoForwarding(forwardingSettings: SettingsAutoForwarding, forUserId userId: String = "me") -> Observable<SettingsAutoForwarding> {
        let query = SettingsAutoForwardingUpdateQuery.query(withObject: forwardingSettings, userId: userId)
        return updateAutoForwarding(query: query)
    }

    public func updateAutoForwarding(query: SettingsAutoForwardingUpdateQuery) -> Observable<SettingsAutoForwarding> {
        return execute(query: query)
    }

    public func getImap(forUserId userId: String = "me") -> Observable<SettingsImap> {
        let query = SettingsImapQuery.query(withUserId: userId)
        return getImap(query: query)
    }

    public func getImap(query: SettingsImapQuery) -> Observable<SettingsImap> {
        return execute(query: query)
    }

    public func updateImap(imapSettings: SettingsImap, forUserId userId: String = "me") -> Observable<SettingsImap> {
        let query = SettingsImapUpdateQuery.query(withObject: imapSettings, userId: userId)
        return updateImap(query: query)
    }

    public func updateImap(query: SettingsImapUpdateQuery) -> Observable<SettingsImap> {
        return execute(query: query)
    }

    public func getPop(forUserId userId: String = "me") -> Observable<SettingsPop> {
        let query = SettingsPopQuery.query(withUserId: userId)
        return getPop(query: query)
    }

    public func getPop(query: SettingsPopQuery) -> Observable<SettingsPop> {
        return execute(query: query)
    }

    public func updatePop(popSettings: SettingsPop, forUserId userId: String = "me") -> Observable<SettingsPop> {
        let query = SettingsPopUpdateQuery.query(withObject: popSettings, userId: userId)
        return updatePop(query: query)
    }

    public func updatePop(query: SettingsPopUpdateQuery) -> Observable<SettingsPop> {
        return execute(query: query)
    }

    public func getVacation(forUserId userId: String = "me") -> Observable<SettingsVacation> {
        let query = SettingsVacationQuery.query(withUserId: userId)
        return getVacation(query: query)
    }

    public func getVacation(query: SettingsVacationQuery) -> Observable<SettingsVacation> {
        return execute(query: query)
    }

    public func updateVacation(vacationSettings: SettingsVacation, forUserId userId: String = "me") -> Observable<SettingsVacation> {
        let query = SettingsVacationUpdateQuery.query(withObject: vacationSettings, userId: userId)
        return updateVacation(query: query)
    }

    public func updateVacation(query: SettingsVacationUpdateQuery) -> Observable<SettingsVacation> {
        return execute(query: query)
    }

    // MARK: - Filters

    public func createFilter(filter: Filter, forUserId userId: String = "me") -> Observable<Filter> {
        let query = FilterCreateQuery.query(withObject: filter, userId: userId)
        return createFilter(query: query)
    }

    public func createFilter(query: FilterCreateQuery) -> Observable<Filter> {
        return execute(query: query)
    }

    public func getFilter(filterId: String, forUserId userId: String = "me") -> Observable<Filter> {
        let query = FilterGetQuery.query(withUserId: userId, identifier: filterId)
        return getFilter(query: query)
    }

    public func getFilter(query: FilterGetQuery) -> Observable<Filter> {
        return execute(query: query)
    }

    public func deleteFilter(filterId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = FilterDeleteQuery.query(withUserId: userId, identifier: filterId)
        return deleteFilter(query: query)
    }

    public func deleteFilter(query: FilterDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func listFilters(forUserId userId: String = "me") -> Observable<FilterListResponse> {
        let query = FilterListQuery.query(withUserId: userId)
        return listFilters(query: query)
    }

    public func listFilters(query: FilterListQuery) -> Observable<FilterListResponse> {
        return execute(query: query)
    }

    // MARK: - Forward addresses

    public func listForwardingAddresses(forUserId userId: String = "me") -> Observable<ForwardingAddressListResponse> {
        let query = ForwardingAddressListQuery.query(withUserId: userId)
        return listForwardingAddresses(query: query)
    }

    public func listForwardingAddresses(query: ForwardingAddressListQuery) -> Observable<ForwardingAddressListResponse> {
        return execute(query: query)
    }

    public func getForwardingAddress(forwardingEmail: String, forUserId userId: String = "me") -> Observable<ForwardingAddress> {
        let query = ForwardingAddressGetQuery.query(withUserId: userId, forwardingEmail: forwardingEmail)
        return getForwardingAddress(query: query)
    }

    public func getForwardingAddress(query: ForwardingAddressGetQuery) -> Observable<ForwardingAddress> {
        return execute(query: query)
    }

    public func createForwardingAddress(forwardingAddress: ForwardingAddress, forUserId userId: String = "me") -> Observable<ForwardingAddress> {
        let query = ForwardingAddressCreateQuery.query(withObject: forwardingAddress, userId: userId)
        return createForwardingAddress(query: query)
    }

    public func createForwardingAddress(query: ForwardingAddressCreateQuery) -> Observable<ForwardingAddress> {
        return execute(query: query)
    }

    public func deleteForwardingAddress(forwardingEmail: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = ForwardingAddressDeleteQuery.query(withUserId: userId, forwardingEmail: forwardingEmail)
        return deleteForwardingAddress(query: query)
    }

    public func deleteForwardingAddress(query: ForwardingAddressDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    // MARK: Send As Aliases

    public func createSendAsAlias(sendAsAlias: SendAsAlias, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsCreateQuery.query(withObject: sendAsAlias, userId: userId)
        return createSendAsAlias(query: query)
    }

    public func createSendAsAlias(query: SendAsCreateQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    public func getSendAsAlias(sendAsEmail: String, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsGetQuery.query(withUserId: userId, sendAsEmail: sendAsEmail)
        return getSendAsAlias(query: query)
    }

    public func getSendAsAlias(query: SendAsGetQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    public func listSendAsAliases(forUserId userId: String = "me") -> Observable<SendAsListResponse> {
        let query = SendAsListQuery.query(withUserId: userId)
        return listSendAsAliases(query: query)
    }

    public func listSendAsAliases(query: SendAsListQuery) -> Observable<SendAsListResponse> {
        return execute(query: query)
    }

    public func patchSendAsAlias(sendAsAlias: SendAsAlias, sendAsEmail: String, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsPatchQuery.query(withObject: sendAsAlias, userId: userId, sendAsEmail: sendAsEmail)
        return patchSendAsAlias(query: query)
    }

    public func patchSendAsAlias(query: SendAsPatchQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    public func deleteSendAsAlias(sendAsEmail: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = SendAsDeleteQuery.query(withUserId: userId, sendAsEmail: sendAsEmail)
        return deleteSendAsAlias(query: query)
    }

    public func deleteSendAsAlias(query: SendAsDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func updateSendAsAlias(sendAsAlias: SendAsAlias, sendAsEmail: String, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsUpdateQuery.query(withObject: sendAsAlias, userId: userId, sendAsEmail: sendAsEmail)
        return updateSendAsAlias(query: query)
    }

    public func updateSendAsAlias(query: SendAsUpdateQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    public func verifySendAsAlias(sendAsEmail: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = SendAsVerifyQuery.query(withUserId: userId, sendAsEmail: sendAsEmail)
        return verifySendAsAlias(query: query)
    }

    public func verifySendAsAlias(query: SendAsVerifyQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func listThreads(forUserId userId: String = "me") -> Observable<ThreadListResponse> {
        let query = ThreadListQuery.query(withUserId: userId)
        return listThreads(query: query)
    }

    public func listThreads(query: ThreadListQuery) -> Observable<ThreadListResponse> {
        return executePaged(query: query)
    }

    public func getThread(threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadGetQuery.query(withUserId: userId, identifier: threadId)
        return getThread(query: query)
    }

    public func getThread(query: ThreadGetQuery) -> Observable<Thread> {
        return execute(query: query)
    }

    public func trashThread(threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadTrashQuery.query(withUserId: userId, identifier: threadId)
        return trashThread(query: query)
    }

    public func trashThread(query: ThreadTrashQuery) -> Observable<Thread> {
        return execute(query: query)
    }

    public func deleteThread(threadId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = ThreadDeleteQuery.query(withUserId: userId, identifier: threadId)
        return deleteThread(query: query)
    }

    public func deleteThread(query: ThreadDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    public func modifyThread(modifyThreadRequest: ThreadModifyRequest, threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadModifyQuery.query(withObject: modifyThreadRequest, userId: userId, identifier: threadId)
        return modifyThread(query: query)
    }
    
    public func modifyThread(query: ThreadModifyQuery) -> Observable<Thread> {
        return execute(query: query)
    }
    
    public func untrashThread(threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadUntrashQuery.query(withUserId: userId, identifier: threadId)
        return untrashThread(query: query)
    }
    
    public func untrashThread(query: ThreadUntrashQuery) -> Observable<Thread> {
        return execute(query: query)
    }

    // Batch queries

    public func batchQuery(queries: [Query]) -> Observable<BatchResult> {
        let query = BatchQuery(queries: queries)
        return execute(query: query)
    }
}

public protocol GetQueryType {
    static func query(withUserId userId: String, identifier: String) -> Self
    var format: String? { get set }
}

public protocol Identifiable {
    associatedtype QueryType: RxGmail.Query, GetQueryType
    var identifier: String? { get }
}

extension Identifiable {
    func getQuery(forUserId userId: String = "me") -> QueryType {
        return QueryType.query(withUserId: userId, identifier: self.identifier!)
    }
}

extension RxGmail.MessageGetQuery: GetQueryType { }
extension RxGmail.ThreadGetQuery: GetQueryType { }
extension RxGmail.LabelsGetQuery: GetQueryType {
    public var format: String? {
        get { return nil }
        set { }
    }
}

extension RxGmail.Message: Identifiable {
    public typealias QueryType = RxGmail.MessageGetQuery
}

extension RxGmail.Label: Identifiable {
    public typealias QueryType = RxGmail.LabelsGetQuery
}

extension RxGmail.Thread: Identifiable {
    public typealias QueryType = RxGmail.ThreadGetQuery
}

extension RxGmail {
    // See https://developers.google.com/gmail/api/v1/reference/users/messages/get
    public enum DetailType {
        case full
        case metadata
        case minimal
        case raw

        func asGmailFormat() -> String {
            switch self {
            case .full: return kGTLRGmailFormatFull
            case .metadata: return kGTLRGmailFormatMetadata
            case .minimal: return kGTLRGmailFormatMinimal
            case .raw: return kGTLRGmailFormatRaw
            }
        }
    }

    /**
        Gmail "List" queries return only response objects with identifiers but no details. fetchMetadata uses a batch query to retrieve details for all of the response objects in an array.
     
        - Parameter identifiables: array of response objects with an "identifier" attribute
        - Parameter format: Specifies what details to retrieve.
        - Returns: An observable of the array of response objects whose metadata were successfully retrieved.
     */
    public func fetchDetails<T: Identifiable>(_ identifiables: [T], detailType: DetailType? = nil, forUserId userId: String = "me") -> Observable<[T]>{
        let queries: [T.QueryType] = identifiables.map { (identifiable: T) -> T.QueryType in
            var query = identifiable.getQuery(forUserId: userId)
            query.format = detailType?.asGmailFormat()
            return query
        }
        return self.batchQuery(queries: queries)
            .map { $0.successes?.values.map { $0 as! T } }
            .unwrap()
    }
}

extension RxGmail.Message {
    public func parseHeaders() -> [String:String] {
        guard let rawHeaders = self.payload?.headers else { return [:] }
        var headers = [String:String]()
        rawHeaders.forEach {
            if let name = $0.name {
                headers[name] = $0.value ?? ""
            }
        }
        return headers
    }
}
