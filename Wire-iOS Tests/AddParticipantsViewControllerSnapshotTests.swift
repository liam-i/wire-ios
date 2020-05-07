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

import XCTest
@testable import Wire

final class AddParticipantsViewControllerSnapshotTests: XCTestCase, CoreDataFixtureTestHelper {
    var coreDataFixture: CoreDataFixture!

    var sut: AddParticipantsViewController!

    override func setUp() {
        super.setUp()

        coreDataFixture = CoreDataFixture()
    }

    override func tearDown() {
        sut = nil
        SelfUser.provider = nil

        coreDataFixture = nil

        super.tearDown()
    }

    func testForEveryOneIsHere() {
        let newValues = ConversationCreationValues(name: "", participants: [], allowGuests: true)

        sut = AddParticipantsViewController(context: .create(newValues), variant: .light)
        verify(matching: sut)
    }

    func testForAddParticipantsButtonIsShown() {
        let conversation = createGroupConversation()

        sut = AddParticipantsViewController(context: .add(conversation), variant: .light)

        let user = createUser(name: "Bill")
        sut.userSelection.add(user)
        sut.userSelection(UserSelection(), didAddUser: user)

        verify(matching: sut)
    }

}
