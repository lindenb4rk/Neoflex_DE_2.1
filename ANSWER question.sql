--удалить дубли, то есть и первое включение и второе?
WITH
	DUBLES AS (SELECT
					COUNT(*),
					CLIENT_RK,
					EFFECTIVE_FROM_DATE
				FROM
					DM.CLIENT_COPY
				GROUP BY
					CLIENT_RK,
					EFFECTIVE_FROM_DATE
					--оставляем только дубли
				HAVING
					COUNT(*) >= 2
		)
DELETE FROM DM.CLIENT_COPY
WHERE
	(CLIENT_RK, EFFECTIVE_FROM_DATE) IN (
		SELECT
			CLIENT_RK,
			EFFECTIVE_FROM_DATE
		FROM
			DUBLES
	)