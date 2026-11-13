namespace MBS.CertificationSessionManagement.Test;

using System.TestLibraries.Utilities;
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

codeunit 50100 "MBS Library - Cert. Session"
{
    Access = Internal;

    var
        Any: Codeunit Any;
        CertNoSeriesCode: Code[20];
        SessionNoSeriesCode: Code[20];
        PostedSessionNoSeriesCode: Code[20];

    procedure CreateCertificationSetup()
    var
        CertSetup: Record "MBS Certification Setup";
    begin
        if not CertSetup.Get() then begin
            CertSetup.Init();
            CertSetup.Insert(true);
        end;

        if CertSetup."Certification Nos." = '' then begin
            CertNoSeriesCode := CreateNoSeries('CERT');
            CertSetup."Certification Nos." := CertNoSeriesCode;
        end;
        if CertSetup."Cert. Session Nos." = '' then begin
            SessionNoSeriesCode := CreateNoSeries('CERTSESS');
            CertSetup."Cert. Session Nos." := SessionNoSeriesCode;
        end;
        if CertSetup."Posted Cert. Sess. Nos." = '' then begin
            PostedSessionNoSeriesCode := CreateNoSeries('PCERTSESS');
            CertSetup."Posted Cert. Sess. Nos." := PostedSessionNoSeriesCode;
        end;
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
        Certification.Validate(Name, 'Test Certification ' + Format(Certification."No."));
        Certification.Validate(Duration, 1);
        Certification.Validate("Min. Candidates", 1);
        Certification.Validate("Max. Candidates", 20);
        Certification.Modify(true);
    end;

    procedure CreateBlockedCertification(var Certification: Record "MBS Certification")
    begin
        CreateCertification(Certification);
        Certification.Validate(Blocked, true);
        Certification.Modify(true);
    end;

    procedure CreateInvigilatorResource(var Resource: Record Resource)
    begin
        Resource.Init();
        Resource."No." := CopyStr(Any.AlphanumericText(MaxStrLen(Resource."No.")), 1, MaxStrLen(Resource."No."));
        Resource.Type := Resource.Type::Person;
        Resource.Name := CopyStr('Invigilator ' + Resource."No.", 1, MaxStrLen(Resource.Name));
        Resource.Insert(true);
    end;

    procedure CreateRoomResource(var Resource: Record Resource)
    begin
        Resource.Init();
        Resource."No." := CopyStr(Any.AlphanumericText(MaxStrLen(Resource."No.")), 1, MaxStrLen(Resource."No."));
        Resource.Type := Resource.Type::Machine;
        Resource.Name := CopyStr('Room ' + Resource."No.", 1, MaxStrLen(Resource.Name));
        Resource.Insert(true);
    end;

    procedure CreateCandidateContact(var Contact: Record Contact)
    begin
        Contact.Init();
        Contact."No." := '';
        Contact.Insert(true);
        Contact.Validate(Name, 'Candidate ' + Contact."No.");
        Contact.Modify(true);
    end;

    procedure CreateCertSessionHeader(var SessionHeader: Record "MBS Cert. Session Header")
    var
        Certification: Record "MBS Certification";
        Invigilator: Record Resource;
        Room: Record Resource;
    begin
        CreateCertification(Certification);
        CreateInvigilatorResource(Invigilator);
        CreateRoomResource(Room);

        CreateCertificationSetup();
        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", Certification."No.");
        SessionHeader.Validate("Session Date", WorkDate());
        SessionHeader.Validate("Invigilator Resource No.", Invigilator."No.");
        SessionHeader.Validate("Room Resource No.", Room."No.");
        SessionHeader.Validate("Posting Date", WorkDate());
        SessionHeader.Validate("Document Date", WorkDate());
        SessionHeader.Modify(true);
    end;

    procedure AddCandidateLine(var CandidateLine: Record "MBS Cert. Candidate Line"; SessionHeaderNo: Code[20])
    var
        Contact: Record Contact;
        LineNo: Integer;
    begin
        CreateCandidateContact(Contact);

        CandidateLine.Reset();
        CandidateLine.SetRange("Document No.", SessionHeaderNo);
        if CandidateLine.FindLast() then
            LineNo := CandidateLine."Line No." + 10000
        else
            LineNo := 10000;

        CandidateLine.Init();
        CandidateLine."Document No." := SessionHeaderNo;
        CandidateLine."Line No." := LineNo;
        CandidateLine.Insert(true);
        CandidateLine.Validate("Candidate Contact No.", Contact."No.");
        CandidateLine.Validate("Attempt No.", 1);
        CandidateLine.Modify(true);
    end;

    procedure SetCandidateResult(var CandidateLine: Record "MBS Cert. Candidate Line"; ResultStatus: Enum "MBS Cert. Result Status"; Attended: Boolean)
    begin
        CandidateLine.Validate(Attended, Attended);
        CandidateLine.Validate("Result Status", ResultStatus);
        CandidateLine.Modify(true);
    end;

    procedure CloseCertificationSession(var SessionHeader: Record "MBS Cert. Session Header")
    begin
        SessionHeader.Validate(Status, SessionHeader.Status::Closed);
        SessionHeader.Modify(true);
    end;

    procedure PostCertificationSession(var SessionHeader: Record "MBS Cert. Session Header")
    var
        CertPost: Codeunit "MBS Certification-Post";
    begin
        CertPost.Run(SessionHeader);
    end;

    procedure CreateReadyToPostSession(var SessionHeader: Record "MBS Cert. Session Header"; CandidateCount: Integer)
    var
        CandidateLine: Record "MBS Cert. Candidate Line";
        i: Integer;
    begin
        CreateCertSessionHeader(SessionHeader);
        for i := 1 to CandidateCount do begin
            AddCandidateLine(CandidateLine, SessionHeader."No.");
            SetCandidateResult(CandidateLine, CandidateLine."Result Status"::Passed, true);
        end;
        CloseCertificationSession(SessionHeader);
    end;

    procedure PostAndGetPostedSession(var SessionHeader: Record "MBS Cert. Session Header"; var PostedHeader: Record "MBS Posted Cert. Sess. Hdr.")
    begin
        PostCertificationSession(SessionHeader);
        PostedHeader.SetRange("Pre-Assigned No.", SessionHeader."No.");
        PostedHeader.FindFirst();
    end;

    procedure FindPostedCandidateLine(var PostedCandLine: Record "MBS Posted Cert. Cand. Line"; PostedDocNo: Code[20]; CandidateContactNo: Code[20])
    begin
        PostedCandLine.SetRange("Document No.", PostedDocNo);
        PostedCandLine.SetRange("Candidate Contact No.", CandidateContactNo);
        PostedCandLine.FindFirst();
    end;

    procedure FindCertLedgerEntry(var LedgerEntry: Record "MBS Cert. Ledger Entry"; CertNo: Code[20]; CandidateContactNo: Code[20])
    begin
        LedgerEntry.SetRange("Certification No.", CertNo);
        LedgerEntry.SetRange("Candidate Contact No.", CandidateContactNo);
        LedgerEntry.FindFirst();
    end;

    procedure CreateCertCommentLine(TableName: Enum "MBS Cert. Comment Table Name"; No: Code[20]; CommentText: Text[80])
    var
        CommentLine: Record "MBS Cert. Comment Line";
        LineNo: Integer;
    begin
        CommentLine.Reset();
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", No);
        if CommentLine.FindLast() then
            LineNo := CommentLine."Line No." + 10000
        else
            LineNo := 10000;

        CommentLine.Init();
        CommentLine."Table Name" := TableName;
        CommentLine."No." := No;
        CommentLine."Line No." := LineNo;
        CommentLine.Insert(true);
        CommentLine.Validate(Comment, CommentText);
        CommentLine.Modify(true);
    end;

    local procedure CreateNoSeries(Prefix: Code[10]): Code[20]
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
        NoSeries.Description := Prefix + ' Number Series';
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
