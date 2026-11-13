namespace MBS.CertificationSessionManagement.PostedSession;

using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Posting;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;
using System.Security.AccessControl;
using System.Security.User;

table 50005 "MBS Posted Cert. Sess. Hdr."
{
    Access = Internal;
    Caption = 'Posted Certification Session Header';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    DrillDownPageId = "MBS Posted Cert. Sess. List";
    LookupPageId = "MBS Posted Cert. Sess. List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the posted session number.';
        }
        field(20; "Certification No."; Code[20])
        {
            Caption = 'Certification No.';
            TableRelation = "MBS Certification";
            ToolTip = 'Specifies the certification.';
        }
        field(30; "Certification Name"; Text[50])
        {
            Caption = 'Certification Name';
            ToolTip = 'Specifies the certification name.';
        }
        field(40; "Session Date"; Date)
        {
            Caption = 'Session Date';
            ToolTip = 'Specifies the session date.';
        }
        field(50; "Invigilator Resource No."; Code[20])
        {
            Caption = 'Invigilator Resource No.';
            TableRelation = Resource where(Type = const(Person));
            ToolTip = 'Specifies the invigilator.';
        }
        field(60; "Invigilator Name"; Text[100])
        {
            CalcFormula = lookup(Resource.Name where("No." = field("Invigilator Resource No."), Type = const(Person)));
            Caption = 'Invigilator Name';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the invigilator name.';
        }
        field(70; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where(Type = const(Machine));
            ToolTip = 'Specifies the room.';
        }
        field(80; "Room Name"; Text[50])
        {
            Caption = 'Room Name';
            ToolTip = 'Specifies the room name.';
        }
        field(90; Status; Enum "MBS Cert. Session Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status at posting time.';
        }
        field(100; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
            ToolTip = 'Specifies the duration.';
        }
        field(110; "Min. Candidates"; Integer)
        {
            Caption = 'Min. Candidates';
            ToolTip = 'Specifies the minimum candidates.';
        }
        field(120; "Max. Candidates"; Integer)
        {
            Caption = 'Max. Candidates';
            ToolTip = 'Specifies the maximum candidates.';
        }
        field(130; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date.';
        }
        field(140; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ToolTip = 'Specifies the document date.';
        }
        field(150; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
            ToolTip = 'Specifies the reason code.';
        }
        field(160; Comment; Boolean)
        {
            CalcFormula = exist("MBS Cert. Comment Line" where("Table Name" = const("Posted Certification Session"), "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies whether comments exist.';
        }
        field(170; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series".Code;
        }
        field(180; "User Id"; Code[50])
        {
            Caption = 'User Id';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            ToolTip = 'Specifies the user who posted.';
        }
        field(210; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Pre-Assigned No.';
            Editable = false;
            ToolTip = 'Specifies the original certification session document number.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
