namespace MBS.CertificationSessionManagement.PerformanceTest;

using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Certification;
using Microsoft.Projects.Resources.Resource;

codeunit 50252 "MBS BCPT Session Contention"
{
    Access = Internal;

    trigger OnRun()
    var
        SessionHeader: Record "MBS Cert. Session Header";
        Certification: Record "MBS Certification";
        SharedInvigilator: Record Resource;
        SharedRoom: Record Resource;
        i: Integer;
    begin
        BCPTLibrary.CreateCertification(Certification);
        BCPTLibrary.CreateInvigilatorResource(SharedInvigilator);
        BCPTLibrary.CreateRoomResource(SharedRoom);

        for i := 1 to 5 do begin
            BCPTLibrary.CreateCertificationSetup();
            SessionHeader.Init();
            SessionHeader.Insert(true);
            SessionHeader.Validate("Certification No.", Certification."No.");
            SessionHeader.Validate("Session Date", WorkDate() + i);
            SessionHeader.Validate("Invigilator Resource No.", SharedInvigilator."No.");
            SessionHeader.Validate("Room Resource No.", SharedRoom."No.");
            SessionHeader.Validate("Posting Date", WorkDate() + i);
            SessionHeader.Validate("Document Date", WorkDate() + i);
            SessionHeader.Modify(true);

            BCPTLibrary.ApplyResultDistribution(SessionHeader."No.", 70, 20);
            BCPTLibrary.PostSession(SessionHeader);
        end;
    end;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Cert.";
}
