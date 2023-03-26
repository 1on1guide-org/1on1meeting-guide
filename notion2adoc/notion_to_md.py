import os
import requests
from mdutils.mdutils import MdUtils

NOTION_API_KEY = os.environ["NOTION_API_KEY"]
NOTION_DATABASE_ID = os.environ["NOTION_DATABASE_ID"]

headers = {
    "Authorization": f"Bearer {NOTION_API_KEY}",
    "Notion-Version": "2022-06-28",  # Notion APIのバージョンを最新に更新してください
    "Content-Type": "application/json",
}

def get_database_items():
    url = f"https://api.notion.com/v1/databases/{NOTION_DATABASE_ID}/query"
    filter_body = {
        "filter": {
            "property": "状態",
            "select": {
                "equals": "公開前"
            }
        }
    }
    response = requests.post(url, headers=headers, json=filter_body)
    response.raise_for_status()
    return response.json()["results"]

def create_markdown_file(item):
    number = item["properties"]["No."]["number"]
    file_name = f"{int(number)}.md"
    title = item["properties"]["パターン名"]["title"][0]["plain_text"]
    md_file = MdUtils(file_name=file_name, title=title)

    # セクションと項目の定義
    sections = [
        ("はじめに", "はじめに(サブタイトル的に内容を推測できるもの)"),
        ("要約", "要約(使用例を除く詳細をまとめ理解を促すもの)"),
        ("状況", "状況"),
        ("問題", "問題"),
        ("フォース", "フォース(問題に至る背景)"),
        ("使用例", "使用例(カードを切るタイミングや背景)"),
        ("関連パターン", "関連パターン"),
    ]

    # 各セクションと対応する項目をMarkdownファイルに追加
    for section_title, property_name in sections:
        if property_name in item["properties"] and item["properties"][property_name]["rich_text"]:
            content = item["properties"][property_name]["rich_text"][0]["plain_text"]
            md_file.new_header(level=2, title=section_title)
            md_file.new_line(content)

    md_file.create_md_file()

if __name__ == "__main__":
    items = get_database_items()
    for item in items:
        create_markdown_file(item)