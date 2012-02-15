{*******************************************************************************
  ����: dmzn@163.com 2008-08-07
  ����: ϵͳ���ݿⳣ������

  ��ע:
  *.�Զ�����SQL���,֧�ֱ���:$Inc,����;$Float,����;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,��������
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //ϵͳ����

var
  gSysTableList: TList = nil;                        //ϵͳ������
  gSysDBType: TSysDatabaseType = dtSQLServer;        //ϵͳ��������

//------------------------------------------------------------------------------
const
  //�����ֶ�
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //С���ֶ�
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //ͼƬ�ֶ�
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //�������
  sField_SQLServer_Now           = 'getDate()';

  //�ʻ�״̬
  sFlag_Normal        = 1;                           //�ʻ�����
  sFlag_Freeze        = 2;                           //�ʻ�����
  sFlag_Invalid       = 3;                           //�ʻ�����

ResourceString     
  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //���
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����

  sFlag_Male          = '1';                         //��
  sFlag_Female        = '0';                         //Ů

  sFlag_Integer       = 'I';                         //����
  sFlag_Decimal       = 'D';                         //С��

  sFlag_SyncW         = 'N';                         //�ȴ�ͬ��
  sFlag_Syncing       = 'S';                         //ͬ����
  sFlag_Synced        = 'D';                         //done

  sFlag_BillNew       = 'N';                         //�¶���
  sFlag_BillLock      = 'L';                         //�ն�����
  sFlag_BillCancel    = 'C';                         //�ն�ȡ��
  sFlag_BillAccept    = 'A';                         //����ȷ��
  sFlag_BillDeliver   = 'D';                         //������
  sFlag_BillTakeDeliv = 'T';                         //�ն��ջ�
  sFlag_BillDone      = 'O';                         //��������

  sFlag_ReportTitle   = 'RepTitle';                  //����ͷ
  sFlag_ReportEnding  = 'RepEnd';                    //����β

  {*���ݱ�*}
  sTable_SysDict      = 'Sys_Dict';                  //ϵͳ�ֵ��
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־��
  sTable_SysExtInfo   = 'Sys_ExtInfo';               //ϵͳ��չ��Ϣ

  sTable_MITAdmin     = 'MIT_Admin';                 //�м������Ա
  sTable_MITDB        = 'MIT_DBConfig';              //���ݿ����ñ�
                                                                 
  sTable_Terminal     = 'HX_Terminal';               //�ն��˻���
  sTable_TerminalUser = 'HX_T_Users';                //�ն��û���
  sTable_MACRebind    = 'HX_T_MACRebind';            //MAC������

  sTable_DL_Style     = 'HX_Style';                  //��ʽ��
  sTable_DL_Product   = 'HX_Product';                //��Ʒ��
  sTable_DL_Size      = 'HX_Size';                   //�ߴ�
  sTable_DL_Color     = 'HX_Color';                  //��ɫ
  sTable_DL_Brand     = 'HX_Brand';                  //Ʒ��
  sTable_DL_Noties    = 'HX_Notices';                //ͨ��
  sTable_DL_Order     = 'HX_TerminalOrder';          //����
  sTable_DL_OrderDtl  = 'HX_TerminalOrderDetail';    //������ϸ
  sTable_DL_TermSale  = 'HX_TerminalSaleRecord';     //�ն�����

  sTable_Product      = 'HX_T_Product';              //��Ʒ��
  sTable_Sale         = 'HX_T_Sale';                 //���ۼ�¼
  sTable_SaleDtl      = 'HX_T_SaleDtl';              //������ϸ
  sTable_AutoWan      = 'HX_T_AutoWarn';             //���Ԥ��
  sTable_Order        = 'HX_T_Order';                //������
  sTable_OrderDtl     = 'HX_T_OrderDtl';             //������ϸ
  sTable_Return       = 'HX_T_Return';               //�˵���
  sTable_ReturnDtl    = 'HX_T_ReturnDtl';            //�˵���ϸ
  sTable_OrderDeal    = 'HX_T_OrderDeal';            //�����ջ�
  sTable_OrderAdjust  = 'HX_T_OrderAdjust';          //��������
  sTable_Member       = 'HX_T_Member';               //��Ա��Ϣ
  sTable_MemberSet    = 'HX_T_MemberSet';            //��Ա�趨


  {*�½���*}  
  sSQL_NewMITAdmin = 'Create Table $Table(A_UserID varChar(15),' +
       'A_Name varChar(32), A_Pwd varChar(15), A_Create DateTime,' +
       'A_Update DateTime)';
  {-----------------------------------------------------------------------------
   ϵͳ�û���: MITAdmin
   *.A_UserID: �û��˻�
   *.A_Name: �û���
   *.A_Pwd: ����
   *.A_Create: ����ʱ��
   *.A_Update: ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewMITDB = 'Create Table $Table(D_Agent varChar(15), D_Name varChar(80),' +
       'D_Host varChar(32), D_Port Integer, D_DBName varChar(32),' +
       'D_User varChar(15), D_Pwd varChar(15), D_ConnStr varChar(220),' +
       'D_Create DateTime, D_Update DateTime, D_Invalid Char(1))';
  {-----------------------------------------------------------------------------
   ���ݿ�����: DBConfig
   *.D_Agent: ������
   *.D_Name: ��������
   *.D_Host: ������ַ
   *.D_DBName: ���ݿ���
   *.D_Port: �˿�
   *.D_User: ��¼�û�
   *.D_Pwd: ��¼����
   *.D_ConnStr: ����
   *.D_Create: ����ʱ��
   *.D_Update: ����ʱ��
   *.D_Invalid: �Ƿ�ʧЧ
  -----------------------------------------------------------------------------}

  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(100), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ϵͳ�ֵ�: MITDict
   *.D_ID: ���
   *.D_Name: ����
   *.D_Desc: ����
   *.D_Value: ȡֵ
   *.D_Memo: �����Ϣ
   *.D_ParamA: �������
   *.D_ParamB: �ַ�����
   *.D_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.I_ID: ���
   *.I_Group: ��Ϣ����
   *.I_ItemID: ��Ϣ��ʶ
   *.I_Item: ��Ϣ��
   *.I_Info: ��Ϣ����
   *.I_ParamA: �������
   *.I_ParamB: �ַ�����
   *.I_Memo: ��ע��Ϣ
   *.I_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   ϵͳ��־: SysLog
   *.L_ID: ���
   *.L_Date: ��������
   *.L_Man: ������
   *.L_Group: ��Ϣ����
   *.L_ItemID: ��Ϣ��ʶ
   *.L_KeyID: ������ʶ
   *.L_Event: �¼�
  -----------------------------------------------------------------------------}

  sSQL_NewTerminalUser = 'Create Table $Table(U_ID $Inc, U_Name varChar(32),' +
       'U_Pwd varChar(16), U_Phone varChar(20), U_TerminalId varChar(15),' +
       'U_Type Char(1), U_Invalid Char(1))';

  {-----------------------------------------------------------------------------
   �ն��û���: TerminalUser
   *.U_ID: ���
   *.U_Name: �˻���
   *.U_Pwd: ����
   *.U_Phone: �绰
   *.U_TerminalId: �ն˵�
   *.U_Type: ����(�곤,��Ա)
   *.U_Invalid: �Ƿ�ͣ��
  -----------------------------------------------------------------------------}

  sSQL_NewMACRebind = 'Create Table $Table(M_ID $Inc, M_MAC varChar(32),' +
       'M_TerminalId varChar(15), M_ReqTime DateTime,' +
       'M_Allow Char(1) Default ''N'',M_AllowMan Char(32), M_AllowTime DateTime)';

  {-----------------------------------------------------------------------------
   MAC�������: MACRebind
   *.M_ID: ���
   *.M_MAC: MAC��ַ
   *.M_TerminalId: �ն˱�ʶ
   *.M_Allow: �Ƿ�ͨ��
   *.M_AllowMan: �����
   *.M_AllowTime:���ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewProduct = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'P_ID varChar(15), P_Color varChar(15), P_Size varChar(15),' +
       'P_Number Integer, P_Price $Float, P_InPrice $Float, P_OldPrice $Float,' +
       'P_TerminalId varChar(15), P_LastIn DateTime)';
  {-----------------------------------------------------------------------------
   ��Ʒ��: Product
   *.R_ID: ���
   *.R_Sync: ͬ��
   *.P_ID: ��Ʒ��ʶ
   *.P_Color: ��ɫ
   *.P_Size: ��С
   *.P_Number: �����
   *.P_Price: ���ۼ�
   *.P_InPrice: ������
   *.P_OldPrice: ����ǰ�ۼ�
   *.P_TerminalId: �ն˱�ʶ
   *.P_LastIn: ������ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewSale = 'Create Table $Table(R_ID $Inc, R_Sync Char(1), S_ID varChar(15),' +
       'S_TerminalId varChar(15), S_Number Integer, S_Money $Float,' +
       'S_Member varChar(15), S_Deduct $Float, S_DeMoney $Float,' +
       'S_Man varChar(32), S_Date DateTime)';
  {-----------------------------------------------------------------------------
   ���ۼ�¼: Sale
   *.R_ID: ���
   *.R_Sync: ͬ��
   *.S_ID: ���۱��
   *.S_TerminalId: �ն˱�ʶ
   *.S_Number: ���ۼ���
   *.S_Money: ����Ǯ��
   *.S_Member: ��Ա��
   *.S_Deduct: �ۿ۱�
   *.S_DeMoney: �Żݽ�
   *.S_Man: ������
   *.S_Date: ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewSaleDtl = 'Create Table $Table(R_ID $Inc, R_Sync Char(1), D_SaleID varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_Member varChar(15), D_Deduct $Float, D_DeMoney $Float)';
  {-----------------------------------------------------------------------------
   ������ϸ: SaleDtl
   *.R_ID: ���
   *.R_Sync: ͬ��
   *.D_SaleID: ���۱��
   *.D_Product: ��Ʒ���
   *.D_Number: ���ۼ���
   *.D_Price: ���۵���
   *.D_Member: ��Ա��
   *.D_Deduct: �ۿ۱�
   *.D_DeMoney: �Żݽ�
  -----------------------------------------------------------------------------}

  sSQL_NewAutoWarn = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'W_TerminalId varChar(15), W_Product varChar(15), W_AvgNum Integer,' +
       'W_Status Char(1))';
  {-----------------------------------------------------------------------------
   ���Ԥ��: AutoWarn
   *.R_ID: ���
   *.R_Sync:ͬ��
   *.W_TerminalId: �ն�
   *.W_Product: ��Ʒ���
   *.W_AvgNum: ƽ������
   *.W_Status: ��¼״̬
  -----------------------------------------------------------------------------}

  sSQL_NewOrder = 'Create Table $Table(R_ID $Inc, O_ID varChar(15),' +
       'O_TerminalId varChar(15), O_Number Integer, O_DoneNum Integer,' +
       ' O_Man varChar(32), O_Date DateTime, O_ActDate DateTime, O_Status Char(1))';
  {-----------------------------------------------------------------------------
   ������: Order
   *.R_ID: ���
   *.O_ID: ������
   *.O_TerminalId: �ն�
   *.O_Number: ��������
   *.O_DoneNum: �����
   *.O_Man: �µ���
   *.O_Date: �µ�ʱ��
   *.O_ActDate: ����ʱ��
   *.O_Status: ����״̬
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDtl = 'Create Table $Table(R_ID $Inc, D_Order varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_HasIn Integer, D_InDate DateTime)';
  {-----------------------------------------------------------------------------
   ������ϸ: OrderDtl
   *.R_ID: ���
   *.D_Order: ������
   *.D_Product: ��Ʒ
   *.D_Number: ��������
   *.D_Price: ������
   *.D_HasIn: �����
   *.D_InDate: �ϴ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDeal = 'Create Table $Table(R_ID $Inc, D_Order varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_Man varChar(32), D_Date DateTime, D_Memo varChar(80))';
  {-----------------------------------------------------------------------------
   �����ջ�: OrderDeal
   *.R_ID: ���
   *.D_Order: ������
   *.D_Product: ��Ʒ
   *.D_Number: �ջ���
   *.D_Price: �ջ���
   *.D_Man: �ջ���
   *.D_Date: �ջ�ʱ��
   *.D_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewOrderAdjust = 'Create Table $Table(R_ID $Inc, A_Order varChar(15),' +
       'A_Product varChar(15), A_Number Integer, A_NewNum Integer,' +
       'A_Man varChar(32), A_Date DateTime, A_Memo varChar(80))';
  {-----------------------------------------------------------------------------
   ��������: OrderAdjust
   *.R_ID: ���
   *.A_Order: ������
   *.A_Product: ��Ʒ
   *.A_Number: ԭ������
   *.A_NewNum: �¶�����
   *.A_Man: �޸���
   *.A_Date: �޸�ʱ��
   *.A_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewReturn = 'Create Table $Table(R_ID $Inc, T_ID varChar(15),' +
       'T_TerminalId varChar(15), T_Number Integer, T_DoneNum Integer,' +
       'T_Man varChar(32), T_Date DateTime, T_ActMan varChar(32),' +
       'T_ActDate DateTime, T_Memo varChar(500), T_Status Char(1))';
  {-----------------------------------------------------------------------------
   �˻���: Return
   *.R_ID: ���
   *.T_ID: �˻���
   *.T_TerminalId: �ն�
   *.T_Number: �˻�����
   *.T_DoneNum: ʵ���ջ�
   *.T_Man: �µ���
   *.T_Date: �µ�ʱ��
   *.T_ActMan: ������
   *.T_ActDate: ����ʱ��
   *.T_Status: ״̬
  -----------------------------------------------------------------------------}

  sSQL_NewReturnDtl = 'Create Table $Table(R_ID $Inc, D_Return varChar(15),' +
       'D_Product varChar(15), D_Number Integer, D_Price $Float,' +
       'D_HasIn Integer, D_InDate DateTime)';
  {-----------------------------------------------------------------------------
   �˻�����ϸ: ReturnDtl
   *.R_ID: ���
   *.D_Return: �˻���
   *.D_Product: ��Ʒ
   *.D_Number: �˻�����
   *.D_Price: ����������
   *.D_HasIn: �����
   *.D_InDate: �ϴ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewMember = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'M_TerminalId varChar(15), M_ID varChar(15), M_Card varChar(15),' +
       'M_IDCard varChar(20), M_Name varChar(32), M_Sex Char(1), ' +
       'M_BirthDay DateTime, M_Phone varChar(32), M_Addr varChar(80),' +
       'M_BuyTime Integer, M_BuyMoney $Float, M_DeMoney $Float, M_Type Char(1),' +
       'M_Limit Char(1), M_Man varChar(32), M_Date DateTime, M_Memo varChar(80))';
  {-----------------------------------------------------------------------------
   ��Ա��: Member
   *.R_ID: ���
   *.R_Sync: ͬ��
   *.M_TerminalId: �ն�
   *.M_ID: ��Ա��
   *.M_Card: ����
   *.M_IDCard: ���֤
   *.M_Name: ����
   *.M_Sex: �Ա�
   *.M_BirthDay: ����
   *.M_Phone: �绰
   *.M_Addr: ��ַ
   *.M_BuyTime: �������
   *.M_BuyMoney: ������
   *.M_DeMoney:�Żݽ��
   *.M_Type: ��Ա����(��,��ͨ)
   *.M_Limit: ������Ч(��,��)
   *.M_Man: �쿨��
   *.M_Date: �쿨ʱ��
   *.M_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewMemberSet = 'Create Table $Table(R_ID $Inc, R_Sync Char(1),' +
       'S_TerminalId varChar(15), S_Type Char(15), S_Money $Float,' +
       'S_Deduct $Float, S_AddMan varChar(32), S_AddDate DateTime,' +
       'S_ModifyMan varChar(32), S_ModifyDate DateTime)';
  {-----------------------------------------------------------------------------
   ��Ա�趨: Memberset
   *.R_ID: ���
   *.R_Sync: ͬ��
   *.S_TerminalId: �ն�
   *.S_Type: ��Ա����
   *.S_Money: ���
   *.S_Deduct: �ۿ�
   *.S_AddMan: �����
   *.S_AddDate: ���ʱ��
   *.S_ModifyMan: �޸���
   *.S_ModifyDate: �޸�ʱ��
  -----------------------------------------------------------------------------}

implementation

//------------------------------------------------------------------------------
//Desc: ���ϵͳ����
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: ϵͳ��
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);
  AddSysTableItem(sTable_SysExtInfo, sSQL_NewExtInfo);

  AddSysTableItem(sTable_MITAdmin, sSQL_NewMITAdmin);
  AddSysTableItem(sTable_MITDB, sSQL_NewMITDB);
  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);

  AddSysTableItem(sTable_TerminalUser, sSQL_NewTerminalUser);
  AddSysTableItem(sTable_MACRebind, sSQL_NewMACRebind);

  AddSysTableItem(sTable_Product, sSQL_NewProduct);
  AddSysTableItem(sTable_Sale, sSQL_NewSale);
  AddSysTableItem(sTable_SaleDtl, sSQL_NewSaleDtl);
  AddSysTableItem(sTable_AutoWan, sSQL_NewAutoWarn);
  AddSysTableItem(sTable_Order, sSQL_NewOrder);
  AddSysTableItem(sTable_OrderDtl, sSQL_NewOrderDtl);
  AddSysTableItem(sTable_OrderDeal, sSQL_NewOrderDeal);
  AddSysTableItem(sTable_OrderAdjust, sSQL_NewOrderAdjust);
  AddSysTableItem(sTable_Return, sSQL_NewReturn);
  AddSysTableItem(sTable_ReturnDtl, sSQL_NewReturnDtl);
  AddSysTableItem(sTable_Member, sSQL_NewMember);
  AddSysTableItem(sTable_MemberSet, sSQL_NewMemberSet);
end;

//Desc: ����ϵͳ��
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


