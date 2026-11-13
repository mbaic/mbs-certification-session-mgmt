namespace MBS.CertificationSessionManagement.PostedSession;

page 50009 "MBS Posted Cert. Sess. List"
{
    ApplicationArea = All;
    Caption = 'Posted Certification Sessions';
    CardPageId = "MBS Posted Cert. Session";
    Editable = false;
    PageType = List;
    SourceTable = "MBS Posted Cert. Sess. Hdr.";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted session number.';
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
            }
        }
    }
}
