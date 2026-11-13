namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Posting;

codeunit 50251 "MBS BCPT Post Sess. Validation"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CertPost: Codeunit "MBS Certification-Post";
    begin
        BCPTLibrary.CreateCertificationSetup();

        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Posting Date", WorkDate());
        SessionHeader.Validate("Document Date", WorkDate());
        SessionHeader.Status := SessionHeader.Status::Closed;
        SessionHeader.Modify(true);

        asserterror CertPost.Run(SessionHeader);
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
