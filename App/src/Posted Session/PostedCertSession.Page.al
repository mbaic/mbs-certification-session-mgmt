namespace MBS.CertificationSessionManagement.PostedSession;

using MBS.CertificationSessionManagement.Certification;

page 50008 "MBS Posted Cert. Session"
{
    ApplicationArea = All;
    Caption = 'Posted Certification Session';
    Editable = false;
    PageType = Document;
    SourceTable = "MBS Posted Cert. Sess. Hdr.";

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
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration.';
                }
                field("Invigilator Resource No."; Rec."Invigilator Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invigilator.';
                }
                field("Room Resource No."; Rec."Room Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room.';
                }
            }
            part(CandidateLines; "MBS Posted Cert. Sess. Sub.")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            group(PostingDetails)
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
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who posted.';
                }
                field("Pre-Assigned No."; Rec."Pre-Assigned No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original certification session document number.';
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
                RunPageLink = "Table Name" = const("Posted Certification Session"), "No." = field("No.");
                ToolTip = 'View comments.';
            }
        }
    }
}
