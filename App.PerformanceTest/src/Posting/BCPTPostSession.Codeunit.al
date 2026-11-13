namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Ledger;

codeunit 50248 "MBS BCPT Post Session"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        BCPTLibrary.CreateSessionWithCandidates(SessionHeader, 25);
        BCPTLibrary.ApplyResultDistribution(SessionHeader."No.", 70, 20);
        BCPTLibrary.PostSession(SessionHeader);

        PostedHeader.SetRange("Certification No.", SessionHeader."Certification No.");
        PostedHeader.FindLast();

        LedgerEntry.SetRange("Document No.", PostedHeader."No.");
        if LedgerEntry.Count() <> 25 then
            Error(LedgerCountErr, LedgerEntry.Count());
    end;

    var
        LedgerCountErr: Label 'Expected 25 ledger entries, found %1.', Comment = '%1 = number of ledger entries found';
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
