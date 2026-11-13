namespace MBS.CertificationSessionManagement.Ledger;

using Microsoft.Foundation.AuditCodes;
using System.Security.AccessControl;
using System.Security.User;

table 50008 "MBS Cert. Register"
{
    Access = Internal;
    Caption = 'Certification Register';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    DrillDownPageId = "MBS Cert. Registers";
    LookupPageId = "MBS Cert. Registers";

    fields
    {
        field(10; "No."; Integer)
        {
            Caption = 'No.';
            ToolTip = 'Specifies the register number.';
        }
        field(20; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "MBS Cert. Ledger Entry";
            ToolTip = 'Specifies the first entry number.';
        }
        field(30; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "MBS Cert. Ledger Entry";
            ToolTip = 'Specifies the last entry number.';
        }
        field(40; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            ToolTip = 'Specifies the creation date.';
        }
        field(50; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
            ToolTip = 'Specifies the source code.';
        }
        field(60; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user.';

            trigger OnLookup()
            var
                UserRec: Record User;
            begin
                if Page.RunModal(Page::Users, UserRec) = Action::LookupOK then
                    "User ID" := UserRec."User Name";
            end;
        }
        field(70; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            ToolTip = 'Specifies the journal batch name.';
        }
    }

    keys
    {
        key(PK; "No.") { }
        key(Key2; "Creation Date") { }
    }
}
