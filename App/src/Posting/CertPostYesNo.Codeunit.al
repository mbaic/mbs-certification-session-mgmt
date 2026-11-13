namespace MBS.CertificationSessionManagement.Posting;

using MBS.CertificationSessionManagement.Session;
using System.Utilities;

codeunit 50001 "MBS Cert.-Post (Yes/No)"
{
    Access = Internal;
    TableNo = "MBS Cert. Session Header";

    trigger OnRun()
    begin
        SessionHeader.Copy(Rec);
        PostSession();
        Rec := SessionHeader;
    end;

    var
        SessionHeader: Record "MBS Cert. Session Header";
        CertPost: Codeunit "MBS Certification-Post";
        ConfirmMgt: Codeunit "Confirm Management";
        PostConfirmQst: Label 'Do you want to post the certification session?';

    local procedure PostSession()
    begin
        if not ConfirmMgt.GetResponse(PostConfirmQst, false) then
            exit;

        CertPost.Run(SessionHeader);
        Commit();
    end;
}
