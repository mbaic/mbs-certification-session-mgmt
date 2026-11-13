namespace MBS.CertificationSessionManagement.Session;

using MBS.CertificationSessionManagement.Posting;
using Microsoft.CRM.Contact;

table 50003 "MBS Cert. Candidate Line"
{
    Access = Internal;
    Caption = 'Certification Candidate Line';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(10; "Document No."; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'Document No.';
            TableRelation = "MBS Cert. Session Header";
        }
        field(20; "Line No."; Integer)
        {
            AllowInCustomizations = Never;
            Caption = 'Line No.';
        }
        field(30; "Candidate Contact No."; Code[20])
        {
            Caption = 'Candidate Contact No.';
            TableRelation = Contact;
            ToolTip = 'Specifies the candidate contact.';

            trigger OnValidate()
            begin
                if "Candidate Contact No." <> '' then
                    CalcFields("Candidate Name");
            end;
        }
        field(40; "Candidate Name"; Text[100])
        {
            CalcFormula = lookup(Contact.Name where("No." = field("Candidate Contact No.")));
            Caption = 'Candidate Name';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the candidate name.';
        }
        field(50; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            ToolTip = 'Specifies the date the candidate registered.';
        }
        field(60; Attended; Boolean)
        {
            Caption = 'Attended';
            ToolTip = 'Specifies whether the candidate attended the session.';
        }
        field(70; "Attempt No."; Integer)
        {
            Caption = 'Attempt No.';
            ToolTip = 'Specifies the attempt number for this candidate.';
        }
        field(80; "Result Status"; Enum "MBS Cert. Result Status")
        {
            Caption = 'Result Status';
            ToolTip = 'Specifies the result of the assessment.';
        }
        field(90; Score; Decimal)
        {
            Caption = 'Score';
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the candidate score if applicable.';
        }
        field(100; Notes; Text[250])
        {
            Caption = 'Notes';
            ToolTip = 'Specifies notes for this candidate line.';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Registration Date" = 0D then
            "Registration Date" := WorkDate();
    end;
}
