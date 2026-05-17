%% src/xml_bridge.erl
-module(xml_bridge).
-export([parse_ordered/1]).
-include_lib("xmerl/include/xmerl.hrl").

parse_ordered(XmlBinary) ->
    XmlCharList = binary_to_list(XmlBinary),
    {XmlData, _} = xmerl_scan:string(XmlCharList),
    process_node(XmlData).

%% User要素の処理
%% nameは要素名、attributesは要素が持つ属性の配列、contentは要素が持つ子要素の配列
%% この関数ではパターンマッチによって要素名がUserの要素のみを引き受け、attributesをAttrsという変数、contentをContentという変数に束縛している
process_node(#xmlElement{name = 'User', attributes = Attrs, content = Content}) ->
    %% Id属性の取得, Id属性を持つ要素の値のリストをリスト内包表記を用いてフィルタしつつ生成
    Id = case [A#xmlAttribute.value || A <- Attrs, A#xmlAttribute.name == 'Id'] of
        %% Valは要素の値、それをbinary = 文字列に変換する
        [Val] -> list_to_binary(Val);
        _ -> <<"unknown">>
    end,
    %% 子要素（xmlElement）のみを「元の並び順のまま」再帰的に処理
    Children = [process_node(E) || E <- Content, is_record(E, xmlElement)],
    
    %% Gleamの User(id, children) にマッピングされるタプル
    {user, Id, Children};

%% Name要素の処理
process_node(#xmlElement{name = 'Name', content = Content}) ->
    Text = case [T || T <- Content, is_record(T, xmlText)] of
        [TextNode] -> list_to_binary(TextNode#xmlText.value);
        _ -> <<>>
    end,
    
    %% Gleamの Name(String) にマッピングされるタプル
    {name, Text}.