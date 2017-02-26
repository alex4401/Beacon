; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Beacon"
#define MyAppVersion "1.0.0b6"
#define MyAppPublisher "The ZAZ Studios"
#define MyAppURL "https://thezaz.com/beacon"
#define MyAppExeName "Beacon.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{E58BA263-A23C-484E-99DF-319D5BD1399F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputBaseFilename=Install {#MyAppName}
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\..\Project\Builds - Beacon.xojo_project\Windows\Beacon\Beacon.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\Project\Builds - Beacon.xojo_project\Windows\Beacon\Beacon Libs\*"; DestDir: "{app}\Libs"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\Project\Builds - Beacon.xojo_project\Windows\Beacon\Beacon Resources\*"; DestDir: "{app}\Resources"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\Project\Builds - Beacon.xojo_project\Mac OS X (Cocoa Intel)\Beacon.app\Contents\Resources\Classes.json"; DestDir: "{app}\Resources"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
