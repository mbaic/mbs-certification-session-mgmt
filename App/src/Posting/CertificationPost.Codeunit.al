namespace MBS.CertificationSessionManagement.Posting;

using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Setup;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;

codeunit 50000 "MBS Certification-Post"
{
    Access = Internal;
    TableNo = "MBS Cert. Session Header";

    trigger OnRun()
    begin
        ClearAll();
        SessionHeader := Rec;

        ValidateHeaderFields();
        CheckCandidatesExist();

        Window.Open('#1#################################\\' + PostingProgressTxt);
        Window.Update(1, StrSubstNo('%1 %2', SessionLbl, SessionHeader."No."));

        AssignPostingNo();
        InitPosting();
        CreatePostedHeader();

        Window.Update(1, StrSubstNo(PostedProgressTxt, SessionHeader."No.", PostedHeader."No."));

        CopyCommentLines(
            CertCommentLine."Table Name"::"Certification Session",
            CertCommentLine."Table Name"::"Posted Certification Session",
            SessionHeader."No.",
            PostedHeader."No.");

        PostCandidateLines();

        Window.Close();
        Rec := SessionHeader;
    end;

    var
        CertCommentLine: Record "MBS Cert. Comment Line";
        CertCommentLine2: Record "MBS Cert. Comment Line";
        CertJnlLine: Record "MBS Cert. Journal Line";
        CandidateLine: Record "MBS Cert. Candidate Line";
        PostedCandLine: Record "MBS Posted Cert. Cand. Line";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        SessionHeader: Record "MBS Cert. Session Header";
        SourceCodeSetup: Record "Source Code Setup";
        CertJnlPostLine: Codeunit "MBS Cert. Jnl.-Post Line";
        NoSeriesMgt: Codeunit "No. Series";
        SourceCode: Code[10];
        Window: Dialog;
        LineCount: Integer;
        NoCandidateErr: Label 'There are no candidates to post.';
        PostingProgressTxt: Label 'Posting lines              #2######\', Comment = '#2 is the line count.';
        SessionLbl: Label 'Session';
        PostedProgressTxt: Label 'Session %1  -> Posted Session %2', Comment = '%1 = session no., %2 = posted session no.';

    local procedure AssignPostingNo()
    begin
        if SessionHeader."Posting No." <> '' then
            exit;

        SessionHeader.TestField("Posting No. Series");
        SessionHeader."Posting No." := NoSeriesMgt.GetNextNo(SessionHeader."Posting No. Series", SessionHeader."Posting Date");
        SessionHeader.Modify(false);
        Commit();
    end;

    local procedure InitPosting()
    begin
        SourceCodeSetup.Get();
        SourceCode := SourceCodeSetup."MBS Certification";
    end;

    local procedure CheckCandidatesExist()
    begin
        CandidateLine.Reset();
        CandidateLine.SetRange("Document No.", SessionHeader."No.");
        if CandidateLine.IsEmpty() then
            Error(NoCandidateErr);
    end;

    local procedure CopyCommentLines(FromTableName: Enum "MBS Cert. Comment Table Name"; ToTableName: Enum "MBS Cert. Comment Table Name"; FromNo: Code[20]; ToNo: Code[20])
    begin
        CertCommentLine.Reset();
        CertCommentLine.SetRange("Table Name", FromTableName);
        CertCommentLine.SetRange("No.", FromNo);
        if CertCommentLine.FindSet() then
            repeat
                CertCommentLine2 := CertCommentLine;
                CertCommentLine2."Table Name" := ToTableName;
                CertCommentLine2."No." := ToNo;
                CertCommentLine2.Insert(false);
            until CertCommentLine.Next() = 0;
    end;

    local procedure CreatePostedHeader()
    begin
        PostedHeader.Init();
        PostedHeader.TransferFields(SessionHeader);
        PostedHeader."No." := SessionHeader."Posting No.";
        PostedHeader."No. Series" := SessionHeader."Posting No. Series";
        PostedHeader."Pre-Assigned No." := SessionHeader."No.";
        PostedHeader."User Id" := CopyStr(UserId(), 1, 50);
        PostedHeader.Insert(false);
    end;

    local procedure CreatePostedCandidateLine()
    begin
        PostedCandLine.Init();
        PostedCandLine.TransferFields(CandidateLine);
        PostedCandLine."Document No." := PostedHeader."No.";
        PostedCandLine.Insert(false);
    end;

    local procedure PostCandidateLines()
    begin
        LineCount := 0;
        CandidateLine.Reset();
        CandidateLine.SetRange("Document No.", SessionHeader."No.");
        if not CandidateLine.FindSet() then
            exit;

        repeat
            LineCount += 1;
            Window.Update(2, LineCount);
            PostCandidateLine();
        until CandidateLine.Next() = 0;

        // Delete original document
        CandidateLine.Reset();
        CandidateLine.SetRange("Document No.", SessionHeader."No.");
        CandidateLine.DeleteAll(false);

        CertCommentLine.Reset();
        CertCommentLine.SetRange("Table Name", CertCommentLine."Table Name"::"Certification Session");
        CertCommentLine.SetRange("No.", SessionHeader."No.");
        CertCommentLine.DeleteAll(false);

        SessionHeader.Delete(false);
    end;

    local procedure PostCandidateLine()
    begin
        CandidateLine.TestField("Candidate Contact No.");

        PostCertJnlLine();
        CreatePostedCandidateLine();
    end;

    local procedure PostCertJnlLine()
    begin
        CertJnlLine.Init();
        CertJnlLine."Certification No." := SessionHeader."Certification No.";
        CertJnlLine."Posting Date" := SessionHeader."Posting Date";
        CertJnlLine."Document Date" := SessionHeader."Document Date";
        CertJnlLine."Document No." := PostedHeader."No.";
        CertJnlLine."Entry Type" := CertJnlLine."Entry Type"::Registration;
        CertJnlLine."Candidate Contact No." := CandidateLine."Candidate Contact No.";
        CertJnlLine."Candidate Name" := CopyStr(CandidateLine."Candidate Name", 1, MaxStrLen(CertJnlLine."Candidate Name"));
        CertJnlLine.Description := CopyStr(CandidateLine."Candidate Name", 1, MaxStrLen(CertJnlLine.Description));
        CertJnlLine."Result Status" := CandidateLine."Result Status";
        CertJnlLine."Attempt No." := CandidateLine."Attempt No.";
        CertJnlLine.Score := CandidateLine.Score;
        CertJnlLine."Invigilator Resource No." := SessionHeader."Invigilator Resource No.";
        CertJnlLine."Room Resource No." := SessionHeader."Room Resource No.";
        CertJnlLine."Session Date" := SessionHeader."Session Date";
        CertJnlLine."Cert. Session No." := PostedHeader."No.";
        CertJnlLine."Source Code" := SourceCode;
        CertJnlLine."Reason Code" := SessionHeader."Reason Code";
        CertJnlLine."Posting No. Series" := SessionHeader."Posting No. Series";

        CertJnlPostLine.RunWithCheck(CertJnlLine);
    end;

    local procedure ValidateHeaderFields()
    begin
        SessionHeader.TestField("Posting Date");
        SessionHeader.TestField("Document Date");
        SessionHeader.TestField("Certification No.");
        SessionHeader.TestField(Duration);
        SessionHeader.TestField("Invigilator Resource No.");
        SessionHeader.TestField("Room Resource No.");
        SessionHeader.TestField(Status, SessionHeader.Status::Closed);
    end;
}
