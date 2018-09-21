//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

extension ConversationInputBarViewController {
    
    @objc func configureMentionButton() {
        mentionButton.addTarget(self, action: #selector(ConversationInputBarViewController.mentionButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc func mentionButtonTapped(sender: Any) {
        // TODO: Trigger mentioning flow
    }
}

extension ConversationInputBarViewController: MentionsSearchResultsViewControllerDelegate {
    func didSelectUserToMention(_ user: ZMUser) {
        guard let handler = mentionsHandler else { return }

        let text = inputBar.textView.attributedText ?? NSAttributedString(string: inputBar.textView.text)
        inputBar.textView.attributedText = handler.replace(mention: user, in: text)
        mentionsHandler = nil
        mentionsView?.dismissIfVisible()
    }
}

extension ConversationInputBarViewController {

    func triggerMentionsIfNeeded(from textView: UITextView, with selection: UITextRange? = nil) {
        if let selectedRange = selection ?? textView.selectedTextRange {
            let position = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            mentionsHandler = MentionsHandler(text: textView.text, cursorPosition: position)
        }

        if let handler = mentionsHandler, let searchString = handler.searchString(in: textView.text) {
            let participants = conversation.activeParticipants.array as! [ZMUser]
            mentionsView?.search(in: participants, with: searchString)
        } else {
            mentionsHandler = nil
            mentionsView?.dismissIfVisible()
        }
    }

    @objc func registerForTextFieldSelectionChange() {
        textfieldObserverToken = inputBar.textView.observe(\MarkdownTextView.selectedTextRange, options: [.prior]) { [weak self] (textView: MarkdownTextView, change: NSKeyValueObservedChange<UITextRange?>) -> Void in
            let newValue = change.newValue ?? nil
            self?.triggerMentionsIfNeeded(from: textView, with: newValue)
        }
    }
}
