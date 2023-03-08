﻿---1
SELECT (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên nhân viên có ít nhất 1 thân nhân'
	FROM NHANVIEN, THANNHAN
	WHERE NHANVIEN.MANV= THANNHAN.MA_NVIEN
	GROUP BY (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV)
	HAVING COUNT(THANNHAN.MA_NVIEN) > 1
---2
SELECT (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên nhân viên không có thân nhân'
	FROM NHANVIEN
	WHERE NHANVIEN.MANV NOT IN (SELECT THANNHAN.MA_NVIEN
								FROM NHANVIEN, THANNHAN
								WHERE NHANVIEN.MANV = THANNHAN.MA_NVIEN
								)
---3
	SELECT (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên nhân viên có trên 2 thân nhân'
	FROM NHANVIEN, THANNHAN
	WHERE NHANVIEN.MANV= THANNHAN.MA_NVIEN
	GROUP BY (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV)
	HAVING COUNT(THANNHAN.MA_NVIEN) > 2
---4
	SELECT (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên trưởng phòng có ít nhất 1 thân nhân'
	FROM NHANVIEN, PHONGBAN
	WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND
		  PHONGBAN.TRPHG IN (SELECT THANNHAN.MA_NVIEN
							 FROM NHANVIEN, THANNHAN
							 WHERE NHANVIEN.MANV = THANNHAN.MA_NVIEN
							 )
---6
SELECT (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên có lương trung bình trên mức lương trung bình của phòng "Quản lý"'
	FROM NHANVIEN
	WHERE NHANVIEN.LUONG > (SELECT AVG(NHANVIEN.LUONG)
							FROM NHANVIEN, PHONGBAN
							WHERE NHANVIEN.PHG = PHONGBAN.MAPHG AND
								  PHONGBAN.TENPHG = N'Quản lý')
---7
SELECT (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên có lương trung bình trên mức lương trung bình của phòng đang làm việc'
	FROM NHANVIEN
	WHERE NHANVIEN.LUONG > (SELECT AVG(NHANVIEN.LUONG)
							FROM NHANVIEN, PHONGBAN
							WHERE NHANVIEN.PHG = PHONGBAN.MAPHG )
---8
SELECT PHONGBAN.TENPHG, (NHANVIEN.HOVN + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên trưởng phòng của phòng ban đông nhân viên nhất'
	FROM NHANVIEN, PHONGBAN
	WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND
		  PHONGBAN.MAPHG = (SELECT TOP 1 PHONGBAN.MAPHG
							FROM NHANVIEN, PHONGBAN
							WHERE NHANVIEN.PHG = PHONGBAN.MAPHG
							GROUP BY PHONGBAN.MAPHG
							ORDER BY COUNT (NHANVIEN.PHG) DESC
							)
---9
SELECT DEAN.MADA
	FROM DEAN
	WHERE DEAN.MADA NOT IN (SELECT PHANCONG.MADA
							FROM PHANCONG
							WHERE PHANCONG.MA_NVIEN = '456'
							)
---10
SELECT DISTINCT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
FROM NHANVIEN, DEAN, DIADIEM_PHG
WHERE NHANVIEN.PHG = DEAN.PHONG AND NHANVIEN.PHG = DIADIEM_PHG.MAPHG AND DEAN.DDIEM_DA LIKE '%Quãng Ngãi' AND DIADIEM_PHG.DIADIEM NOT LIKE '%Quãng Ngãi'
);
---11
SELECT DISTINCT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
FROM NHANVIEN, DEAN, DIADIEM_PHG
WHERE NHANVIEN.PHG = DEAN.PHONG AND NHANVIEN.PHG = DIADIEM_PHG.MAPHG AND DEAN.DDIEM_DA IN (SELECT DEAN.DDIEM_DA FROM DEAN) AND DIADIEM_PHG.DIADIEM NOT LIKE DEAN.DDIEM_DA

---12
SELECT PHANCONG.MADA
FROM NHANVIEN, PHANCONG
WHERE NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Lê'
UNION --phép kết
SELECT DEAN.MADA
FROM NHANVIEN, PHONGBAN, DEAN
WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND PHONGBAN.MAPHG = DEAN.PHONG AND NHANVIEN.HONV = N'Lê'
---13
SELECT DEAN.MADA
FROM DEAN
WHERE DEAN.MADA IN (SELECT PHANCONG.MADA FROM PHANCONG WHERE PHANCONG.MA_NVIEN = '123' AND PHANCONG.MA_NVIEN = '789')

---14
SELECT DEAN.TENDA
FROM NHANVIEN, DEAN, PHANCONG
WHERE DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Đinh' AND NHANVIEN.TENLOT = N'Bá' AND NHANVIEN.TENNV = N'Tiến' 
UNION
SELECT DEAN.TENDA
FROM NHANVIEN, DEAN, PHANCONG
WHERE DEAN.MADA	= PHANCONG.MADA AND NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Trần' AND NHANVIEN.TENLOT = N'Thanh' AND NHANVIEN.TENNV = N'Tâm'
---15
SELECT da.TENDA
FROM DEAN da
INNER JOIN PhanCong pc1 ON da.MADA = pc1.MADA
INNER JOIN PhanCong pc2 ON da.MADA = pc2.MADA
WHERE pc1.MA_NVIEN = 'Tiến' AND pc2.MA_NVIEN = 'Tâm';