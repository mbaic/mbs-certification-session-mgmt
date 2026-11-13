namespace MBS.CertificationSessionManagement.PerformanceTest;

codeunit 50244 "MBS BCPT Create Cert. Bulk"
{
    Access = Internal;

    trigger OnRun()
    begin
        BCPTLibrary.CreateCertifications(100);
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
