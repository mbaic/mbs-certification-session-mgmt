namespace MBS.CertificationSessionManagement.Dataset;

using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Posting;

codeunit 50302 "MBS Contoso Cert. Session"
{
    Access = Internal;

    var
        ContosoCert: Codeunit "MBS Contoso Certification";

    procedure CreatePlannedSession()
    var
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        if SessionAlreadyExists('AL Fundamentals Assessment', CalcDate('<+30D>', WorkDate())) then
            exit;

        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", ContosoCert.GetCertificationNo('AL Fundamentals Assessment'));
        SessionHeader.Validate("Session Date", CalcDate('<+30D>', WorkDate()));
        SessionHeader.Validate("Invigilator Resource No.", 'D-INV-001');
        SessionHeader.Validate("Room Resource No.", 'D-ROOM-001');
        SessionHeader.Validate(Status, SessionHeader.Status::Planning);
        SessionHeader.Modify(true);

        AddCandidateToSession(SessionHeader."No.", 'D-CAND-001', 1);
        AddCandidateToSession(SessionHeader."No.", 'D-CAND-002', 1);
        AddCandidateToSession(SessionHeader."No.", 'D-CAND-003', 1);
    end;

    procedure CreateOpenSessionWithCandidates()
    var
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        if SessionAlreadyExists('Warehouse Safety Certification', CalcDate('<+7D>', WorkDate())) then
            exit;

        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", ContosoCert.GetCertificationNo('Warehouse Safety Certification'));
        SessionHeader.Validate("Session Date", CalcDate('<+7D>', WorkDate()));
        SessionHeader.Validate("Invigilator Resource No.", 'D-INV-002');
        SessionHeader.Validate("Room Resource No.", 'D-ROOM-002');
        SessionHeader.Validate(Status, SessionHeader.Status::Open);
        SessionHeader.Modify(true);

        AddCandidateWithResult(SessionHeader."No.", 'D-CAND-004', 1, true, "MBS Cert. Result Status"::Passed);
        AddCandidateWithResult(SessionHeader."No.", 'D-CAND-005', 1, true, "MBS Cert. Result Status"::Failed);
        AddCandidateWithResult(SessionHeader."No.", 'D-CAND-006', 1, false, "MBS Cert. Result Status"::" ");
    end;

    procedure CreateReadyToPostSession()
    var
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        if SessionAlreadyExists('Data Privacy Awareness Test', CalcDate('<+3D>', WorkDate())) then
            exit;

        SessionHeader.Init();
        SessionHeader.Insert(true);
        SessionHeader.Validate("Certification No.", ContosoCert.GetCertificationNo('Data Privacy Awareness Test'));
        SessionHeader.Validate("Session Date", CalcDate('<+3D>', WorkDate()));
        SessionHeader.Validate("Invigilator Resource No.", 'D-INV-003');
        SessionHeader.Validate("Room Resource No.", 'D-ROOM-003');
        SessionHeader.Validate("Posting Date", CalcDate('<+3D>', WorkDate()));
        SessionHeader.Validate("Document Date", CalcDate('<+3D>', WorkDate()));
        SessionHeader.Validate(Status, SessionHeader.Status::Closed);
        SessionHeader.Modify(true);

        AddCandidateWithResult(SessionHeader."No.", 'D-CAND-007', 1, true, "MBS Cert. Result Status"::Passed);
        AddCandidateWithResult(SessionHeader."No.", 'D-CAND-008', 1, true, "MBS Cert. Result Status"::Passed);
        AddCandidateWithResult(SessionHeader."No.", 'D-CAND-001', 2, true, "MBS Cert. Result Status"::Failed);
    end;

    local procedure AddCandidateToSession(SessionNo: Code[20]; CandidateContactNo: Code[20]; AttemptNo: Integer)
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
        CandidateLine.Modify(true);
    end;

    local procedure AddCandidateWithResult(SessionNo: Code[20]; CandidateContactNo: Code[20]; AttemptNo: Integer; Attended: Boolean; ResultStatus: Enum "MBS Cert. Result Status")
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

    local procedure SessionAlreadyExists(CertName: Text[50]; SessionDate: Date): Boolean
    var
        SessionHeader: Record "MBS Cert. Session Header";
    begin
        SessionHeader.SetRange("Certification No.", ContosoCert.GetCertificationNo(CertName));
        SessionHeader.SetRange("Session Date", SessionDate);
        exit(not SessionHeader.IsEmpty());
    end;
}
