; ---------------------------
; InstallCert.iss
; This simply makes xyn's programs 'trustworthy' in -redacted's- eyes
; xyn promises to never do anything unethical with this, he simply wants his programs to not get quarantined or removed
; xyn does this in spite of the fact that a code sign cert costs a fortune, a leg, and your spouse
; and on top of that your time - making it unrealistic for any small dev to get their legit software out
; xyn for the free world
; ---------------------------

// Setup section
[Setup]
AppName=xynLabs Certificate Installer
AppVersion=1.0
DefaultDirName={pf}\xynLabsCerts
DefaultGroupName=xynLabs
OutputDir=dist
OutputBaseFilename=InstallCert
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
WizardSizePercent=125

// Code section
[Code]
var
  ExplanationPage: TWizardPage;
  DescLabel: TLabel;
  GitHubLabel: TLabel;
  AgreementLabel: TLabel;

procedure GitHubLabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ResultCode: Integer;
begin
  if not Exec('explorer.exe', 'https://github.com/xynLabs-xyn', '', 1, False, ResultCode) then
    MsgBox('Error opening URL', mbError, MB_OK);
end;

procedure InitializeWizard();
begin
  // Create a banner with a text informing the user that administrative rights are required to install the certificate into the Trusted Root
  ExplanationPage := CreateCustomPage(wpWelcome, 'You should Run As Administrator', 'What is this?');

  // Create the description and explanation
  DescLabel := TLabel.Create(WizardForm);
  DescLabel.Parent := ExplanationPage.Surface;
  DescLabel.Left := ScaleX(10);
  DescLabel.Top := ScaleY(10);
  DescLabel.WordWrap := True;
  DescLabel.Width := ScaleX(420);
  DescLabel.Caption :=
    'This installation should be executed using Run As Administrator ' + #13#10 + + #13#10 +
    'This installer adds xynLabs self-signed certificate to the Trusted Root so that all of xyn''s software ' + #13#10 +
    'are recognized as ''trustworthy'' by Windows security. ' + #13#10 +
    'Code signing certificates from recognized providers are insanely expensive, and the process to get one is extremely complex and tedious. ' + #13#10 +
    'It''s unrealistic for a lesser dev to get one unless they can afford spending half a fortune worth of time and money to comply with the madness. ' + #13#10 +
    'This is a loophole. ' + #13#10 +
    'xyn promises to never use this in malice; it''s simply an attempt to stop Windows security from flagging ' +
    'his software as potential malware.' + #13#10 +
    'All of his projects/software will be uploaded to his GitHub as a proof of transparency, along with his custom license that states what you are allowed to use the code for. ' + #13#10 +
    'If you don''t know how to code, you can give it to ChatGPT and ask it to explain it for you, and even check if there is anything harmful. ' + #13#10 +
    'In short the license states that the only reason the code is open and available for the public eye to see, is as evidence of ethical intents. ';

  // Create the clickable GitHub link
  GitHubLabel := TLabel.Create(WizardForm);
  GitHubLabel.Parent := ExplanationPage.Surface;
  GitHubLabel.Left := ScaleX(10);
  GitHubLabel.Top := DescLabel.Top + DescLabel.Height + ScaleY(10);
  GitHubLabel.Caption := 'https://github.com/xynLabs-xyn';
  GitHubLabel.Font.Color := clBlue;
  GitHubLabel.Font.Style := [fsUnderline];
  GitHubLabel.Cursor := crHandPoint;
  GitHubLabel.OnMouseDown := @GitHubLabelMouseDown;

  // Create the agreement text, positioned below the GitHub link
  AgreementLabel := TLabel.Create(WizardForm);
  AgreementLabel.Parent := ExplanationPage.Surface;
  AgreementLabel.Left := ScaleX(10);
  AgreementLabel.Top := GitHubLabel.Top + GitHubLabel.Height + ScaleY(10);
  AgreementLabel.WordWrap := True;
  AgreementLabel.Width := ScaleX(400);
  AgreementLabel.Caption :=
    + #13#10 + // This is what a linebreak looks like in dirty Pascal language from the 70s
    'By completing this installation you acknowledge that you''ve understood what this means and agree to this certificate being installed.';
end;

// File section
[Files]
; Include certificate
Source: "cert\selfsigned.cer"; DestDir: "{app}\cert\cert"; Flags: ignoreversion

// Execute section
[Run]
; Install the certificate to the Trusted Root
; Using certutil to add the certificate
Filename: "certutil.exe"; Parameters: "-addstore -f Root ""{app}\cert\selfsigned.cer"""; Flags: runhidden; StatusMsg: "Installing certificate..."
