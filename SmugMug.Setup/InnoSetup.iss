; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{122C4BD3-8100-4758-9E8A-D41BCB2141F1}
AppName=Send to SmugMug
AppVersion=2.0.5103
;AppVerName=Send to SmugMug 1.3
AppPublisher=Omar Shahine
AppPublisherURL=http://www.shahine.com/garage/software/send-to-smugmug/
AppSupportURL=http://www.shahine.com/garage/software/send-to-smugmug/
AppUpdatesURL=http://www.shahine.com/garage/software/send-to-smugmug/
DefaultDirName={pf}\Send to SmugMug
DisableDirPage=yes
OutputBaseFilename=SendToSmugMug
Compression=lzma
SolidCompression=yes
DisableProgramGroupPage=yes
UsePreviousGroup=False
MinVersion=0,6.0
LicenseFile=License.rtf
;SignTool IDE C:\Users\Omar\Sources\SmugMug\SmugMug.Setup\signtool.exe sign /sha1 51a673b34ceca4042eabc0f656282ad4d156563a /t http://timestamp.comodoca.com/authenticode $p
SignTool=SignTool /d $qSend to SmugMug$q /v $f
OutputDir=Release
UninstallDisplayIcon={app}\App.ico
UninstallDisplayName=Send to SmugMug

[code]
function IsDotNetDetected(version: string; service: cardinal): boolean;
// Indicates whether the specified version and service pack of the .NET Framework is installed.
//
// version -- Specify one of these strings for the required .NET Framework version:
//    'v1.1.4322'     .NET Framework 1.1
//    'v2.0.50727'    .NET Framework 2.0
//    'v3.0'          .NET Framework 3.0
//    'v3.5'          .NET Framework 3.5
//    'v4\Client'     .NET Framework 4.0 Client Profile
//    'v4\Full'       .NET Framework 4.0 Full Installation
//    'v4.5'          .NET Framework 4.5
//
// service -- Specify any non-negative integer for the required service pack level:
//    0               No service packs required
//    1, 2, etc.      Service pack 1, 2, etc. required
var
    key: string;
    install, release, serviceCount: cardinal;
    check45, success: boolean;
begin
    // .NET 4.5 installs as update to .NET 4.0 Full
    if version = 'v4.5' then begin
        version := 'v4\Full';
        check45 := true;
    end else
        check45 := false;

    // installation key group for all .NET versions
    key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;

    // .NET 3.0 uses value InstallSuccess in subkey Setup
    if Pos('v3.0', version) = 1 then begin
        success := RegQueryDWordValue(HKLM, key + '\Setup', 'InstallSuccess', install);
    end else begin
        success := RegQueryDWordValue(HKLM, key, 'Install', install);
    end;

    // .NET 4.0/4.5 uses value Servicing instead of SP
    if Pos('v4', version) = 1 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Servicing', serviceCount);
    end else begin
        success := success and RegQueryDWordValue(HKLM, key, 'SP', serviceCount);
    end;

    // .NET 4.5 uses additional value Release
    if check45 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Release', release);
        success := success and (release >= 378389);
    end;

    result := success and (install = 1) and (serviceCount >= service);
end;

function InitializeSetup():boolean;
var
  ResultCode: integer;
  ResultDownload : Boolean;
  ErrorCode: Integer;
begin
  if not IsDotNetDetected('v4\Full', 0) then begin
      ResultDownload := MsgBox('This setup requires the .NET Framework. Please download and install the .NET Framework and run this setup again. Do you want to download the framwork now?',
        mbConfirmation, MB_YESNO) = idYes;
      if ResultDownload =false then
      begin
        Result:=false;
      end else
      begin
        Result:=false;
        ShellExec('open',
          'http://download.microsoft.com/download/1/B/E/1BE39E79-7E39-46A3-96FF-047F95396215/dotNetFx40_Full_setup.exe',
          '','',SW_SHOWNORMAL,ewNoWait,ErrorCode);
      end;
  end else begin
      if Exec('msiexec.exe', '/X {8D445B72-D4AB-4769-A5AF-5056D9D019BD} /qn', '', SW_SHOW,
      ewWaitUntilTerminated, ResultCode) then
      begin
        // handle success if necessary; ResultCode contains the exit code
        // msgbox(IntToStr(ResultCode), mbInformation, MB_OK);
      end
      else begin
        // handle failure if necessary; ResultCode contains the error code
      end;

      // Proceed Setup
      Result := True;
  end;
end;

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\SmugMug.SendToSmugMug\bin\Release\Send to smugmug.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Assemblies\AppRunnerCM.dll"; DestDir: "{app}"; Check: not IsWin64(); Flags: ignoreversion onlyifdoesntexist regserver restartreplace
Source: "..\Assemblies\x64\AppRunnerCM.dll"; DestDir: "{app}"; Check: IsWin64(); Flags: ignoreversion onlyifdoesntexist regserver restartreplace
Source: "..\SmugMug.SendToSmugMug\bin\Release\Newtonsoft.Json.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Assemblies\AxInterop.MediaPlayer.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Assemblies\Interop.MediaPlayer.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Assemblies\log4net.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SmugMug.SendToSmugMug\bin\Release\Send to smugmug.exe.config"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SmugMug.SendToSmugMug\bin\Release\SmugMug.Api.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SmugMug.SendToSmugMug\bin\Release\SmugMug.Toolkit.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SmugMug.SendToSmugMug\bin\Release\SmugMug.VideoPlayer.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SmugMug.SendToSmugMug\ReadMe.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SmugMug.SendToSmugMug\App.ico"; DestDir: "{app}"

[Icons]
Name: "{commonprograms}\Send to SmugMug"; Filename: "{app}\Send to smugmug.exe"
;Name: "{commondesktop}\Send to SmugMug"; Filename: "{app}\Send to smugmug.exe"
Name: "{group}\{cm:UninstallProgram, Send to SmugMug}"; Filename: "{uninstallexe}"

[Run]
;Filename: "msiexec.exe"; Parameters: "/X {{8D445B72-D4AB-4769-A5AF-5056D9D019BD}} /qn"
Filename: "{app}\Send to smugmug.exe"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,Send to SmugMug}"
