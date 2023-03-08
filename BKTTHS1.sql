--CAU1
-- Tạo login cho trưởng nhóm trưởng nhóm
CREATE LOGIN TruongNhom WITH PASSWORD = '12042002';
GO

-- Tạo user cho trưởng nhóm trưởng nhóm
USE AdventureWorks2008R2;
CREATE USER TruongNhom FOR LOGIN TruongNhom;
GO

-- Tạo login cho nhân viên NV
CREATE LOGIN NhanVien WITH PASSWORD = '12042002';
GO

-- Tạo user cho nhân viên NV
USE AdventureWorks2008R2;
CREATE USER NhanVien FOR LOGIN NhanVien;
GO

-- Tạo login cho nhân viên QuanLy
CREATE LOGIN QuanLy WITH PASSWORD = '12042002';
GO

-- Tạo user cho nhân viên QL
USE AdventureWorks2008R2;
CREATE USER QuanLy FOR LOGIN QuanLy;
GO

--b. Phân quyền cho các nhân viên:

-- Phân quyền cho trưởng nhóm TN
USE AdventureWorks2008R2;
GRANT SELECT, UPDATE,DELETE ON Production.ProductInventory TO TruongNhom;
GO

-- Phân quyền cho nhân viên NV
USE AdventureWorks2008R2;
GRANT SELECT,UPDATE, DELETE ON Production.ProductInventory TO NhanVien;
GO

-- Phân quyền cho nhân viên QL
USE AdventureWorks2008R2;
GRANT SELECT ON Production.ProductInventory TO QuanLy;
GO

-- Admin phải có quyền CONTROL trên tất cả các đối tượng trong cơ sở dữ liệu
USE AdventureWorks2008R2;
GRANT CONTROL TO [Admin];
GO

--c. Đăng nhập và thực hiện các yêu cầu:

-- Đăng nhập với tài khoản của trưởng nhóm TN
USE AdventureWorks2008R2;
EXECUTE AS USER = 'TN';

-- Sửa 1 dòng dữ liệu tùy ý trong bảng Production.ProductInventory
UPDATE Production.ProductInventory
SET Quantity = 20
WHERE ProductID = 1;

-- Kết thúc quyền của trưởng nhóm TN
REVERT;

-- Đăng nhập với tài khoản của nhân viên NV
USE AdventureWorks2008R2;
EXECUTE AS USER = 'NV';

-- Xóa 1 dòng dữ liệu tùy ý trong bảng Production.ProductInventory
DELETE FROM Production.ProductInventory
WHERE ProductID = 2;

-- Kết thúc quyền của nhân viên NV
REVERT;

-- Đăng nhập với tài khoản của nhân viên QL
USE AdventureWorks2008R2;
EXECUTE AS USER = 'QL';

-- Xem lại kết quả thực hiện của trưởng nhóm TN và nhân viên NV
SELECT * FROM Production.ProductInventory;

-- Kết thúc quyền của nhân viên QL
REVERT;

--d. Ai có thể sửa được dữ liệu bảng Production.Product ?

--Chỉ có trưởng nhóm TN và nhân viên QL có thể sửa được dữ liệu bảng Production.Product, vì họ được phân quyền SELECT và UPDATE trên bảng này.

--e. Thu hồi quyền cấp cho nhân viên NV:

-- Thu hồi quyền của nhân viên NV
USE AdventureWorks2008R2;
REVOKE SELECT, DELETE ON Production.ProductInventory FROM NV;
GO

-- Xóa user của nhân viên NV
USE AdventureWorks2008R2;
DROP USER NV;
GO
--f.Vô hiệu hóa
ALTER LOGIN TruongNhom DISABLE;
ALTER LOGIN NhanVien DISABLE;
--CAU2
--T1: Thực hiện Full Backup

BACKUP DATABASE AdventureWorks2008R2
TO DISK = 'C:\Backup\AdventureWorks2008R2_Full.bak'
WITH INIT;

--T2: Cập nhật tăng mức tồn kho an toàn SafetyStockLevel trong table Production.Product lên 10% cho các mặt hàng là nguyên liệu sản xuất

USE AdventureWorks2008R2;
GO
UPDATE Production.Product
SET SafetyStockLevel = SafetyStockLevel * 1.1
WHERE FinishedGoodsFlag = 0;

--T3: Thực hiện Differential Backup

BACKUP DATABASE AdventureWorks2008R2
TO DISK = 'C:\Backup\AdventureWorks2008R2_Diff.bak'
WITH DIFFERENTIAL;

--T4: Xóa mọi bản ghi trong bảng Person.Emailaddress

USE AdventureWorks2008R2;
GO
DELETE FROM Person.EmailAddress;

--T5: Thực hiện Differential Backup

BACKUP DATABASE AdventureWorks2008R2
TO DISK = 'C:\Backup\AdventureWorks2008R2_Diff.bak'
WITH DIFFERENTIAL;

--T6: Thêm một dòng trong table Person.ContactType

USE AdventureWorks2008R2;
GO
INSERT INTO Person.ContactType (Name)
VALUES ('Test');

--T7: Thực hiện Log Backup

BACKUP LOG AdventureWorks2008R2
TO DISK = 'C:\Backup\AdventureWorks2008R2_Log.bak';

--T8: Xóa CSDL AdventureWorks2008R2.

DROP DATABASE AdventureWorks2008R2;

--T9: Phục hồi CSDL về trạng thái ở T7

RESTORE DATABASE AdventureWorks2008R2
FROM DISK = 'C:\Backup\AdventureWorks2008R2_Full.bak'
WITH NORECOVERY;

RESTORE DATABASE AdventureWorks2008R2
FROM DISK = 'C:\Backup\AdventureWorks2008R2_Diff.bak'
WITH NORECOVERY;

RESTORE LOG AdventureWorks2008R2
FROM DISK = 'C:\Backup\AdventureWorks2008R2_Log.bak'
WITH NORECOVERY;

RESTORE DATABASE AdventureWorks2008R2 WITH RECOVERY;
--T10: Kiểm tra xem DB phục hồi có ở trạng thái T7 không ?
--Kiểm tra lại dữ liệu trong bảng Person.EmailAddress và Person.ContactType 
--để xác nhận rằng các thao tác từ T2 đến T7 đã được phục hồi thành công. 
--Nếu dữ liệu trong các bảng này giống như trạng thái ở T7 thì DB đã phục hồi thành công
