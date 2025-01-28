/*select distinct client_rk, effective_from_date from
dm.client;
--разница в 1 строку, отобразил в скриншоте
select distinct * from
dm.client;
--'конфликтный' ключ
select * from dm.client
where client_rk = 3055149 and effective_from_date =	'2023-08-11';

--покажем какой способ мы выбрали
select * from dm.client;
*/

--убрать если используем в транзакции наш код
DROP TABLE IF EXISTS DUBLES;

CREATE TEMPORARY TABLE DUBLES AS
SELECT
	CLIENT_RK,
	EFFECTIVE_FROM_DATE,
	EFFECTIVE_TO_DATE,
	ACCOUNT_RK,
	ADDRESS_RK,
	DEPARTMENT_RK,
	CARD_TYPE_CODE,
	CLIENT_ID,
	COUNTERPARTY_TYPE_CD,
	BLACK_LIST_FLAG,
	CLIENT_OPEN_DTTM,
	BANKRUPTCY_RK
FROM
	(
	--'нумеруем дубли'
		SELECT
			ROW_NUMBER() OVER (PARTITION BY
					CLIENT_RK,
					EFFECTIVE_FROM_DATE) AS HOW,
			*
		FROM
			DM.CLIENT
	) numbers
WHERE
	HOW = 2;
/*
оставляем только дубли(если дублей 3 и более то соответвенно 
есть строка под номерами 1 и 2 согласно ROW_NUMBER() )
*/

--удаляем строки,ключ которых говорит о том что они дубли
DELETE FROM DM.CLIENT
WHERE
	(CLIENT_RK, EFFECTIVE_FROM_DATE) IN (
		SELECT
			CLIENT_RK,
			EFFECTIVE_FROM_DATE
		FROM
			DUBLES
	);

--записываем наши бывшие дубли
INSERT INTO DM.CLIENT 
SELECT * FROM DUBLES;

