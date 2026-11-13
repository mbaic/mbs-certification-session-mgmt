namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Session;

codeunit 50102 "MBS Cert. Master Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure BlockedCertificationCannotBeSelectedOnSessionTest()
    var
        Certification: Record "MBS Certification";
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        // [SCENARIO] A blocked certification cannot be selected on a new session.
        // [GIVEN] A blocked certification exists.
        LibraryCertSession.CreateBlockedCertification(Certification);

        // [GIVEN] A session header exists.
        LibraryCertSession.CreateCertificationSetup();
        SessionHeader.Init();
        SessionHeader.Insert(true);

        // [WHEN] The user tries to set the blocked certification on the session.
        asserterror SessionHeader.Validate("Certification No.", Certification."No.");

        // [THEN] An error is raised because the certification is blocked.
        LibraryAssert.ExpectedError('Blocked');
    end;

    [Test]
    procedure CertificationDefaultsFlowToSessionSnapshotTest()
    var
        Certification: Record "MBS Certification";
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        // [SCENARIO] Creating a session with a certification copies default values.
        // [GIVEN] A certification exists with duration and candidate limits.
        LibraryCertSession.CreateCertification(Certification);

        // [WHEN] A session header is created referencing this certification.
        LibraryCertSession.CreateCertificationSetup();
        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", Certification."No.");
        SessionHeader.Modify(true);

        // [THEN] Session inherits the certification defaults.
        LibraryAssert.AreEqual(Certification.Name, SessionHeader."Certification Name", 'Certification Name should be copied.');
        LibraryAssert.AreEqual(Certification.Duration, SessionHeader.Duration, 'Duration should be copied.');
        LibraryAssert.AreEqual(Certification."Max. Candidates", SessionHeader."Max. Candidates", 'Max. Candidates should be copied.');
    end;
}
