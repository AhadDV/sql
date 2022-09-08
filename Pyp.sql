CREATE DATABASE PYPSQLTASK
USE PYPSQLTASK

CREATE TABLE Country (
 
 Id int primary key identity ,
 [Name] nvarchar(80) NOT NULL,
 Code nvarchar(50)
)

CREATE TABLE City(
Id int primary key identity,
[Name] nvarchar(80) NOT NULL,
CountryId int NOT NULL FOREIGN KEY REFERENCES Country(Id),
Code nvarchar(50)
)

CREATE TABLE District(
 Id int primary key identity,
 Name nvarchar(80) NOT NULL,
 CountryId int not null FOREIGN KEY REFERENCES Country(Id),
 CityId int not null FOREIGN KEY REFERENCES City(Id),
 Code nvarchar(50)
)

CREATE TABLE Town(
Id int primary key identity,
[Name] nvarchar(80)  NOT NULL,
CountryId int FOREIGN KEY REFERENCES Country(Id),
CityId int FOREIGN KEY REFERENCES City(Id),
DistrictId int FOREIGN KEY REFERENCES District(Id),
Code nvarchar(50)
)



CREATE PROCEDURE AddTables @CountryName as nvarchar(80),@CityName as nvarchar(80),@DistrictName as nvarchar(80),@TownName as nvarchar(80)
AS
BEGIN


exec AddCountryIfNoExsist @CountryName=@CountryName

declare @CountryId as int
Select @CountryId=Id From Country where [Name]=@CountryName

exec AddCity @Name=@CityName,@Id=@CountryId
declare @CityId as int
Select @CityId=Id From City where [Name]=@CityName and @CountryId=@CountryId


exec AddDistrict @Name=@DistrictName,@CountryId=@CountryId,@CityId=@CityId

declare @DistrictId as int
Select @DistrictId=Id From District where [Name]=@DistrictName and @CountryId=@CountryId and @CityId=@CityId

exec AddTown @Name=@TownName,@CountryId=@CountryId,@CityId=@CityId,@DistrictId=@DistrictId

end
GO
exec AddTables @CountryName='tst1',@CityName='tes3',@DistrictName='district',@TownName='hbjn'




create procedure AddCountryIfNoExsist @CountryName as nvarchar(80)
as
begin
if exists(select [Name] from dbo.Country where [Name]=@CountryName)
Begin 
print  @CountryName + ' '+'Alrady exsist'
END
ELSE
BEGIN
INSERT INTO dbo.Country
values(@CountryName,'codee')
print @CountryName +'alrady created'
end
end




CREATE PROCEDURE AddCity @Name as nvarchar(80), @Id as int
as 
begin

IF  EXISTS(select [Name] from dbo.City where [Name]=@Name and CountryId=@Id)
begin
print @Name+' city country Alrady has'
end
ELSE
BEGIN
INSERT INTO dbo.City
values(@Name,@Id,'citycode')
print @Name+ 'City created'
END
end
GO

create procedure AddDistrict @Name as nvarchar(80),@CountryId as int ,@CityId int
AS
BEGIN
IF  EXISTS(select [Name] from dbo.District where [Name]=@Name and CountryId=@CountryId and CityId=@CityId)
begin
print @Name+'district city of country  Alrady has'
end
ELSE
BEGIN
INSERT INTO dbo.District
values(@Name,@CountryId,@CityId,'districtcode')
print @Name+ 'district created'
END
end
GO

create procedure AddTown @Name as nvarchar(80),@CountryId as int ,@CityId int,@DistrictId as int
AS
BEGIN
IF  EXISTS(select [Name] from dbo.Town where [Name]=@Name and CountryId=@CountryId and CityId=@CityId and DistrictId=@DistrictId)
begin
print @Name+'Town district of city of country  Alrady has'
end
ELSE
BEGIN
INSERT INTO dbo.Town
values(@Name,@CountryId,@CityId,@DistrictId,'town code')
print @Name+ 'Town created'
END
end
GO

