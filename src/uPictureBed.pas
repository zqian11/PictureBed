unit uPictureBed;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, IdBaseComponent, IdComponent, IdTCPClient, ExtCtrls,
  ExtDlgs;

type
  TFMain = class(TForm)
    imgBox: TImage;
    btnUpload: TButton;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    edtMarkdown: TEdit;
    btnCopyMarkdown: TButton;
    cxlbl1: TLabel;
    cxlbl2: TLabel;
    btnCopyHTML: TButton;
    cxlbl3: TLabel;
    btnCopyLink: TButton;
    edtHTML: TEdit;
    edtLink: TEdit;
    btnLocalFile: TButton;
    dlgOpenPic: TOpenPictureDialog;
    pnl1: TPanel;
    procedure btnUploadClick(Sender: TObject);
    procedure btnCopyMarkdownClick(Sender: TObject);
    procedure btnCopyHTMLClick(Sender: TObject);
    procedure btnCopyLinkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLocalFileClick(Sender: TObject);
    procedure clearResult;
  private
    { Private declarations }
    // ����WM_DRAWCLIPBOARD��Ϣ����
    procedure WMDrawClipBoard(var AMessage: TMessage); message WM_DRAWCLIPBOARD;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;
  currImg: string;
   //�۲�������һ�����ھ��
  NextClipHwnd: HWND;
  isShow: Boolean;
  picDir: string;

implementation

{$R *.dfm}

uses
  Clipbrd, jpeg, IdMultipartFormData, IdHTTP, IdGlobal, superobject;

{ �Ӽ��а��ȡͼƬ }
//procedure TFMain.btnClipClick(Sender: TObject);
//begin
//  if (Clipboard.HasFormat(CF_BITMAP)) or (Clipboard.HasFormat(CF_PICTURE)) then
//  begin
//    btnUpload.Enabled := True;
//    imgBox.Picture.LoadFromClipboardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0)
//  end
//  else
//    ShowMessage('���а�û�п�������');
//
//end;

procedure TFMain.clearResult;
begin
  edtMarkdown.Text := '';
  edtHTML.Text := '';
  edtLink.Text := '';
end;

procedure TFMain.btnUploadClick(Sender: TObject);
var
  rspStream: TStringStream;
  httpClient: TIdHTTP;
  formData: TIdMultiPartFormDataStream;
  rspString: string;
  rspJson: ISuperObject;
  imgUrl: string;
begin
  try
    btnUpload.Enabled := False;
    btnUpload.Caption := '�ϴ���...';
    rspStream := TStringStream.Create('');
    httpClient := TIdHTTP.Create(nil);
    httpClient.ReadTimeout := 15000;
    formData := TIdMultiPartFormDataStream.Create;
    formData.AddFile('image_field', currImg, GetMIMETypeFromFile(currImg));
    httpClient.Post('http://www.niupic.com/index/upload/process', formData, rspStream);
    rspString := rspStream.DataString;
    rspJson := SO(UTF8Decode(rspString));
    if rspJson.S['code'] = '200' then
    begin
      btnUpload.Enabled := True;
      btnUpload.Caption := '�ϴ�';
      imgUrl := rspJson.S['data'];
      edtMarkdown.Text := '![ͼƬ����](https://' + imgUrl + ')';
      edtHTML.Text := '<img src="https://' + imgUrl + '" />';
      edtLink.Text := 'https://' + imgUrl;
    end
    else
    begin
      btnUpload.Enabled := True;
      btnUpload.Caption := '�ϴ�';
      ShowMessage('�ϴ�ʧ�ܣ�' + rspJson.S['msg']);
    end;
  finally
    rspStream.Free;
    httpClient.Free;
    formData.Free;
  end;

end;

procedure TFMain.btnCopyMarkdownClick(Sender: TObject);
begin
  // ![����](��ַ)
  Clipboard.AsText := edtMarkdown.Text;
end;

procedure TFMain.btnCopyHTMLClick(Sender: TObject);
begin
  Clipboard.AsText := edtHTML.Text;
end;

procedure TFMain.btnCopyLinkClick(Sender: TObject);
begin
  Clipboard.AsText := edtLink.Text;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   //�ӹ۲�����ɾ�����۲촰��
  ChangeClipboardChain(Handle, NextClipHwnd);
  //��WM_DRAWCLIPBOARD��Ϣ���ݵ���һ���۲����еĴ���
  SendMessage(NextClipHwnd, WM_CHANGECBCHAIN, Handle, NextClipHwnd);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  //��ù۲�������һ�����ھ��
  NextClipHwnd := SetClipBoardViewer(Handle);
  picDir := GetEnvironmentVariable('APPDATA') + '\PictureBed\' + FormatDateTime('YYYYMMDD', Now) + '\';
  if not DirectoryExists(picDir) then
    ForceDirectories(picDir);
end;

procedure TFMain.WMDrawClipBoard(var AMessage: TMessage);
var
  bmpObj: TBitmap;
  jpgObj: TJPEGImage;
  i: integer;
  isBitmap: boolean;
begin
   //��WM_DRAWCLIPBOARD��Ϣ���ݵ���һ���۲����еĴ���
  if NextClipHwnd <> 0 then
    SendMessage(NextClipHwnd, AMessage.Msg, AMessage.WParam, AMessage.LParam);
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    if (isShow = True) then
    begin
      btnUpload.Enabled := True;
      if IsIconic(Application.Handle) = True  // �����Ƿ���С��
        then
        Application.Restore              // �ָ�����
      else
        Application.BringToFront;        // �ᵽǰ����ʾ
      // SetForegroundWindow(Handle);
      try
        try
          imgBox.Picture.LoadFromClipboardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);
          clearResult;
          currImg := picDir + FormatDateTime('hhnnss', Now) + '.jpg';
          bmpObj := TBitmap.Create;
          jpgObj := TJPEGImage.Create;

          bmpObj.LoadFromClipboardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);
          jpgObj.Assign(bmpObj);
          jpgObj.SaveToFile(currImg);
        except
          on E: Exception do
            ShowMessage('��֧�ֵ�����');
        end;
      finally
        bmpObj.Free;
        jpgObj.Free;
      end;

    end;
  end;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  isShow := True;
end;

procedure TFMain.btnLocalFileClick(Sender: TObject);
begin
  if (dlgOpenPic.Execute = True) then
  begin
    imgBox.Picture.LoadFromFile(dlgOpenPic.FileName);
    clearResult;
    currImg := picDir + FormatDateTime('hhnnss', Now) + '.jpg';
    imgBox.Picture.SaveToFile(currImg);
    btnUpload.Enabled := True;
  end;
end;

end.

