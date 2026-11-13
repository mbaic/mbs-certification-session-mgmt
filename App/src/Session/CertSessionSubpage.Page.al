namespace MBS.CertificationSessionManagement.Session;

page 50007 "MBS Cert. Session Subpage"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Candidates';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "MBS Cert. Candidate Line";

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
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the registration date.';
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
                    ToolTip = 'Specifies the assessment result.';
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the score.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies notes.';
                }
            }
        }
    }
}
