import pandas as pd
from sqlalchemy import create_engine
import urllib

# Parámetros de conexión a Azure
server = 'srv-portafolio-alvaropereznunez.database.windows.net'
database = 'RiesgoPYME_DB'
username = ''
password = ''  
driver = '{ODBC Driver 17 for SQL Server}'

# Motor de conexión (engine)
params = urllib.parse.quote_plus(
    f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}"
)
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# Datos desde Azure
print("Cargando datos desde Azure...")
query = "SELECT Sector_Economico, Tipo_Empresa, Term, Monto_Desembolsado_PEN FROM Creditos_PYME"
df = pd.read_sql(query, engine)

# Definir el motor de reglas de Triage
def evaluar_solicitud_credito(sector, tipo_empresa, plazo_meses, monto):
    if sector in ["Transporte", "Construcción"] and plazo_meses <= 60 and monto <= 50000:
        return "🔴 ZONA ROJA"
    elif sector == "Agricultura" or (tipo_empresa == "Empresa Existente" and plazo_meses > 120):
        return "🟢 ZONA VERDE"
    else:
        return "🟡 ZONA AMARILLA"

# Regla a toda la cartera
print("Procesando la cartera de créditos...")
df['Decision_Triage'] = df.apply(
    lambda row: evaluar_solicitud_credito(
        row['Sector_Economico'], 
        row['Tipo_Empresa'], 
        row['Term'], 
        row['Monto_Desembolsado_PEN']
    ), 
    axis=1
)

# Resultados finales en la consola
print("\n--- DISTRIBUCIÓN AUTOMÁTICA DE LA CARTERA (MODELO TRIAGE) ---")
print(df['Decision_Triage'].value_counts())
print("\nPorcentaje del total:")
print(round(df['Decision_Triage'].value_counts(normalize=True) * 100, 2).astype(str) + " %")