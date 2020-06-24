using GoogleCloud
using HTTP
using Tables
using JSON3
using DataFrames
using JSONTables
using Dates

include("functions.jl")


id = "148386669"
Start_date = "2020-06-10"
End_date = "2020-06-19"
metrics = ["sessions","users"]
Dimensions = ["date", "source", "medium"]
creds = JSONCredentials("credentials.json")
session = GoogleSession(creds, ["analytics.readonly", "spreadsheets"])

cabecalho = ga_session(session)

#dados_ga = ga_extract(headers, id,Start_date, End_date,metrics,Dimensions)
sheet_id = "1yfcbeGP12wEeHG8_qcsaBTcizKpeR0L-XyZ5OeLxGEk"
sheet_range = "A1:C10"

df = Sheet_GET_data(cabecalho, sheet_id, sheet_range)
