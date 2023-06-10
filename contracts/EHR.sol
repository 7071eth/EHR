//SPDX-License-Identifier: MIT
pragma solidity^0.8.0;

contract EHR {

    //Type for storing a single doctor details
    struct Doc {
        string Doc_Name;
        string Doc_Qual;
        string Doc_Location;
        address Doc_Address;
        bool isRegistered;

    }

    //Type for storing a single patient details
    struct Pat {
        string Pat_Name;
        uint8 Pat_Age;
        address Pat_Address;
        bool isRegistered;
        string[] Pat_Disease;
        uint[] Pat_PrescribedMedicine;
    }

    //Type for storing a single medicine details
    struct Med {
        uint Med_Id;
        string Med_Name;
        string Med_Exp;
        string Med_Dose;
        string Med_Price;
        bool isRegistered;
    }

    address public owner;
    mapping(address=>Doc)  Doctor;
    mapping(address=>Pat)  Patient;
    mapping(uint=>Med)  Medicine;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyDoctor {
        require(Doctor[msg.sender].isRegistered,"You are not a registered doctor");
        _;
    }

    modifier onlyPatient {
        require(Patient[msg.sender].isRegistered,"You are not a registered patient");
        _;
    }

    modifier onlyAdmin {
        require(msg.sender==owner,"Not owner");
        _;
    }

    //Function to add doctor details
    function RegisterDoctor(string memory _DocName,string memory _DocQual,string memory _DocLocation) public {
        require(!Doctor[msg.sender].isRegistered,"The doctor is already registered");
        Doctor[msg.sender] = Doc(_DocName,_DocQual,_DocLocation,msg.sender,true);
    }

    //Function to add patient details
    function RegisterPatient(string memory _PatName,uint8 _PatAge) public{
        require(!Patient[msg.sender].isRegistered,"The doctor is already registered");
        Patient[msg.sender].Pat_Name=_PatName;
        Patient[msg.sender].Pat_Age=_PatAge;
        Patient[msg.sender].Pat_Address=msg.sender;
        Patient[msg.sender].isRegistered=true;
    }

    //Function to add Medicine details
    function RegisterMedicine(uint _Id,string memory _MName,string memory _MExp,string memory _MDose, string memory _Price) public {
        require(!Medicine[_Id].isRegistered,"The Medicine is already registered");
        Medicine[_Id] = Med(_Id,_MName,_MExp,_MDose,_Price,true);
    } 

    //Function to add disease details
    function AddDiseaseByPatient (string memory _PDis) public  onlyPatient{
        require(Patient[msg.sender].Pat_Address != address(0), "Patient not found");
        Patient[msg.sender].Pat_Disease.push(_PDis);
    }

    //Function to prescribe medicine by doctor
    function PrescribeMedByDoc (uint _MedId,address _PatAdd) public onlyDoctor{
        require(Patient[_PatAdd].Pat_Address != address(0), "Patient not found");
        require(Doctor[msg.sender].Doc_Address != address(0), "Doctor not found");
        Patient[_PatAdd].Pat_PrescribedMedicine.push(_MedId);
    }

    //Functon to update the age of the patient
    function UpdatePatientAge(uint8 _NewAge) public onlyPatient{
        require(Patient[msg.sender].Pat_Address != address(0), "Patient not found");
        Patient[msg.sender].Pat_Age=_NewAge;
    }

    //Function to view the records
    function ViewMyRecords() public view onlyPatient returns(string memory,uint8, string[] memory, uint[] memory) {
        require(Patient[msg.sender].Pat_Address != address(0), "Patient not found");
        return(Patient[msg.sender].Pat_Name,Patient[msg.sender].Pat_Age,Patient[msg.sender].Pat_Disease,Patient[msg.sender].Pat_PrescribedMedicine);
    }

    //Function to view medicine details
    function ViewMedDetails (uint _id) public view returns(string memory Name,string memory Exp,string memory Dose,string memory Price){
        require(Medicine[_id].isRegistered,"The Medicine is not registered");
        Name= Medicine[_id].Med_Name;
        Exp= Medicine[_id].Med_Exp;
        Dose= Medicine[_id].Med_Dose;
        Price= Medicine[_id].Med_Price;
    }

    //Function to view prescribed medicine
    function ViewPresMed(address _PatAddress) public view onlyPatient returns(uint[] memory){
        require(Patient[_PatAddress].Pat_Address != address(0), "Patient not found");
        return Patient[_PatAddress].Pat_PrescribedMedicine;
    }

     //Function to view the records by doctor
    function ViewPatDataByDoc(address PAddress) public view onlyDoctor returns(string memory,uint8, string[] memory, uint[] memory) {
        return(Patient[PAddress].Pat_Name,Patient[PAddress].Pat_Age,Patient[PAddress].Pat_Disease,Patient[PAddress].Pat_PrescribedMedicine);
    }

    //Function to view the doctor details
    function ViewDocDetails(address DAddress) public view returns (string memory, string memory, string memory){
        require(Doctor[DAddress].Doc_Address != address(0), "Doctor not found");
        return(Doctor[DAddress].Doc_Name,Doctor[DAddress].Doc_Qual,Doctor[DAddress].Doc_Location);
    }

}

