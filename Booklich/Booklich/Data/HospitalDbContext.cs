using System;
using System.Collections.Generic;
using Booklich.Models;
using Microsoft.EntityFrameworkCore;

namespace Booklich.Data;

public partial class HospitalDbContext : DbContext
{
    public HospitalDbContext()
    {
    }

    public HospitalDbContext(DbContextOptions<HospitalDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<Appointment> Appointments { get; set; }

    public virtual DbSet<Billing> Billings { get; set; }

    public virtual DbSet<Department> Departments { get; set; }

    public virtual DbSet<Doctor> Doctors { get; set; }

    public virtual DbSet<DoctorSearch> DoctorSearches { get; set; }

    public virtual DbSet<Equipment> Equipment { get; set; }

    public virtual DbSet<MedicalRecord> MedicalRecords { get; set; }

    public virtual DbSet<Medication> Medications { get; set; }

    public virtual DbSet<Patient> Patients { get; set; }

    public virtual DbSet<Prescription> Prescriptions { get; set; }

    public virtual DbSet<Room> Rooms { get; set; }

    public virtual DbSet<SelectSpecialty> SelectSpecialties { get; set; }

    public virtual DbSet<Session> Sessions { get; set; }

    public virtual DbSet<Staff> Staff { get; set; }

    public virtual DbSet<TimeSlot> TimeSlots { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=HUYNH-TAN; Database=HospitalDB;Integrated Security=True; Trust Server Certificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.AccountId).HasName("PK__Account__349DA586BAF989A1");

            entity.ToTable("Account");

            entity.HasIndex(e => e.Username, "UQ__Account__536C85E40F7A46BA").IsUnique();

            entity.Property(e => e.AccountId).HasColumnName("AccountID");
            entity.Property(e => e.PasswordAccount).HasMaxLength(255);
            entity.Property(e => e.Role).HasMaxLength(50);
            entity.Property(e => e.Username).HasMaxLength(50);
        });

        modelBuilder.Entity<Appointment>(entity =>
        {
            entity.HasKey(e => e.AppointmentId).HasName("PK__Appointm__8ECDFCA244087FB1");

            entity.Property(e => e.AppointmentId).HasColumnName("AppointmentID");
            entity.Property(e => e.AppointmentDate).HasColumnType("datetime");
            entity.Property(e => e.DoctorId).HasColumnName("DoctorID");
            entity.Property(e => e.Fee).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.PatientId).HasColumnName("PatientID");
            entity.Property(e => e.TimeSlot).HasMaxLength(10);

            entity.HasOne(d => d.Doctor).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointment_Doctor");

            entity.HasOne(d => d.Patient).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointment_Patient");
        });

        modelBuilder.Entity<Billing>(entity =>
        {
            entity.HasKey(e => e.BillingId).HasName("PK__Billing__F1656D1382E248A4");

            entity.ToTable("Billing");

            entity.Property(e => e.BillingId).HasColumnName("BillingID");
            entity.Property(e => e.Amount).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Notes).HasMaxLength(255);
            entity.Property(e => e.PatientId).HasColumnName("PatientID");

            entity.HasOne(d => d.Patient).WithMany(p => p.Billings)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Billing__Patient__5DCAEF64");
        });

        modelBuilder.Entity<Department>(entity =>
        {
            entity.HasKey(e => e.DepartmentId).HasName("PK__Departme__B2079BCD78C68F9D");

            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");
            entity.Property(e => e.DepartmentName).HasMaxLength(50);
            entity.Property(e => e.LocationHospital).HasMaxLength(100);
        });

        modelBuilder.Entity<Doctor>(entity =>
        {
            entity.HasKey(e => e.DoctorId).HasName("PK__Doctors__2DC00EDF442F39B6");

            entity.Property(e => e.DoctorId).HasColumnName("DoctorID");
            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");
            entity.Property(e => e.DescriptionDoctor).HasMaxLength(2000);
            entity.Property(e => e.Education).HasMaxLength(500);
            entity.Property(e => e.Experience).HasMaxLength(2000);
            entity.Property(e => e.FullName).HasMaxLength(100);
            entity.Property(e => e.ImageUrl).HasMaxLength(255);
            entity.Property(e => e.Position).HasMaxLength(50);
            entity.Property(e => e.Specialty).HasMaxLength(50);

            entity.HasOne(d => d.Department).WithMany(p => p.Doctors)
                .HasForeignKey(d => d.DepartmentId)
                .HasConstraintName("FK__Doctors__Departm__4316F928");
        });

        modelBuilder.Entity<DoctorSearch>(entity =>
        {
            entity.HasKey(e => e.DoctorSearchId).HasName("PK__DoctorSe__1CAABC05AA761E64");

            entity.ToTable("DoctorSearch");

            entity.Property(e => e.DoctorSearchId).HasColumnName("DoctorSearchID");
            entity.Property(e => e.DoctorId).HasColumnName("DoctorID");
            entity.Property(e => e.Specialty).HasMaxLength(50);

            entity.HasOne(d => d.Doctor).WithMany(p => p.DoctorSearches)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DoctorSea__Docto__45F365D3");
        });

        modelBuilder.Entity<Equipment>(entity =>
        {
            entity.HasKey(e => e.EquipmentId).HasName("PK__Equipmen__344745990AF18A13");

            entity.Property(e => e.EquipmentId).HasColumnName("EquipmentID");
            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");
            entity.Property(e => e.EquipmentName).HasMaxLength(50);
            entity.Property(e => e.Notes).HasMaxLength(255);

            entity.HasOne(d => d.Department).WithMany(p => p.Equipment)
                .HasForeignKey(d => d.DepartmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Equipment__Depar__6383C8BA");
        });

        modelBuilder.Entity<MedicalRecord>(entity =>
        {
            entity.HasKey(e => e.RecordId).HasName("PK__MedicalR__FBDF78C937D7A044");

            entity.Property(e => e.RecordId).HasColumnName("RecordID");
            entity.Property(e => e.DoctorId).HasColumnName("DoctorID");
            entity.Property(e => e.PatientId).HasColumnName("PatientID");

            entity.HasOne(d => d.Doctor).WithMany(p => p.MedicalRecords)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__MedicalRe__Docto__5441852A");

            entity.HasOne(d => d.Patient).WithMany(p => p.MedicalRecords)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__MedicalRe__Patie__534D60F1");
        });

        modelBuilder.Entity<Medication>(entity =>
        {
            entity.HasKey(e => e.MedicationId).HasName("PK__Medicati__62EC1ADA0110E18D");

            entity.Property(e => e.MedicationId).HasColumnName("MedicationID");
            entity.Property(e => e.Dosage).HasMaxLength(50);
            entity.Property(e => e.MedicationName).HasMaxLength(50);
        });

        modelBuilder.Entity<Patient>(entity =>
        {
            entity.HasKey(e => e.PatientId).HasName("PK__Patients__970EC346C50ABFA4");

            entity.Property(e => e.PatientId).HasColumnName("PatientID");
            entity.Property(e => e.AccountId).HasColumnName("AccountID");
            entity.Property(e => e.AddressPatients).HasMaxLength(255);
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.Gender).HasMaxLength(10);
            entity.Property(e => e.LastName).HasMaxLength(50);
            entity.Property(e => e.Phone).HasMaxLength(15);

            entity.HasOne(d => d.Account).WithMany(p => p.Patients)
                .HasForeignKey(d => d.AccountId)
                .HasConstraintName("FK__Patients__Accoun__3A81B327");
        });

        modelBuilder.Entity<Prescription>(entity =>
        {
            entity.HasKey(e => e.PrescriptionId).HasName("PK__Prescrip__40130812F4484EC6");

            entity.Property(e => e.PrescriptionId).HasColumnName("PrescriptionID");
            entity.Property(e => e.DoctorId).HasColumnName("DoctorID");
            entity.Property(e => e.Dosage).HasMaxLength(50);
            entity.Property(e => e.MedicationId).HasColumnName("MedicationID");
            entity.Property(e => e.PatientId).HasColumnName("PatientID");

            entity.HasOne(d => d.Doctor).WithMany(p => p.Prescriptions)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Prescript__Docto__59FA5E80");

            entity.HasOne(d => d.Medication).WithMany(p => p.Prescriptions)
                .HasForeignKey(d => d.MedicationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Prescript__Medic__5AEE82B9");

            entity.HasOne(d => d.Patient).WithMany(p => p.Prescriptions)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Prescript__Patie__59063A47");
        });

        modelBuilder.Entity<Room>(entity =>
        {
            entity.HasKey(e => e.RoomId).HasName("PK__Rooms__32863919498725AF");

            entity.Property(e => e.RoomId).HasColumnName("RoomID");
            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");
            entity.Property(e => e.Notes).HasMaxLength(255);
            entity.Property(e => e.RoomNumber).HasMaxLength(10);
            entity.Property(e => e.RoomType).HasMaxLength(50);

            entity.HasOne(d => d.Department).WithMany(p => p.Rooms)
                .HasForeignKey(d => d.DepartmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Rooms__Departmen__66603565");
        });

        modelBuilder.Entity<SelectSpecialty>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SelectSp__3214EC07E57E86C7");

            entity.ToTable("SelectSpecialty");

            entity.Property(e => e.PatientId).HasColumnName("PatientID");
            entity.Property(e => e.Specialty).HasMaxLength(100);

            entity.HasOne(d => d.Patient).WithMany(p => p.SelectSpecialties)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SelectSpe__Patie__48CFD27E");
        });

        modelBuilder.Entity<Session>(entity =>
        {
            entity.HasKey(e => e.SessionId).HasName("PK__Sessions__C9F492709FDBE442");

            entity.Property(e => e.SessionId).HasColumnName("SessionID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.PatientId).HasColumnName("PatientID");
            entity.Property(e => e.SessionToken).HasMaxLength(255);

            entity.HasOne(d => d.Patient).WithMany(p => p.Sessions)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Sessions__Patien__3E52440B");
        });

        modelBuilder.Entity<Staff>(entity =>
        {
            entity.HasKey(e => e.StaffId).HasName("PK__Staff__96D4AAF784E7036D");

            entity.Property(e => e.StaffId).HasColumnName("StaffID");
            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.LastName).HasMaxLength(50);
            entity.Property(e => e.Phone).HasMaxLength(15);
            entity.Property(e => e.Position).HasMaxLength(50);

            entity.HasOne(d => d.Department).WithMany(p => p.Staff)
                .HasForeignKey(d => d.DepartmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Staff__Departmen__60A75C0F");
        });

        modelBuilder.Entity<TimeSlot>(entity =>
        {
            entity.HasKey(e => e.TimeSlotId).HasName("PK__TimeSlot__41CC1F520745F867");

            entity.Property(e => e.TimeSlotId).HasColumnName("TimeSlotID");
            entity.Property(e => e.Date).HasColumnType("datetime");
            entity.Property(e => e.DoctorId).HasColumnName("DoctorID");
            entity.Property(e => e.IsAvailable).HasDefaultValue(true);
            entity.Property(e => e.Time).HasMaxLength(10);

            entity.HasOne(d => d.Doctor).WithMany(p => p.TimeSlots)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TimeSlot_Doctor");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
