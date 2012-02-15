{*******************************************************************************
  作者: dmzn@163.com 2011-11-21
  描述: 添加新会员
*******************************************************************************}
unit UFrameNewMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, UGridPainter, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, Grids, StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, cxRadioGroup, cxTextEdit, ExtCtrls, UTransPanel,
  cxGroupBox, cxMaskEdit, cxDropDownEdit, cxCalendar, UImageButton;

type
  TfFrameNewMember = class(TfFrameBase)
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditCard: TcxTextEdit;
    EditName: TcxTextEdit;
    EditPhone: TcxTextEdit;
    EditAddr: TcxTextEdit;
    Radio3: TcxRadioButton;
    Radio4: TcxRadioButton;
    cxGroupBox1: TcxGroupBox;
    Radio1: TcxRadioButton;
    Radio2: TcxRadioButton;
    Label7: TLabel;
    EditSF: TcxTextEdit;
    Label8: TLabel;
    EditDate: TcxDateEdit;
    ImageButton1: TImageButton;
    ImageButton2: TImageButton;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  DB, ULibFun, UFormCtrl, UDataModule, UMgrControl, USysFun, USysConst, USysDB;

class function TfFrameNewMember.FrameID: integer;
begin
  Result := cFI_FrameNewMember;
end;

procedure TfFrameNewMember.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFrameNewMember.BtnOKClick(Sender: TObject);
var nStr,nHint,nSex,nType: string;
    nDS: TDataSet;
    nIsNew: Boolean;
begin
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('请输入会员卡号', sHint); Exit;
  end;

  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    ShowMsg('请输入用户名', sHint); Exit;
  end;

  if Radio1.Checked then
       nSex := sFlag_Male
  else nSex := sFlag_Female;

  if Radio3.Checked then
       nType := sFlag_Yes
  else nType := sFlag_No;

  //----------------------------------------------------------------------------
  nStr := 'Select Count(*) From %s Where M_TerminalId=''%s'' and M_Card=''%s''';
  nStr := Format(nStr, [sTable_Member, gSysParam.FTerminalID, EditCard.Text]);

  nDS := FDM.LockDataSet(nStr, nHint);
  try
    if not Assigned(nDS) then
    begin
      ShowDlg(nHint, sWarn); Exit;
    end;

    nIsNew := nDS.Fields[0].AsInteger < 1;
    if not nIsNew then
    begin
      nStr := '该卡已在使用中,是否更新会员信息?';
      if not QueryDlg(nStr, sAsk) then Exit;
    end;
  finally
    FDM.ReleaseDataSet(nDS);
  end;

  if nIsNew then
  begin
    nStr := MakeSQLByStr([SF('M_TerminalId', gSysParam.FTerminalID),
            SF('M_Card', EditCard.Text), SF('M_Name', EditName.Text),
            SF('M_Sex', nSex), SF('M_Phone', EditPhone.Text),
            SF('M_IDCard', EditSF.Text), SF('M_BirthDay', EditDate.Text),
            SF('M_Addr', EditAddr.Text), SF('M_Limit', nType),
            SF('M_BuyTime', '0', sfVal), SF('M_BuyMoney', '0', sfVal),
            SF('M_DeMoney', '0', sfVal), SF('M_Man', gSysParam.FUserID),
            SF('M_Date', sField_SQLServer_Now, sfVal)], sTable_Member, '', True);
    //make sql
  end else
  begin
    nStr := 'M_TerminalId=''%s'' and M_Card=''%s''';
    nStr := Format(nStr, [gSysParam.FTerminalID, EditCard.Text]);
    //where

    nStr := MakeSQLByStr([SF('M_TerminalId', gSysParam.FTerminalID),
            SF('M_Card', EditCard.Text), SF('M_Name', EditName.Text),
            SF('M_Sex', nSex), SF('M_Phone', EditPhone.Text),
            SF('M_Addr', EditAddr.Text),
            SF('M_IDCard', EditSF.Text), SF('M_BirthDay', EditDate.Text),
            SF('M_Limit', nType)], sTable_Member, nStr, False);
    //make sql
  end;

  if FDM.SQLExecute(nStr, nHint) < 0 then
       ShowDlg(nHint, sWarn)
  else ShowMsg('保存成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameNewMember, TfFrameNewMember.FrameID);
end.
