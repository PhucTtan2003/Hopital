﻿-- Tạo cơ sở dữ liệu
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
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NULL,
    Gender NVARCHAR(10) NULL,
    AddressPatients NVARCHAR(255) NULL,
    Phone NVARCHAR(15) NOT NULL,
    Email NVARCHAR(50) NULL,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Sessions (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    SessionToken NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE() NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) NOT NULL,
    LocationHospital NVARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    Specialty NVARCHAR(50) NOT NULL,
    ImageUrl NVARCHAR(255) NULL,
    DescriptionDoctor NVARCHAR(2000) NOT NULL,
    Experience NVARCHAR(2000) NOT NULL,
    Education NVARCHAR(500) NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE DoctorSearch (
    DoctorSearchID INT PRIMARY KEY IDENTITY(1,1),
    Specialty NVARCHAR(50) NOT NULL,
    DoctorID INT NOT NULL,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE SelectSpecialty (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    Specialty NVARCHAR(100) NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Notes NVARCHAR(255) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    DateMedical DATE NOT NULL,
    Diagnosis NVARCHAR(MAX) NOT NULL,
    Treatment NVARCHAR(MAX) NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY IDENTITY(1,1),
    MedicationName NVARCHAR(50) NOT NULL,
    DescriptionMedications NVARCHAR(MAX) NULL,
    Dosage NVARCHAR(50) NOT NULL
);

CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    MedicationID INT NOT NULL,
    DateBill DATE NOT NULL,
    Dosage NVARCHAR(50) NOT NULL,
    Instructions NVARCHAR(MAX) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);

CREATE TABLE Billing (
    BillingID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DateBill DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Notes NVARCHAR(255) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    DepartmentID INT NOT NULL,
    Phone NVARCHAR(15) NOT NULL,
    Email NVARCHAR(50) NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY IDENTITY(1,1),
    EquipmentName NVARCHAR(50) NOT NULL,
    DepartmentID INT NOT NULL,
    Notes NVARCHAR(255) NULL,
    LastMaintenanceDate DATE NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(10) NOT NULL,
    DepartmentID INT NOT NULL,
    RoomType NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(255) NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert data into tables
INSERT INTO Account (Username, PasswordAccount, Role) VALUES 
('admin', '123321', 'admin'),
('phuctan', '942003', 'khach');

-- Thêm dữ liệu vào bảng Departments
INSERT INTO Departments (DepartmentName, LocationHospital) VALUES 
('Nội Khoa', 'Building A'),
('Ngoại Khoa', 'Building B'),
('Hồi Sức', 'Building C');

-- Thêm dữ liệu vào bảng Patients
INSERT INTO Patients (AccountID, FirstName, LastName, DateOfBirth, Gender, AddressPatients, Phone, Email) 
VALUES 
(1, 'Thuan', 'Ho', '1985-01-15', 'Male', '123 Le Van Luong', '1234567890', 'thuanho@gmail.com'),
(2, 'Tan', 'Phuc', '1990-06-15', 'Male', '456 Tran Phu', '0987654321', 'tanphuc@gmail.com');

-- Thêm dữ liệu vào bảng Doctors
INSERT INTO Doctors (FullName, Position, Specialty, ImageUrl, DescriptionDoctor, Experience, Education, DepartmentID) VALUES 
('Nguyễn Việt Hậu', 
'Trưởng Khoa Cấp cứu', 
'Ung Bướu', 
'nguyenminhhoang.jpg', 
'Tận tâm với bệnh nhân, luôn luôn cập nhật kiến thức mới trong điều trị ung thư.', 
'2010 - nay: Trưởng Khoa Cấp cứu tại Bệnh viện Đa khoa ABC. 2008 - 2010: Bác sĩ điều trị tại Khoa Ung Bướu Bệnh viện XYZ.', 
'2002 - 2008: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Hà Nội. 2009: Chuyên khoa Ung Bướu tại Đại học Y Dược TP.HCM.', 1),

('TS BS. Phan Tôn Ngọc Vũ', 
'Bác sĩ Gây mê hồi sức', 
'Gây mê Hồi sức', 'tannha.jpg', 
'Chuyên gia trong lĩnh vực Cấp cứu, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
'2012 - nay: Bác sĩ Khoa Cấp cứu tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2);

('PGS TS. Lê Thượng Vũ', 
'Bác sĩ Hô hấp', 
'Hô Hấp', 'tannha.jpg', 
'Chuyên gia trong lĩnh vực Hô Hấp, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
'2012 - nay: Bác sĩ Khoa Hô hấp tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2);

('ThS BS. Bùi Thị Hạnh Duyên', 
'Bác sĩ Hồi sức tích cực', 
'Hồi sức tích cực', 'tannha.jpg', 
'Chuyên gia trong lĩnh vực Hồi sức tích cực , luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
'2012 - nay: Bác sĩ Khoa Cấp cứu tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2);

('TS BS. Lê Quang Nhân', 
'Bác sĩ nội soi', 
'Nội soi', 'tannha.jpg', 
'Chuyên gia trong lĩnh vực nội soi , luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
'2012 - nay: Bác sĩ Khoa nội soi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2);

('TS BS. Lý Xuân Quang', 
'Bác sĩ tai mũi họng', 
'Tai mũi họng', 'tannha.jpg', 
'Chuyên gia trong lĩnh vực Tai mũi họng , luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
'2012 - nay: Bác sĩ Khoa Tai mũi họng tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2);

('PGS TS BS. Võ Duy Thông', 
'Bác sĩ Tiêu hoá', 
'Tiêu hoá', 'tannha.jpg', 
'Chuyên gia trong lĩnh vực Tiêu hoá, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
'2012 - nay: Bác sĩ Khoa Tiêu hoá tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2);

('PGS TS BS. Võ Duy Thông', 
'Bác sĩ Tim mạch', 
'Tim mạch', 'tannha.jpg', 
'Chuyên gia trong lĩnh vực Tim mạch, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
'2012 - nay: Bác sĩ Khoa Tim mạch tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2);

-- Insert data into DoctorSearch table
INSERT INTO DoctorSearch (Specialty, DoctorID)
SELECT Specialty, DoctorID FROM Doctors;

-- Thêm dữ liệu vào bảng SelectSpecialty
INSERT INTO SelectSpecialty (PatientID, Specialty) VALUES 
(1, ' Cấp cứu'),
(2, 'Gây mê hồi sức'),
(1, 'Nội soi'),
(2, 'Tai - Mũi - Họng'),
(1, 'Hồi sức'),
(2, 'Tiêm Mạch'),
(1, 'Tiêu Hóa');


-- Thêm dữ liệu vào bảng Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Notes) VALUES 
(1, 1, '2024-08-01', '09:00', 'Đã lên lịch'),
(2, 2, '2024-08-02', '10:00', 'Đã lên lịch');

-- Thêm dữ liệu vào bảng MedicalRecords
INSERT INTO MedicalRecords (PatientID, DoctorID, DateMedical, Diagnosis, Treatment, Notes) VALUES 
(1, 1, '2024-08-01', 'Tăng huyết áp', 'Thuốc', 'Bệnh nhân cần theo dõi huyết áp hàng ngày'),
(2, 2, '2024-08-02', 'Tiêu hóa không tốt', 'Thuốc - Ăn chín', 'Bệnh nhân cần theo dõi 2 tuần');

-- Thêm dữ liệu vào bảng Medications
INSERT INTO Medications (MedicationName, DescriptionMedications, Dosage) VALUES 
('Aspirin', 'Giảm đau', '500mg'),
('Metformin', 'Kiểm soát đường huyết', '1000mg');

-- Thêm dữ liệu vào bảng Prescriptions
INSERT INTO Prescriptions (PatientID, DoctorID, MedicationID, DateBill, Dosage, Instructions) VALUES 
(1, 1, 1, '2024-08-01', '500mg', 'Uống 1 viên 2 lần mỗi ngày sau bữa ăn'),
(2, 2, 2, '2024-08-02', '1000mg', 'Uống 1 viên mỗi ngày cùng với bữa sáng');

-- Thêm dữ liệu vào bảng Billing
INSERT INTO Billing (PatientID, DateBill, Amount, Notes) VALUES 
(1, '2024-08-01', 100.00, 'Đã thanh toán'),
(2, '2024-08-02', 150.00, 'Chưa thanh toán');

-- Thêm dữ liệu vào bảng Staff
INSERT INTO Staff (FirstName, LastName, Position, DepartmentID, Phone, Email) VALUES 
('Vũ', 'Nguyễn', 'Y Tá', 1, '3344556677', 'nguyenvu@gmail.com'),
('Bảo', 'Hồ', 'Kỹ Thuật Viên', 2, '4455667788', 'hobao@gmail.com');

-- Thêm dữ liệu vào bảng Equipment
INSERT INTO Equipment (EquipmentName, DepartmentID, Notes, LastMaintenanceDate) VALUES 
('Máy Điện Tâm', 1, 'Hoạt động tốt', '2024-07-01'),
('Máy Chụp MRI', 2, 'Hoạt động tốt', '2024-06-15');

-- Thêm dữ liệu vào bảng Rooms
INSERT INTO Rooms (RoomNumber, DepartmentID, RoomType, Notes) VALUES 
('101', 1, 'Tư Vấn', 'Còn trống'),
('202', 2, 'Khám Bệnh', 'Đang sử dụng');