namespace MBS.CertificationSessionManagement.PostedSession;

using MBS.CertificationSessionManagement.Posting;
using Microsoft.CRM.Contact;

table 50006 "MBS Posted Cert. Cand. Line"
{
    Access = Internal;
    Caption = 'Posted Certification Candidate Line';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "MBS Posted Cert. Sess. Hdr.";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Candidate Contact No."; Code[20])
        {
            Caption = 'Candidate Contact No.';
            TableRelation = Contact;
            ToolTip = 'Specifies the candidate contact.';
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
            ToolTip = 'Specifies the registration date.';
        }
        field(60; Attended; Boolean)
        {
            Caption = 'Attended';
            ToolTip = 'Specifies whether the candidate attended.';
        }
        field(70; "Attempt No."; Integer)
        {
            Caption = 'Attempt No.';
            ToolTip = 'Specifies the attempt number.';
        }
        field(80; "Result Status"; Enum "MBS Cert. Result Status")
        {
            Caption = 'Result Status';
            ToolTip = 'Specifies the result.';
        }
        field(90; Score; Decimal)
        {
            Caption = 'Score';
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the score.';
        }
        field(100; Notes; Text[250])
        {
            Caption = 'Notes';
            ToolTip = 'Specifies notes.';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
