import gleeunit
import gleeunit/should
import trial_xmerl.{type XmlNode, Name, User}

// テスト用にErlangの関数をバインド
// (型が正しいかどうかもテストを通じて検証できます)
@external(erlang, "xml_bridge", "parse_ordered")
fn parse_ordered(xml_string: String) -> XmlNode

pub fn main() {
  gleeunit.main()
}

// gleeunitは末尾が `_test` の関数を自動で実行します
pub fn parse_ordered_sequence_test() {
  let xml_data = "<User Id=\"123\"><Name>Hoge</Name></User>"

  // Erlangコードの実行
  let result = parse_ordered(xml_data)

  // 期待通りのデータ構造が返ってくるか検証
  result
  |> should.equal(User("123", [Name("Hoge")]))
}
