namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Ledger;
using MBS.CertificationSessionManagement.Posting;
using Microsoft.CRM.Contact;
using Microsoft.Projects.Resources.Resource;

codeunit 50106 "MBS Cert. Ledger Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure CandidateAttemptHistoryCanBeFilteredByCertificationTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
        CertNo: Code[20];
    begin
        // [SCENARIO] Ledger entries can be filtered by certification number.
        // [GIVEN] A posted session with candidates.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 2);
        CertNo := SessionHeader."Certification No.";

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] Filtering ledger by certification returns the posted entries.
        LedgerEntry.SetRange("Certification No.", CertNo);
        LibraryAssert.AreEqual(2, LedgerEntry.Count(), 'Should find 2 entries for the certification.');
    end;

    [Test]
    procedure CandidateRetakeHistoryRemainsChronologicalTest()
    var
        SessionHeader1: Record "MBS Cert. Session Header";
        SessionHeader2: Record "MBS Cert. Session Header";
        PostedHeader1: Record "MBS Posted Cert. Sess. Hdr.";
        PostedHeader2: Record "MBS Posted Cert. Sess. Hdr.";
        CandidateLine1: Record "MBS Cert. Candidate Line";
        CandidateLine2: Record "MBS Cert. Candidate Line";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
        CandidateContact: Record Contact;
        Certification: Record "MBS Certification";
        Invigilator: Record Resource;
        Room: Record Resource;
    begin
        // [SCENARIO] Multiple attempts by the same candidate remain traceable chronologically.
        // [GIVEN] A candidate who fails session 1 and passes session 2.
        LibraryCertSession.CreateCertification(Certification);
        LibraryCertSession.CreateInvigilatorResource(Invigilator);
        LibraryCertSession.CreateRoomResource(Room);
        LibraryCertSession.CreateCandidateContact(CandidateContact);

        // Session 1 - Failed attempt
        LibraryCertSession.CreateCertificationSetup();
        SessionHeader1.Init();
        SessionHeader1.Insert(true);
        SessionHeader1.Validate("Certification No.", Certification."No.");
        SessionHeader1.Validate("Session Date", WorkDate());
        SessionHeader1.Validate("Invigilator Resource No.", Invigilator."No.");
        SessionHeader1.Validate("Room Resource No.", Room."No.");
        SessionHeader1.Validate("Posting Date", WorkDate());
        SessionHeader1.Validate("Document Date", WorkDate());
        SessionHeader1.Modify(true);

        CandidateLine1.Init();
        CandidateLine1."Document No." := SessionHeader1."No.";
        CandidateLine1."Line No." := 10000;
        CandidateLine1.Insert(true);
        CandidateLine1.Validate("Candidate Contact No.", CandidateContact."No.");
        CandidateLine1.Validate("Attempt No.", 1);
        CandidateLine1.Validate(Attended, true);
        CandidateLine1.Validate("Result Status", CandidateLine1."Result Status"::Failed);
        CandidateLine1.Modify(true);
        LibraryCertSession.CloseCertificationSession(SessionHeader1);
        LibraryCertSession.PostAndGetPostedSession(SessionHeader1, PostedHeader1);

        // Session 2 - Passed re-sit
        SessionHeader2.Init();
        SessionHeader2.Insert(true);
        SessionHeader2.Validate("Certification No.", Certification."No.");
        SessionHeader2.Validate("Session Date", WorkDate() + 7);
        SessionHeader2.Validate("Invigilator Resource No.", Invigilator."No.");
        SessionHeader2.Validate("Room Resource No.", Room."No.");
        SessionHeader2.Validate("Posting Date", WorkDate() + 7);
        SessionHeader2.Validate("Document Date", WorkDate() + 7);
        SessionHeader2.Modify(true);

        CandidateLine2.Init();
        CandidateLine2."Document No." := SessionHeader2."No.";
        CandidateLine2."Line No." := 10000;
        CandidateLine2.Insert(true);
        CandidateLine2.Validate("Candidate Contact No.", CandidateContact."No.");
        CandidateLine2.Validate("Attempt No.", 2);
        CandidateLine2.Validate(Attended, true);
        CandidateLine2.Validate("Result Status", CandidateLine2."Result Status"::Passed);
        CandidateLine2.Modify(true);
        LibraryCertSession.CloseCertificationSession(SessionHeader2);
        LibraryCertSession.PostAndGetPostedSession(SessionHeader2, PostedHeader2);

        // [THEN] Two ledger entries exist for this candidate and certification.
        LedgerEntry.SetRange("Certification No.", Certification."No.");
        LedgerEntry.SetRange("Candidate Contact No.", CandidateContact."No.");
        LibraryAssert.AreEqual(2, LedgerEntry.Count(), 'Should have 2 attempt entries.');

        // [THEN] First entry is Failed, second is Passed.
        LedgerEntry.FindSet();
        LibraryAssert.AreEqual(LedgerEntry."Result Status"::Failed, LedgerEntry."Result Status", 'First attempt should be Failed.');
        LedgerEntry.Next();
        LibraryAssert.AreEqual(LedgerEntry."Result Status"::Passed, LedgerEntry."Result Status", 'Second attempt should be Passed.');
    end;
}
