namespace MBS.CertificationSessionManagement.Certification;

page 50001 "MBS Certification List"
{
    ApplicationArea = All;
    Caption = 'Certifications';
    CardPageId = "MBS Certification Card";
    Editable = false;
    PageType = List;
    SourceTable = "MBS Certification";
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
                    ToolTip = 'Specifies the certification number.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the certification name.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default duration.';
                }
                field("Max. Candidates"; Rec."Max. Candidates")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of candidates.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this certification is blocked.';
                }
            }
        }
    }
}
