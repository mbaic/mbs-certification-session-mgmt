namespace MBS.CertificationSessionManagement.Dataset;

using MBS.CertificationSessionManagement.Setup;
using MBS.CertificationSessionManagement.Certification;
using Microsoft.CRM.Contact;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;

codeunit 50301 "MBS Contoso Certification"
{
    Access = Internal;

    procedure CreateCertificationSetup()
    var
        CertSetup: Record "MBS Certification Setup";
    begin
        if not CertSetup.Get() then begin
            CertSetup.Init();
            CertSetup.Insert(true);
        end;

        if CertSetup."Certification Nos." = '' then
            CertSetup."Certification Nos." := EnsureNoSeries('D-CERT', 'Demo Certification Nos.', 'D-CERT-0001', 'D-CERT-9999');
        if CertSetup."Cert. Session Nos." = '' then
            CertSetup."Cert. Session Nos." := EnsureNoSeries('D-CSESS', 'Demo Cert. Session Nos.', 'D-CSESS-0001', 'D-CSESS-9999');
        if CertSetup."Posted Cert. Sess. Nos." = '' then
            CertSetup."Posted Cert. Sess. Nos." := EnsureNoSeries('D-PCSESS', 'Demo Posted Cert. Sess. Nos.', 'D-PCSESS-0001', 'D-PCSESS-9999');
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

    procedure CreateCertifications()
    begin
        EnsureCertification('AL Fundamentals Assessment', 1, 5, 30);
        EnsureCertification('BC Functional Consultant Exam', 2, 3, 25);
        EnsureCertification('Warehouse Safety Certification', 0.5, 2, 20);
        EnsureCertification('Data Privacy Awareness Test', 1, 1, 50);
        EnsureCertification('Product Specialist Accreditation', 1.5, 4, 15);
    end;

    procedure CreateInvigilators()
    begin
        EnsureInvigilator('D-INV-001', 'Anna Lindqvist');
        EnsureInvigilator('D-INV-002', 'Marcus Chen');
        EnsureInvigilator('D-INV-003', 'Sophie Mueller');
    end;

    procedure CreateRooms()
    begin
        EnsureRoom('D-ROOM-001', 'Assessment Room A', 30);
        EnsureRoom('D-ROOM-002', 'Assessment Room B', 20);
        EnsureRoom('D-ROOM-003', 'Small Exam Room C', 10);
    end;

    procedure CreateCandidates()
    begin
        EnsureCandidate('D-CAND-001', 'James Wilson');
        EnsureCandidate('D-CAND-002', 'Maria Santos');
        EnsureCandidate('D-CAND-003', 'Erik Johansson');
        EnsureCandidate('D-CAND-004', 'Priya Sharma');
        EnsureCandidate('D-CAND-005', 'Lucas Dubois');
        EnsureCandidate('D-CAND-006', 'Aisha Khan');
        EnsureCandidate('D-CAND-007', 'Thomas Berg');
        EnsureCandidate('D-CAND-008', 'Elena Rossi');
    end;

    procedure GetCertificationNo(Name: Text[50]): Code[20]
    var
        Certification: Record "MBS Certification";
    begin
        Certification.SetRange(Name, Name);
        Certification.FindFirst();
        exit(Certification."No.");
    end;

    procedure GetInvigilatorNo(ResourceNo: Code[20]): Code[20]
    begin
        exit(ResourceNo);
    end;

    procedure GetRoomNo(ResourceNo: Code[20]): Code[20]
    begin
        exit(ResourceNo);
    end;

    procedure GetCandidateNo(ContactNo: Code[20]): Code[20]
    begin
        exit(ContactNo);
    end;

    local procedure EnsureCertification(CertName: Text[50]; Duration: Decimal; MinCandidates: Integer; MaxCandidates: Integer)
    var
        Certification: Record "MBS Certification";
    begin
        Certification.SetRange(Name, CertName);
        if Certification.FindFirst() then
            exit;

        Certification.Init();
        Certification.Insert(true);
        Certification.Validate(Name, CertName);
        Certification.Validate(Duration, Duration);
        Certification.Validate("Min. Candidates", MinCandidates);
        Certification.Validate("Max. Candidates", MaxCandidates);
        Certification.Modify(true);
    end;

    local procedure EnsureInvigilator(ResourceNo: Code[20]; ResourceName: Text[100])
    var
        Resource: Record Resource;
    begin
        if Resource.Get(ResourceNo) then
            exit;

        Resource.Init();
        Resource."No." := ResourceNo;
        Resource.Insert(true);
        Resource.Validate(Type, Resource.Type::Person);
        Resource.Validate(Name, ResourceName);
        Resource.Modify(true);
    end;

    local procedure EnsureRoom(ResourceNo: Code[20]; ResourceName: Text[100]; MaxCapacity: Integer)
    var
        Resource: Record Resource;
    begin
        if Resource.Get(ResourceNo) then
            exit;

        Resource.Init();
        Resource."No." := ResourceNo;
        Resource.Insert(true);
        Resource.Validate(Type, Resource.Type::Machine);
        Resource.Validate(Name, ResourceName);
        Resource.Modify(true);
    end;

    local procedure EnsureCandidate(ContactNo: Code[20]; ContactName: Text[100])
    var
        Contact: Record Contact;
    begin
        if Contact.Get(ContactNo) then
            exit;

        Contact.Init();
        Contact."No." := ContactNo;
        Contact.Insert(true);
        Contact.Validate(Name, ContactName);
        Contact.Modify(true);
    end;

    local procedure EnsureNoSeries(SeriesCode: Code[20]; Description: Text[100]; StartNo: Code[20]; EndNo: Code[20]): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(SeriesCode) then
            exit(SeriesCode);

        NoSeries.Init();
        NoSeries.Code := SeriesCode;
        NoSeries.Description := Description;
        NoSeries."Default Nos." := true;
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := SeriesCode;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine."Starting No." := StartNo;
        NoSeriesLine."Ending No." := EndNo;
        NoSeriesLine."Increment-by No." := 1;
        NoSeriesLine.Insert(true);

        exit(SeriesCode);
    end;
}
