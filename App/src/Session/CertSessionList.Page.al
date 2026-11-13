namespace MBS.CertificationSessionManagement.Session;

page 50006 "MBS Cert. Session List"
{
    ApplicationArea = All;
    Caption = 'Certification Sessions';
    CardPageId = "MBS Cert. Session";
    Editable = false;
    PageType = List;
    SourceTable = "MBS Cert. Session Header";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the session number.';
                }
                field("Certification No."; Rec."Certification No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the certification.';
                }
                field("Certification Name"; Rec."Certification Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the certification name.';
                }
                field("Session Date"; Rec."Session Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the session date.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                }
            }
        }
    }
}
