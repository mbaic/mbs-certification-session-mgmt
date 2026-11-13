namespace MBS.CertificationSessionManagement.PostedSession;

page 50010 "MBS Posted Cert. Sess. Sub."
{
    ApplicationArea = All;
    Caption = 'Posted Candidates';
    Editable = false;
    PageType = ListPart;
    SourceTable = "MBS Posted Cert. Cand. Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Candidate Contact No."; Rec."Candidate Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the candidate contact.';
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the candidate name.';
                }
                field(Attended; Rec.Attended)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the candidate attended.';
                }
                field("Attempt No."; Rec."Attempt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the attempt number.';
                }
                field("Result Status"; Rec."Result Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the result.';
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the score.';
                }
            }
        }
    }
}
