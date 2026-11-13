namespace MBS.CertificationSessionManagement.Posting;

using MBS.CertificationSessionManagement.Certification;
using Microsoft.CRM.Contact;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;

table 50009 "MBS Cert. Journal Line"
{
    Access = Internal;
    Caption = 'Certification Journal Line';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(10; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Certification No."; Code[20])
        {
            Caption = 'Certification No.';
            TableRelation = "MBS Certification";
        }
        field(40; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
            end;
        }
        field(50; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(60; "Entry Type"; Enum "MBS Cert. Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(70; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(80; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(90; "Candidate Contact No."; Code[20])
        {
            Caption = 'Candidate Contact No.';
            TableRelation = Contact;
        }
        field(100; "Candidate Name"; Text[50])
        {
            Caption = 'Candidate Name';
        }
        field(110; "Result Status"; Enum "MBS Cert. Result Status")
        {
            Caption = 'Result Status';
        }
        field(120; "Attempt No."; Integer)
        {
            Caption = 'Attempt No.';
        }
        field(130; Score; Decimal)
        {
            Caption = 'Score';
            DecimalPlaces = 0 : 2;
        }
        field(140; "Invigilator Resource No."; Code[20])
        {
            Caption = 'Invigilator Resource No.';
            TableRelation = Resource where(Type = const(Person));
        }
        field(150; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where(Type = const(Machine));
        }
        field(160; "Session Date"; Date)
        {
            Caption = 'Session Date';
        }
        field(170; "Cert. Session No."; Code[20])
        {
            Caption = 'Cert. Session No.';
        }
        field(180; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(190; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(200; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure EmptyLine(): Boolean
    begin
        exit(
            ("Certification No." = '') and
            ("Candidate Contact No." = '')
        );
    end;
}
