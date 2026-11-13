namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Posting;
using MBS.CertificationSessionManagement.Ledger;
using MBS.CertificationSessionManagement.PostedSession;

codeunit 50104 "MBS Cert. Result Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure PostedLedgerStoresPassOutcomeTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CandidateLine: Record "MBS Cert. Candidate Line";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        // [SCENARIO] A passed result is stored in the ledger entry after posting.
        // [GIVEN] A ready-to-post session with one candidate marked as Passed.
        LibraryCertSession.CreateCertSessionHeader(SessionHeader);
        LibraryCertSession.AddCandidateLine(CandidateLine, SessionHeader."No.");
        LibraryCertSession.SetCandidateResult(CandidateLine, CandidateLine."Result Status"::Passed, true);
        LibraryCertSession.CloseCertificationSession(SessionHeader);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The ledger entry records the Passed result.
        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        LedgerEntry.SetRange("Candidate Contact No.", CandidateLine."Candidate Contact No.");
        LedgerEntry.FindFirst();
        LibraryAssert.AreEqual(LedgerEntry."Result Status"::Passed, LedgerEntry."Result Status", 'Ledger entry should store Passed result.');
    end;

    [Test]
    procedure PostedLedgerStoresFailOutcomeTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CandidateLine: Record "MBS Cert. Candidate Line";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        // [SCENARIO] A failed result is stored in the ledger entry after posting.
        // [GIVEN] A session with one candidate marked as Failed.
        LibraryCertSession.CreateCertSessionHeader(SessionHeader);
        LibraryCertSession.AddCandidateLine(CandidateLine, SessionHeader."No.");
        LibraryCertSession.SetCandidateResult(CandidateLine, CandidateLine."Result Status"::Failed, true);
        LibraryCertSession.CloseCertificationSession(SessionHeader);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The ledger entry records the Failed result.
        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        LedgerEntry.FindFirst();
        LibraryAssert.AreEqual(LedgerEntry."Result Status"::Failed, LedgerEntry."Result Status", 'Ledger entry should store Failed result.');
    end;

    [Test]
    procedure PostedLedgerStoresAttemptNumberTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CandidateLine: Record "MBS Cert. Candidate Line";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        // [SCENARIO] The attempt number on the candidate line is preserved in the ledger.
        // [GIVEN] A candidate with Attempt No. = 2.
        LibraryCertSession.CreateCertSessionHeader(SessionHeader);
        LibraryCertSession.AddCandidateLine(CandidateLine, SessionHeader."No.");
        CandidateLine.Validate("Attempt No.", 2);
        CandidateLine.Modify(true);
        LibraryCertSession.SetCandidateResult(CandidateLine, CandidateLine."Result Status"::Passed, true);
        LibraryCertSession.CloseCertificationSession(SessionHeader);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The ledger entry shows Attempt No. = 2.
        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        LedgerEntry.FindFirst();
        LibraryAssert.AreEqual(2, LedgerEntry."Attempt No.", 'Attempt No. should be 2 in ledger.');
    end;
}
