namespace MBS.CertificationSessionManagement.Test;

using MBS.CertificationSessionManagement.Ledger;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Session;
using Microsoft.Foundation.AuditCodes;
using System.TestLibraries.Utilities;

codeunit 50108 "MBS Cert. Register Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure PostSessionCreatesRegisterCoveringLedgerEntriesTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
        CertRegister: Record "MBS Cert. Register";
    begin
        // [SCENARIO] Posting writes a register whose range covers the new ledger entries.
        // [GIVEN] A closed session with two candidates.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 2);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The last register ends at the last ledger entry of the posted document.
        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        LedgerEntry.FindLast();
        CertRegister.FindLast();
        LibraryAssert.AreEqual(LedgerEntry."Entry No.", CertRegister."To Entry No.", 'Register should end at the last ledger entry.');
    end;

    [Test]
    procedure PostSessionStampsLedgerEntryWithSourceCodeTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
        SourceCode: Record "Source Code";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        // [SCENARIO] Ledger entries carry the source code configured in Source Code Setup.
        // [GIVEN] A certification source code assigned in Source Code Setup and a closed session.
        LibraryCertSession.CreateCertificationSetup();
        SourceCode.Code := 'MBSCERTTST';
        SourceCode.Description := 'Certification test';
        if SourceCode.Insert() then;
        SourceCodeSetup.Get();
        SourceCodeSetup."MBS Certification" := SourceCode.Code;
        SourceCodeSetup.Modify();
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 1);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The ledger entry has that source code.
        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        LedgerEntry.FindFirst();
        LibraryAssert.AreEqual(SourceCode.Code, LedgerEntry."Source Code", 'Ledger entry should carry the certification source code.');
    end;

    [Test]
    procedure PostSessionRecordsPostingUserOnPostedHeaderTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
    begin
        // [SCENARIO] The posted header records who posted the session.
        // [GIVEN] A closed session.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 1);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The posted header user id is the current user.
        LibraryAssert.AreEqual(CopyStr(UserId(), 1, MaxStrLen(PostedHeader."User Id")), PostedHeader."User Id", 'Posted header should record the posting user.');
    end;

    [Test]
    procedure PostSessionPostsOneLedgerEntryPerCandidateTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        // [SCENARIO] Each candidate line becomes exactly one ledger entry.
        // [GIVEN] A closed session with three candidates.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 3);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] Three ledger entries exist for the posted document.
        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        LibraryAssert.AreEqual(3, LedgerEntry.Count(), 'There should be one ledger entry per candidate.');
    end;
}
