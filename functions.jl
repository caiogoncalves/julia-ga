function ga_session(session)
    auth = authorize(session)
    headers = Dict{String, String}(
        "Authorization" => "$(auth[:token_type]) $(auth[:access_token])" )
end

function ga_extract(session,id,Start_date,End_date,metrics,Dimensions)

    headers = session

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
        df[!, Symbol(i)] = []
    end

    for i in tabela
        push!(df, i)
    end
    return(df)
end

function Sheet_GET_data(headers, sheet_id, sheet_range)
    url = "https://sheets.googleapis.com/v4/spreadsheets/"*sheet_id*"/values/"*sheet_range

    requisicao_sheet = HTTP.request("GET", url, cabecalho)

    sheet = String(requisicao_sheet.body)
    tabela = JSON3.read(sheet)
    tabela = tabela.values

    df = DataFrame()

    for i in tabela[1]
        df[!, Symbol(i)] = []
    end

    for i in 2:length(tabela)
        push!(df, teste[i])
    end
    return df
end
