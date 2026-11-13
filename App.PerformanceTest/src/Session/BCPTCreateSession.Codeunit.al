namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;

codeunit 50245 "MBS BCPT Create Session"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        BCPTLibrary.CreateSessionWithCandidates(SessionHeader, 25);
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
