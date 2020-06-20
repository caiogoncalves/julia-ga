using GoogleCloud
using HTTP
using Tables
using JSON3
using DataFrames
using JSONTables
using Dates

id = "148386669"
Start_date = "2020-06-10"
End_date = "2020-06-19"
metrics = ["sessions","users"]
Dimensions = ["date", "source", "medium"]
creds = JSONCredentials("credentials.json")

function ga_extract(id,Start_date,End_date,metrics,Dimensions)

    session = GoogleSession(creds, ["analytics.readonly"])
    auth = authorize(session)
    headers = Dict{String, String}(
        "Authorization" => "$(auth[:token_type]) $(auth[:access_token])"
    )

    url = "https://www.googleapis.com/analytics/v3/management/accounts/"


    query_metrics = join(metrics,",ga:")
    query_dimensions = join(Dimensions,",ga:")
    url_get_data = "https://www.googleapis.com/analytics/v3/data/ga?ids=ga:"*
        id*"&start-date="*
        Start_date*"&end-date="*
        End_date*"&metrics=ga:"*query_metrics*
        "&dimensions=ga:"*query_dimensions

    requisicao = HTTP.request("GET", url, headers)
    requisicao_report = HTTP.request("GET", url_get_data, headers)
    tabela = String(requisicao_report.body)
    tabela = JSON3.read(tabela)
    tabela = tabela[:rows]


    coltabela = vcat(Dimensions,metrics)
    df = DataFrame()

    for i in coltabela
        df[Symbol(i)] = []
    end

    for i in tabela
        push!(df, i)
    end
    return(df)
end

dados_ga = ga_extract(id,Start_date,End_date,metrics,Dimensions)
