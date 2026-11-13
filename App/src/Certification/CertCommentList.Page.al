namespace MBS.CertificationSessionManagement.Certification;

page 50004 "MBS Cert. Comment List"
{
    ApplicationArea = All;
    Caption = 'Certification Comments';
    Editable = false;
    PageType = ListPart;
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
