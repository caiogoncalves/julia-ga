using GoogleCloud
using HTTP
using Tables
using JSON3
using JSON
using DataFrames
using JSONTables
using Dates
using OrderedCollections
include("functions.jl")


id = "148386669"
Start_date = "2020-06-10"
End_date = "2020-06-19"
metrics = ["sessions","users"]
Dimensions = ["date", "source", "medium"]
creds = JSONCredentials("credentials.json")
session = GoogleSession(creds, ["analytics", "spreadsheets"])

cabecalho = ga_session(session)

dados_ga = ga_extract(cabecalho, id,Start_date, End_date,metrics,Dimensions)
sheet_id = "1yfcbeGP12wEeHG8_qcsaBTcizKpeR0L-XyZ5OeLxGEk"
#sheet_range = "Sheet1!A1:C10"
sheet_start = 'A'
sheet_end = sheet_start + size(dados_ga)[2]
sheet_range = "Sheet1!" * sheet_start * string(1) * ":" * sheet_end * string(1+size(dados_ga)[1])
#df = Sheet_GET_data(cabecalho, sheet_id, sheet_range)

url = "https://sheets.googleapis.com/v4/spreadsheets/"*sheet_id*"/values/"*sheet_range*"?valueInputOption=RAW"

dict1 = OrderedDict("range" => sheet_range,
            "majorDimension" => "ROWS",
            "values" => [names(dados_ga)])
for i in 1:size(dados_ga)[1]
    push!(dict1["values"],dados_ga[i,:])
end

stringdata = JSON.json(dict1)

requisicao_sheet = HTTP.request("PUT", url, cabecalho, stringdata)

names(df)
dict1
