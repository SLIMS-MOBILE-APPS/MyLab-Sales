DateTime SelecteDate = DateTime.now();
String title = 'Clients List';
String clientName = '';
String selectedEmpid = '';
String selectedEmname = '';
String selectedEmMail = '';
String phoneno = '';
String selectedClientid = '';
String loginUserid = '';
String Result_srv_id = '';
String selectedBillid = '';
String selectedServiceid = '';
String selectedUmrno = '';
String Patname = '';
String billno = '';
String Agegender = '';
String Billdt = '';
String Refdr = '';
String Umrno = '';
String Client = '';
String Comments = '';
String Referal = '';
String clinical_summry = '';
String Servicegroup = '';
String Skipflg = '';
String pending = '';
String stat = '';
String approved = '';
String hold = '';
String abnormal = '';
String MailId = '';
String EmpName = '';
String EmpMob = '';
String EmpMail = '';
String lockstat = '';
String loginEmpid = '';
String sessionid = '';
String selectDate = "";
String activeclnt = '';
String lockedclnt = '';
String totalclnt = '';
String slsManager_Id = '';
String address = '';
String mybusiness = '';
String collection = '';
String dues = '';
String lastpay = '';
String lastdate = '';
var daypay = null;
var daybusin = null;
var monthpay = null;
var monthbusi = null;
String clientsid = '';
String dposit = '';

String generateOtp = "";

String ClientRefernceId = '';

String ClientBusinessId = "";

var dayWiseAchieveTargetAmount = null;

// var selectedManagerData = null;
var selectedClientData = null;
var selectedPatientData = null;

//var selected
// LUCID LIVE
// String API_url  = "http://103.145.36.189/mobilesalesapi_live";
// String Connection_Flag  = '1';

// String ReportUrl =
//     "http://103.145.36.189/his/PUBLIC/HIMSREPORTVIEWER.ASPX?UNIUQ_ID=";

// LUCID Testing
//String API_url  = "http://103.145.36.189/mobilesalesapi_uat";

// String API_url  = "http://115.112.254.129/MobileSalesApi";

String manager_name = '';
String manager_business = '';
String manager_deposits = '';
String manager_balance = '';
String manager_active = '';
String manager_inActive = '';
String manager_total = '';
String manager_mobile = '';
String manager_mail = '';

String BILL_COUNT = '';
String SRV_COUNT = '';
String GROSS = '';
String NET = '';
String DISCOUNT = '';
String CANCELLED = '';
String fromDate = '';
String ToDate = '';

String controllerUserName = '';
String controllerPassword = '';
String tab_index = "";
String Amount_CWB = "";
String Loc_Name_CWB = "";
String location_wise_flg_glb = "";
// String location_id_glb = "";

String TOTAL_CHANNEL_AMOUNT = "";
String TOTAL_SRV_GRP_AMOUNT = "";
String TOTAL_CLIENT_AMOUNT = "";
String reference_type_id = "";
String glb_user_name = "";
String glb_password = "";
String CLIENT_ID = "";
String CLIENT_NAME = "";
String Employee_Code = "";

String SelectedlocationId = "";

String glbFlag = "";
String IP_EMP_ID_glb = "";

String Glb_service_group_id = "";
String Service_Group_Name = "";
String LOC_ID = "";

String Sales_Gross = "";
String Sales_Net = "";
String Sales_Samples = "";
String Sales_Test = "";
String Service_Group_ID = "";
String employee_id = "";

String Service_ID = "";
String Total_Count = "";

String mobile_no = "";
String bill_no = "";
String SERVICE_NAME = "";
String Counts = "";

String Referal_Doctor_Id = "";

String REFERAL_DOCTOR = "";
String REF_AMOUNT = "";
String SERVICE_GROUP_ID = "";
String SERVICE_ID = "";
String SERVICE_NAME_By_Referal = "";
String CNT = "";

String SERVICE_ID_by_summary = "";
String SERVICE_GROUP_ID_BY_SUMMARY = "";
String CNT_BY_SUMMARY = "";
String SERVICE_GROUP_NAME_BY_SUMMARY = "";
String Radio_Lab_Flag = "";
String SERVICE_NAME_SERVICES = "";
String Count_Services = "";
String USER_ID = "";
String SERVICE_ID_by_Cardialogy = "";

String Glb_WITHOUTHEAD_URL = "";
String Glb_WITHHEAD_URL = "";
//String ReportDataSet='';

//..........................................
String Report_URL = "";
String Report_URL1 =
    "https://slims.afriglobalmedicare.com/pdflink/pdfwebsite/billwise?BookingId=";
String Connection_Flag = "";
String Logo = "";
String API_url = "";
String Slims_API_url = "https://mobileappjw.softmed.in/";
String Glb_IS_REQ_BUSINESS = "";
String Glb_BILL_TYPE_ID = "";
String Glb_Tarrif = "";
String GLB_TARRIF_ID = "";
String GLB_TARRIF_NAME = "";
String Glb_client_name = "";
String Glb_From_Date = "";
String Glb_To_Date = "";
String Glb_SESSION_ID = "";
String Glb_IS_ACCESS_ADD_CLIENT = "";

String glb_deposits = "";
String Glb_empname = "";
String Glb_business = "";

String Glb_balance = "";

String Glb_mobileno = "";

String Glb_emailid = "";
String glb_emp_name = "";
String Glb_EMPLOYEE_CD = "";

String Glb_ACTIVE = "";
String Glb_TOTAL = "";
String Glb_IN_ACTIVE = "";
String Glb_myUpdateData = "";
String Glb_COMPANY_WISE_LAST_PAYMENT = "";
String Glb_CMP_AMOUNTS = "";
String new_selectedEmpid = "";

String Glb_Mng_business = "";
String Glb_Mng_deposits = "";
String Glb_Mng_balance = "";
String Glb_Mng_acount = "";
String Glb_Mng_icount = "";
String Glb_Mng_total = "";
var Glb_myOrderList = [];
var Glb_ManagerDetailsList = [];
String Glb_Dashboard_BALANCE = "0";

String Glb_IS_LOCK_REQ = "";

String Glb_second_new_selectedEmpid = "";
String Login_verification = "";
String Glb_Client_Code = "";
String Glb_DESIGNATION_NAME = "";
String Glb_UPLOAD_ATTACHMENTS = "";
String Glb_IS_REPORT_OPEN_WEB = "";

//.....................................................pay u payment code start
Map<String, dynamic> deviceInformation = {
  "appName": "MeYdya",
  "appversion": "1.0.1"
};

bool isPayment = false;
var udf5 = {};
//.....................................................pay u payment code finished

//Pay_U_Money Globals Value
String glb_Transaction_Client_Id = "";
String glb_Transaction_txnid = "";
String glb_Transaction_amount = "";
String glb_Transaction_phone = "";
String glb_Transaction_email = "";
String glb_Transaction_firstname = "";
String Response_Content = "";
String glb_entered_price = "";
String glb_MOBILE_PHONE = "";
String glb_merchantSalt = "";
String glb_merchantKey = "";
String Server_Flag = "";
String Navigate_mngrcnt = "";
String glb_Transaction_status = "";
String Glb_Flag = "";
String glb_session_id = "";
String Glb_Method = "";
String Glb_FILTER_BUSINESS_PAYMENTS = "";
String Glb_SelectedDate = "";
String Glb_Hours_session_id = "";
String Glb_BILL_AMOUNT = "";

String glb_EMPLOYEE_NAME = "";
String glb_EMPLOYEE_ID = "";
String glb_EMAIL_ID = "";
String glb_MOBILE_PHONE_NEW = "";
String Glb_LAST_REFRESH_DT = "";
String Glb_CLIENT_NAME_RCPT_CNC = "";
String Glb_BILL_AMOUNT_RCPT_CNC = "";
String Class_refresh = "";

//client serach for lock

String clientLockFlag = "";
String clientName_Client_Lock = "";
String clientid_Client_Lock = "";
String IS_CREDIT_LIMIT_REQ_Client_Lock = "";
String CREDIT_LIMT_AMNT_Client_Lock = "=";
String balance_Client_Lock = "";
String Client_CODE_Lock = "";

String glb_Expended_Open = "";
String Glb_TARIFF_ID = "";
String Glb_Dr_Cr_Note = "";

String Glb_Client_Need = "";

String Glb_Client_Need_Avg_Business = "";
String Glb_Client_Need_Avg_Deposits = "";
String Glb_Client_Need_Inventory_Purchase = "";
String Glb_Client_Need_Inventory_Consumption = "";
String Glb_Client_Need_Add_Franchise_Client = "";
String Glb_Client_Need_Location_Wise_Business = "";

String Glb_Code = "";
String Glb_Name = "";
String Glb_Owner_Name = "";
String Glb_Mobile = "";
String Glb_Mail_Id = "";
String Glb_Address = "";
String Glb_MKTG_Emp = "";
String refresh_data = "";

String Glb_Payment_Today_DB_Avble = "";
String Glb_Payment_Last_Month_DB_Avble = "";
String Glb_Payment_This_Month_DB_Avble = "";

String Glb_Deposit_Today_DB_Avble = "";
String Glb_Deposit_Last_Month_DB_Avble = "";
String Glb_Deposit_This_Month_DB_Avble = "";

String Glb_inventory_purchase_Today_DB_Avble = "";
String Glb_inventory_purchase_Last_Month_DB_Avble = "";
String Glb_inventory_purchase_This_Month_DB_Avble = "";

String Glb_inventory_consumption_Today_DB_Avble = "";
String Glb_inventory_consumption_Last_Month_DB_Avble = "";
String Glb_inventory_consumption_This_Month_DB_Avble = "";

String Glb_Refresh_need = "";

var currentData = [];
