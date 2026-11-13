namespace MBS.CertificationSessionManagement.Setup;

using Microsoft.Foundation.AuditCodes;

codeunit 50004 "MBS Certification Install"
{
    Subtype = Install;
    Access = Internal;

    trigger OnInstallAppPerCompany()
    begin
        InsertSourceCode();
    end;

    local procedure InsertSourceCode()
    var
        SourceCode: Record "Source Code";
        SourceCodeSetup: Record "Source Code Setup";
        SourceCodeCodeTok: Label 'MBSCERT', Locked = true;
        SourceCodeDescTxt: Label 'Certification Session Posting';
    begin
        if not SourceCode.Get(SourceCodeCodeTok) then begin
            SourceCode.Init();
            SourceCode.Code := SourceCodeCodeTok;
            SourceCode.Description := CopyStr(SourceCodeDescTxt, 1, MaxStrLen(SourceCode.Description));
            SourceCode.Insert(false);
        end;

        if not SourceCodeSetup.Get() then
            exit;
        if SourceCodeSetup."MBS Certification" <> SourceCodeCodeTok then begin
            SourceCodeSetup."MBS Certification" := SourceCodeCodeTok;
            SourceCodeSetup.Modify(false);
        end;
    end;
}
