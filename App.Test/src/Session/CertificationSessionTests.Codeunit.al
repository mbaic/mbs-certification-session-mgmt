namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Posting;

codeunit 50103 "MBS Cert. Session Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure SessionWithoutCandidatesThrowsErrorTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        // [SCENARIO] A session without candidate lines cannot be posted.
        // [GIVEN] A session exists with no candidate lines.
        LibraryCertSession.CreateCertSessionHeader(SessionHeader);
        LibraryCertSession.CloseCertificationSession(SessionHeader);

        // [WHEN] The user tries to post the session.
        asserterror LibraryCertSession.PostCertificationSession(SessionHeader);

        // [THEN] An error indicates no candidates to post.
        LibraryAssert.ExpectedError('no candidates');
    end;

    [Test]
    procedure SessionWithoutPostingDateThrowsErrorTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CandidateLine: Record "MBS Cert. Candidate Line";
    begin
        // [SCENARIO] A session without a posting date cannot be posted.
        // [GIVEN] A session with candidates but no posting date.
        LibraryCertSession.CreateCertSessionHeader(SessionHeader);
        LibraryCertSession.AddCandidateLine(CandidateLine, SessionHeader."No.");
        LibraryCertSession.SetCandidateResult(CandidateLine, CandidateLine."Result Status"::Passed, true);
        SessionHeader.Validate("Posting Date", 0D);
        SessionHeader.Modify(true);
        LibraryCertSession.CloseCertificationSession(SessionHeader);

        // [WHEN] The user tries to post the session.
        asserterror LibraryCertSession.PostCertificationSession(SessionHeader);

        // [THEN] An error indicates posting date is required.
        LibraryAssert.ExpectedError('Posting Date');
    end;

    [Test]
    procedure CandidateWithoutReferenceThrowsErrorTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CandidateLine: Record "MBS Cert. Candidate Line";
        LineNo: Integer;
    begin
        // [SCENARIO] A candidate line without a contact reference prevents posting.
        // [GIVEN] A session with a candidate line missing the contact no.
        LibraryCertSession.CreateCertSessionHeader(SessionHeader);

        CandidateLine.Init();
        CandidateLine."Document No." := SessionHeader."No.";
        CandidateLine."Line No." := 10000;
        CandidateLine.Insert(true);
        // Deliberately leave "Candidate Contact No." blank
        LibraryCertSession.CloseCertificationSession(SessionHeader);

        // [WHEN] The user tries to post the session.
        asserterror LibraryCertSession.PostCertificationSession(SessionHeader);

        // [THEN] An error indicates candidate contact no. is required.
        LibraryAssert.ExpectedError('Candidate Contact No.');
    end;
}
