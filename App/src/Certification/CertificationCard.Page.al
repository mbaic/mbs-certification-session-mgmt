namespace MBS.CertificationSessionManagement.Certification;

page 50002 "MBS Certification Card"
{
    ApplicationArea = All;
    Caption = 'Certification Card';
    PageType = Card;
    SourceTable = "MBS Certification";

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
                    ToolTip = 'Specifies the certification number.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the certification name.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the certification.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default duration of the certification session in days.';
                }
                field("Min. Candidates"; Rec."Min. Candidates")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum number of candidates for a session.';
                }
                field("Max. Candidates"; Rec."Max. Candidates")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum number of candidates for a session.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this certification is blocked.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the last modification.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether comments exist for this certification.';
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
                RunPageLink = "Table Name" = const(Certification), "No." = field("No.");
                ToolTip = 'View or add comments for this certification.';
            }
        }
    }
}
