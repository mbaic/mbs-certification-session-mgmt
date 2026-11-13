namespace MBS.CertificationSessionManagement.Session;

using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Posting;
using MBS.CertificationSessionManagement.Setup;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;

table 50002 "MBS Cert. Session Header"
{
    Access = Internal;
    Caption = 'Certification Session Header';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    DrillDownPageId = "MBS Cert. Session List";
    LookupPageId = "MBS Cert. Session List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the session number.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GetSetup();
                    if NoSeries.IsManual(CertSetup."Cert. Session Nos.") then
                        "No. Series" := '';
                end;
            end;
        }
        field(20; "Certification No."; Code[20])
        {
            Caption = 'Certification No.';
            TableRelation = "MBS Certification";
            ToolTip = 'Specifies the certification this session is for.';

            trigger OnValidate()
            begin
                if "Certification No." <> xRec."Certification No." then begin
                    if "Certification No." = '' then begin
                        "Certification Name" := '';
                        Duration := 0;
                        "Min. Candidates" := 0;
                        "Max. Candidates" := 0;
                        exit;
                    end;
                    Certification.Get("Certification No.");
                    Certification.TestField(Blocked, false);
                    "Certification Name" := Certification.Name;
                    Duration := Certification.Duration;
                    "Min. Candidates" := Certification."Min. Candidates";
                    "Max. Candidates" := Certification."Max. Candidates";
                end;
            end;
        }
        field(30; "Certification Name"; Text[50])
        {
            Caption = 'Certification Name';
            ToolTip = 'Specifies the name of the certification.';
        }
        field(40; "Session Date"; Date)
        {
            Caption = 'Session Date';
            ToolTip = 'Specifies the planned date of the certification session.';

            trigger OnValidate()
            begin
                if "Session Date" <> xRec."Session Date" then
                    TestField(Status, Status::Planning);
            end;
        }
        field(50; "Invigilator Resource No."; Code[20])
        {
            Caption = 'Invigilator Resource No.';
            TableRelation = Resource where(Type = const(Person));
            ToolTip = 'Specifies the invigilator/assessor for this session.';

            trigger OnValidate()
            begin
                CalcFields("Invigilator Name");
            end;
        }
        field(60; "Invigilator Name"; Text[100])
        {
            CalcFormula = lookup(Resource.Name where("No." = field("Invigilator Resource No."), Type = const(Person)));
            Caption = 'Invigilator Name';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the name of the invigilator.';
        }
        field(70; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where(Type = const(Machine));
            ToolTip = 'Specifies the room for this session.';

            trigger OnValidate()
            begin
                if "Room Resource No." <> '' then begin
                    Room.Get("Room Resource No.");
                    "Room Name" := CopyStr(Room.Name, 1, MaxStrLen("Room Name"));
                end else
                    "Room Name" := '';
            end;
        }
        field(80; "Room Name"; Text[50])
        {
            Caption = 'Room Name';
            ToolTip = 'Specifies the name of the room.';
        }
        field(90; Status; Enum "MBS Cert. Session Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status of the session.';
        }
        field(100; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
            ToolTip = 'Specifies the session duration in days.';
        }
        field(110; "Min. Candidates"; Integer)
        {
            Caption = 'Min. Candidates';
            ToolTip = 'Specifies the minimum number of candidates.';
        }
        field(120; "Max. Candidates"; Integer)
        {
            Caption = 'Max. Candidates';
            ToolTip = 'Specifies the maximum number of candidates.';
        }
        field(130; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date for this session.';
        }
        field(140; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ToolTip = 'Specifies the document date.';
        }
        field(150; "Reason Code"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
            ToolTip = 'Specifies the reason code.';
        }
        field(160; Comment; Boolean)
        {
            AllowInCustomizations = Never;
            CalcFormula = exist("MBS Cert. Comment Line" where("Table Name" = const("Certification Session"), "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies whether comments exist for this session.';
        }
        field(170; "No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series".Code;
        }
        field(180; "Posting No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'Posting No. Series';
            TableRelation = "No. Series".Code;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    GetSetup();
                    CertSetup.TestField("Cert. Session Nos.");
                    CertSetup.TestField("Posted Cert. Sess. Nos.");
                    NoSeries.TestAreRelated(CertSetup."Posted Cert. Sess. Nos.", "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;
        }
        field(190; "Posting No."; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'Posting No.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Certification No.", "Certification Name")
        {
        }
        fieldgroup(Brick; "No.", "Certification Name")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GetSetup();
            CertSetup.TestField("Cert. Session Nos.");
            "No." := NoSeries.GetNextNo(CertSetup."Cert. Session Nos.", WorkDate());
            "No. Series" := CertSetup."Cert. Session Nos.";
        end;
        InitRecord();
        if GetFilter("Certification No.") <> '' then
            if GetRangeMin("Certification No.") = GetRangeMax("Certification No.") then
                Validate("Certification No.", GetRangeMin("Certification No."));
    end;

    trigger OnDelete()
    begin
        if CurrFieldNo > 0 then
            TestField(Status, Status::Canceled);

        CandidateLine.Reset();
        CandidateLine.SetRange("Document No.", "No.");
        CandidateLine.DeleteAll(true);

        CertCommentLine.Reset();
        CertCommentLine.SetRange("Table Name", CertCommentLine."Table Name"::"Certification Session");
        CertCommentLine.SetRange("No.", "No.");
        CertCommentLine.DeleteAll(false);
    end;

    var
        CandidateLine: Record "MBS Cert. Candidate Line";
        Certification: Record "MBS Certification";
        CertCommentLine: Record "MBS Cert. Comment Line";
        CertSetup: Record "MBS Certification Setup";
        Room: Record Resource;
        NoSeries: Codeunit "No. Series";
        CertSetupNotFoundErr: Label 'Certification Setup not found';

    procedure AssistEdit(OldHeader: Record "MBS Cert. Session Header"): Boolean
    var
        SessionHeader: Record "MBS Cert. Session Header";
        NoSeriesCode: Code[20];
    begin
        SessionHeader := Rec;
        GetSetup();
        CertSetup.TestField("Cert. Session Nos.");
        NoSeriesCode := SessionHeader."No. Series";
        if NoSeries.LookupRelatedNoSeries(CertSetup."Cert. Session Nos.", OldHeader."No. Series", NoSeriesCode) then begin
            SessionHeader."No. Series" := NoSeriesCode;
            SessionHeader."No." := NoSeries.GetNextNo(NoSeriesCode, WorkDate());
            Rec := SessionHeader;
            exit(true);
        end;
    end;

    local procedure InitRecord()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
        "Document Date" := WorkDate();
        GetSetup();
        if "Posting No. Series" = '' then
            "Posting No. Series" := CertSetup."Posted Cert. Sess. Nos.";
    end;

    local procedure GetSetup()
    begin
        if not CertSetup.Get() then
            Error(CertSetupNotFoundErr);
    end;
}
