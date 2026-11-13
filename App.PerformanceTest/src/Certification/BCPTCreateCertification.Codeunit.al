namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Certification;

codeunit 50243 "MBS BCPT Create Certification"
{
    Access = Internal;

    trigger OnRun()
    var
        Certification: Record "MBS Certification";
    begin
        BCPTLibrary.CreateCertification(Certification);
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
