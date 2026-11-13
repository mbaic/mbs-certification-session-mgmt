namespace MBS.CertificationSessionManagement.Dataset;

using Microsoft.DemoTool;

enumextension 50300 "MBS Cert. Demo Module" extends "Contoso Demo Data Module"
{
    value(50300; "MBS Certification Session")
    {
        Caption = 'Certification Session Management';
        Implementation = "Contoso Demo Data Module" = "MBS Cert. Demo Data Module";
    }
}
