namespace MBS.CertificationSessionManagement.Dataset;

using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Posting;
using MBS.CertificationSessionManagement.Ledger;

codeunit 50303 "MBS Contoso Cert. History"
{
    Access = Internal;

    var
        ContosoCert: Codeunit "MBS Contoso Certification";
        ContosoCertSession: Codeunit "MBS Contoso Cert. Session";

    procedure CreatePostedSessions()
    begin
        CreateAndPostSession(
            'BC Functional Consultant Exam',
            CalcDate('<-60D>', WorkDate()),
            'D-INV-001',
            'D-ROOM-001');

        CreateAndPostSession(
            'Product Specialist Accreditation',
            CalcDate('<-30D>', WorkDate()),
            'D-INV-002',
            'D-ROOM-002');
    end;

    procedure CreateRetakeScenario()
    var
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        if not RetakeAlreadyExists('D-CAND-002', 'AL Fundamentals Assessment') then begin
            CreateRetakeSession(
                'AL Fundamentals Assessment',
                CalcDate('<-90D>', WorkDate()),
                'D-INV-003',
                'D-ROOM-003',
                'D-CAND-002',
                1,
                "MBS Cert. Result Status"::Failed);

            CreateRetakeSession(
                'AL Fundamentals Assessment',
                CalcDate('<-45D>', WorkDate()),
                'D-INV-003',
                'D-ROOM-003',
                'D-CAND-002',
                2,
                "MBS Cert. Result Status"::Passed);
        end;

        if not RetakeAlreadyExists('D-CAND-003', 'Warehouse Safety Certification') then begin
            CreateRetakeSession(
                'Warehouse Safety Certification',
                CalcDate('<-75D>', WorkDate()),
                'D-INV-001',
                'D-ROOM-002',
                'D-CAND-003',
                1,
                "MBS Cert. Result Status"::Absent);

            CreateRetakeSession(
                'Warehouse Safety Certification',
                CalcDate('<-30D>', WorkDate()),
                'D-INV-001',
                'D-ROOM-002',
                'D-CAND-003',
                2,
                "MBS Cert. Result Status"::Passed);
        end;
    end;

    local procedure CreateAndPostSession(CertName: Text[50]; SessionDate: Date; InvigilatorNo: Code[20]; RoomNo: Code[20])
    var
        SessionHeader: Record "MBS Cert. Session Header";
        PostedHeader: Record "MBS Posted Cert. Sess. Hdr.";
        CertPost: Codeunit "MBS Certification-Post";
    begin
        PostedHeader.SetRange("Certification No.", ContosoCert.GetCertificationNo(CertName));
        PostedHeader.SetRange("Session Date", SessionDate);
        if not PostedHeader.IsEmpty() then
            exit;

        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", ContosoCert.GetCertificationNo(CertName));
        SessionHeader.Validate("Session Date", SessionDate);
        SessionHeader.Validate("Invigilator Resource No.", InvigilatorNo);
        SessionHeader.Validate("Room Resource No.", RoomNo);
        SessionHeader.Validate("Posting Date", SessionDate);
        SessionHeader.Validate("Document Date", SessionDate);
        SessionHeader.Modify(true);

        AddHistoricalCandidate(SessionHeader."No.", 'D-CAND-004', 1, true, "MBS Cert. Result Status"::Passed);
        AddHistoricalCandidate(SessionHeader."No.", 'D-CAND-005', 1, true, "MBS Cert. Result Status"::Passed);
        AddHistoricalCandidate(SessionHeader."No.", 'D-CAND-006', 1, true, "MBS Cert. Result Status"::Failed);
        AddHistoricalCandidate(SessionHeader."No.", 'D-CAND-007', 1, true, "MBS Cert. Result Status"::Passed);

        SessionHeader.Validate(Status, SessionHeader.Status::Closed);
        SessionHeader.Modify(true);
        CertPost.Run(SessionHeader);
    end;

    local procedure CreateRetakeSession(CertName: Text[50]; SessionDate: Date; InvigilatorNo: Code[20]; RoomNo: Code[20]; CandidateNo: Code[20]; AttemptNo: Integer; ResultStatus: Enum "MBS Cert. Result Status")
    var
        SessionHeader: Record "MBS Cert. Session Header";
        CertPost: Codeunit "MBS Certification-Post";
    begin
        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", ContosoCert.GetCertificationNo(CertName));
        SessionHeader.Validate("Session Date", SessionDate);
        SessionHeader.Validate("Invigilator Resource No.", InvigilatorNo);
        SessionHeader.Validate("Room Resource No.", RoomNo);
        SessionHeader.Validate("Posting Date", SessionDate);
        SessionHeader.Validate("Document Date", SessionDate);
        SessionHeader.Modify(true);

        AddHistoricalCandidate(
            SessionHeader."No.",
            CandidateNo,
            AttemptNo,
            ResultStatus <> "MBS Cert. Result Status"::Absent,
            ResultStatus);

        SessionHeader.Validate(Status, SessionHeader.Status::Closed);
        SessionHeader.Modify(true);
        CertPost.Run(SessionHeader);
    end;

    local procedure AddHistoricalCandidate(SessionNo: Code[20]; CandidateContactNo: Code[20]; AttemptNo: Integer; Attended: Boolean; ResultStatus: Enum "MBS Cert. Result Status")
    var
        CandidateLine: Record "MBS Cert. Candidate Line";
        LineNo: Integer;
    begin
        CandidateLine.SetRange("Document No.", SessionNo);
        if CandidateLine.FindLast() then
            LineNo := CandidateLine."Line No." + 10000
        else
            LineNo := 10000;

        CandidateLine.Init();
        CandidateLine."Document No." := SessionNo;
        CandidateLine."Line No." := LineNo;
        CandidateLine.Insert(true);
        CandidateLine.Validate("Candidate Contact No.", CandidateContactNo);
        CandidateLine.Validate("Attempt No.", AttemptNo);
        CandidateLine.Validate(Attended, Attended);
        CandidateLine.Validate("Result Status", ResultStatus);
        CandidateLine.Modify(true);
    end;

    local procedure RetakeAlreadyExists(CandidateContactNo: Code[20]; CertName: Text[50]): Boolean
    var
        LedgerEntry: Record "MBS Cert. Ledger Entry";
    begin
        LedgerEntry.SetRange("Certification No.", ContosoCert.GetCertificationNo(CertName));
        LedgerEntry.SetRange("Candidate Contact No.", CandidateContactNo);
        exit(LedgerEntry.Count() >= 2);
    end;
}
