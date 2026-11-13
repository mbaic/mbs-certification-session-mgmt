namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;

codeunit 50247 "MBS BCPT Capture Results"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        BCPTLibrary.CreateSessionWithCandidates(SessionHeader, 25);
        BCPTLibrary.ApplyResultDistribution(SessionHeader."No.", 60, 30);
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
