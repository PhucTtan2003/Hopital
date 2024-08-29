-- Tạo cơ sở dữ liệu nếu chưa có
CREATE DATABASE HospitalDB;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE HospitalDB;
GO

-- Bảng Account: Lưu thông tin tài khoản
CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordAccount NVARCHAR(255) NOT NULL,
    Roles NVARCHAR(50) NOT NULL, 
    CONSTRAINT CHK_Role CHECK (Roles IN ('admin', 'khach'))
);

-- Bảng Departments: Lưu thông tin khoa trong bệnh viện
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(50) NOT NULL,
    LocationHospital NVARCHAR(100) NOT NULL
);

-- Bảng Doctors: Lưu thông tin bác sĩ
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

-- Bảng Patients: Lưu thông tin bệnh nhân
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NULL,
    Gender NVARCHAR(10) NULL CHECK (Gender IN ('Male', 'Female')),
    AddressPatients NVARCHAR(255) NULL,
    Phone NVARCHAR(15) NOT NULL,
    Email NVARCHAR(50) NULL,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

-- Bảng Sessions: Quản lý phiên làm việc của bệnh nhân
CREATE TABLE Sessionses (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    SessionToken NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE() NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Bảng TimeSlots: Quản lý các khung giờ có sẵn của bác sĩ
CREATE TABLE TimeSlots (
    TimeSlotID INT PRIMARY KEY IDENTITY(1,1),
    DoctorID INT NOT NULL,
    Date DATETIME NOT NULL,
    Time NVARCHAR(10) NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Bảng Appointments: Lưu thông tin các cuộc hẹn
CREATE TABLE Appointments (
    AppointmentId INT PRIMARY KEY IDENTITY(1,1),
    PatientId INT NOT NULL,
    DoctorId INT NOT NULL,
    TimeSlotID INT NOT NULL,
    Fee DECIMAL(18, 2) NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    FOREIGN KEY (PatientId) REFERENCES Patients(PatientId),
    FOREIGN KEY (DoctorId) REFERENCES Doctors(DoctorId),
    FOREIGN KEY (TimeSlotID) REFERENCES TimeSlots(TimeSlotID)
);

-- Bảng SelectSpecialty: Chọn chuyên khoa cho bệnh nhân
CREATE TABLE SelectSpecialties (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PatientId INT NOT NULL,
    Specialty NVARCHAR(100) NOT NULL,
    FOREIGN KEY (PatientId) REFERENCES Patients(PatientId)
);

-- Bảng DoctorSearch: Tìm kiếm bác sĩ theo chuyên khoa
CREATE TABLE DoctorSearch (
    DoctorSearchID INT PRIMARY KEY IDENTITY(1,1),
    Specialty NVARCHAR(50) NOT NULL,
    DoctorID INT NOT NULL,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Bảng MedicalRecords: Lưu trữ hồ sơ bệnh án
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    MedicalDate DATE NOT NULL,
    Diagnosis NVARCHAR(MAX) NOT NULL,
    Treatment NVARCHAR(MAX) NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Bảng Medications: Lưu trữ thông tin thuốc
CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY IDENTITY(1,1),
    MedicationName NVARCHAR(50) NOT NULL,
    MedicationImage NVARCHAR (50) NOT NULL,
    FeeMedication NVARCHAR (50) NOT NULL,
    StatusMedication NVARCHAR (50) NOT NULL,
    DescriptionMedications NVARCHAR(MAX) NULL,
    Dosage NVARCHAR(50) NOT NULL
);

-- Bảng Prescriptions: Quản lý đơn thuốc
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

-- Bảng Billing: Quản lý thanh toán
CREATE TABLE Billing (
    BillingID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DateBill DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Notes NVARCHAR(255) NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Bảng Staff: Lưu thông tin nhân viên
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

-- Bảng Equipment: Quản lý thiết bị
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY IDENTITY(1,1),
    EquipmentName NVARCHAR(50) NOT NULL,
    DepartmentID INT NOT NULL,
    Notes NVARCHAR(255) NULL,
    LastMaintenanceDate DATE NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Bảng Rooms: Quản lý phòng khám
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(10) NOT NULL,
    DepartmentID INT NOT NULL,
    RoomType NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(255) NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Thêm dữ liệu mẫu vào bảng Account
INSERT INTO Account (Username, PasswordAccount, Roles) VALUES 
('admin', '123321', 'admin'),
('phuctan', '942003', 'khach');

-- Thêm dữ liệu mẫu vào bảng Departments
INSERT INTO Departments (DepartmentName, LocationHospital) VALUES 
(N'Nội Khoa', 'Building A'),
(N'Ngoại Khoa', 'Building B'),
(N'Hồi Sức', 'Building C');

-- Thêm dữ liệu mẫu vào bảng Patients
INSERT INTO Patients (AccountID, FirstName, LastName, DateOfBirth, Gender, AddressPatients, Phone, Email) 
VALUES 
(1, 'Thuan', 'Ho', '1985-01-15', 'Male', N'123 Le Van Luong', '1234567890', 'thuanho@gmail.com'),
(2, 'Tan', 'Phuc', '1990-06-15', 'Male', N'456 Tran Phu', '0987654321', 'tanphuc@gmail.com');

-- Thêm dữ liệu mẫu vào bảng Doctors
INSERT INTO Doctors (FullName, Position, Specialty, ImageUrl, DescriptionDoctor, Experience, Education, DepartmentID) VALUES 
(N'Nguyễn Việt Hậu', 
N'Trưởng Khoa Cấp cứu', 
N'Ung Bướu', 
N'nguyenminhhoang.jpg', 
N'Tận tâm với bệnh nhân, luôn luôn cập nhật kiến thức mới trong điều trị ung thư.', 
N'2010 - nay: Trưởng Khoa Cấp cứu tại Bệnh viện Đa khoa ABC. 2008 - 2010: Bác sĩ điều trị tại Khoa Ung Bướu Bệnh viện XYZ.', 
N'2002 - 2008: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Hà Nội. 2009: Chuyên khoa Ung Bướu tại Đại học Y Dược TP.HCM.', 1),

(N'Huỳnh Phúc Tấn', 
N'Trưởng Khoa Cấp cứu', 
N'Ung Bướu', 
N'nguyenminhhoang.jpg', 
N'Tận tâm với bệnh nhân, luôn luôn cập nhật kiến thức mới trong điều trị ung thư.', 
N'2010 - nay: Trưởng Khoa Cấp cứu tại Bệnh viện Đa khoa ABC. 2008 - 2010: Bác sĩ điều trị tại Khoa Ung Bướu Bệnh viện XYZ.', 
N'2002 - 2008: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Hà Nội. 2009: Chuyên khoa Ung Bướu tại Đại học Y Dược TP.HCM.', 1),

(N'TS BS. Phan Tôn Ngọc Vũ', 
N'Bác sĩ Gây mê hồi sức', 
N'Hô Hấp', 
N'tannha.jpg', 
N'Chuyên gia trong lĩnh vực Cấp cứu, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Cấp cứu tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2),

(N'PGS TS. Lê Thượng Vũ', 
N'Bác sĩ Hô hấp', 
N'Hô Hấp', 
N'tannha.jpg', 
N'Chuyên gia trong lĩnh vực Hô Hấp, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Hô hấp tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 2),

(N'ThS BS. Bùi Thị Hạnh Duyên', 
N'Bác sĩ Tiêu hóa', 
N'Tiêu hóa', 
N'tannha.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'BS. Lương Ngọc Thiện', 
N'Bác sĩ Tiêu hóa', 
N'Tiêu Hóa', 
N'tannha.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'ThS BS. Hồ Phúc Thuận', 
N'Bác sĩ Nội tiết', 
N'Nội tiết', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'BS. Huỳnh Phúc Tấn', 
N'Bác sĩ ', 
N'Nội tiết', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'ThS BS. Hồ Phúc Thuận', 
N'Bác sĩ Da liễu', 
N'Da liễu', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'BS. Huỳnh Phúc Tấn', 
N'Bác sĩ ', 
N'Da liễu', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'ThS BS. Lương Ngọc Thiện', 
N'Bác sĩ Huyết Học', 
N'Huyết Học', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'BS. Huỳnh Phúc Tấn', 
N'Bác sĩ ', 
N'Huyết Học', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'ThS BS. Nguyễn Minh Hoàng', 
N'Bác sĩ Viêm Gan', 
N'Viêm Gan', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'BS. Nguyễn Minh Hoàng', 
N'Bác sĩ Viêm Gan ', 
N'Viêm Gan', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'ThS BS. Nguyễn Minh Hoàng', 
N'Bác sĩ Nội Thận', 
N'Nội thận', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3),

(N'BS. Nguyễn Minh Hoàng', 
N'Bác sĩ Nội Thận ', 
N'Nội thận', 
N'tanhuynh.jpg', 
N'Chuyên gia trong lĩnh vực Nhi Khoa, luôn đặt bệnh nhân lên hàng đầu và áp dụng các phương pháp điều trị tiên tiến nhất.', 
N'2012 - nay: Bác sĩ Khoa Nhi tại Bệnh viện Đa khoa ABC. 2009 - 2012: Bác sĩ điều trị tại Khoa Cấp cứu Bệnh viện XYZ.', 
N'2003 - 2009: Tốt nghiệp Bác sĩ đa khoa tại Đại học Y Khoa Phạm Ngọc Thạch. 2010: Chuyên khoa Nội Tiết tại Đại học Y Dược TP.HCM.', 3);



-- Thêm dữ liệu mẫu vào bảng SelectSpecialty
INSERT INTO SelectSpecialties (PatientID, Specialty) VALUES 
(1, N'Hô Hấp'),
(2, N'Tiêu hóa'),
(1, N'Nội Tiết'),
(2, N'Da liễu'),
(1, N'Huyết Học'),
(2, N'Viêm Gan'),
(1, N'Nội thận'),
(2, N'Ung bướu');

-- Thêm dữ liệu mẫu vào bảng TimeSlots
INSERT INTO TimeSlots (DoctorID, Date, Time, IsAvailable) 
VALUES 
(1, '2024-10-10 00:00:00', '09:00', 1),
(1, '2024-10-10 00:00:00', '11:00', 1),
(1, '2024-10-10 00:00:00', '13:00', 1),
(1, '2024-10-10 00:00:00', '15:00', 1),
(2, '2024-10-11 00:00:00', '09:00', 1),
(2, '2024-10-11 00:00:00', '11:00', 1),
(2, '2024-10-11 00:00:00', '13:00', 1),
(2, '2024-10-11 00:00:00', '15:00', 1),
(3, '2024-10-12 00:00:00', '09:00', 1),
(3, '2024-10-12 00:00:00', '11:00', 1),
(3, '2024-10-12 00:00:00', '13:00', 1),
(3, '2024-10-12 00:00:00', '15:00', 1),
(4, '2024-10-13 00:00:00', '09:00', 1),
(4, '2024-10-13 00:00:00', '11:00', 1),
(4, '2024-10-13 00:00:00', '13:00', 1),
(4, '2024-10-13 00:00:00', '15:00', 1),
(5, '2024-10-14 00:00:00', '09:00', 1),
(5, '2024-10-14 00:00:00', '11:00', 1),
(5, '2024-10-14 00:00:00', '13:00', 1),
(5, '2024-10-14 00:00:00', '15:00', 1);

-- Thêm dữ liệu mẫu vào bảng Appointments
INSERT INTO Appointments (PatientID, DoctorID, TimeSlotID, Fee, Notes) 
VALUES 
(1, 1, 1, 100.00, N'Đã đặt khám'),
(2, 2, 2, 150.00, N'Đã đặt khám');

-- Thêm dữ liệu mẫu vào bảng MedicalRecords
INSERT INTO MedicalRecords (PatientID, DoctorID, MedicalDate, Diagnosis, Treatment, Notes) VALUES 
(1, 1, '2024-08-01', N'Tăng huyết áp', N'Thuốc', N'Bệnh nhân cần theo dõi huyết áp hàng ngày'),
(2, 2, '2024-08-02', N'Tiêu hóa không tốt', N'Thuốc - Ăn chín', N'Bệnh nhân cần theo dõi 2 tuần');

-- Thêm dữ liệu mẫu vào bảng Medications
INSERT INTO Medications (MedicationName,MedicationImage,FeeMedication, StatusMedication, DescriptionMedications, Dosage) VALUES 
('Aspirin','aspirin.jpg','100000',N'Còn hàng', N'Giảm đau', '500mg'),
('Metformin','metformin.jfif','150000',N'Còn hàng', N'Kiểm soát đường huyết', '1000mg'),
('Paradol','paradol.jpg','50000',N'Còn hàng', N'Sốt,Giảm đau', '200mg'),
('Acetaminophen','acetaminophen.jpg','250000',N'Còn hàng', N'Giảm đau', '1000mg'),
('Floctafenin','floctafenin.jpg','100000',N'Đã hết hàng', N'Giảm đau', '500mg'),
('Nefopam','nefopam.jpg','150000',N'Đã hết hàng', N'Kiểm soát đường huyết', '3000mg'),
('Paracetamol','paracetamol.jpg ','250000',N'Còn hàng', N'Giảm đau', '1000mg'),
('Codein','Codein.jpg','100000',N'Đã hết hàng', N'Giảm đau', '500mg');

-- Thêm dữ liệu mẫu vào bảng Prescriptions
INSERT INTO Prescriptions (PatientID, DoctorID, MedicationID, DateBill, Dosage, Instructions) VALUES 
(1, 1, 1, '2024-08-01', '500mg', N'Uống 1 viên 2 lần mỗi ngày sau bữa ăn'),
(2, 2, 2, '2024-08-02', '1000mg', N'Uống 1 viên mỗi ngày cùng với bữa sáng');

-- Thêm dữ liệu mẫu vào bảng Billing
INSERT INTO Billing (PatientID, DateBill, Amount, Notes) VALUES 
(1, '2024-08-01', 100.00, N'Đã thanh toán'),
(2, '2024-08-02', 150.00, N'Chưa thanh toán');

-- Thêm dữ liệu mẫu vào bảng Staff
INSERT INTO Staff (FirstName, LastName, Position, DepartmentID, Phone, Email) VALUES 
(N'Vũ',N'Nguyễn', N'Y Tá', 1, '3344556677', 'nguyenvu@gmail.com'),
(N'Bảo', N'Hồ', N'Kỹ Thuật Viên', 2, '4455667788', 'hobao@gmail.com');

-- Thêm dữ liệu mẫu vào bảng Equipment
INSERT INTO Equipment (EquipmentName, DepartmentID, Notes, LastMaintenanceDate) VALUES 
(N'Máy Điện Tâm', 1, N'Hoạt động tốt', '2024-07-01'),
(N'Máy Chụp MRI', 2, N'Hoạt động tốt', '2024-06-15');

-- Thêm dữ liệu mẫu vào bảng Rooms
INSERT INTO Rooms (RoomNumber, DepartmentID, RoomType, Notes) VALUES 
('101', 1, N'Tư Vấn', N'Còn trống'),
('202', 2, N'Khám Bệnh', N'Đang sử dụng');
