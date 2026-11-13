namespace MBS.CertificationSessionManagement.Ledger;

page 50011 "MBS Cert. Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Certification Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "MBS Cert. Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("Certification No."; Rec."Certification No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the certification.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Candidate Contact No."; Rec."Candidate Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the candidate.';
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the candidate name.';
                }
                field("Result Status"; Rec."Result Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the result.';
                }
                field("Attempt No."; Rec."Attempt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the attempt number.';
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the score.';
                }
                field("Session Date"; Rec."Session Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the session date.';
                }
                field("Invigilator Resource No."; Rec."Invigilator Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invigilator.';
                }
            }
        }
    }
}
