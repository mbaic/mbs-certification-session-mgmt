namespace MBS.CertificationSessionManagement.Setup;

page 50000 "MBS Certification Setup"
{
    ApplicationArea = All;
    Caption = 'Certification Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "MBS Certification Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Certification Nos."; Rec."Certification Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for certification master records.';
                }
                field("Cert. Session Nos."; Rec."Cert. Session Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for certification session documents.';
                }
                field("Posted Cert. Sess. Nos."; Rec."Posted Cert. Sess. Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for posted certification sessions.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
