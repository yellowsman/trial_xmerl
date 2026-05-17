// 1. 同一のリストに混在させるための型定義
pub type XmlNode {
  Name(String)
  User(id: String, children: List(XmlNode))
}

// 2. Erlangのブリッジ関数をバインド
@external(erlang, "xml_bridge", "parse_ordered")
pub fn parse_ordered(xml_string: String) -> XmlNode

pub fn main() {
  let xml_data =
    "
    <User Id=\"123\">
        <Name>Hoge</Name>
        <Name>Fuga</Name>
        <Name>HogeHoge</Name>
        <User Id=\"456\">
             <Name>456Hoge</Name>
             <Name>456Fuga</Name>
         </User>
         <Name>HogeFuga</Name>
    </User>
  "

  let result = parse_ordered(xml_data)

  // 構造をそのままデバック出力
  echo result
}
