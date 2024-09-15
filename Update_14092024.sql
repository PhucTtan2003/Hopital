-- Tạo cơ sở dữ liệu nếu chưa có
CREATE DATABASE HospitalDB;
GO
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
    CreatedAt DATETIME DEFAULT GETDATE(), -- Thêm cột CreatedAt để lưu ngày tạo hồ sơ
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
(2, 'Tan', 'Phuc', '1990-06-15', 'Male', N'456 Tran Phu', '0987654321', 'tanphuc@gmail.com'),
(1, 'Ngoc', 'Tran', '1988-03-12', 'Female', N'789 Nguyen Trai', '0912345678', 'ngoctran@gmail.com'),
(2, 'Minh', 'Le', '1985-08-22', 'Male', N'12 Nguyen Hue', '0934567890', 'minhle@gmail.com'),
(1, 'Ha', 'Nguyen', '1992-04-17', 'Female', N'234 Hai Ba Trung', '0976543210', 'hanguyen@gmail.com'),
(2, 'Khoa', 'Phan', '1989-02-05', 'Male', N'567 Le Loi', '0954321789', 'khoaphan@gmail.com'),
(1, 'Lan', 'Do', '1991-11-25', 'Female', N'890 Vo Thi Sau', '0923456789', 'lando@gmail.com'),
(2, 'Quang', 'Pham', '1987-07-30', 'Male', N'345 Ly Thuong Kiet', '0987651234', 'quangpham@gmail.com'),
(1, 'Thu', 'Vo', '1993-09-12', 'Female', N'678 Phan Dang Luu', '0912987654', 'thuvo@gmail.com'),
(2, 'Hieu', 'Nguyen', '1986-05-15', 'Male', N'123 Nguyen Dinh Chieu', '0998765432', 'hieunguyen@gmail.com'),
(1, 'Bich', 'Ho', '1994-10-22', 'Female', N'567 Ton Duc Thang', '0971234567', 'bichho@gmail.com'),
(2, 'Tuan', 'Le', '1989-12-01', 'Male', N'456 Xuan Thuy', '0945678901', 'tuanle@gmail.com'),
(1, 'Hong', 'Phan', '1987-01-23', 'Female', N'890 Bach Dang', '0934561234', 'hongphan@gmail.com'),
(2, 'Thanh', 'Nguyen', '1990-08-05', 'Male', N'234 Hoang Hoa Tham', '0912349876', 'thanhnguyen@gmail.com'),
(2, 'Dung', 'Tran', '1992-09-17', 'Male', N'567 Nguyen Thi Minh Khai', '0923458765', 'dungtran@gmail.com'),
(1, 'Mai', 'Vo', '1993-03-11', 'Female', N'890 Cach Mang Thang Tam', '0954321678', 'maivo@gmail.com'),
(2, 'Hung', 'Do', '1985-11-25', 'Male', N'123 Le Duan', '0934567891', 'hungdo@gmail.com'),
(1, 'Anh', 'Nguyen', '1994-06-19', 'Female', N'456 Hoang Dieu', '0987654322', 'anhnguyen@gmail.com'),
(2, 'Son', 'Phan', '1986-02-15', 'Male', N'789 Tran Hung Dao', '0919876543', 'sonphan@gmail.com'),
(2, 'Ly', 'Ho', '1991-07-07', 'Female', N'567 Bui Thi Xuan', '0923987654', 'lyho@gmail.com'),
(1, 'Dat', 'Le', '1988-04-12', 'Male', N'890 Nguyen Van Cu', '0931234567', 'datle@gmail.com'),
(2, 'Huyen', 'Pham', '1990-10-20', 'Female', N'123 Dinh Tien Hoang', '0945671234', 'huyenpham@gmail.com'),
(1, 'Viet', 'Tran', '1985-12-22', 'Male', N'456 Le Loi', '0981234567', 'viettran@gmail.com'),
(2, 'Linh', 'Nguyen', '1993-01-11', 'Female', N'789 Hai Ba Trung', '0917654321', 'linhnguyen@gmail.com'),
(1, 'Thanh', 'Vo', '1990-05-14', 'Male', N'123 Le Van Sy', '0928765432', 'thanhvo@gmail.com'),
(2, 'Hoa', 'Do', '1987-08-09', 'Female', N'567 Pham Ngoc Thach', '0941234567', 'hoado@gmail.com'),
(1, 'An', 'Le', '1989-11-30', 'Male', N'890 Xo Viet Nghe Tinh', '0938765432', 'anle@gmail.com'),
(2, 'Yen', 'Pham', '1992-03-19', 'Female', N'123 Dong Khoi', '0951234567', 'yenpham@gmail.com'),
(1, 'Hai', 'Tran', '1991-06-05', 'Male', N'456 Tran Quoc Toan', '0912348765', 'haitran@gmail.com'),
(2, 'Minh', 'Nguyen', '1986-09-25', 'Female', N'789 Dien Bien Phu', '0976543210', 'minhnguyen@gmail.com'),
(1, 'Quoc', 'Vo', '1985-12-01', 'Male', N'123 Ton Duc Thang', '0923456789', 'quocvo@gmail.com'),
(2, 'Trang', 'Do', '1990-03-17', 'Female', N'456 Vo Van Tan', '0987654321', 'trangdo@gmail.com'),
(1, 'Vinh', 'Le', '1988-08-22', 'Male', N'789 Cong Hoa', '0934567890', 'vinhle@gmail.com'),
(2, 'Kim', 'Phan', '1994-04-11', 'Female', N'123 Tran Phu', '0912345678', 'kimphan@gmail.com'),
(1, 'Hoang', 'Nguyen', '1992-07-28', 'Male', N'456 Pham Van Dong', '0978765432', 'hoangnguyen@gmail.com'),
(2, 'Thao', 'Tran', '1991-09-17', 'Female', N'789 Le Trong Tan', '0923456789', 'thaotran@gmail.com'),
(1, 'Tu', 'Vo', '1993-12-03', 'Male', N'123 Cach Mang Thang Tam', '0941234567', 'tuvo@gmail.com'),
(2, 'Diep', 'Le', '1989-04-19', 'Female', N'456 Le Van Luong', '0976543210', 'dieple@gmail.com'),
(1, 'Thanh', 'Do', '1990-08-15', 'Male', N'789 Nguyen Tat Thanh', '0954321678', 'thanhdo@gmail.com'),
(2, 'Hien', 'Nguyen', '1992-02-21', 'Female', N'123 Xuan Thuy', '0931234567', 'hiennguyen@gmail.com'),
(1, 'Tuan', 'Pham', '1987-09-09', 'Male', N'456 Hoang Van Thu', '0929876543', 'tuanpham@gmail.com'),
(2, 'Lan', 'Vo', '1994-10-11', 'Female', N'789 Le Hong Phong', '0987651234', 'lanvo@gmail.com'),
(1, 'Cuong', 'Nguyen', '1986-01-25', 'Male', N'123 Nguyen Tri Phuong', '0918765432', 'cuongnguyen@gmail.com'),
(2, 'Truc', 'Tran', '1991-03-17', 'Female', N'456 Vo Thi Sau', '0959876543', 'tructran@gmail.com'),
(1, 'Loi', 'Le', '1988-05-19', 'Male', N'789 Cach Mang Thang Tam', '0948765432', 'loile@gmail.com'),
(2, 'Phu', 'Pham', '1990-09-22', 'Male', N'123 Xo Viet Nghe Tinh', '0912345678', 'phupham@gmail.com'),
(1, 'Nga', 'Nguyen', '1987-12-30', 'Female', N'456 Le Duan', '0934567891', 'nganguyen@gmail.com'),
(2, 'Nhat', 'Tran', '1992-07-05', 'Male', N'789 Nguyen Trai', '0981234567', 'nhattran@gmail.com'),
(1, 'Nguyen', 'Le', '1985-01-25', 'Female', N'123 Dien Bien Phu', '0978765432', 'nguyenle@gmail.com'),
(2, 'Tien', 'Pham', '1986-06-12', 'Male', N'456 Tran Phu', '0923456789', 'tienpham@gmail.com'),
(1, 'Hoang', 'Le', '1989-02-14', 'Male', N'789 Nguyen Hue', '0912345678', 'hoangle@gmail.com'),
(2, 'Thu', 'Tran', '1991-11-12', 'Female', N'456 Le Loi', '0987654321', 'thutran@gmail.com'),
(1, 'Khang', 'Nguyen', '1987-09-09', 'Male', N'123 Hai Ba Trung', '0934567890', 'khangnguyen@gmail.com'),
(2, 'Hanh', 'Do', '1992-06-18', 'Female', N'789 Bui Thi Xuan', '0912345678', 'hanhdo@gmail.com'),
(1, 'Bao', 'Phan', '1985-10-25', 'Male', N'456 Vo Thi Sau', '0987654321', 'baophan@gmail.com'),
(2, 'Ngoc', 'Le', '1990-03-07', 'Female', N'123 Xuan Thuy', '0934567890', 'ngocle@gmail.com'),
(1, 'Duc', 'Nguyen', '1988-05-20', 'Male', N'789 Nguyen Van Cu', '0912345678', 'ducnguyen@gmail.com'),
(2, 'My', 'Tran', '1993-12-01', 'Female', N'456 Le Van Luong', '0987654321', 'mytran@gmail.com'),
(1, 'Tan', 'Pham', '1986-01-19', 'Male', N'123 Nguyen Dinh Chieu', '0934567890', 'tanpham@gmail.com'),
(2, 'Lan', 'Nguyen', '1994-08-23', 'Female', N'789 Pham Van Dong', '0912345678', 'lannguyen@gmail.com'),
(1, 'Dat', 'Vo', '1985-11-10', 'Male', N'456 Le Hong Phong', '0987654321', 'datvo@gmail.com'),
(2, 'Huong', 'Le', '1992-09-09', 'Female', N'123 Cach Mang Thang Tam', '0934567890', 'huongle@gmail.com'),
(1, 'Minh', 'Nguyen', '1990-07-17', 'Male', N'789 Vo Van Tan', '0912345678', 'minhnguyen2@gmail.com'),
(2, 'Trang', 'Pham', '1987-03-27', 'Female', N'456 Ton Duc Thang', '0987654321', 'trangpham@gmail.com'),
(1, 'Hieu', 'Le', '1991-04-21', 'Male', N'123 Hoang Van Thu', '0934567890', 'hieule@gmail.com'),
(2, 'Tuan', 'Tran', '1993-06-06', 'Male', N'789 Dien Bien Phu', '0912345678', 'tuantran@gmail.com'),
(1, 'Thao', 'Nguyen', '1988-10-31', 'Female', N'456 Le Duan', '0987654321', 'thaonguyen@gmail.com'),
(2, 'Anh', 'Vo', '1992-01-13', 'Male', N'123 Tran Hung Dao', '0934567890', 'anhvo@gmail.com'),
(1, 'Hoa', 'Pham', '1989-05-25', 'Female', N'789 Nguyen Tat Thanh', '0912345678', 'hoapham@gmail.com'),
(2, 'Phuc', 'Nguyen', '1990-11-22', 'Male', N'456 Le Van Sy', '0987654321', 'phucnguyen@gmail.com'),
(1, 'Dieu', 'Tran', '1987-02-05', 'Female', N'123 Pham Ngoc Thach', '0934567890', 'dieutran@gmail.com'),
(2, 'Nam', 'Le', '1991-03-19', 'Male', N'789 Le Trong Tan', '0912345678', 'namle@gmail.com'),
(1, 'Vy', 'Pham', '1994-08-03', 'Female', N'456 Bui Thi Xuan', '0987654321', 'vypham@gmail.com'),
(2, 'An', 'Nguyen', '1986-06-25', 'Male', N'123 Ly Thuong Kiet', '0934567890', 'annguyen@gmail.com'),
(1, 'Son', 'Le', '1990-09-14', 'Male', N'789 Nguyen Dinh Chieu', '0912345678', 'sonle@gmail.com'),
(2, 'Trang', 'Tran', '1988-05-16', 'Female', N'456 Hai Ba Trung', '0987654321', 'trangtran@gmail.com'),
(1, 'Hien', 'Nguyen', '1992-12-02', 'Male', N'123 Nguyen Van Troi', '0934567890', 'hiennguyen@gmail.com'),
(2, 'Linh', 'Pham', '1994-04-27', 'Female', N'789 Xuan Thuy', '0912345678', 'linhpham@gmail.com'),
(1, 'Hung', 'Le', '1985-11-19', 'Male', N'456 Tran Phu', '0987654321', 'hungle@gmail.com'),
(2, 'Tam', 'Nguyen', '1991-07-12', 'Female', N'123 Le Duan', '0934567890', 'tamnguyen@gmail.com'),
(1, 'Quang', 'Tran', '1990-08-30', 'Male', N'789 Nguyen Hue', '0912345678', 'quangtran@gmail.com'),
(2, 'Lan', 'Le', '1987-10-18', 'Female', N'456 Nguyen Trai', '0987654321', 'lanle@gmail.com'),
(1, 'Vu', 'Pham', '1986-03-07', 'Male', N'123 Hai Ba Trung', '0934567890', 'vupham@gmail.com'),
(2, 'My', 'Nguyen', '1993-01-29', 'Female', N'789 Cach Mang Thang Tam', '0912345678', 'mynguyen@gmail.com'),
(1, 'Tuyen', 'Le', '1989-12-25', 'Female', N'456 Pham Van Dong', '0987654321', 'tuyenle@gmail.com'),
(2, 'Kiet', 'Nguyen', '1990-05-11', 'Male', N'123 Vo Van Tan', '0934567890', 'kietnguyen@gmail.com'),
(1, 'Anh', 'Tran', '1991-09-22', 'Female', N'789 Ton Duc Thang', '0912345678', 'anhtran@gmail.com'),
(2, 'Tan', 'Pham', '1985-04-13', 'Male', N'456 Le Van Luong', '0987654321', 'tanpham2@gmail.com'),
(1, 'Thu', 'Le', '1992-06-19', 'Female', N'123 Nguyen Trai', '0934567890', 'thule@gmail.com'),
(2, 'Thinh', 'Nguyen', '1991-08-25', 'Male', N'789 Le Trong Tan', '0912345678', 'thinhnguyen@gmail.com'),
(1, 'Tuan', 'Pham', '1993-03-03', 'Male', N'456 Cach Mang Thang Tam', '0987654321', 'tuanpham@gmail.com'),
(2, 'Mai', 'Le', '1994-07-15', 'Female', N'123 Vo Thi Sau', '0934567890', 'maile@gmail.com');




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
(N'Thái', N'Phạm', N'Y Tá', 1, '01112223334', 'phamthai@gmail.com'),
(N'Hồng', N'Nguyễn', N'Dược Sĩ', 2, '02223334445', 'nguyenhong@gmail.com'),
(N'Diệu', N'Võ', N'Kỹ Thuật Viên', 3, '03334445556', 'vodieutk@gmail.com'),
(N'Khánh', N'Lê', N'Bác Sĩ', 1, '04445556667', 'lekhanhbs@gmail.com'),
(N'Thịnh', N'Trần', N'Y Tá', 2, '05556667778', 'tranthinhyt@gmail.com'),
(N'Hòa', N'Hoàng', N'Dược Sĩ', 3, '06667778889', 'hoanghoa@gmail.com'),
(N'Tuyên', N'Phan', N'Kỹ Thuật Viên', 1, '07778889990', 'phantuyenktv@gmail.com'),
(N'Trinh', N'Tạ', N'Bác Sĩ', 2, '08889990011', 'tatrinhbs@gmail.com'),
(N'Kiên', N'Vũ', N'Dược Sĩ', 3, '09990001122', 'vukien@gmail.com'),
(N'Tú', N'Nguyễn', N'Y Tá', 1, '10001112223', 'nguyentu@gmail.com'),
(N'Phúc', N'Lê', N'Y Tá', 1, '11112223334', 'lephuc@gmail.com'),
(N'Minh', N'Trần', N'Dược Sĩ', 2, '12223334445', 'tranminh@gmail.com'),
(N'Trường', N'Phan', N'Kỹ Thuật Viên', 3, '13334445556', 'phantruong@gmail.com'),
(N'Hiếu', N'Võ', N'Bác Sĩ', 1, '14445556667', 'vohieu@gmail.com'),
(N'Hoàng', N'Nguyễn', N'Y Tá', 2, '15556667778', 'nguyenhoang@gmail.com'),
(N'Quân', N'Đỗ', N'Dược Sĩ', 3, '16667778889', 'doquan@gmail.com'),
(N'Thảo', N'Vương', N'Kỹ Thuật Viên', 1, '17778889990', 'vuongthao@gmail.com'),
(N'Lan', N'Hoàng', N'Bác Sĩ', 2, '18889990011', 'hoanglan@gmail.com'),
(N'Duy', N'Phạm', N'Dược Sĩ', 3, '19990001122', 'phamduy@gmail.com'),
(N'Bích', N'Vũ', N'Y Tá', 1, '20001112233', 'vubich@gmail.com'),
(N'Long', N'Phạm', N'Y Tá', 1, '21112223334', 'phamtlong@gmail.com'),
(N'Giang', N'Nguyễn', N'Dược Sĩ', 2, '22223334445', 'nguyengiang@gmail.com'),
(N'Thủy', N'Lê', N'Kỹ Thuật Viên', 3, '23334445556', 'lethuytk@gmail.com'),
(N'Tiến', N'Võ', N'Bác Sĩ', 1, '24445556667', 'votienbs@gmail.com'),
(N'Nam', N'Hoàng', N'Y Tá', 2, '25556667778', 'hoangnamyt@gmail.com'),
(N'Quỳnh', N'Trần', N'Dược Sĩ', 3, '26667778889', 'tranquynh@gmail.com'),
(N'Diệp', N'Phan', N'Kỹ Thuật Viên', 1, '27778889990', 'phandieptk@gmail.com'),
(N'Thúy', N'Nguyễn', N'Bác Sĩ', 2, '28889990011', 'nguyenthuybs@gmail.com'),
(N'Huy', N'Tạ', N'Dược Sĩ', 3, '29990001122', 'tahuy@gmail.com'),
(N'Phượng', N'Vũ', N'Y Tá', 1, '30001112233', 'vuphuong@gmail.com'),
(N'Doan', N'Phạm', N'Y Tá', 1, '31112223334', 'phamdoan@gmail.com'),
(N'Yến', N'Lê', N'Dược Sĩ', 2, '32223334445', 'leyen@gmail.com'),
(N'Triều', N'Trần', N'Kỹ Thuật Viên', 3, '33334445556', 'trantrieu@gmail.com'),
(N'Thanh', N'Võ', N'Bác Sĩ', 1, '34445556667', 'vothanhbs@gmail.com'),
(N'Phúc', N'Hoàng', N'Y Tá', 2, '35556667778', 'hoangphucyt@gmail.com'),
(N'Khoa', N'Trần', N'Dược Sĩ', 3, '36667778889', 'trankhoa@gmail.com'),
(N'Trung', N'Phan', N'Kỹ Thuật Viên', 1, '37778889990', 'phantrungktv@gmail.com'),
(N'Hậu', N'Nguyễn', N'Bác Sĩ', 2, '38889990011', 'nguyenhau@gmail.com'),
(N'Mai', N'Vũ', N'Y Tá', 1, '39990001122', 'vutmai@gmail.com'),
(N'Tuấn', N'Hoàng', N'Dược Sĩ', 3, '40001112233', 'hoangtuands@gmail.com'),
(N'Đức', N'Lê', N'Y Tá', 1, '41112223334', 'leducyt@gmail.com'),
(N'Lan Anh', N'Nguyễn', N'Dược Sĩ', 2, '42223334445', 'nguyenlananh@gmail.com'),
(N'Việt', N'Tạ', N'Kỹ Thuật Viên', 3, '43334445556', 'taviettk@gmail.com'),
(N'Văn', N'Phạm', N'Y Tá', 1, '44445556667', 'phamvan@gmail.com'),
(N'Thảo', N'Nguyễn', N'Dược Sĩ', 2, '45556667778', 'nguyenthao@gmail.com'),
(N'Bảo', N'Lê', N'Kỹ Thuật Viên', 3, '46667778889', 'lebao@gmail.com'),
(N'Tín', N'Võ', N'Bác Sĩ', 1, '47778889990', 'votinbs@gmail.com'),
(N'Tâm', N'Hoàng', N'Y Tá', 2, '48889990011', 'hoangtamyt@gmail.com'),
(N'Quý', N'Trần', N'Dược Sĩ', 3, '49990001122', 'tranquy@gmail.com'),
(N'Diệu', N'Phan', N'Kỹ Thuật Viên', 1, '50001112233', 'phandieu@gmail.com'),
(N'Hà', N'Nguyễn', N'Bác Sĩ', 2, '51112223334', 'nguyenha@gmail.com'),
(N'Vỹ', N'Lê', N'Dược Sĩ', 3, '52223334445', 'levy@gmail.com'),
(N'Hoàn', N'Võ', N'Y Tá', 1, '53334445556', 'vohoan@gmail.com'),
(N'Tiến', N'Hoàng', N'Dược Sĩ', 2, '54445556667', 'hoangtien@gmail.com'),
(N'Tuấn', N'Phạm', N'Kỹ Thuật Viên', 3, '55556667778', 'phamtuanktv@gmail.com'),
(N'Dương', N'Trần', N'Bác Sĩ', 1, '56667778889', 'trandương@gmail.com'),
(N'Trúc', N'Phan', N'Y Tá', 2, '57778889990', 'phantruc@gmail.com'),
(N'Tú', N'Nguyễn', N'Dược Sĩ', 3, '58889990011', 'nguyentu@gmail.com'),
(N'Vân', N'Lê', N'Kỹ Thuật Viên', 1, '59990001122', 'levan@gmail.com'),
(N'Tri', N'Hoàng', N'Y Tá', 2, '60001112233', 'hoangtri@gmail.com'),
(N'Kim', N'Phạm', N'Dược Sĩ', 3, '61112223334', 'phamkim@gmail.com'),
(N'Hùng', N'Trần', N'Kỹ Thuật Viên', 1, '62223334445', 'tranhung@gmail.com'),
(N'Thắng', N'Nguyễn', N'Bác Sĩ', 2, '63334445556', 'nguyenthăngbs@gmail.com'),
(N'Huệ', N'Lê', N'Y Tá', 3, '64445556667', 'lehuệyt@gmail.com'),
(N'Dương', N'Võ', N'Dược Sĩ', 1, '65556667778', 'voduongds@gmail.com'),
(N'Tuyền', N'Phạm', N'Kỹ Thuật Viên', 2, '66667778889', 'phamduyen@gmail.com'),
(N'Giang', N'Trần', N'Bác Sĩ', 3, '67778889990', 'trangiang@gmail.com'),
(N'Trúc', N'Nguyễn', N'Y Tá', 1, '68889990011', 'nguyentruc@gmail.com'),
(N'Tú', N'Lê', N'Dược Sĩ', 2, '69990001122', 'letu@gmail.com'),
(N'Vân', N'Phạm', N'Kỹ Thuật Viên', 3, '70001112233', 'phamvan@gmail.com'),
(N'Tri', N'Hoàng', N'Y Tá', 1, '71112223334', 'hoangtri@gmail.com'),
(N'Kim', N'Trần', N'Dược Sĩ', 2, '72223334445', 'trankim@gmail.com'),
(N'Hùng', N'Nguyễn', N'Kỹ Thuật Viên', 3, '73334445556', 'nguyenhung@gmail.com'),
(N'Thắng', N'Lê', N'Bác Sĩ', 1, '74445556667', 'lethangbs@gmail.com'),
(N'Huệ', N'Phan', N'Y Tá', 2, '75556667778', 'phanhueyt@gmail.com'),
(N'Dương', N'Võ', N'Dược Sĩ', 3, '76667778889', 'voduongds@gmail.com'),
(N'Tuyền', N'Hoàng', N'Kỹ Thuật Viên', 1, '77778889990', 'hoangtuyen@gmail.com'),
(N'Giang', N'Phạm', N'Bác Sĩ', 2, '78889990011', 'phamgiangbs@gmail.com'),
(N'Trúc', N'Lê', N'Y Tá', 3, '79990001122', 'letruc@gmail.com'),
(N'Tú', N'Trần', N'Dược Sĩ', 1, '80001112233', 'trantu@gmail.com'),
(N'Vân', N'Nguyễn', N'Kỹ Thuật Viên', 2, '81112223334', 'nguyenvan@gmail.com'),
(N'Tri', N'Phan', N'Y Tá', 3, '82223334445', 'phantri@gmail.com'),
(N'Kim', N'Hoàng', N'Dược Sĩ', 1, '83334445556', 'hoangkim@gmail.com'),
(N'Hùng', N'Lê', N'Kỹ Thuật Viên', 2, '84445556667', 'lehung@gmail.com'),
(N'Thắng', N'Nguyễn', N'Bác Sĩ', 3, '85556667778', 'nguyenthangbs@gmail.com'),
(N'Huệ', N'Trần', N'Y Tá', 1, '86667778889', 'tranhueyt@gmail.com'),
(N'Dương', N'Phan', N'Dược Sĩ', 2, '87778889990', 'phanduongds@gmail.com'),
(N'Tuyền', N'Võ', N'Kỹ Thuật Viên', 3, '88889990011', 'votuyenktv@gmail.com'),
(N'Khôi', N'Phạm', N'Y Tá', 1, '89990001122', 'phamkhoi@gmail.com'),
(N'Ngọc', N'Nguyễn', N'Dược Sĩ', 2, '90001112233', 'nguyenngoc@gmail.com'),
(N'Hạnh', N'Lê', N'Kỹ Thuật Viên', 3, '91112223334', 'lehanh@gmail.com'),
(N'Vũ', N'Võ', N'Bác Sĩ', 1, '92223334445', 'vovu@gmail.com'),
(N'Tài', N'Hoàng', N'Y Tá', 2, '93334445556', 'hoangtai@gmail.com'),
(N'Tùng', N'Trần', N'Dược Sĩ', 3, '94445556667', 'trantung@gmail.com'),
(N'Thúy', N'Phan', N'Kỹ Thuật Viên', 1, '95556667778', 'phanthuy@gmail.com'),
(N'Hương', N'Nguyễn', N'Bác Sĩ', 2, '96667778889', 'nguyenhuong@gmail.com'),
(N'Phong', N'Lê', N'Dược Sĩ', 3, '97778889990', 'lephong@gmail.com'),
(N'Tâm', N'Vũ', N'Y Tá', 1, '98889990011', 'vutam@gmail.com'),
(N'Uyên', N'Hoàng', N'Y Tá', 2, '99990001122', 'hoanguyen@gmail.com'),
(N'Triều', N'Trần', N'Dược Sĩ', 3, '100001112233', 'trantrieubacsy@gmail.com'),
(N'Bình', N'Phạm', N'Y Tá', 1, '10011223334', 'phambinh@gmail.com'),
(N'Đạt', N'Nguyễn', N'Dược Sĩ', 2, '10122334445', 'nguyendat@gmail.com'),
(N'An', N'Lê', N'Kỹ Thuật Viên', 3, '10233445556', 'lean@gmail.com'),
(N'Hậu', N'Võ', N'Bác Sĩ', 1, '10344556667', 'vohau@gmail.com'),
(N'Liên', N'Hoàng', N'Y Tá', 2, '10455667778', 'hoanglien@gmail.com'),
(N'Nhung', N'Trần', N'Dược Sĩ', 3, '10566778889', 'trannhung@gmail.com'),
(N'Vinh', N'Phan', N'Kỹ Thuật Viên', 1, '10677889990', 'phanvinh@gmail.com'),
(N'Giáp', N'Nguyễn', N'Bác Sĩ', 2, '10788990011', 'nguyengiapbs@gmail.com'),
(N'Trung', N'Lê', N'Y Tá', 3, '10899001122', 'letrungyt@gmail.com'),
(N'Tân', N'Vũ', N'Dược Sĩ', 1, '10900112233', 'vutan@gmail.com'),
(N'Ngân', N'Hoàng', N'Kỹ Thuật Viên', 2, '11011223344', 'hoangngan@gmail.com'),
(N'Vượng', N'Trần', N'Bác Sĩ', 3, '11122334455', 'tranvuongbs@gmail.com'),
(N'Kiều', N'Phạm', N'Y Tá', 1, '11233445566', 'phamkieu@gmail.com'),
(N'Thành', N'Nguyễn', N'Dược Sĩ', 2, '11344556677', 'nguyenthanh@gmail.com'),
(N'Tâm', N'Lê', N'Kỹ Thuật Viên', 3, '11455667788', 'letamktv@gmail.com'),
(N'Hiệp', N'Võ', N'Bác Sĩ', 1, '11566778899', 'vohiep@gmail.com'),
(N'Linh', N'Hoàng', N'Y Tá', 2, '11677889900', 'hoanglinh@gmail.com'),
(N'Hậu', N'Trần', N'Dược Sĩ', 3, '11788990011', 'tranhau@gmail.com'),
(N'Hạnh', N'Phan', N'Kỹ Thuật Viên', 1, '11899001122', 'phanhanh@gmail.com'),
(N'Trinh', N'Nguyễn', N'Bác Sĩ', 2, '11900112233', 'nguyentrinh@gmail.com'),
(N'Thúy', N'Lê', N'Y Tá', 3, '12011223344', 'lethuy@gmail.com'),
(N'Phương', N'Võ', N'Dược Sĩ', 1, '12122334455', 'vophuong@gmail.com'),
(N'Phúc', N'Hoàng', N'Kỹ Thuật Viên', 2, '12233445566', 'hoangphuc@gmail.com'),
(N'Tiến', N'Trần', N'Bác Sĩ', 3, '12344556677', 'trantienbs@gmail.com'),
(N'Hoàng', N'Phạm', N'Y Tá', 1, '12455667788', 'phamhoang@gmail.com'),
(N'Quân', N'Nguyễn', N'Dược Sĩ', 2, '12566778899', 'nguyenquan@gmail.com'),
(N'Bảo', N'Lê', N'Kỹ Thuật Viên', 3, '12677889900', 'lebảo@gmail.com'),
(N'Triều', N'Võ', N'Bác Sĩ', 1, '12788990011', 'votrieubacsy@gmail.com'),
(N'An', N'Hoàng', N'Y Tá', 2, '12899001122', 'hoangan@gmail.com'),
(N'Thảo', N'Trần', N'Dược Sĩ', 3, '12900112233', 'tranthao@gmail.com'),
(N'Tuấn', N'Phan', N'Kỹ Thuật Viên', 1, '13011223344', 'phantuan@gmail.com'),
(N'Vỹ', N'Nguyễn', N'Bác Sĩ', 2, '13122334455', 'nguyenvy@gmail.com'),
(N'Tú', N'Lê', N'Y Tá', 3, '13233445566', 'letu@gmail.com');



-- Thêm dữ liệu mẫu vào bảng Equipment
INSERT INTO Equipment (EquipmentName, DepartmentID, Notes, LastMaintenanceDate) VALUES 
(N'Máy Điện Tâm', 1, N'Hoạt động tốt', '2024-07-01'),
(N'Máy Chụp MRI', 2, N'Hoạt động tốt', '2024-06-15');

-- Thêm dữ liệu mẫu vào bảng Rooms
INSERT INTO Rooms (RoomNumber, DepartmentID, RoomType, Notes) VALUES 
('101', 1, N'Tư Vấn', N'Còn trống'),
('202', 2, N'Khám Bệnh', N'Đang sử dụng');