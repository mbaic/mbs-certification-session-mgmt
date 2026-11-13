namespace MBS.CertificationSessionManagement.Posting;

enum 50001 "MBS Cert. Result Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Passed)
    {
        Caption = 'Passed';
    }
    value(2; Failed)
    {
        Caption = 'Failed';
    }
    value(3; Absent)
    {
        Caption = 'Absent';
    }
    value(4; Incomplete)
    {
        Caption = 'Incomplete';
    }
    value(5; Canceled)
    {
        Caption = 'Canceled';
    }
}
