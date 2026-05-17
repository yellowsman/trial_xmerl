-module(xml_helper).
-export([parse/1]).

parse(Binary) ->
    % GleamのString(Binary)をErlangのCharlistに変換
    Charlist = binary_to_list(Binary),
    % xmerl_scan:string は {xmlElement, ...} と {Rest} の2要素タプルを返す
    {Xml, _Rest} = xmerl_scan:string(Charlist),
    Xml.