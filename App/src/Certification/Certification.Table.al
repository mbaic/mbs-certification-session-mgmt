namespace MBS.CertificationSessionManagement.Certification;

using MBS.CertificationSessionManagement.Setup;
using Microsoft.Foundation.NoSeries;

table 50001 "MBS Certification"
{
    Access = Internal;
    Caption = 'Certification';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    DrillDownPageId = "MBS Certification List";
    LookupPageId = "MBS Certification List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the certification number.';
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the certification name.';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := UpperCase(Name);
            end;
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the certification.';
        }
        field(40; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
            ToolTip = 'Specifies the default duration of the certification session in days.';
        }
        field(50; "Min. Candidates"; Integer)
        {
            Caption = 'Min. Candidates';
            ToolTip = 'Specifies the minimum number of candidates for a session.';
        }
        field(60; "Max. Candidates"; Integer)
        {
            Caption = 'Max. Candidates';
            ToolTip = 'Specifies the maximum number of candidates for a session.';
        }
        field(70; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Specifies whether this certification is blocked and cannot be used in new sessions.';
        }
        field(80; "Search Name"; Text[50])
        {
            AllowInCustomizations = Never;
            Caption = 'Search Name';
            ToolTip = 'Specifies the search name.';
        }
        field(90; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            ToolTip = 'Specifies the date of the last modification.';
        }
        field(100; Comment; Boolean)
        {
            AllowInCustomizations = Never;
            CalcFormula = exist("MBS Cert. Comment Line" where("Table Name" = const(Certification), "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
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
        fieldgroup(DropDown; "No.", Name)
        {
        }
        fieldgroup(Brick; "No.", Name)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GetSetup();
            CertSetup.TestField("Certification Nos.");
            "No." := NoSeries.GetNextNo(CertSetup."Certification Nos.", WorkDate());
            "No. Series" := CertSetup."Certification Nos.";
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today();
    end;

    trigger OnDelete()
    begin
        CertCommentLine.Reset();
        CertCommentLine.SetRange("Table Name", CertCommentLine."Table Name"::Certification);
        CertCommentLine.SetRange("No.", "No.");
        CertCommentLine.DeleteAll(false);
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today();
    end;

    var
        CertCommentLine: Record "MBS Cert. Comment Line";
        Certification: Record "MBS Certification";
        CertSetup: Record "MBS Certification Setup";
        NoSeries: Codeunit "No. Series";
        CertSetupNotFoundErr: Label 'Certification Setup not found';

    procedure AssistEdit(): Boolean
    var
        NoSeriesCode: Code[20];
    begin
        Certification := Rec;
        GetSetup();
        CertSetup.TestField("Certification Nos.");
        NoSeriesCode := Certification."No. Series";
        if NoSeries.LookupRelatedNoSeries(CertSetup."Certification Nos.", xRec."No. Series", NoSeriesCode) then begin
            Certification."No. Series" := NoSeriesCode;
            Certification."No." := NoSeries.GetNextNo(NoSeriesCode, WorkDate());
            Rec := Certification;
            exit(true);
        end;
    end;

    local procedure GetSetup()
    begin
        if not CertSetup.Get() then
            Error(CertSetupNotFoundErr);
    end;
}
