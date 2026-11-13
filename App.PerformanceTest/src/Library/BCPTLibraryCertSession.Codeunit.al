namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Setup;
using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Posting;
using MBS.CertificationSessionManagement.Ledger;
using Microsoft.CRM.Contact;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;

codeunit 50242 "MBS BCPT Library - Cert."
{
    Access = Internal;

    procedure CreateCertificationSetup()
    var
        CertSetup: Record "MBS Certification Setup";
    begin
        if CertSetup.Get() then
            if (CertSetup."Certification Nos." <> '') and
               (CertSetup."Cert. Session Nos." <> '') and
               (CertSetup."Posted Cert. Sess. Nos." <> '')
            then
                exit;

        if not CertSetup.Get() then begin
            CertSetup.Init();
            CertSetup.Insert(true);
        end;

        if CertSetup."Certification Nos." = '' then
            CertSetup."Certification Nos." := EnsureNoSeries('BCCERT');
        if CertSetup."Cert. Session Nos." = '' then
            CertSetup."Cert. Session Nos." := EnsureNoSeries('BCCSESS');
        if CertSetup."Posted Cert. Sess. Nos." = '' then
            CertSetup."Posted Cert. Sess. Nos." := EnsureNoSeries('BCPCSESS');
        CertSetup.Modify(true);
        EnsureSourceCodeSetup();
    end;

    local procedure EnsureSourceCodeSetup()
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        if not SourceCodeSetup.Get() then begin
            SourceCodeSetup.Init();
            SourceCodeSetup.Insert(true);
        end;
    end;

    procedure CreateCertification(var Certification: Record "MBS Certification")
    begin
        CreateCertificationSetup();
        Certification.Init();
        Certification.Insert(true);
        Certification.Validate(Name, 'Perf Cert ' + Certification."No.");
        Certification.Validate(Duration, 1);
        Certification.Validate("Min. Candidates", 1);
        Certification.Validate("Max. Candidates", 100);
        Certification.Modify(true);
    end;

    procedure CreateCertifications(Count: Integer)
    var
        Certification: Record "MBS Certification";
        i: Integer;
    begin
        for i := 1 to Count do
            CreateCertification(Certification);
    end;

    procedure CreateInvigilatorResource(var Resource: Record Resource)
    begin
        // Reuse one pooled resource per type so BCPT iterations do not flood the Resource table.
        Resource.Init();
        Resource."No." := 'BCPT-INV-0001';
        Resource.Type := Resource.Type::Person;
        Resource.Name := 'BCPT Invigilator';
        if not Resource.Get(Resource."No.") then
            Resource.Insert(true);
    end;

    procedure CreateRoomResource(var Resource: Record Resource)
    begin
        // Reuse one pooled resource per type so BCPT iterations do not flood the Resource table.
        Resource.Init();
        Resource."No." := 'BCPT-ROOM-0001';
        Resource.Type := Resource.Type::Machine;
        Resource.Name := 'BCPT Room';
        if not Resource.Get(Resource."No.") then
            Resource.Insert(true);
    end;

    procedure CreateCandidateSet(var Contacts: array[500] of Code[20]; Count: Integer)
    var
        Contact: Record Contact;
        i: Integer;
    begin
        for i := 1 to Count do begin
            Contact.Init();
            Contact."No." := '';
            Contact.Insert(true);
            Contact.Validate(Name, 'Candidate ' + Format(i));
            Contact.Modify(true);
            Contacts[i] := Contact."No.";
        end;
    end;

    procedure CreateSessionWithCandidates(var SessionHeader: Record "MBS Cert. Session Header"; CandidateCount: Integer)
    var
        CandidateLine: Record "MBS Cert. Candidate Line";
        Certification: Record "MBS Certification";
        Invigilator: Record Resource;
        Room: Record Resource;
        Contact: Record Contact;
        LineNo: Integer;
        i: Integer;
    begin
        CreateCertification(Certification);
        CreateInvigilatorResource(Invigilator);
        CreateRoomResource(Room);

        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", Certification."No.");
        SessionHeader.Validate("Session Date", WorkDate());
        SessionHeader.Validate("Invigilator Resource No.", Invigilator."No.");
        SessionHeader.Validate("Room Resource No.", Room."No.");
        SessionHeader.Validate("Posting Date", WorkDate());
        SessionHeader.Validate("Document Date", WorkDate());
        SessionHeader.Modify(true);

        LineNo := 10000;
        for i := 1 to CandidateCount do begin
            Contact.Init();
            Contact."No." := '';
            Contact.Insert(true);
            Contact.Validate(Name, 'Perf Candidate ' + Format(i));
            Contact.Modify(true);

            CandidateLine.Init();
            CandidateLine."Document No." := SessionHeader."No.";
            CandidateLine."Line No." := LineNo;
            CandidateLine.Insert(true);
            CandidateLine.Validate("Candidate Contact No.", Contact."No.");
            CandidateLine.Validate("Attempt No.", 1);
            CandidateLine.Modify(true);

            LineNo += 10000;
        end;
    end;

    procedure ApplyResultDistribution(SessionHeaderNo: Code[20]; PassPct: Integer; FailPct: Integer)
    var
        CandidateLine: Record "MBS Cert. Candidate Line";
        TotalLines: Integer;
        PassCount: Integer;
        FailCount: Integer;
        CurrentLine: Integer;
    begin
        CandidateLine.SetRange("Document No.", SessionHeaderNo);
        TotalLines := CandidateLine.Count();
        PassCount := Round(TotalLines * PassPct / 100, 1);
        FailCount := Round(TotalLines * FailPct / 100, 1);
        CurrentLine := 0;

        if CandidateLine.FindSet() then
            repeat
                CurrentLine += 1;
                CandidateLine.Validate(Attended, true);
                if CurrentLine <= PassCount then
                    CandidateLine.Validate("Result Status", CandidateLine."Result Status"::Passed)
                else
                    if CurrentLine <= PassCount + FailCount then
                        CandidateLine.Validate("Result Status", CandidateLine."Result Status"::Failed)
                    else
                        CandidateLine.Validate("Result Status", CandidateLine."Result Status"::Absent);
                CandidateLine.Modify(true);
            until CandidateLine.Next() = 0;
    end;

    procedure PostSession(var SessionHeader: Record "MBS Cert. Session Header")
    var
        CertPost: Codeunit "MBS Certification-Post";
    begin
        SessionHeader.Validate(Status, SessionHeader.Status::Closed);
        SessionHeader.Modify(true);
        CertPost.Run(SessionHeader);
    end;

    procedure MeasureHistoryLookup(CertNo: Code[20]; CandidateContactNo: Code[20])
    var
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        LedgerEntry.SetRange("Certification No.", CertNo);
        if CandidateContactNo <> '' then
            LedgerEntry.SetRange("Candidate Contact No.", CandidateContactNo);
        LedgerEntry.SetLoadFields("Entry No.", "Result Status", "Attempt No.", "Posting Date");
        LedgerEntry.FindSet();
        repeat
        until LedgerEntry.Next() = 0;
    end;

    local procedure EnsureNoSeries(Prefix: Code[10]): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesCode: Code[20];
    begin
        NoSeriesCode := Prefix + '-0001';
        if NoSeries.Get(NoSeriesCode) then
            exit(NoSeriesCode);

        NoSeries.Init();
        NoSeries.Code := NoSeriesCode;
        NoSeries.Description := Prefix;
        NoSeries."Default Nos." := true;
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeriesCode;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine."Starting No." := Prefix + '-00001';
        NoSeriesLine."Ending No." := Prefix + '-99999';
        NoSeriesLine."Increment-by No." := 1;
        NoSeriesLine.Insert(true);

        exit(NoSeriesCode);
    end;
}
