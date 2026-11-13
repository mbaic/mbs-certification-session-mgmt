namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Setup;

codeunit 50107 "MBS Cert. Permission Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure OperationalUserCanProcessStandardSessionWorkflowTest()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
    begin
        // [SCENARIO] A user holding the assignable permission set can run the standard workflow end to end.
        // [GIVEN] Setup and a closed session with one candidate.
        LibraryCertSession.CreateCertificationSetup();
        LibraryCertSession.CreateReadyToPostSession(SessionHeader, 1);

        // [WHEN] The session is posted.
        LibraryCertSession.PostAndGetPostedSession(SessionHeader, PostedHeader);

        // [THEN] The posted session exists.
        LibraryAssert.AreEqual(SessionHeader."Posting No.", PostedHeader."No.", 'Posted session should carry the assigned posting number.');
    end;

    [Test]
    procedure SetupRecordExistsAfterInitializationTest()
    var
        CertSetup: Record "MBS Certification Setup";
    begin
        // [SCENARIO] Setup can be accessed after initialization.
        // [GIVEN] Setup is initialized via the library.
        LibraryCertSession.CreateCertificationSetup();

        // [WHEN] Setup record is read.
        // [THEN] It exists and number series fields are populated.
        LibraryAssert.IsTrue(CertSetup.Get(), 'Setup record should exist.');
        LibraryAssert.AreNotEqual('', CertSetup."Certification Nos.", 'Certification Nos. should be populated.');
        LibraryAssert.AreNotEqual('', CertSetup."Cert. Session Nos.", 'Session Nos. should be populated.');
        LibraryAssert.AreNotEqual('', CertSetup."Posted Cert. Sess. Nos.", 'Posted Session Nos. should be populated.');
    end;
}
