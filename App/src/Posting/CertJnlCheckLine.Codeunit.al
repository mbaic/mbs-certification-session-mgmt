namespace MBS.CertificationSessionManagement.Posting;

using Microsoft.Finance.GeneralLedger.Setup;
using System.Security.User;

codeunit 50002 "MBS Cert. Jnl.-Check Line"
{
    Access = Internal;
    TableNo = "MBS Cert. Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        ClosingDateErr: Label 'cannot be a closing date.';
        PostingDateNotAllowedErr: Label 'is not within your range of allowed posting dates.';

    procedure RunCheck(var CertJnlLine: Record "MBS Cert. Journal Line")
    begin
        if CertJnlLine.EmptyLine() then
            exit;

        CheckMandatoryFields(CertJnlLine);
        CheckPostingDate(CertJnlLine);
        CheckDocumentDate(CertJnlLine);
    end;

    local procedure CheckMandatoryFields(var CertJnlLine: Record "MBS Cert. Journal Line")
    begin
        CertJnlLine.TestField("Posting Date");
        CertJnlLine.TestField("Certification No.");
    end;

    local procedure CheckDocumentDate(var CertJnlLine: Record "MBS Cert. Journal Line")
    begin
        if (CertJnlLine."Document Date" <> 0D) and
           (CertJnlLine."Document Date" = ClosingDate(CertJnlLine."Document Date"))
        then
            CertJnlLine.FieldError("Document Date", ClosingDateErr);
    end;

    local procedure CheckPostingDate(var CertJnlLine: Record "MBS Cert. Journal Line")
    begin
        if CertJnlLine."Posting Date" = ClosingDate(CertJnlLine."Posting Date") then
            CertJnlLine.FieldError("Posting Date", ClosingDateErr);

        InitAllowedPostingDateRange();

        if (CertJnlLine."Posting Date" < AllowPostingFrom) or (CertJnlLine."Posting Date" > AllowPostingTo) then
            CertJnlLine.FieldError("Posting Date", PostingDateNotAllowedErr);
    end;

    local procedure InitAllowedPostingDateRange()
    begin
        if (AllowPostingFrom <> 0D) or (AllowPostingTo <> 0D) then
            exit;

        if UserId() <> '' then
            if UserSetup.Get(UserId()) then begin
                AllowPostingFrom := UserSetup."Allow Posting From";
                AllowPostingTo := UserSetup."Allow Posting To";
            end;

        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then
            if GLSetup.Get() then begin
                AllowPostingFrom := GLSetup."Allow Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            end;

        if AllowPostingTo = 0D then
            AllowPostingTo := DMY2Date(31, 12, 9999);
    end;
}
