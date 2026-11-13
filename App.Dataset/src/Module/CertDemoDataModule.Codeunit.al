namespace MBS.CertificationSessionManagement.Dataset;

using Microsoft.DemoTool;

codeunit 50300 "MBS Cert. Demo Data Module" implements "Contoso Demo Data Module"
{
    Access = Internal;

    procedure RunConfigurationPage()
    begin
    end;

    procedure GetDependencies(): List of [Enum "Contoso Demo Data Module"]
    var
        ContosoDemoDataModules: List of [Enum "Contoso Demo Data Module"];
    begin
        exit(ContosoDemoDataModules);
    end;

    procedure CreateSetupData()
    var
        ContosoCert: Codeunit "MBS Contoso Certification";
    begin
        ContosoCert.CreateCertificationSetup();
    end;

    procedure CreateMasterData()
    var
        ContosoCert: Codeunit "MBS Contoso Certification";
    begin
        ContosoCert.CreateCertifications();
        ContosoCert.CreateInvigilators();
        ContosoCert.CreateRooms();
        ContosoCert.CreateCandidates();
    end;

    procedure CreateTransactionalData()
    var
        ContosoCertSession: Codeunit "MBS Contoso Cert. Session";
    begin
        ContosoCertSession.CreatePlannedSession();
        ContosoCertSession.CreateOpenSessionWithCandidates();
        ContosoCertSession.CreateReadyToPostSession();
    end;

    procedure CreateHistoricalData()
    var
        ContosoCertHistory: Codeunit "MBS Contoso Cert. History";
    begin
        ContosoCertHistory.CreatePostedSessions();
        ContosoCertHistory.CreateRetakeScenario();
    end;
}
