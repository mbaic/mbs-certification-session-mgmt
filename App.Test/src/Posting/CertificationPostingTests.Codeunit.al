namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Ledger;
using MBS.CertificationSessionManagement.Posting;

codeunit 50105 "MBS Cert. Posting Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure PostSessionCreatesPostedHeaderTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
    begin
        // [SCENARIO] Posting a valid session creates a posted session header.
        // [GIVEN] A valid ready-to-post session with one candidate.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 1);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] A posted header exists with matching certification data.
        LibraryAssert.AreEqual(SessionHeader."Certification No.", PostedHeader."Certification No.", 'Certification No. should match.');
        LibraryAssert.AreEqual(SessionHeader."Certification Name", PostedHeader."Certification Name", 'Certification Name should match.');
    end;

    [Test]
    procedure PostSessionCreatesPostedCandidateLinesTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        PostedCandLine: Record "MBS Posted Cert. Cand. Line";
    begin
        // [SCENARIO] Posting creates posted candidate lines matching the source lines.
        // [GIVEN] A session with 3 candidates.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 3);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] 3 posted candidate lines exist.
        PostedCandLine.SetRange("Document No.", PostedHeader."No.");
        LibraryAssert.AreEqual(3, PostedCandLine.Count(), 'Should have 3 posted candidate lines.');
    end;

    [Test]
    procedure PostSessionCopiesCommentsToPostedHistoryTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        CommentLine: Record "MBS Cert. Comment Line";
    begin
        // [SCENARIO] Comments on the session are copied to the posted session.
        // [GIVEN] A session with comments.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 1);
        LibraryCertSession.CreateCertCommentLine(
            CommentLine."Table Name"::"Certification Session",
            SessionHeader."No.",
            'Test comment for posting');

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The comment exists on the posted session.
        CommentLine.Reset();
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::"Posted Certification Session");
        CommentLine.SetRange("No.", PostedHeader."No.");
        LibraryAssert.IsTrue(CommentLine.FindFirst(), 'Comment should be copied to posted session.');
        LibraryAssert.AreEqual('Test comment for posting', CommentLine.Comment, 'Comment text should match.');
    end;

    [Test]
    procedure PostSessionCreatesCertificationLedgerEntriesTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        // [SCENARIO] Posting creates one ledger entry per candidate.
        // [GIVEN] A session with 2 candidates.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 2);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] 2 ledger entries exist for this posted document.
        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        LibraryAssert.AreEqual(2, LedgerEntry.Count(), 'Should have 2 ledger entries.');
    end;

    [Test]
    procedure PostSessionDeletesOriginalDocumentTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        OriginalNo: Code[20];
    begin
        // [SCENARIO] After posting, the original session document is deleted.
        // [GIVEN] A valid ready-to-post session.
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 1);
        OriginalNo := SessionHeader."No.";

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The original session header no longer exists.
        LibraryAssert.IsFalse(SessionHeader.Get(OriginalNo), 'Original session should be deleted after posting.');
    end;

    [Test]
    procedure PostSessionWithoutClosedStatusThrowsErrorTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CandidateLine: Record "MBS Cert. Candidate Line";
    begin
        // [SCENARIO] A session that is not Closed cannot be posted.
        // [GIVEN] A session in Planning status with candidates.
        LibraryCertSession.CreateCertSessionHeader(SessionHeader);
        LibraryCertSession.AddCandidateLine(CandidateLine, SessionHeader."No.");
        LibraryCertSession.SetCandidateResult(CandidateLine, CandidateLine."Result Status"::Passed, true);
        // Status remains Planning - do NOT close

        // [WHEN] The user tries to post.
        asserterror LibraryCertSession.PostCertificationSession(SessionHeader);

        // [THEN] Error indicates status must be Closed.
        LibraryAssert.ExpectedError('Status');
    end;
}
