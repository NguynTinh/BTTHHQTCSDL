--a. Tạo login và user cho các nhân viên:

-- Tạo login cho trưởng nhóm TN
CREATE LOGIN TN WITH PASSWORD = 'password';
GO

-- Tạo user cho trưởng nhóm TN
USE Sales;
CREATE USER TN FOR LOGIN TN;
GO

-- Tạo login cho nhân viên NV
CREATE LOGIN NV WITH PASSWORD = 'password';
GO

-- Tạo user cho nhân viên NV
USE Sales;
CREATE USER NV FOR LOGIN NV;
GO

-- Tạo login cho nhân viên QL
CREATE LOGIN QL WITH PASSWORD = 'password';
GO

-- Tạo user cho nhân viên QL
USE Sales;
CREATE USER QL FOR LOGIN QL;
GO

--b. Phân quyền cho các nhân viên:

-- Phân quyền cho trưởng nhóm TN
USE Sales;
GRANT SELECT, UPDATE ON Production.ProductInventory TO TN;
GO

-- Phân quyền cho nhân viên NV
USE Sales;
GRANT SELECT, DELETE ON Production.ProductInventory TO NV;
GO

-- Phân quyền cho nhân viên QL
USE Sales;
GRANT SELECT ON Production.ProductInventory TO QL;
GO

-- Admin phải có quyền CONTROL trên tất cả các đối tượng trong cơ sở dữ liệu
USE Sales;
GRANT CONTROL TO [Admin];
GO

--c. Đăng nhập và thực hiện các yêu cầu:

-- Đăng nhập với tài khoản của trưởng nhóm TN
USE Sales;
EXECUTE AS USER = 'TN';

-- Sửa 1 dòng dữ liệu tùy ý trong bảng Production.ProductInventory
UPDATE Production.ProductInventory
SET Quantity = 20
WHERE ProductID = 1;

-- Kết thúc quyền của trưởng nhóm TN
REVERT;

-- Đăng nhập với tài khoản của nhân viên NV
USE Sales;
EXECUTE AS USER = 'NV';

-- Xóa 1 dòng dữ liệu tùy ý trong bảng Production.ProductInventory
DELETE FROM Production.ProductInventory
WHERE ProductID = 2;

-- Kết thúc quyền của nhân viên NV
REVERT;

-- Đăng nhập với tài khoản của nhân viên QL
USE Sales;
EXECUTE AS USER = 'QL';

-- Xem lại kết quả thực hiện của trưởng nhóm TN và nhân viên NV
SELECT * FROM Production.ProductInventory;

-- Kết thúc quyền của nhân viên QL
REVERT;

--d. Ai có thể sửa được dữ liệu bảng Production.Product ?
--Chỉ có trưởng nhóm TN và nhân viên QL có thể sửa được dữ liệu bảng Production.Product, vì họ được phân quyền SELECT và UPDATE trên bảng này.
USE Sales;
SELECT HAS_PERMS_BY_NAME('Production.ProductInventory', 'OBJECT', 'UPDATE');
--e. Thu hồi quyền cấp cho nhân viên NV:

-- Thu hồi quyền của nhân viên NV
USE Sales;
REVOKE SELECT, DELETE ON Production.ProductInventory FROM NV;
GO

-- Xóa user của nhân viên NV
USE Sales;
DROP USER NV;
GO

--f. Để vô hiệu hóa các hoạt động của nhóm 1 trên CSDL, ta có thể xóa các user và login tương ứng hoặc thu hồi quyền của các user đó. Trong trường hợp này, ta sẽ thu hồi quyền để các user không còn truy cập vào bảng Production.ProductInventory. Câu lệnh để thu hồi quyền như sau:
USE Sales;
REVOKE SELECT, INSERT, UPDATE, DELETE ON Production.ProductInventory FROM TN;
REVOKE SELECT, INSERT, UPDATE ON Production.ProductInventory FROM NV;