namespace MBS.CertificationSessionManagement.Certification;

page 50003 "MBS Cert. Comment Sheet"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Certification Comment Sheet';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "MBS Cert. Comment Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the comment.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the comment.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comment text.';
                }
            }
        }
    }
}
