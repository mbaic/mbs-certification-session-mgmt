namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;

codeunit 50249 "MBS BCPT Post Session Bulk"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        i: Integer;
    begin
        for i := 1 to 10 do begin
            BCPTLibrary.CreateSessionWithCandidates(SessionHeader, 25);
            BCPTLibrary.ApplyResultDistribution(SessionHeader."No.", 70, 20);
            BCPTLibrary.PostSession(SessionHeader);
        end;
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
