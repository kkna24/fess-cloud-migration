-- Create the database
CREATE DATABASE critical_event_db;
GO

-- Use the new database
USE critical_event_db;
GO

-- Create the AspNetRoles table
CREATE TABLE dbo.AspNetRoles (
    Id NVARCHAR(450) NOT NULL PRIMARY KEY,
    Name NVARCHAR(256) NULL,
    NormalizedName NVARCHAR(256) NULL,
    ConcurrencyStamp NVARCHAR(MAX) NULL
);
GO

-- Create the AspNetUsers table
CREATE TABLE dbo.AspNetUsers (
    Id NVARCHAR(450) NOT NULL PRIMARY KEY,
    UserName NVARCHAR(256) NULL,
    NormalizedUserName NVARCHAR(256) NULL,
    Email NVARCHAR(256) NULL,
    NormalizedEmail NVARCHAR(256) NULL,
    EmailConfirmed BIT NOT NULL,
    PasswordHash NVARCHAR(MAX) NULL,
    SecurityStamp NVARCHAR(MAX) NULL,
    ConcurrencyStamp NVARCHAR(MAX) NULL,
    PhoneNumber NVARCHAR(MAX) NULL,
    PhoneNumberConfirmed BIT NOT NULL,
    TwoFactorEnabled BIT NOT NULL,
    LockoutEnd DATETIMEOFFSET NULL,
    LockoutEnabled BIT NOT NULL,
    AccessFailedCount INT NOT NULL
);
GO

-- Create the AspNetRoleClaims table
CREATE TABLE dbo.AspNetRoleClaims (
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    RoleId NVARCHAR(450) NOT NULL,
    ClaimType NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AspNetRoleClaims_AspNetRoles_RoleId FOREIGN KEY (RoleId) REFERENCES dbo.AspNetRoles(Id)
);
GO

-- Create the AspNetUserClaims table
CREATE TABLE dbo.AspNetUserClaims (
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    UserId NVARCHAR(450) NOT NULL,
    ClaimType NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

-- Create the AspNetUserLogins table
CREATE TABLE dbo.AspNetUserLogins (
    LoginProvider NVARCHAR(128) NOT NULL,
    ProviderKey NVARCHAR(128) NOT NULL,
    ProviderDisplayName NVARCHAR(MAX) NULL,
    UserId NVARCHAR(450) NOT NULL,
    PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

-- Create the AspNetUserRoles table
CREATE TABLE dbo.AspNetUserRoles (
    UserId NVARCHAR(450) NOT NULL,
    RoleId NVARCHAR(450) NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId FOREIGN KEY (RoleId) REFERENCES dbo.AspNetRoles(Id),
    CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

-- Create the AspNetUserTokens table
CREATE TABLE dbo.AspNetUserTokens (
    UserId NVARCHAR(450) NOT NULL,
    LoginProvider NVARCHAR(128) NOT NULL,
    Name NVARCHAR(128) NOT NULL,
    Value NVARCHAR(MAX) NULL,
    PRIMARY KEY (UserId, LoginProvider, Name),
    CONSTRAINT FK_AspNetUserTokens_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

-- Create the Events table
CREATE TABLE dbo.Events (
    EventId INT NOT NULL PRIMARY KEY IDENTITY,
    EventName NVARCHAR(256) NOT NULL,
    EventDate DATETIME NOT NULL,
    Location NVARCHAR(256) NOT NULL
);
GO

-- Create the EventParticipants table
CREATE TABLE dbo.EventParticipants (
    ParticipantId INT NOT NULL PRIMARY KEY IDENTITY,
    EventId INT NOT NULL,
    UserId NVARCHAR(450) NOT NULL,
    FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId),
    FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

-- Create the EventRoles table
CREATE TABLE dbo.EventRoles (
    EventRoleId INT NOT NULL PRIMARY KEY IDENTITY,
    EventId INT NOT NULL,
    RoleId NVARCHAR(450) NOT NULL,
    FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId),
    FOREIGN KEY (RoleId) REFERENCES dbo.AspNetRoles(Id)
);
GO