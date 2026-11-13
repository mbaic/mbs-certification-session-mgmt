namespace MBS.CertificationSessionManagement.Setup;

using Microsoft.Foundation.AuditCodes;

tableextension 50000 "MBS Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(50000; "MBS Certification"; Code[10])
        {
            Caption = 'Certification';
            DataClassification = CustomerContent;
            TableRelation = "Source Code".Code;
            ToolTip = 'Specifies the source code used when posting certification sessions.';
        }
    }
}
