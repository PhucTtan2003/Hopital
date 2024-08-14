-- Tạo cơ sở dữ liệu
CREATE DATABASE HospitalDB;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE HospitalDB;
GO
CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordAccount NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL
);	
-- Tạo bảng Patients
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
	AccountID INT,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50)  NOT NULL,
    DateOfBirth DATE  NULL,
    Gender NVARCHAR(10)  NULL,
    AddressPatients	 NVARCHAR(255) NULL,
    Phone NVARCHAR(15) NOT NULL,
    Email NVARCHAR(50) NULL,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

-- Tạo bảng Sessions
CREATE TABLE Sessions (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT  NULL ,
    SessionToken NVARCHAR(255) NULL,
    CreatedAt DATETIME DEFAULT GETDATE() NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Tạo bảng Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) NULL,
    LocationHospital NVARCHAR(100) NULL 
);

-- Tạo bảng Doctors
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Specialty NVARCHAR(50) NULL,
    Phone NVARCHAR(15) NOT NULL,
    Email NVARCHAR(50) NULL,
    DepartmentID INT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Appointments
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NULL,
    DoctorID INT NULL,
    AppointmentDate DATE NULL,
    AppointmentTime TIME NULL,
    Notes NVARCHAR(20) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Tạo bảng MedicalRecords
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NULL,
    DoctorID INT NULL,
    DateMedical DATE NULL,
    Diagnosis NVARCHAR(MAX),
    Treatment NVARCHAR(MAX),
    Notes NVARCHAR(MAX),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Tạo bảng Medications
CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY IDENTITY(1,1),
    MedicationName NVARCHAR(50)NULL,
    DescriptionMedications NVARCHAR(MAX),
    Dosage NVARCHAR(50) NULL
);

-- Tạo bảng Prescriptions
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NULL,
    MedicationID INT NULL,
    DateBill DATE NULL,
    Dosage NVARCHAR(50) NULL,
    Instructions NVARCHAR(MAX),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);

-- Tạo bảng Billing
CREATE TABLE Billing (
    BillingID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NULL,
    DateBill DATE NULL,
    Amount DECIMAL(10, 2) NULL,
    Notes NVARCHAR(20) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Tạo bảng Staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50)  NOT NULL,
    Position NVARCHAR(50) NULL,
    DepartmentID INT NULL,
    Phone NVARCHAR(15)  NOT NULL,
    Email NVARCHAR(50) NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Equipment
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY IDENTITY(1,1),
    EquipmentName NVARCHAR(50) NULL,
    DepartmentID INT NULL,
    Notes NVARCHAR(20) NULL,
    LastMaintenanceDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Rooms
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(10) NULL,
    DepartmentID INT NULL,
    RoomType NVARCHAR(50) NULL,
    Notes NVARCHAR(20) NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Account (Username, PasswordAccount, Role)VALUES 
('admin', '123321', 'admin'),
('phuctan','942003', 'khach');


-- Thêm dữ liệu vào bảng Departments
INSERT INTO Departments (DepartmentName, LocationHospital) VALUES 
('Cardiology', 'Building A'),
('Neurology', 'Building B'),
('Orthopedics', 'Building C');

-- Thêm dữ liệu vào bảng Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, AddressPatients, Phone, Email) VALUES
('John', 'Doe', '1985-01-15', 'Male', '123 Main St', '1234567890', 'john.doe@example.com'),
('Jane', 'Smith', '1990-02-20', 'Female', '456 Oak St', '0987654321', 'jane.smith@example.com'	);

-- Thêm dữ liệu vào bảng Doctors
INSERT INTO Doctors (FirstName, LastName, Specialty, Phone, Email, DepartmentID) VALUES 
('Alice', 'Johnson', 'Cardiology', '1122334455', 'alice.johnson@example.com', 1),
('Bob', 'Brown', 'Neurology', '2233445566', 'bob.brown@example.com', 2);

-- Thêm dữ liệu vào bảng Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Notes) VALUES 
(1, 1, '2024-08-01', '09:00', 'Scheduled'),
(2, 2, '2024-08-02', '10:00', 'Scheduled');

-- Thêm dữ liệu vào bảng MedicalRecords
INSERT INTO MedicalRecords (PatientID, DoctorID, DateMedical, Diagnosis, Treatment, Notes) VALUES 
(1, 1, '2024-08-01', 'Hypertension', 'Medication', 'Patient needs to monitor blood pressure daily'),
(2, 2, '2024-08-02', 'Migraine', 'Medication and rest', 'Patient to follow up in 2 weeks');

-- Thêm dữ liệu vào bảng Medications
INSERT INTO Medications (MedicationName, DescriptionMedications, Dosage) VALUES 
('Aspirin', 'Pain reliever', '500mg'),
('Metformin', 'Blood sugar control', '1000mg');

-- Thêm dữ liệu vào bảng Prescriptions
INSERT INTO Prescriptions (PatientID, DoctorID, MedicationID, DateBill, Dosage, Instructions) VALUES 
(1, 1, 1, '2024-08-01', '500mg', 'Take one tablet twice daily after meals'),
(2, 2, 2, '2024-08-02', '1000mg', 'Take one tablet daily with breakfast');

-- Thêm dữ liệu vào bảng Billing
INSERT INTO Billing (PatientID, DateBill, Amount, Notes) VALUES 
(1, '2024-08-01', 100.00, 'Paid'),
(2, '2024-08-02', 150.00, 'Pending');

-- Thêm dữ liệu vào bảng Staff
INSERT INTO Staff (FirstName, LastName, Position, DepartmentID, Phone, Email) VALUES 
('Emily', 'Davis', 'Nurse', 1, '3344556677', 'emily.davis@example.com'),
('Michael', 'Wilson', 'Technician', 2, '4455667788', 'michael.wilson@example.com');

-- Thêm dữ liệu vào bảng Equipment
INSERT INTO Equipment (EquipmentName, DepartmentID, Notes, LastMaintenanceDate) VALUES 
('ECG Machine', 1, 'Operational', '2024-07-01'),
('MRI Scanner', 2, 'Operational', '2024-06-15');
-- Thêm dữ liệu vào bảng Rooms
INSERT INTO Rooms (RoomNumber, DepartmentID, RoomType, Notes) VALUES 
('101', 1, 'Consultation', 'Available'),
('202', 2, 'Examination', 'Occupied');