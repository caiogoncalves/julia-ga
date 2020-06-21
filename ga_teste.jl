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

dados_ga = ga_extract(id,Start_date,End_date,metrics,Dimensions)
