namespace MBS.CertificationSessionManagement.Ledger;

using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Posting;
using Microsoft.CRM.Contact;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;
using System.Security.AccessControl;
using System.Security.User;

table 50007 "MBS Cert. Ledger Entry"
{
    Access = Internal;
    Caption = 'Certification Ledger Entry';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    DrillDownPageId = "MBS Cert. Ledger Entries";
    LookupPageId = "MBS Cert. Ledger Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the entry number.';
        }
        field(20; "Certification No."; Code[20])
        {
            Caption = 'Certification No.';
            TableRelation = "MBS Certification";
            ToolTip = 'Specifies the certification.';
        }
        field(30; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date.';
        }
        field(40; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ToolTip = 'Specifies the document date.';
        }
        field(50; "Entry Type"; Enum "MBS Cert. Entry Type")
        {
            Caption = 'Entry Type';
            ToolTip = 'Specifies the entry type.';
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            ToolTip = 'Specifies the document number.';
        }
        field(70; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description.';
        }
        field(80; "Candidate Contact No."; Code[20])
        {
            Caption = 'Candidate Contact No.';
            TableRelation = Contact;
            ToolTip = 'Specifies the candidate contact.';
        }
        field(90; "Candidate Name"; Text[50])
        {
            Caption = 'Candidate Name';
            ToolTip = 'Specifies the candidate name.';
        }
        field(100; "Result Status"; Enum "MBS Cert. Result Status")
        {
            Caption = 'Result Status';
            ToolTip = 'Specifies the result.';
        }
        field(110; "Attempt No."; Integer)
        {
            Caption = 'Attempt No.';
            ToolTip = 'Specifies the attempt number.';
        }
        field(120; Score; Decimal)
        {
            Caption = 'Score';
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the score.';
        }
        field(130; "Invigilator Resource No."; Code[20])
        {
            Caption = 'Invigilator Resource No.';
            TableRelation = Resource where(Type = const(Person));
            ToolTip = 'Specifies the invigilator.';
        }
        field(140; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where(Type = const(Machine));
            ToolTip = 'Specifies the room.';
        }
        field(150; "Session Date"; Date)
        {
            Caption = 'Session Date';
            ToolTip = 'Specifies the session date.';
        }
        field(160; "Cert. Session No."; Code[20])
        {
            Caption = 'Cert. Session No.';
            ToolTip = 'Specifies the posted session number.';
        }
        field(170; "Source Code"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(180; "Reason Code"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(190; "Posting No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(200; "Journal Batch Name"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Journal Batch Name';
        }
        field(210; "User Id"; Code[50])
        {
            AllowInCustomizations = Never;
            Caption = 'User Id';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(PK; "Entry No.") { }
        key(Key2; "Document No.", "Posting Date") { }
        key(Key3; "Certification No.", "Candidate Contact No.", "Posting Date") { }
    }
}
