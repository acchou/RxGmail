//
//  RxGmail.swift
//  Pods
//
//  Created by Andy Chou on 3/1/17.
//
//

import GoogleAPIClientForREST
import RxSwift
import RxSwiftExt

// Protocols used to retroactively model all paged query types in the Gmail API.

protocol PagedQuery {
    var pageToken: String? { get set }
}

protocol PagedResponse {
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

class RxGmail {
    let GoogleClientID: String

    let serviceScopes = [kGTLRAuthScopeGmailReadonly]
    let service: GTLRGmailService

    init(gmailService: GTLRGmailService) {
        self.service = gmailService
        let info = Bundle.main.infoDictionary!
        self.GoogleClientID = info["GoogleClientID"] as! String
    }

    // MARK: - Types
    typealias GmailService = GTLRGmailService
    typealias Query = GTLRQueryProtocol
    typealias Response = GTLRObject
    typealias ServiceTicket = GTLRServiceTicket
    typealias UploadParameters = GTLRUploadParameters

    typealias ErrorObject = GTLRErrorObject
    typealias ErrorObjectDetail = GTLRErrorObjectDetail
    typealias ErrorObjectItem = GTLRErrorObjectErrorItem

    typealias Label = GTLRGmail_Label
    typealias LabelsListQuery = GTLRGmailQuery_UsersLabelsList
    typealias LabelsListResponse = GTLRGmail_ListLabelsResponse
    typealias LabelsCreateQuery = GTLRGmailQuery_UsersLabelsCreate
    typealias LabelsDeleteQuery = GTLRGmailQuery_UsersLabelsDelete
    typealias LabelsGetQuery = GTLRGmailQuery_UsersLabelsGet
    typealias LabelsPatchQuery = GTLRGmailQuery_UsersLabelsPatch
    typealias LabelsUpdateQuery = GTLRGmailQuery_UsersLabelsUpdate

    typealias Message = GTLRGmail_Message
    typealias MessagePartBody = GTLRGmail_MessagePartBody
    typealias MessagePart = GTLRGmail_MessagePart
    typealias MessagePartHeader = GTLRGmail_MessagePartHeader
    typealias MessageListQuery = GTLRGmailQuery_UsersMessagesList
    typealias MessageListResponse = GTLRGmail_ListMessagesResponse
    typealias MessageBatchDeleteQuery = GTLRGmailQuery_UsersMessagesBatchDelete
    typealias MessageBatchDeleteRequest = GTLRGmail_BatchDeleteMessagesRequest
    typealias MessageBatchModifyQuery = GTLRGmailQuery_UsersMessagesBatchModify
    typealias MessageBatchModifyRequest = GTLRGmail_BatchModifyMessagesRequest
    typealias MessageDeleteQuery = GTLRGmailQuery_UsersMessagesDelete
    typealias MessageGetQuery = GTLRGmailQuery_UsersMessagesGet
    typealias MessageImportQuery = GTLRGmailQuery_UsersMessagesImport
    typealias MessageInsertQuery = GTLRGmailQuery_UsersMessagesInsert
    typealias MessageModifyQuery = GTLRGmailQuery_UsersMessagesModify
    typealias MessageModifyRequest = GTLRGmail_ModifyMessageRequest
    typealias MessageSendQuery = GTLRGmailQuery_UsersMessagesSend
    typealias MessageTrashQuery = GTLRGmailQuery_UsersMessagesTrash
    typealias MessageUntrashQuery = GTLRGmailQuery_UsersMessagesUntrash
    typealias MessageAttachmentQuery = GTLRGmailQuery_UsersMessagesAttachmentsGet

    typealias Profile = GTLRGmail_Profile
    typealias ProfileQuery = GTLRGmailQuery_UsersGetProfile

    typealias WatchRequest = GTLRGmail_WatchRequest
    typealias WatchResponse = GTLRGmail_WatchResponse
    typealias WatchStartQuery = GTLRGmailQuery_UsersWatch
    typealias WatchStopQuery = GTLRGmailQuery_UsersStop

    typealias Draft = GTLRGmail_Draft
    typealias DraftsCreateQuery = GTLRGmailQuery_UsersDraftsCreate
    typealias DraftsDeleteQuery = GTLRGmailQuery_UsersDraftsDelete
    typealias DraftsGetQuery = GTLRGmailQuery_UsersDraftsGet
    typealias DraftsListQuery = GTLRGmailQuery_UsersDraftsList
    typealias DraftsListResponse = GTLRGmail_ListDraftsResponse
    typealias DraftsSendQuery = GTLRGmailQuery_UsersDraftsSend
    typealias DraftsUpdateQuery = GTLRGmailQuery_UsersDraftsUpdate

    typealias HistoryQuery = GTLRGmailQuery_UsersHistoryList
    typealias HistoryResponse = GTLRGmail_ListHistoryResponse

    typealias SettingsAutoForwardingQuery = GTLRGmailQuery_UsersSettingsGetAutoForwarding
    typealias SettingsAutoForwarding = GTLRGmail_AutoForwarding
    typealias SettingsAutoForwardingUpdateQuery = GTLRGmailQuery_UsersSettingsUpdateAutoForwarding
    typealias SettingsImapQuery = GTLRGmailQuery_UsersSettingsGetImap
    typealias SettingsImapUpdateQuery = GTLRGmailQuery_UsersSettingsUpdateImap
    typealias SettingsImap = GTLRGmail_ImapSettings
    typealias SettingsPopQuery = GTLRGmailQuery_UsersSettingsGetPop
    typealias SettingsPopUpdateQuery = GTLRGmailQuery_UsersSettingsUpdatePop
    typealias SettingsPop = GTLRGmail_PopSettings
    typealias SettingsVacationQuery = GTLRGmailQuery_UsersSettingsGetVacation
    typealias SettingsVacationUpdateQuery = GTLRGmailQuery_UsersSettingsUpdateVacation
    typealias SettingsVacation = GTLRGmail_VacationSettings

    typealias FilterCreateQuery = GTLRGmailQuery_UsersSettingsFiltersCreate
    typealias Filter = GTLRGmail_Filter
    typealias FilterGetQuery = GTLRGmailQuery_UsersSettingsFiltersGet
    typealias FilterDeleteQuery = GTLRGmailQuery_UsersSettingsFiltersDelete
    typealias FilterListQuery = GTLRGmailQuery_UsersSettingsFiltersList
    typealias FilterListResponse = GTLRGmail_ListFiltersResponse

    typealias ForwardingAddress = GTLRGmail_ForwardingAddress
    typealias ForwardingAddressGetQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesGet
    typealias ForwardingAddressDeleteQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesDelete
    typealias ForwardingAddressCreateQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesCreate
    typealias ForwardingAddressListQuery = GTLRGmailQuery_UsersSettingsForwardingAddressesList
    typealias ForwardingAddressListResponse = GTLRGmail_ListForwardingAddressesResponse

    typealias SendAsAlias = GTLRGmail_SendAs
    typealias SendAsListResponse = GTLRGmail_ListSendAsResponse
    typealias SendAsGetQuery = GTLRGmailQuery_UsersSettingsSendAsGet
    typealias SendAsListQuery = GTLRGmailQuery_UsersSettingsSendAsList
    typealias SendAsPatchQuery = GTLRGmailQuery_UsersSettingsSendAsPatch
    typealias SendAsCreateQuery = GTLRGmailQuery_UsersSettingsSendAsCreate
    typealias SendAsDeleteQuery = GTLRGmailQuery_UsersSettingsSendAsDelete
    typealias SendAsUpdateQuery = GTLRGmailQuery_UsersSettingsSendAsUpdate
    typealias SendAsVerifyQuery = GTLRGmailQuery_UsersSettingsSendAsVerify

    typealias ThreadListQuery = GTLRGmailQuery_UsersThreadsList
    typealias ThreadListResponse = GTLRGmail_ListThreadsResponse
    typealias Thread = GTLRGmail_Thread
    typealias ThreadModifyRequest = GTLRGmail_ModifyThreadRequest
    typealias ThreadGetQuery = GTLRGmailQuery_UsersThreadsGet
    typealias ThreadTrashQuery = GTLRGmailQuery_UsersThreadsTrash
    typealias ThreadDeleteQuery = GTLRGmailQuery_UsersThreadsDelete
    typealias ThreadModifyQuery = GTLRGmailQuery_UsersThreadsModify
    typealias ThreadUntrashQuery = GTLRGmailQuery_UsersThreadsUntrash

    // MARK: - Generic request helper functions
    fileprivate func createRequest(observer: AnyObserver<Any?>, query: Query) -> ServiceTicket {
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
    func execute<R: Response>(query: Query) -> Observable<R?> {
        return Observable<Any?>.create { [weak self] observer in
            let serviceTicket = self?.createRequest(observer: observer, query: query)
            return Disposables.create {
                serviceTicket?.cancel()
            }
            }
            .map { $0 as! R? }
    }

    /**
     Execute a query.

     - Parameter query: the query to execute.
     - Returns: an instance of GTLRObject fetched by the query upon success.
     */
    func execute<R: Response>(query: Query) -> Observable<R> {
        return execute(query: query).map { $0! }
    }

    func execute(query: Query) -> Observable<Void> {
        let response: Observable<Response?> = execute(query: query)
        return response.map { _ in () }
    }

    /**
     Execute a query returning a paged response.

     - Parameter query: the query to execute, the result of the query should
     be a paged response.

     - Returns: an observable that sends one event per page.
     */
    func executePaged<Q, R>(query: Q) -> Observable<R>
        where Q: Query, Q: PagedQuery, R: Response, R: PagedResponse {
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
    }

    // MARK: - Users

    func getProfile(forUserId userId: String = "me") -> Observable<Profile> {
        let query = ProfileQuery.query(withUserId: userId)
        return getProfile(query: query)
    }

    func getProfile(query: ProfileQuery) -> Observable<Profile> {
        return execute(query: query)
    }

    func watchRequest(request: WatchRequest, forUserId userId: String = "me") -> Observable<WatchResponse> {
        let query = WatchStartQuery.query(withObject: request, userId: userId)
        return watchRequest(query: query)
    }

    func watchRequest(query: WatchStartQuery) -> Observable<WatchResponse> {
        return execute(query: query)
    }

    func stopNotifications(forUserId userId: String = "me") -> Observable<Void> {
        let query = WatchStopQuery.query(withUserId: userId)
        return stopNotifications(query: query)
    }

    func stopNotifications(query: WatchStopQuery) -> Observable<Void> {
        return execute(query: query)
    }

    // MARK: - Drafts

    func createDraft(draft: Draft, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Draft> {
        let query = DraftsCreateQuery.query(withObject: draft, userId: userId, uploadParameters: uploadParameters)
        return createDraft(query: query)
    }

    func createDraft(query: DraftsCreateQuery) -> Observable<Draft> {
        return execute(query: query)
    }

    func deleteDraft(draftID: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = DraftsDeleteQuery.query(withUserId: userId, identifier: draftID)
        return deleteDraft(query: query)
    }

    func deleteDraft(query: DraftsDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func getDraft(draftID: String, format: String? = nil, forUserId userId: String = "me") -> Observable<Draft> {
        let query = DraftsGetQuery.query(withUserId: userId, identifier: draftID)
        query.format = format
        return getDraft(query: query)
    }

    func getDraft(query: DraftsGetQuery) -> Observable<Draft> {
        return execute(query: query)
    }

    func listDrafts(forUserId userId: String = "me") -> Observable<DraftsListResponse> {
        let query = DraftsListQuery.query(withUserId: userId)
        return listDrafts(query: query)
    }

    func listDrafts(query: DraftsListQuery) -> Observable<DraftsListResponse> {
        return executePaged(query: query)
    }

    func sendDraft(draft: Draft, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = DraftsSendQuery.query(withObject: draft, userId: userId, uploadParameters: uploadParameters)
        return sendDraft(query: query)
    }

    func sendDraft(query: DraftsSendQuery) -> Observable<Message> {
        return execute(query: query)
    }

    func updateDraft(draftID: String, draft: Draft, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Draft> {
        let query = DraftsUpdateQuery.query(withObject: draft, userId: userId, identifier: draftID, uploadParameters: uploadParameters)
        return updateDraft(query: query)
    }

    func updateDraft(query: DraftsUpdateQuery) -> Observable<Draft> {
        return execute(query: query)
    }

    // MARK: - History

    func history(startHistoryId: UInt64, forUserId userId: String = "me") -> Observable<HistoryResponse> {
        let query = HistoryQuery.query(withUserId: userId)
        query.startHistoryId = startHistoryId
        return history(query: query)
    }

    func history(query: HistoryQuery) -> Observable<HistoryResponse> {
        return executePaged(query: query)
    }

    // MARK: - Labels

    func listLabels(forUserId userId: String = "me") -> Observable<LabelsListResponse> {
        let query = LabelsListQuery.query(withUserId: userId)
        return self.listLabels(query: query)
    }

    func listLabels(query: LabelsListQuery) -> Observable<LabelsListResponse> {
        return execute(query: query)
    }

    func createLabel(label: Label, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsCreateQuery.query(withObject: label, userId: userId)
        return createLabel(query: query)
    }

    func createLabel(query: LabelsCreateQuery) -> Observable<Label> {
        return execute(query: query)
    }

    func deleteLabel(labelId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = LabelsDeleteQuery.query(withUserId: userId, identifier: labelId)
        return deleteLabel(query: query)
    }

    func deleteLabel(query: LabelsDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func getLabel(labelId: String, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsGetQuery.query(withUserId: userId, identifier: labelId)
        return getLabel(query: query)
    }

    func getLabel(query: LabelsGetQuery) -> Observable<Label> {
        return execute(query: query)
    }

    func patchLabel(labelId: String, updatedLabel: Label, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsPatchQuery.query(withObject: updatedLabel, userId: userId, identifier: userId)
        return patchLabel(query: query)
    }

    func patchLabel(query: LabelsPatchQuery) -> Observable<Label> {
        return execute(query: query)
    }

    func updateLabel(labelId: String, updatedLabel: Label, forUserId userId: String = "me") -> Observable<Label> {
        let query = LabelsUpdateQuery.query(withObject: updatedLabel, userId: userId, identifier: labelId)
        return updateLabel(query: query)
    }

    func updateLabel(query: LabelsUpdateQuery) -> Observable<Label> {
        return execute(query: query)
    }

    // MARK: - Messages

    // Each event returns a page of messages.
    func listMessages(forUserId userId: String = "me") -> Observable<MessageListResponse> {
        let query = MessageListQuery.query(withUserId: userId)
        return listMessages(query: query)
    }

    func listMessages(query: MessageListQuery) -> Observable<MessageListResponse> {
        return executePaged(query: query)
    }

    func batchDeleteMessages(request: MessageBatchDeleteRequest, forUserId userId: String = "me") -> Observable<Void> {
        let query = MessageBatchDeleteQuery.query(withObject: request, userId: userId)
        return batchDeleteMessages(query: query)
    }

    func batchDeleteMessages(query: MessageBatchDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func batchModifyMessages(request: MessageBatchModifyRequest, forUserId userId: String = "me") -> Observable<Void> {
        let query = MessageBatchModifyQuery.query(withObject: request, userId: userId)
        return batchModifyMessages(query: query)
    }

    func batchModifyMessages(query: MessageBatchModifyQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func deleteMessage(messageId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = MessageDeleteQuery.query(withUserId: userId, identifier: messageId)
        return deleteMessage(query: query)
    }

    func deleteMessage(query: MessageDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func getMessage(messageId: String, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageGetQuery.query(withUserId: userId, identifier: messageId)
        return getMessage(query: query)
    }

    func getMessage(query: MessageGetQuery) -> Observable<Message> {
        return execute(query: query)
    }

    func importMessage(message: Message, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageImportQuery.query(withObject: message, userId: userId, uploadParameters: uploadParameters)
        return importMessage(query: query)
    }

    func importMessage(query: MessageImportQuery) -> Observable<Message> {
        return execute(query: query)
    }

    func insertMessage(message: Message, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageInsertQuery.query(withObject: message, userId: userId, uploadParameters: uploadParameters)
        return insertMessage(query: query)
    }

    func insertMessage(query: MessageInsertQuery) -> Observable<Message> {
        return execute(query: query)
    }

    func modifyMessage(messageId: String, request: MessageModifyRequest, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageModifyQuery.query(withObject: request, userId: userId, identifier: messageId)
        return modifyMessage(query: query)
    }

    func modifyMessage(query: MessageModifyQuery) -> Observable<Message> {
        return execute(query: query)
    }

    func sendMessage(message: Message, uploadParameters: UploadParameters? = nil, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageSendQuery.query(withObject: message, userId: userId, uploadParameters: uploadParameters)
        return sendMessage(query: query)
    }

    func sendMessage(query: MessageSendQuery) -> Observable<Message> {
        return execute(query: query)
    }

    func trashMessage(messageId: String, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageTrashQuery.query(withUserId: userId, identifier: messageId)
        return trashMessage(query: query)
    }

    func trashMessage(query: MessageTrashQuery) -> Observable<Message> {
        return execute(query: query)
    }

    func untrashMessage(messageId: String, forUserId userId: String = "me") -> Observable<Message> {
        let query = MessageUntrashQuery.query(withUserId: userId, identifier: messageId)
        return untrashMessage(query: query)
    }

    func untrashMessage(query: MessageUntrashQuery) -> Observable<Message> {
        return execute(query: query)
    }

    // MARK: - Attachments
    func getAttachments(messageId: String, attachmentId: String, forUserId userId: String = "me") ->  Observable<MessagePartBody> {
        let query = MessageAttachmentQuery.query(withUserId: userId, messageId: messageId, identifier: attachmentId)
        return getAttachments(query: query)
    }

    func getAttachments(query: MessageAttachmentQuery) -> Observable<MessagePartBody> {
        return execute(query: query)
    }

    // Mark: - Settings
    func getAutoForwarding(forUserId userId: String = "me") -> Observable<SettingsAutoForwarding> {
        let query = SettingsAutoForwardingQuery.query(withUserId: userId)
        return getAutoForwarding(query: query)
    }

    func getAutoForwarding(query: SettingsAutoForwardingQuery) -> Observable<SettingsAutoForwarding> {
        return execute(query: query)
    }

    func updateAutoForwarding(forwardingSettings: SettingsAutoForwarding, forUserId userId: String = "me") -> Observable<SettingsAutoForwarding> {
        let query = SettingsAutoForwardingUpdateQuery.query(withObject: forwardingSettings, userId: userId)
        return updateAutoForwarding(query: query)
    }

    func updateAutoForwarding(query: SettingsAutoForwardingUpdateQuery) -> Observable<SettingsAutoForwarding> {
        return execute(query: query)
    }

    func getImap(forUserId userId: String = "me") -> Observable<SettingsImap> {
        let query = SettingsImapQuery.query(withUserId: userId)
        return getImap(query: query)
    }

    func getImap(query: SettingsImapQuery) -> Observable<SettingsImap> {
        return execute(query: query)
    }

    func updateImap(imapSettings: SettingsImap, forUserId userId: String = "me") -> Observable<SettingsImap> {
        let query = SettingsImapUpdateQuery.query(withObject: imapSettings, userId: userId)
        return updateImap(query: query)
    }

    func updateImap(query: SettingsImapUpdateQuery) -> Observable<SettingsImap> {
        return execute(query: query)
    }

    func getPop(forUserId userId: String = "me") -> Observable<SettingsPop> {
        let query = SettingsPopQuery.query(withUserId: userId)
        return getPop(query: query)
    }

    func getPop(query: SettingsPopQuery) -> Observable<SettingsPop> {
        return execute(query: query)
    }

    func updatePop(popSettings: SettingsPop, forUserId userId: String = "me") -> Observable<SettingsPop> {
        let query = SettingsPopUpdateQuery.query(withObject: popSettings, userId: userId)
        return updatePop(query: query)
    }

    func updatePop(query: SettingsPopUpdateQuery) -> Observable<SettingsPop> {
        return execute(query: query)
    }

    func getVacation(forUserId userId: String = "me") -> Observable<SettingsVacation> {
        let query = SettingsVacationQuery.query(withUserId: userId)
        return getVacation(query: query)
    }

    func getVacation(query: SettingsVacationQuery) -> Observable<SettingsVacation> {
        return execute(query: query)
    }

    func updateVacation(vacationSettings: SettingsVacation, forUserId userId: String = "me") -> Observable<SettingsVacation> {
        let query = SettingsVacationUpdateQuery.query(withObject: vacationSettings, userId: userId)
        return updateVacation(query: query)
    }

    func updateVacation(query: SettingsVacationUpdateQuery) -> Observable<SettingsVacation> {
        return execute(query: query)
    }

    // MARK: - Filters

    func createFilter(filter: Filter, forUserId userId: String = "me") -> Observable<Filter> {
        let query = FilterCreateQuery.query(withObject: filter, userId: userId)
        return createFilter(query: query)
    }

    func createFilter(query: FilterCreateQuery) -> Observable<Filter> {
        return execute(query: query)
    }

    func getFilter(filterId: String, forUserId userId: String = "me") -> Observable<Filter> {
        let query = FilterGetQuery.query(withUserId: userId, identifier: filterId)
        return getFilter(query: query)
    }

    func getFilter(query: FilterGetQuery) -> Observable<Filter> {
        return execute(query: query)
    }

    func deleteFilter(filterId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = FilterDeleteQuery.query(withUserId: userId, identifier: filterId)
        return deleteFilter(query: query)
    }

    func deleteFilter(query: FilterDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func listFilters(forUserId userId: String = "me") -> Observable<FilterListResponse> {
        let query = FilterListQuery.query(withUserId: userId)
        return listFilters(query: query)
    }

    func listFilters(query: FilterListQuery) -> Observable<FilterListResponse> {
        return execute(query: query)
    }

    // MARK: - Forward addresses

    func listForwardingAddresses(forUserId userId: String = "me") -> Observable<ForwardingAddressListResponse> {
        let query = ForwardingAddressListQuery.query(withUserId: userId)
        return listForwardingAddresses(query: query)
    }

    func listForwardingAddresses(query: ForwardingAddressListQuery) -> Observable<ForwardingAddressListResponse> {
        return execute(query: query)
    }

    func getForwardingAddress(forwardingEmail: String, forUserId userId: String = "me") -> Observable<ForwardingAddress> {
        let query = ForwardingAddressGetQuery.query(withUserId: userId, forwardingEmail: forwardingEmail)
        return getForwardingAddress(query: query)
    }

    func getForwardingAddress(query: ForwardingAddressGetQuery) -> Observable<ForwardingAddress> {
        return execute(query: query)
    }

    func createForwardingAddress(forwardingAddress: ForwardingAddress, forUserId userId: String = "me") -> Observable<ForwardingAddress> {
        let query = ForwardingAddressCreateQuery.query(withObject: forwardingAddress, userId: userId)
        return createForwardingAddress(query: query)
    }

    func createForwardingAddress(query: ForwardingAddressCreateQuery) -> Observable<ForwardingAddress> {
        return execute(query: query)
    }

    func deleteForwardingAddress(forwardingEmail: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = ForwardingAddressDeleteQuery.query(withUserId: userId, forwardingEmail: forwardingEmail)
        return deleteForwardingAddress(query: query)
    }

    func deleteForwardingAddress(query: ForwardingAddressDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    // MARK: Send As Aliases

    func createSendAsAlias(sendAsAlias: SendAsAlias, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsCreateQuery.query(withObject: sendAsAlias, userId: userId)
        return createSendAsAlias(query: query)
    }

    func createSendAsAlias(query: SendAsCreateQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    func getSendAsAlias(sendAsEmail: String, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsGetQuery.query(withUserId: userId, sendAsEmail: sendAsEmail)
        return getSendAsAlias(query: query)
    }

    func getSendAsAlias(query: SendAsGetQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    func listSendAsAliases(forUserId userId: String = "me") -> Observable<SendAsListResponse> {
        let query = SendAsListQuery.query(withUserId: userId)
        return listSendAsAliases(query: query)
    }

    func listSendAsAliases(query: SendAsListQuery) -> Observable<SendAsListResponse> {
        return execute(query: query)
    }

    func patchSendAsAlias(sendAsAlias: SendAsAlias, sendAsEmail: String, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsPatchQuery.query(withObject: sendAsAlias, userId: userId, sendAsEmail: sendAsEmail)
        return patchSendAsAlias(query: query)
    }

    func patchSendAsAlias(query: SendAsPatchQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    func deleteSendAsAlias(sendAsEmail: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = SendAsDeleteQuery.query(withUserId: userId, sendAsEmail: sendAsEmail)
        return deleteSendAsAlias(query: query)
    }

    func deleteSendAsAlias(query: SendAsDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func updateSendAsAlias(sendAsAlias: SendAsAlias, sendAsEmail: String, forUserId userId: String = "me") -> Observable<SendAsAlias> {
        let query = SendAsUpdateQuery.query(withObject: sendAsAlias, userId: userId, sendAsEmail: sendAsEmail)
        return updateSendAsAlias(query: query)
    }

    func updateSendAsAlias(query: SendAsUpdateQuery) -> Observable<SendAsAlias> {
        return execute(query: query)
    }

    func verifySendAsAlias(sendAsEmail: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = SendAsVerifyQuery.query(withUserId: userId, sendAsEmail: sendAsEmail)
        return verifySendAsAlias(query: query)
    }

    func verifySendAsAlias(query: SendAsVerifyQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func listThreads(forUserId userId: String = "me") -> Observable<ThreadListResponse> {
        let query = ThreadListQuery.query(withUserId: userId)
        return listThreads(query: query)
    }

    func listThreads(query: ThreadListQuery) -> Observable<ThreadListResponse> {
        return executePaged(query: query)
    }

    func getThread(threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadGetQuery.query(withUserId: userId, identifier: threadId)
        return getThread(query: query)
    }

    func getThread(query: ThreadGetQuery) -> Observable<Thread> {
        return execute(query: query)
    }

    func trashThread(threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadTrashQuery.query(withUserId: userId, identifier: threadId)
        return trashThread(query: query)
    }

    func trashThread(query: ThreadTrashQuery) -> Observable<Thread> {
        return execute(query: query)
    }

    func deleteThread(threadId: String, forUserId userId: String = "me") -> Observable<Void> {
        let query = ThreadDeleteQuery.query(withUserId: userId, identifier: threadId)
        return deleteThread(query: query)
    }

    func deleteThread(query: ThreadDeleteQuery) -> Observable<Void> {
        return execute(query: query)
    }

    func modifyThread(modifyThreadRequest: ThreadModifyRequest, threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadModifyQuery.query(withObject: modifyThreadRequest, userId: userId, identifier: threadId)
        return modifyThread(query: query)
    }
    
    func modifyThread(query: ThreadModifyQuery) -> Observable<Thread> {
        return execute(query: query)
    }
    
    func untrashThread(threadId: String, forUserId userId: String = "me") -> Observable<Thread> {
        let query = ThreadUntrashQuery.query(withUserId: userId, identifier: threadId)
        return untrashThread(query: query)
    }
    
    func untrashThread(query: ThreadUntrashQuery) -> Observable<Thread> {
        return execute(query: query)
    }
}
