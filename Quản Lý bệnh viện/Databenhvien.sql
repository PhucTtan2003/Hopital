-- Tạo cơ sở dữ liệu
CREATE DATABASE HospitalDB;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE HospitalDB;
GO

-- Tạo bảng Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) NOT NULL,
    Location NVARCHAR(100)
);

-- Tạo bảng Patients
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    Address NVARCHAR(255),
    Phone NVARCHAR(15),
    Email NVARCHAR(50)
);

-- Tạo bảng Doctors
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Specialty NVARCHAR(50),
    Phone NVARCHAR(15),
    Email NVARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Appointments
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status NVARCHAR(20),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Tạo bảng MedicalRecords
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT,
    DoctorID INT,
    Date DATE NOT NULL,
    Diagnosis NVARCHAR(MAX),
    Treatment NVARCHAR(MAX),
    Notes NVARCHAR(MAX),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Tạo bảng Medications
CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY IDENTITY(1,1),
    MedicationName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX),
    Dosage NVARCHAR(50)
);

-- Tạo bảng Prescriptions
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT,
    DoctorID INT,
    MedicationID INT,
    Date DATE NOT NULL,
    Dosage NVARCHAR(50),
    Instructions NVARCHAR(MAX),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);

-- Tạo bảng Billing
CREATE TABLE Billing (
    BillingID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT,
    Date DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(20),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Tạo bảng Staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50),
    DepartmentID INT,
    Phone NVARCHAR(15),
    Email NVARCHAR(50),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Equipment
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY IDENTITY(1,1),
    EquipmentName NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    Status NVARCHAR(20),
    LastMaintenanceDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Rooms
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(10) NOT NULL,
    DepartmentID INT,
    RoomType NVARCHAR(50),
    Status NVARCHAR(20),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Thêm dữ liệu vào bảng Departments
INSERT INTO Departments (DepartmentName, Location) VALUES ('Cardiology', 'Building A');
INSERT INTO Departments (DepartmentName, Location) VALUES ('Neurology', 'Building B');
INSERT INTO Departments (DepartmentName, Location) VALUES ('Orthopedics', 'Building C');

-- Thêm dữ liệu vào bảng Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, Address, Phone, Email)
VALUES ('John', 'Doe', '1985-01-15', 'Male', '123 Main St', '1234567890', 'john.doe@example.com');
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, Address, Phone, Email)
VALUES ('Jane', 'Smith', '1990-02-20', 'Female', '456 Oak St', '0987654321', 'jane.smith@example.com');

-- Thêm dữ liệu vào bảng Doctors
INSERT INTO Doctors (FirstName, LastName, Specialty, Phone, Email, DepartmentID)
VALUES ('Alice', 'Johnson', 'Cardiology', '1122334455', 'alice.johnson@example.com', 1);
INSERT INTO Doctors (FirstName, LastName, Specialty, Phone, Email, DepartmentID)
VALUES ('Bob', 'Brown', 'Neurology', '2233445566', 'bob.brown@example.com', 2);

-- Thêm dữ liệu vào bảng Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status)
VALUES (1, 1, '2024-08-01', '09:00', 'Scheduled');
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status)
VALUES (2, 2, '2024-08-02', '10:00', 'Scheduled');

-- Thêm dữ liệu vào bảng MedicalRecords
INSERT INTO MedicalRecords (PatientID, DoctorID, Date, Diagnosis, Treatment, Notes)
VALUES (1, 1, '2024-08-01', 'Hypertension', 'Medication', 'Patient needs to monitor blood pressure daily');
INSERT INTO MedicalRecords (PatientID, DoctorID, Date, Diagnosis, Treatment, Notes)
VALUES (2, 2, '2024-08-02', 'Migraine', 'Medication and rest', 'Patient to follow up in 2 weeks');

-- Thêm dữ liệu vào bảng Medications
INSERT INTO Medications (MedicationName, Description, Dosage)
VALUES ('Aspirin', 'Pain reliever', '500mg');
INSERT INTO Medications (MedicationName, Description, Dosage)
VALUES ('Metformin', 'Blood sugar control', '1000mg');

-- Thêm dữ liệu vào bảng Prescriptions
INSERT INTO Prescriptions (PatientID, DoctorID, MedicationID, Date, Dosage, Instructions)
VALUES (1, 1, 1, '2024-08-01', '500mg', 'Take one tablet twice daily after meals');
INSERT INTO Prescriptions (PatientID, DoctorID, MedicationID, Date, Dosage, Instructions)
VALUES (2, 2, 2, '2024-08-02', '1000mg', 'Take one tablet daily with breakfast');

-- Thêm dữ liệu vào bảng Billing
INSERT INTO Billing (PatientID, Date, Amount, Status)
VALUES (1, '2024-08-01', 100.00, 'Paid');
INSERT INTO Billing (PatientID, Date, Amount, Status)
VALUES (2, '2024-08-02', 150.00, 'Pending');

-- Thêm dữ liệu vào bảng Staff
INSERT INTO Staff (FirstName, LastName, Position, DepartmentID, Phone, Email)
VALUES ('Emily', 'Davis', 'Nurse', 1, '3344556677', 'emily.davis@example.com');
INSERT INTO Staff (FirstName, LastName, Position, DepartmentID, Phone, Email)
VALUES ('Michael', 'Wilson', 'Technician', 2, '4455667788', 'michael.wilson@example.com');

-- Thêm dữ liệu vào bảng Equipment
INSERT INTO Equipment (EquipmentName, DepartmentID, Status, LastMaintenanceDate)
VALUES ('ECG Machine', 1, 'Operational', '2024-07-01');
INSERT INTO Equipment (EquipmentName, DepartmentID, Status, LastMaintenanceDate)
VALUES ('MRI Scanner', 2, 'Operational', '2024-06-15');

-- Thêm dữ liệu vào bảng Rooms
INSERT INTO Rooms (RoomNumber, DepartmentID, RoomType, Status)
VALUES ('101', 1, 'Consultation', 'Available');
INSERT INTO Rooms (RoomNumber, DepartmentID, RoomType, Status)
VALUES ('202', 2, 'Examination', 'Occupied');
