namespace MBS.CertificationSessionManagement.Posting;

enum 50000 "MBS Cert. Session Status"
{
    Extensible = true;

    value(0; Planning)
    {
        Caption = 'Planning';
    }
    value(1; Open)
    {
        Caption = 'Open';
    }
    value(2; Closed)
    {
        Caption = 'Closed';
    }
    value(3; Canceled)
    {
        Caption = 'Canceled';
    }
}
