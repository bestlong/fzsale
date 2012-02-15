        ��  ��                  �  0   ��
 R O D L F I L E                     <?xml version="1.0" encoding="utf-8"?>
<Library Name="FZSale" UID="{34EF457B-16B4-449F-99E8-E602D03B2C77}" Version="3.0">
<Documentation><![CDATA[服装销售业务中间件]]></Documentation>
<Services>
<Service Name="SrvDB" UID="{7C241041-C46F-4C8A-A818-8DA401044A6B}">
<Documentation><![CDATA[数据服务]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{67AE7A34-B074-4CB3-AA40-DC57D60F950C}">
<Operations>
<Operation Name="SQLQuery" UID="{869CC8D4-521E-4778-B1B1-1CB783ED5667}">
<Documentation><![CDATA[使用SQL查询数据]]></Documentation>
<Parameters>
<Parameter Name="Result" DataType="SrvResult" Flag="Result">
</Parameter>
<Parameter Name="nZID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[终端店标识]]></Documentation>
</Parameter>
<Parameter Name="nDID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[代理商标识]]></Documentation>
</Parameter>
<Parameter Name="nSQL" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[SQL语句]]></Documentation>
</Parameter>
<Parameter Name="nData" DataType="Binary" Flag="Out" >
<Documentation><![CDATA[查询结果]]></Documentation>
</Parameter>
</Parameters>
</Operation>
<Operation Name="SQLExecute" UID="{4BA11194-8829-4A79-9BE5-1304EED56F43}">
<Documentation><![CDATA[执行写操作]]></Documentation>
<Parameters>
<Parameter Name="Result" DataType="SrvResult" Flag="Result">
</Parameter>
<Parameter Name="nZID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[终端店标识]]></Documentation>
</Parameter>
<Parameter Name="nDID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[代理商标识]]></Documentation>
</Parameter>
<Parameter Name="nSQL" DataType="SQLItem" Flag="In" >
<Documentation><![CDATA[SQL语句]]></Documentation>
</Parameter>
</Parameters>
</Operation>
<Operation Name="SQLUpdates" UID="{78E970E6-89DF-4A0E-B95D-557DF7FA4E96}">
<Documentation><![CDATA[批量写操作]]></Documentation>
<Parameters>
<Parameter Name="Result" DataType="SrvResult" Flag="Result">
</Parameter>
<Parameter Name="nZID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[终端店标识]]></Documentation>
</Parameter>
<Parameter Name="nDID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[代理商标识]]></Documentation>
</Parameter>
<Parameter Name="nSQLList" DataType="SQLItems" Flag="In" >
<Documentation><![CDATA[SQL列表组]]></Documentation>
</Parameter>
<Parameter Name="nAtomic" DataType="Boolean" Flag="In" >
<Documentation><![CDATA[是否事务操作]]></Documentation>
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="SrvConn" UID="{7918B78C-94FD-4FD0-B767-4FDAB82E00B5}">
<Documentation><![CDATA[链路连接服务,包括登录、心跳、安全认证等.]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{BA2637C5-07A2-466C-8675-5F269C550B83}">
<Operations>
<Operation Name="SweetHeart" UID="{0780F44C-9D14-4E9A-89D8-2190E9F3DD7D}">
<Documentation><![CDATA[心跳指令,返回服务器时间]]></Documentation>
<Parameters>
<Parameter Name="Result" DataType="SrvResult" Flag="Result">
</Parameter>
</Parameters>
</Operation>
<Operation Name="SignIn" UID="{90FCBA06-8F75-478B-87B8-5330C78498CD}">
<Parameters>
<Parameter Name="Result" DataType="SrvResult" Flag="Result">
</Parameter>
<Parameter Name="nZID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[终端店标识]]></Documentation>
</Parameter>
<Parameter Name="nDID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[代理商标识]]></Documentation>
</Parameter>
<Parameter Name="nMAC" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[终端MAC地址.]]></Documentation>
</Parameter>
<Parameter Name="nUser" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[登录用户名]]></Documentation>
</Parameter>
<Parameter Name="nPwd" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[用户密码]]></Documentation>
</Parameter>
<Parameter Name="nVerMIT" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[中间件版本]]></Documentation>
</Parameter>
<Parameter Name="nVerClient" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[客户端版本]]></Documentation>
</Parameter>
</Parameters>
</Operation>
<Operation Name="RegistMe" UID="{8BDDC3BF-C6E5-4DA5-AD3E-7E0CB72A5480}">
<Parameters>
<Parameter Name="Result" DataType="SrvResult" Flag="Result">
</Parameter>
<Parameter Name="nZID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[终端标识]]></Documentation>
</Parameter>
<Parameter Name="nDID" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[代理标识]]></Documentation>
</Parameter>
<Parameter Name="nMAC" DataType="AnsiString" Flag="In" >
<Documentation><![CDATA[待绑定MAC]]></Documentation>
</Parameter>
<Parameter Name="nIsFirst" DataType="Boolean" Flag="In" >
<Documentation><![CDATA[是否首次注册,若不是首次,则提交更新MAC绑定申请.]]></Documentation>
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
</Services>
<Structs>
<Struct Name="SrvResult" UID="{28EEAED7-7910-4BB5-BD1E-B9680B08FF5D}" AutoCreateParams="1">
<Documentation><![CDATA[服务执行返回结果的数据结构]]></Documentation>
<Elements>
<Element Name="Re_sult" DataType="Boolean">
<Documentation><![CDATA[执行结果(成功,失败)]]></Documentation>
</Element>
<Element Name="Action" DataType="Integer">
<Documentation><![CDATA[结果要触发的动作(错误,跳转,升级等)]]></Documentation>
</Element>
<Element Name="DataStr" DataType="AnsiString">
<Documentation><![CDATA[动作所需的字符数据]]></Documentation>
</Element>
<Element Name="DataInt" DataType="Integer">
<Documentation><![CDATA[动作所需的数值型数据]]></Documentation>
</Element>
</Elements>
</Struct>
<Struct Name="SQLItem" UID="{FA23E2A1-4FE9-4421-8E0A-BE9A37B78B7A}" AutoCreateParams="1">
<Documentation><![CDATA[按条件执行的SQL语句.若IfRun存在,则先执行,然后按照IfType判断条件是否满足.满足后执行SQL.
可用IfType如下:
1.IfType=1: IfRun为查询语句,且查询记录数<1时通过.
2.IfType=2: IfRun为查询语句,且查询记录数>0时通过.
3.IfType=5: IfRun为操作语句,且影响记录数<1时通过.
4.IfType=6: IfRun为操作语句,且影响记录数>0时通过.]]></Documentation>
<Elements>
<Element Name="SQL" DataType="AnsiString">
<Documentation><![CDATA[SQL语句]]></Documentation>
</Element>
<Element Name="IfRun" DataType="AnsiString">
<Documentation><![CDATA[SQL执行条件]]></Documentation>
</Element>
<Element Name="IfType" DataType="Integer">
</Element>
</Elements>
</Struct>
</Structs>
<Enums>
</Enums>
<Arrays>
<Array Name="SQLItems" UID="{88C8DAA6-0668-442A-8500-AB3B0A8997EE}">
<Documentation><![CDATA[包含SQLItem的数组]]></Documentation>
<ElementType DataType="SQLItem" />
</Array>
</Arrays>
</Library>
