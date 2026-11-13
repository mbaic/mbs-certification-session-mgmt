namespace MBS.CertificationSessionManagement.Posting;

using MBS.CertificationSessionManagement.Ledger;

codeunit 50003 "MBS Cert. Jnl.-Post Line"
{
    Access = Internal;
    TableNo = "MBS Cert. Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        CertJnlLine: Record "MBS Cert. Journal Line";
        CertLedgerEntry: Record "MBS Cert. Ledger Entry";
        CertRegister: Record "MBS Cert. Register";
        CertJnlCheckLine: Codeunit "MBS Cert. Jnl.-Check Line";
        NextEntryNo: Integer;

    procedure RunWithCheck(var CertJnlLine2: Record "MBS Cert. Journal Line")
    begin
        CertJnlLine := CertJnlLine2;
        Code();
        CertJnlLine2 := CertJnlLine;
    end;

    local procedure Code()
    begin
        if CertJnlLine.EmptyLine() then
            exit;

        CertJnlCheckLine.RunCheck(CertJnlLine);
        InitNextEntryNo();

        if CertJnlLine."Document Date" = 0D then
            CertJnlLine."Document Date" := CertJnlLine."Posting Date";

        UpdateRegister();
        InsertLedgerEntry();
    end;

    local procedure InitNextEntryNo()
    begin
        if NextEntryNo <> 0 then
            exit;

        CertLedgerEntry.ReadIsolation(IsolationLevel::UpdLock);
        if CertLedgerEntry.FindLast() then
            NextEntryNo := CertLedgerEntry."Entry No.";
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure InsertLedgerEntry()
    begin
        CertLedgerEntry.Init();
        CertLedgerEntry."Entry No." := NextEntryNo;
        CertLedgerEntry."Certification No." := CertJnlLine."Certification No.";
        CertLedgerEntry."Posting Date" := CertJnlLine."Posting Date";
        CertLedgerEntry."Document Date" := CertJnlLine."Document Date";
        CertLedgerEntry."Entry Type" := CertJnlLine."Entry Type";
        CertLedgerEntry."Document No." := CertJnlLine."Document No.";
        CertLedgerEntry.Description := CertJnlLine.Description;
        CertLedgerEntry."Candidate Contact No." := CertJnlLine."Candidate Contact No.";
        CertLedgerEntry."Candidate Name" := CertJnlLine."Candidate Name";
        CertLedgerEntry."Result Status" := CertJnlLine."Result Status";
        CertLedgerEntry."Attempt No." := CertJnlLine."Attempt No.";
        CertLedgerEntry.Score := CertJnlLine.Score;
        CertLedgerEntry."Invigilator Resource No." := CertJnlLine."Invigilator Resource No.";
        CertLedgerEntry."Room Resource No." := CertJnlLine."Room Resource No.";
        CertLedgerEntry."Session Date" := CertJnlLine."Session Date";
        CertLedgerEntry."Cert. Session No." := CertJnlLine."Cert. Session No.";
        CertLedgerEntry."Source Code" := CertJnlLine."Source Code";
        CertLedgerEntry."Reason Code" := CertJnlLine."Reason Code";
        CertLedgerEntry."Posting No. Series" := CertJnlLine."Posting No. Series";
        CertLedgerEntry."Journal Batch Name" := CertJnlLine."Journal Batch Name";
        CertLedgerEntry."User Id" := CopyStr(UserId(), 1, 50);
        CertLedgerEntry.Insert(false);
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure UpdateRegister()
    begin
        if CertRegister."No." = 0 then begin
            CertRegister.ReadIsolation(IsolationLevel::UpdLock);
            if (not CertRegister.FindLast()) or (CertRegister."To Entry No." <> 0) then begin
                CertRegister.Init();
                CertRegister."No." := CertRegister."No." + 1;
                CertRegister."From Entry No." := NextEntryNo;
                CertRegister."To Entry No." := NextEntryNo;
                CertRegister."Creation Date" := Today();
                CertRegister."Source Code" := CertJnlLine."Source Code";
                CertRegister."Journal Batch Name" := CertJnlLine."Journal Batch Name";
                CertRegister."User ID" := CopyStr(UserId(), 1, 50);
                CertRegister.Insert(false);
            end;
        end;
        CertRegister."To Entry No." := NextEntryNo;
        CertRegister.Modify(false);
    end;
}
