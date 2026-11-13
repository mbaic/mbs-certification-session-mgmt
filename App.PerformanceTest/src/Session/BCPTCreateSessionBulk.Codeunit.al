namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;

codeunit 50246 "MBS BCPT Create Session Bulk"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        i: Integer;
    begin
        for i := 1 to 10 do
            BCPTLibrary.CreateSessionWithCandidates(SessionHeader, 25);
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
