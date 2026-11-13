namespace MBS.CertificationSessionManagement.Setup;

using Microsoft.Foundation.NoSeries;

table 50000 "MBS Certification Setup"
{
    Access = Internal;
    Caption = 'Certification Setup';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
            NotBlank = true;
        }
        field(20; "Certification Nos."; Code[20])
        {
            Caption = 'Certification Nos.';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series for certification master records.';
        }
        field(30; "Cert. Session Nos."; Code[20])
        {
            Caption = 'Cert. Session Nos.';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series for certification session documents.';
        }
        field(40; "Posted Cert. Sess. Nos."; Code[20])
        {
            Caption = 'Posted Cert. Sess. Nos.';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series for posted certification sessions.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
