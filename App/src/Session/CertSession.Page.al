namespace MBS.CertificationSessionManagement.Session;

using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Posting;

page 50005 "MBS Cert. Session"
{
    ApplicationArea = All;
    Caption = 'Certification Session';
    PageType = Document;
    SourceTable = "MBS Cert. Session Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the session number.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
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
                    ToolTip = 'Specifies the planned date.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration.';
                }
            }
            group(Resources)
            {
                Caption = 'Resources';

                field("Invigilator Resource No."; Rec."Invigilator Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invigilator.';
                }
                field("Invigilator Name"; Rec."Invigilator Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invigilator name.';
                }
                field("Room Resource No."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room.';
                }
                field("Room Name"; Rec."Room Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room name.';
                }
                field("Min. Candidates"; Rec."Min. Candidates")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum candidates.';
                }
                field("Max. Candidates"; Rec."Max. Candidates")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum candidates.';
                }
            }
            part(CandidateLines; "MBS Cert. Session Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            group(Posting)
            {
                Caption = 'Posting';

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting number series.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Comments)
            {
                ApplicationArea = All;
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = page "MBS Cert. Comment Sheet";
                RunPageLink = "Table Name" = const("Certification Session"), "No." = field("No.");
                ToolTip = 'View or add comments.';
            }
        }
        area(Processing)
        {
            action("P&ost")
            {
                ApplicationArea = All;
                Caption = 'P&ost';
                Image = PostOrder;
                ShortcutKey = 'F9';
                ToolTip = 'Post the certification session.';

                trigger OnAction()
                var
                    CertPostYesNo: Codeunit "MBS Cert.-Post (Yes/No)";
                begin
                    CertPostYesNo.Run(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(PostRef; "P&ost") { }
            }
        }
    }
}
