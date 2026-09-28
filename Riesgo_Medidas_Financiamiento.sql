SELECT -- Riesgo por sector
    Sector_Economico,
    COUNT(*) AS Total_Creditos,
    SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS Creditos_Incumplidos,
    ROUND(
        CAST(SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2
    ) AS Tasa_Incumplimiento_Pct
FROM 
    Creditos_PYME
GROUP BY 
    Sector_Economico
ORDER BY 
    Tasa_Incumplimiento_Pct DESC;
GO
SELECT --Riesgo por antigüedad de empresa
    Tipo_Empresa,
    COUNT(*) AS Total_Creditos,
    SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS Creditos_Incumplidos,
    ROUND(
        CAST(SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2
    ) AS Tasa_Incumplimiento_Pct
FROM 
    Creditos_PYME
GROUP BY 
    Tipo_Empresa
ORDER BY 
    Tasa_Incumplimiento_Pct DESC;
GO
SELECT --Riesgo por plazo de financiamiento
    CASE 
        WHEN Term <= 60 THEN 'Corto Plazo (0-5 años)'
        WHEN Term > 60 AND Term <= 120 THEN 'Mediano Plazo (5-10 años)'
        ELSE 'Largo Plazo (> 10 años)'
    END AS Categoria_Plazo,
    COUNT(*) AS Total_Creditos,
    SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS Creditos_Incumplidos,
    ROUND(
        CAST(SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2
    ) AS Tasa_Incumplimiento_Pct
FROM 
    Creditos_PYME
GROUP BY 
    CASE 
        WHEN Term <= 60 THEN 'Corto Plazo (0-5 años)'
        WHEN Term > 60 AND Term <= 120 THEN 'Mediano Plazo (5-10 años)'
        ELSE 'Largo Plazo (> 10 años)'
    END
ORDER BY 
    Tasa_Incumplimiento_Pct DESC;
GO
SELECT -- Riesgo por rango de monto
    CASE 
        WHEN Monto_Desembolsado_PEN <= 50000 THEN '1. Monto Bajo (<= 50k)'
        WHEN Monto_Desembolsado_PEN > 50000 AND Monto_Desembolsado_PEN <= 150000 THEN '2. Monto Medio (50k - 150k)'
        ELSE '3. Monto Alto (> 150k)'
    END AS Rango_Monto,
    COUNT(*) AS Total_Creditos,
    SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS Creditos_Incumplidos,
    ROUND(
        CAST(SUM(CASE WHEN Estado_Credito = 'Castigado' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 2
    ) AS Tasa_Incumplimiento_Pct
FROM 
    Creditos_PYME
GROUP BY 
    CASE 
        WHEN Monto_Desembolsado_PEN <= 50000 THEN '1. Monto Bajo (<= 50k)'
        WHEN Monto_Desembolsado_PEN > 50000 AND Monto_Desembolsado_PEN <= 150000 THEN '2. Monto Medio (50k - 150k)'
        ELSE '3. Monto Alto (> 150k)'
    END
ORDER BY 
    Rango_Monto;