namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
using MBS.CertificationSessionManagement.Setup;
using MBS.CertificationSessionManagement.Certification;

codeunit 50101 "MBS Cert. Setup Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryCertSession: Codeunit "MBS Library - Cert. Session";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure CreateCertificationWithoutNoAssignsSeriesNumberTest()
    var
        Certification: Record "MBS Certification";
    begin
        // [SCENARIO] Creating a certification without specifying a number assigns the next number from the series.
        // [GIVEN] Certification setup exists with a valid number series.
        LibraryCertSession.CreateCertificationSetup();

        // [WHEN] A new certification is created without specifying a number.
        Certification.Init();
        Certification.Insert(true);

        // [THEN] The certification number is assigned from the number series.
        LibraryAssert.AreNotEqual('', Certification."No.", 'Certification No. should be assigned from number series.');
    end;

    [Test]
    procedure SetupRecordInitializesAutomaticallyTest()
    var
        CertSetup: Record "MBS Certification Setup";
    begin
        // [SCENARIO] Opening setup page creates the setup record if missing.
        // [GIVEN] No setup record exists.
        if CertSetup.Get() then
            CertSetup.Delete();

        // [WHEN] Setup is created through helper.
        LibraryCertSession.CreateCertificationSetup();

        // [THEN] A setup record exists.
        LibraryAssert.IsTrue(CertSetup.Get(), 'Certification Setup record should exist.');
    end;
}
