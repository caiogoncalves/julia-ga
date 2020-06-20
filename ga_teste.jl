using GoogleCloud
using HTTP
using Tables
using JSON3
using DataFrames
using JSONTables

creds = JSONCredentials("credentials.json")
session = GoogleSession(creds, ["analytics.readonly"])
auth = authorize(session)
    headers = Dict{String, String}(
        "Authorization" => "$(auth[:token_type]) $(auth[:access_token])"
    )

url = "https://www.googleapis.com/analytics/v3/management/accounts/"
url_get_data = "https://www.googleapis.com/analytics/v3/data/ga?ids=ga:148386669&start-date=2020-06-10&end-date=2020-06-13&metrics=ga:sessions&dimensions=ga:date"

requisicao = HTTP.request("GET", url, headers)
requisicao_report = HTTP.request("GET", url_get_data, headers)
#println(String(requisicao_report.body))
tabela = String(requisicao_report.body)
tabela = JSON3.read(tabela)
tabela = tabela[:rows]
dia = zeros()
sessoes = zeros()
for i in tabela
    dia = push!(dia, i[1])
    sessoes = append!(sessoes ,i[2])
end
jtable = jsontable(tabela)
new_dfs = DataFrame(reduce(vcat, jtable))
println(new_dfs)
