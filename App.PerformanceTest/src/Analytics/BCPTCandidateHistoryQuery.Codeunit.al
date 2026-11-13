namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Ledger;

codeunit 50250 "MBS BCPT Cand. History Query"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        Certification: Record "MBS Certification";
        i: Integer;
    begin
        for i := 1 to 5 do begin
            BCPTLibrary.CreateSessionWithCandidates(SessionHeader, 25);
            BCPTLibrary.ApplyResultDistribution(SessionHeader."No.", 60, 30);
            BCPTLibrary.PostSession(SessionHeader);
            if i = 1 then
                Certification.Get(SessionHeader."Certification No.");
        end;

        BCPTLibrary.MeasureHistoryLookup(Certification."No.", '');
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
