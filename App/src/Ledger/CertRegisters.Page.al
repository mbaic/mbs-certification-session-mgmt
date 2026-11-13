namespace MBS.CertificationSessionManagement.Ledger;

page 50012 "MBS Cert. Registers"
{
    ApplicationArea = All;
    Caption = 'Certification Registers';
    Editable = false;
    PageType = List;
    SourceTable = "MBS Cert. Register";
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
                    ToolTip = 'Specifies the register number.';
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first entry number.';
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last entry number.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creation date.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source code.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user.';
                }
            }
        }
    }
}
