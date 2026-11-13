namespace MBS.CertificationSessionManagement.Permissions;

using MBS.CertificationSessionManagement.Certification;
using MBS.CertificationSessionManagement.Ledger;
using MBS.CertificationSessionManagement.PostedSession;
using MBS.CertificationSessionManagement.Posting;
using MBS.CertificationSessionManagement.Session;
using MBS.CertificationSessionManagement.Setup;
using Microsoft.Foundation.AuditCodes;

permissionset 50000 "MBS Cert. All Users"
{
    Assignable = true;
    Caption = 'Cert. Session Mgt. - All';

    Permissions =
        table "MBS Certification Setup" = X,
        table "MBS Certification" = X,
        table "MBS Cert. Session Header" = X,
        table "MBS Cert. Candidate Line" = X,
        table "MBS Cert. Comment Line" = X,
        table "MBS Posted Cert. Sess. Hdr." = X,
        table "MBS Posted Cert. Cand. Line" = X,
        table "MBS Cert. Ledger Entry" = X,
        table "MBS Cert. Register" = X,
        table "MBS Cert. Journal Line" = X,
        tabledata "MBS Certification Setup" = RIMD,
        tabledata "MBS Certification" = RIMD,
        tabledata "MBS Cert. Session Header" = RIMD,
        tabledata "MBS Cert. Candidate Line" = RIMD,
        tabledata "MBS Cert. Comment Line" = RIMD,
        tabledata "MBS Posted Cert. Sess. Hdr." = RI,
        tabledata "MBS Posted Cert. Cand. Line" = RI,
        tabledata "MBS Cert. Ledger Entry" = RI,
        tabledata "MBS Cert. Register" = RIM,
        tabledata "MBS Cert. Journal Line" = RIMD,
        page "MBS Certification Setup" = X,
        page "MBS Certification List" = X,
        page "MBS Certification Card" = X,
        page "MBS Cert. Comment Sheet" = X,
        page "MBS Cert. Comment List" = X,
        page "MBS Cert. Session" = X,
        page "MBS Cert. Session List" = X,
        page "MBS Cert. Session Subpage" = X,
        page "MBS Posted Cert. Session" = X,
        page "MBS Posted Cert. Sess. List" = X,
        page "MBS Posted Cert. Sess. Sub." = X,
        page "MBS Cert. Ledger Entries" = X,
        page "MBS Cert. Registers" = X,
        codeunit "MBS Certification-Post" = X,
        codeunit "MBS Cert.-Post (Yes/No)" = X,
        codeunit "MBS Cert. Jnl.-Check Line" = X,
        codeunit "MBS Cert. Jnl.-Post Line" = X,
        tabledata "Source Code Setup" = R,
        tabledata "Source Code" = R;
}
